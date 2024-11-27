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

  // Function to initialize roles if not present
  Future<void> _initializeRoles() async {
    try {
      final rolesCollection = await firestore.collection('roles').get();

      if (rolesCollection.docs.isEmpty) {
        // Add default roles
        await firestore.collection('roles').doc('Admin').set({
          'permissions': {
            'Read': true,
            'Write': true,
            'Delete': true,
          },
        });

        await firestore.collection('roles').doc('Editor').set({
          'permissions': {
            'Read': true,
            'Write': true,
            'Delete': false,
          },
        });

        await firestore.collection('roles').doc('Viewer').set({
          'permissions': {
            'Read': true,
            'Write': false,
            'Delete': false,
          },
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

  // Function to update permission
  Future<void> _updatePermission(
      String roleName, String permissionName, bool enabled) async {
    try {
      await FirebaseFirestore.instance
          .collection('roles')
          .doc(roleName)
          .update({'permissions.$permissionName': enabled});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission updated successfully!')),
      );
    } catch (e) {
      // Log the error
      debugPrint('Firestore Error: $e');

      // Show a user-friendly message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Failed to update permission. Please try again later.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeRoles(); // Initialize roles on page load
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
            // Handling connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching roles'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No roles available'));
            }

            // Map the data safely
            final roles = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>? ?? {};

              // Extract permissions safely
              final permissionsMap =
                  data['permissions'] as Map<String, dynamic>? ?? {};

              final permissions = permissionsMap.entries
                  .map((entry) => {
                        'name': entry.key.toString(),
                        'enabled': entry.value as bool? ?? false,
                      })
                  .toList();

              return {
                'name': doc.id, // Role ID as role name
                'permissions': permissions,
              };
            }).toList();

            return ListView.builder(
              itemCount: roles.length,
              itemBuilder: (context, index) {
                final role = roles[index];

                // Safely access role name and permissions
                final roleName = role['name'] as String? ?? 'Unknown Role';
                final permissions =
                    role['permissions'] as List<Map<String, dynamic>>?;

                return RoleTile(
                  roleName: roleName,
                  permissions: permissions ?? [],
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

class RoleTile extends StatelessWidget {
  final String roleName;
  final List<Map<String, dynamic>> permissions;
  final Future<void> Function(String, String, bool) updatePermission;

  const RoleTile({
    required this.roleName,
    required this.permissions,
    required this.updatePermission,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          roleName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: permissions.map<Widget>((permission) {
          final permissionName = permission['name'] as String;
          final permissionEnabled = permission['enabled'] as bool;

          // Use ValueNotifier for efficient updates
          final ValueNotifier<bool> notifier =
              ValueNotifier<bool>(permissionEnabled);

          return ValueListenableBuilder<bool>(
            valueListenable: notifier,
            builder: (context, value, child) {
              return CheckboxListTile(
                title: Text(permissionName),
                value: value,
                onChanged: (bool? newValue) async {
                  final isEnabled = newValue ?? false;
                  notifier.value = isEnabled; // Update local state
                  await updatePermission(
                      roleName, permissionName, isEnabled); // Persist change
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
