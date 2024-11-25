import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/user_form.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Class-level variable

  Future<void> _addUser(String name, String email, String role) async {
    try {
      await firestore.collection('users').add({
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding user: $e')),
      );
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await firestore.collection('users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $e')),
      );
    }
  }

  Future<void> _updateUser(
      String userId, String name, String email, String role) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'name': name,
        'email': email,
        'role': role,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "User Management"),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').orderBy('createdAt').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching users'));
          }

          final users = snapshot.data!.docs;

          return Container(
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
                        final userData = user.data() as Map<String, dynamic>;
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              userData["name"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${userData["email"]} - ${userData["role"]}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit button
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => UserForm(
                                        userId: user.id,
                                        userName: userData["name"],
                                        userEmail: userData["email"],
                                        userRole: userData["role"],
                                        onSave: (name, email, role) {
                                          _updateUser(
                                              user.id, name, email, role);
                                        },
                                      ),
                                    );
                                  },
                                ),

                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteUser(user.id);
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
          );
        },
      ),

      // Floating Action Button for adding new users
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => UserForm(
              onSave: (name, email, role) {
                _addUser(name, email, role);
              },
            ),
          );
        },
        label: const Text("Add User"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }
}
