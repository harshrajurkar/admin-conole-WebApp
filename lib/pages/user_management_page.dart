import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/user_form.dart';

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock list of users
    final List<Map<String, String>> users = [
      {"name": "John Doe", "email": "john.doe@example.com", "role": "Editor"},
      {
        "name": "Jane Smith",
        "email": "jane.smith@example.com",
        "role": "Admin"
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: "User Management"),
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
              const SizedBox(height: 20),

              // Page title
              const Text(
                "Manage Users",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // User list
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          user["name"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "${user["email"]!} - ${user["role"]!}",
                          style: const TextStyle(fontSize: 14),
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
                                  builder: (_) => UserForm(
                                    userName: user["name"],
                                    userEmail: user["email"],
                                    userRole: user["role"],
                                  ),
                                );
                              },
                            ),

                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // TODO: Add delete logic
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

      // Floating Action Button for adding new users
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const UserForm(),
          );
        },
        label: const Text("Add User"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }
}
