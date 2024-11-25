import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  final String? userName; // Null means adding a new user
  final String? userEmail;
  final String? userRole;

  const UserForm({
    super.key,
    this.userName,
    this.userEmail,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: userEmail);
    String selectedRole = userRole ?? "Viewer"; // Default role

    return AlertDialog(
      title: Text(userName == null ? "Add User" : "Edit User"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: ["Admin", "Editor", "Viewer"]
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedRole = value;
                }
              },
              decoration: const InputDecoration(labelText: "Role"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Save user data to Firestore
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
