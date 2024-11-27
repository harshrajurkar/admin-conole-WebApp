import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vrv_security/pages/login_page.dart';
import 'user_management_page.dart';
import 'role_management_page.dart';
import 'permission_management_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Stream to get the count of users
  Stream<int> _getUserCount() {
    return firestore
        .collection('users')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream to get the count of active users
  Stream<int> _getActiveUserCount() {
    return firestore
        .collection('users')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // Stream to get the count of roles
  Stream<int> _getRoleCount() {
    return firestore
        .collection('roles')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              children: [
                const Text(
                  'Welcome to the Admin Dashboard!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // Stats Row for Total Users, Active Users, and Roles
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Total Users Card
                    StreamBuilder<int>(
                      stream: _getUserCount(),
                      builder: (context, snapshot) {
                        final userCount = snapshot.data ?? 0;
                        return _buildStatCard(
                          'Total Users',
                          userCount.toString(),
                        );
                      },
                    ),

                    // Active Users Card
                    StreamBuilder<int>(
                      stream: _getActiveUserCount(),
                      builder: (context, snapshot) {
                        final activeUserCount = snapshot.data ?? 0;
                        return _buildStatCard(
                          'Active Users',
                          activeUserCount.toString(),
                        );
                      },
                    ),

                    // Total Roles Card
                    StreamBuilder<int>(
                      stream: _getRoleCount(),
                      builder: (context, snapshot) {
                        final roleCount = snapshot.data ?? 0;
                        return _buildStatCard(
                          'Total Roles',
                          roleCount.toString(),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Card container for buttons
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Manage Users Button
                        _buildActionButton(
                          context,
                          icon: Icons.group,
                          label: 'Manage Users',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UserManagementPage(),
                              ),
                            );
                          },
                          isLargeScreen: isLargeScreen,
                        ),
                        const SizedBox(height: 20),

                        // Manage Roles Button
                        _buildActionButton(
                          context,
                          icon: Icons.security,
                          label: 'Manage Roles',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RoleManagementPage(),
                              ),
                            );
                          },
                          isLargeScreen: isLargeScreen,
                        ),
                        const SizedBox(height: 20),

                        // Manage Permissions Button
                        _buildActionButton(
                          context,
                          icon: Icons.lock,
                          label: 'Manage Permissions',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PermissionManagementPage(),
                              ),
                            );
                          },
                          isLargeScreen: isLargeScreen,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build stat cards
  Widget _buildStatCard(String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build responsive action buttons
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isLargeScreen,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: isLargeScreen ? 30 : 24, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(
          fontSize: isLargeScreen ? 18 : 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: EdgeInsets.symmetric(
          vertical: isLargeScreen ? 20 : 14,
          horizontal: isLargeScreen ? 40 : 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
    );
  }

  // Method to handle logout
  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
