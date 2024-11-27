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

  bool _isStatsExpanded = true; // For toggling stats card

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
                const SizedBox(height: 20),

                // Animated Expansion Panel for Stats
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isStatsExpanded
                      ? Column(
                          key: const ValueKey(1),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
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
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => setState(() {
                                _isStatsExpanded = false;
                              }),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text("Hide Stats"),
                            ),
                          ],
                        )
                      : ElevatedButton.icon(
                          key: const ValueKey(2),
                          onPressed: () => setState(() {
                            _isStatsExpanded = true;
                          }),
                          icon: const Icon(Icons.expand_more),
                          label: const Text("Show Stats"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade700,
                          ),
                        ),
                ),

                const SizedBox(height: 20),

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
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

  void _logout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
