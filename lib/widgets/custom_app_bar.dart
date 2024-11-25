import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/login_page.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blue.shade700, // Consistent color palette
      elevation: 5,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: "Logout",
          onPressed: () async {
            bool? confirmLogout = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirm Logout"),
                content: const Text("Are you sure you want to log out?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Logout"),
                  ),
                ],
              ),
            );

            if (confirmLogout == true) {
              await FirebaseAuth.instance.signOut(); // Sign out the user
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
