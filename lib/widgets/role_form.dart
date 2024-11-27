import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RoleForm extends StatefulWidget {
  final String? roleName; // For editing existing roles
  final Map<String, bool>?
      initialPermissions; // Initial permissions for editing

  const RoleForm({super.key, this.roleName, this.initialPermissions});

  @override
  State<RoleForm> createState() => _RoleFormState();
}

class _RoleFormState extends State<RoleForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _roleNameController = TextEditingController();
  bool _readPermission = false;
  bool _writePermission = false;
  bool _deletePermission = false;

  @override
  void initState() {
    super.initState();
    if (widget.roleName != null) {
      _roleNameController.text = widget.roleName!;
      _loadRolePermissions(widget.initialPermissions);
    }
  }

  // Function to load role permissions from Firestore
  void _loadRolePermissions(Map<String, bool>? permissions) {
    if (permissions != null) {
      setState(() {
        _readPermission = permissions['Read'] ?? false;
        _writePermission = permissions['Write'] ?? false;
        _deletePermission = permissions['Delete'] ?? false;
      });
    }
  }

  // Function to validate and save the role
  Future<void> _saveRole() async {
    if (!_formKey.currentState!.validate()) {
      return; // Exit if validation fails
    }

    final roleName = _roleNameController.text.trim();
    final permissions = {
      'Read': _readPermission,
      'Write': _writePermission,
      'Delete': _deletePermission,
    };

    try {
      // Save or update role in Firestore
      final docRef =
          FirebaseFirestore.instance.collection('roles').doc(roleName);
      await docRef.set({'permissions': permissions});

      // Success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role saved successfully!')),
      );

      Navigator.pop(context); // Close the form
    } catch (e) {
      // Graceful error handling
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save role. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Role Name Field with Validation
              TextFormField(
                controller: _roleNameController,
                decoration: const InputDecoration(labelText: 'Role Name'),
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Role name is required.';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                    return 'Role name can only contain letters, numbers, and spaces.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Permissions Checkboxes
              CheckboxListTile(
                title: const Text('Read Permission'),
                value: _readPermission,
                onChanged: (value) => setState(() {
                  _readPermission = value ?? false;
                }),
              ),
              CheckboxListTile(
                title: const Text('Write Permission'),
                value: _writePermission,
                onChanged: (value) => setState(() {
                  _writePermission = value ?? false;
                }),
              ),
              CheckboxListTile(
                title: const Text('Delete Permission'),
                value: _deletePermission,
                onChanged: (value) => setState(() {
                  _deletePermission = value ?? false;
                }),
              ),

              const SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: _saveRole,
                child: const Text('Save Role'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
