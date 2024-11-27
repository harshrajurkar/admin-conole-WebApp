import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_app_bar.dart';

class PermissionManagementPage extends StatefulWidget {
  const PermissionManagementPage({super.key});

  @override
  State<PermissionManagementPage> createState() =>
      _PermissionManagementPageState();
}

class _PermissionManagementPageState extends State<PermissionManagementPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _initializeRoles() async {
    try {
      final rolesCollection = await firestore.collection('roles').get();

      if (rolesCollection.docs.isEmpty) {
        // Add default roles
        await firestore.collection('roles').doc('Admin').set({
          'permissions': {'Read': true, 'Write': true, 'Delete': true},
        });
        await firestore.collection('roles').doc('Editor').set({
          'permissions': {'Read': true, 'Write': true, 'Delete': false},
        });
        await firestore.collection('roles').doc('Viewer').set({
          'permissions': {'Read': true, 'Write': false, 'Delete': false},
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default roles created!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing roles: $e')),
      );
    }
  }

  Future<void> _updatePermission(
      String roleName, String permissionName, bool enabled) async {
    try {
      await firestore
          .collection('roles')
          .doc(roleName)
          .update({'permissions.$permissionName': enabled});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission updated successfully!')),
      );
    } catch (e) {
      debugPrint('Error updating permissions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to update permission. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeRoles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Permission Management"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('roles').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching roles'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No roles available'));
            }

            final roles = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>? ?? {};
              final permissionsMap =
                  data['permissions'] as Map<String, dynamic>? ?? {};
              final permissions = permissionsMap.entries
                  .map((entry) => {
                        'name': entry.key.toString(),
                        'enabled': entry.value as bool? ?? false,
                      })
                  .toList();

              return {'name': doc.id, 'permissions': permissions};
            }).toList();

            return ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];
                final roleName = role['name'] as String;
                final permissions =
                    role['permissions'] as List<Map<String, dynamic>>;

                return AnimatedRoleTile(
                  roleName: roleName,
                  permissions: permissions,
                  updatePermission: _updatePermission,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AnimatedRoleTile extends StatefulWidget {
  final String roleName;
  final List<Map<String, dynamic>> permissions;
  final Future<void> Function(String, String, bool) updatePermission;

  const AnimatedRoleTile({
    required this.roleName,
    required this.permissions,
    required this.updatePermission,
    super.key,
  });

  @override
  State<AnimatedRoleTile> createState() => _AnimatedRoleTileState();
}

class _AnimatedRoleTileState extends State<AnimatedRoleTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpansion() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.roleName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: _toggleExpansion,
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: Column(
              children: widget.permissions.map((permission) {
                final permissionName = permission['name'] as String;
                final permissionEnabled = permission['enabled'] as bool;
                return CheckboxListTile(
                  title: Text(permissionName),
                  value: permissionEnabled,
                  onChanged: (bool? newValue) async {
                    if (newValue != null) {
                      await widget.updatePermission(
                          widget.roleName, permissionName, newValue);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
