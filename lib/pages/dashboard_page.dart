import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'user_management_page.dart';
import 'role_management_page.dart';
import 'permission_management_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: const CustomAppBar(title: "Dashboard"),
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
              mainAxisAlignment: MainAxisAlignment.center,
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
}
