import 'package:flutter/material.dart';
import 'package:orado_customer/features/profile/presentation/edit_profile_screen.dart';
import 'package:orado_customer/features/profile/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String route = 'profile';

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              child: ClipOval(
                child: Icon(Icons.person, size: 50, color: Colors.black),
              ),
              // backgroundImage: AssetImage(user.imageUrl),

            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              user.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(user.phone),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Address'),
              subtitle: Text(user.address),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.grey.shade300,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              child: const Text('Edit Profile',style: TextStyle(color: Colors.black),),
            ),
          ],
        ),
      ),
    );
  }
}
