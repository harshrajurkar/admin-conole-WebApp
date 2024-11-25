import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class PermissionManagementPage extends StatefulWidget {
  const PermissionManagementPage({super.key});

  @override
  State<PermissionManagementPage> createState() =>
      _PermissionManagementPageState();
}

class _PermissionManagementPageState extends State<PermissionManagementPage> {
  // Mock roles with permissions and their initial states
  final List<Map<String, dynamic>> roles = [
    {
      "name": "Admin",
      "permissions": [
        {"name": "Read", "enabled": true},
        {"name": "Write", "enabled": true},
        {"name": "Delete", "enabled": true},
      ],
    },
    {
      "name": "Editor",
      "permissions": [
        {"name": "Read", "enabled": true},
        {"name": "Write", "enabled": true},
        {"name": "Delete", "enabled": false},
      ],
    },
    {
      "name": "Viewer",
      "permissions": [
        {"name": "Read", "enabled": true},
        {"name": "Write", "enabled": false},
        {"name": "Delete", "enabled": false},
      ],
    },
  ];

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: roles.length,
            itemBuilder: (context, index) {
              final role = roles[index];
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    role["name"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    ...role["permissions"].map<Widget>((permission) {
                      return CheckboxListTile(
                        title: Text(permission["name"]),
                        value: permission["enabled"],
                        onChanged: (bool? value) {
                          setState(() {
                            permission["enabled"] = value ?? false;
                          });
                          Future<void> _updatePermission(String roleName,
                              String permissionName, bool enabled) async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('roles')
                                  .doc(roleName)
                                  .update({
                                'permissions.$permissionName': enabled,
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Error updating permission: $e')),
                              );
                            }
                          }
                        },
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
