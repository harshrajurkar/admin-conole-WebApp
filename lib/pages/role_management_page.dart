import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/role_form.dart';

class RoleManagementPage extends StatefulWidget {
  const RoleManagementPage({super.key});

  @override
  State<RoleManagementPage> createState() => _RoleManagementPageState();
}

class _RoleManagementPageState extends State<RoleManagementPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: "Role Management"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Manage Roles",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('roles')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading roles'));
                    }

                    final roles = snapshot.data?.docs ?? [];

                    if (roles.isEmpty) {
                      return const Center(child: Text('No roles found'));
                    }

                    return ListView.builder(
                      itemCount: roles.length,
                      itemBuilder: (context, index) {
                        final roleData = roles[index];
                        final roleName = roleData.id;
                        final permissions = (roleData['permissions']
                                as Map<String, dynamic>?)
                            ?.map((key, value) => MapEntry(key, value as bool));

                        return Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            title: Text(
                              roleName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.blueAccent,
                              ),
                            ),
                            // ExpansionTile automatically handles icon direction
                            children: [
                              permissions == null
                                  ? const ListTile(
                                      title: Text('No permissions set'))
                                  : Column(
                                      children:
                                          permissions.entries.map((entry) {
                                        return Row(
                                          children: [
                                            Checkbox(
                                              value: entry.value,
                                              onChanged:
                                                  null, // Permissions are read-only here
                                            ),
                                            Text(
                                              entry.key,
                                              style: const TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                              // Include the delete button
                              ListTile(
                                title: const Text(
                                  'Delete Role',
                                  style: TextStyle(color: Colors.red),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    try {
                                      // Firestore delete logic
                                      await FirebaseFirestore.instance
                                          .collection('roles')
                                          .doc(roleName)
                                          .delete();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Role deleted successfully!')),
                                      );
                                    } catch (e) {
                                      debugPrint('Firestore Error: $e');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Failed to delete role. Please try again later.')),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const RoleForm(),
          );
        },
        label: const Text("Add Role"),
        icon: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 108, 176, 243),
      ),
    );
  }
}
