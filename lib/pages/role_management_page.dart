import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/role_form.dart';

class RoleManagementPage extends StatelessWidget {
  const RoleManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = ["Admin", "Editor", "Viewer"]; // Mock role list for now
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

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
              // Page title
              const Text(
                "Manage Roles",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Role List
              Expanded(
                child: ListView.builder(
                  itemCount: roles.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          roles[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit button
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      RoleForm(roleName: roles[index]),
                                );
                              },
                            ),

                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // TODO: Add delete role logic
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button for adding new roles
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
