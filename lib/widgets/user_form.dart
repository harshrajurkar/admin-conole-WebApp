import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  final String? userId; // Optional for edit
  final String? userName;
  final String? userEmail;
  final String? userRole;
  final void Function(String name, String email, String role) onSave;

  const UserForm({
    super.key,
    this.userId,
    this.userName,
    this.userEmail,
    this.userRole,
    required this.onSave,
  });

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName ?? '');
    _emailController = TextEditingController(text: widget.userEmail ?? '');
    _roleController = TextEditingController(text: widget.userRole ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.userId == null ? 'Add User' : 'Edit User'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _roleController,
              decoration: const InputDecoration(labelText: 'Role'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a role';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text,
                _emailController.text,
                _roleController.text,
              );
              Navigator.of(context).pop();
            }
          },
          child: Text(widget.userId == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
