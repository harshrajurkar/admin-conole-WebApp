import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? _selectedRole; // Variable to store the selected role

  // Fetch available roles from Firestore
  Future<List<String>> _fetchRoles() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('roles').get();
      // Get document IDs as role names
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching roles: $e");
      return []; // Return an empty list on error
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName ?? '');
    _emailController = TextEditingController(text: widget.userEmail ?? '');
    _selectedRole = widget.userRole; // Pre-set the role if available
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.userId == null ? 'Add User' : 'Edit User'),
      content: Form(
        key: _formKey,
        child: FutureBuilder<List<String>>(
          future: _fetchRoles(), // Fetch roles from Firestore
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading roles: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No roles available.'));
            }

            final roles = snapshot.data!;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name TextField
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
                // Email TextField
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
                // Dropdown for Role Selection
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Save/Submit button
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                _nameController.text,
                _emailController.text,
                _selectedRole!, // Pass the selected role
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
