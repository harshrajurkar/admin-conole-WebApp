import 'package:flutter/material.dart';
import '../pages/dashboard_page.dart';
import '../pages/user_management_page.dart';
import '../pages/role_management_page.dart';
import '../pages/permission_management_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Admin Dashboard",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("User Management"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserManagementPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text("Role Management"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const RoleManagementPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Permission Management"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PermissionManagementPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
