import 'package:flutter/material.dart';

class RoleForm extends StatefulWidget {
  final String? roleName; // Null means adding a new role
  const RoleForm({super.key, this.roleName});

  @override
  State<RoleForm> createState() => _RoleFormState();
}

class _RoleFormState extends State<RoleForm> {
  @override
  Widget build(BuildContext context) {
    final roleController = TextEditingController(text: widget.roleName);

    return AlertDialog(
      title: Text(widget.roleName == null ? "Add Role" : "Edit Role"),
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
