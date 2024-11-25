import 'package:flutter/material.dart';

class RoleForm extends StatelessWidget {
  final String? roleName; // Null means adding a new role
  const RoleForm({super.key, this.roleName});

  @override
  Widget build(BuildContext context) {
    final roleController = TextEditingController(text: roleName);

    return AlertDialog(
      title: Text(roleName == null ? "Add Role" : "Edit Role"),
      content: TextField(
        controller: roleController,
        decoration: const InputDecoration(labelText: "Role Name"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            // TODO: Add role save logic (Firestore update or add)
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
