import 'package:Allergify/allergyinfo.dart';
import 'package:Allergify/allergyprofile.dart';
import 'package:Allergify/chatbot.dart';
import 'package:Allergify/help_support_page.dart';
import 'package:Allergify/homepage.dart';
import 'package:Allergify/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    double statusBarHeight =
        MediaQuery.of(context).padding.top; // Get status bar height

    return Container(
      height: statusBarHeight + 100, // Adjust AppBar height dynamically
      padding: EdgeInsets.only(top: statusBarHeight), // Push content down
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage('assets/images/appbar.png'), // AppBar background image
          fit: BoxFit.cover, // Stretches to fit the width
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // Remove shadow
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu,
                color: Color.fromARGB(255, 48, 45, 45)), // Sidebar menu icon
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

// 🌟 Sidebar Menu Implementation
Widget buildSideBarMenu(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  return StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data == null) {
        return Drawer(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      var userData = snapshot.data!;
      String name = userData['name'] ?? 'Your Name';
      String? profileImagePath = userData['profileImagePath'];

      return Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFBCE1D3),
              ),
              accountName: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              accountEmail: Text(
                user?.email ?? "Email",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: (profileImagePath != null &&
                        profileImagePath.isNotEmpty)
                    ? (profileImagePath
                            .startsWith('http') // Check if it's a network URL
                        ? NetworkImage(profileImagePath)
                        : AssetImage(profileImagePath) as ImageProvider)
                    : AssetImage("assets/images/default_profile_picture.png"),
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.person, color: Color.fromARGB(255, 148, 148, 148)),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      onProfileUpdated: () {}, // Empty callback
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.info, color: Color.fromARGB(255, 148, 148, 148)),
              title: Text(
                'About App',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Center(
                    child: Text(
                      'About Allergify',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  content: const Text(
                    'Allergify is a personalized allergen detection assistant designed to help users identify and avoid food allergens by scanning product ingredients. This app is powered by AI and OCR technologies and provides educational information, allergen tracking, and more to support allergy-safe living.\n\nVersion: 1.0.0\nDeveloped by Nurul Umairah',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'CLOSE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6EA08D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.developer_mode,
                  color: Color.fromARGB(255, 148, 148, 148)),
              title: Text(
                'About Developer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Center(
                    child: Text(
                      'About the Developer',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  content: const Text(
                    'Hi! I’m Nurul Umairah, a final-year Bachelor of Computer Science (Hons.) Mobile Computing student at Universiti Teknologi MARA (UiTM).\n\n'
                    'I developed Allergify as part of my final year project to support individuals with food allergies by providing a smart way to scan, detect, and learn about allergens using AI and OCR technologies.\n\n'
                    'My mission is to build inclusive and user-friendly mobile apps that make everyday life easier and safer.\n\n'
                    'Feel free to reach out or connect for collaboration or feedback!',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'CLOSE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6EA08D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help_outline,
                  color: Color.fromARGB(255, 148, 148, 148)),
              title: Text(
                'Help & Support',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpSupportPage()),
                );
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.logout, color: Color.fromARGB(255, 148, 148, 148)),
              title: Text(
                'Exit App',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              onTap: () => _logout(context),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      );
    },
  );
}

//  Logout Function
Future<void> _logout(BuildContext context) async {
  SystemNavigator.pop(); // Exit the app
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF6EA08D),
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0 && currentIndex != 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1 && currentIndex != 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatbotPage()),
          );
        } else if (index == 2 && currentIndex != 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AllergyInfoPage()),
          );
        } else if (index == 3 && currentIndex != 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AllergyProfilePage()),
          );
        } else {
          onTap(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 13,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.normal,
        color: Colors.white,
        fontSize: 12,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child:
                Image.asset('assets/images/scanner.jpg', width: 35, height: 35),
          ),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child:
                Image.asset('assets/images/chatbot.jpg', width: 40, height: 40),
          ),
          label: 'Chatbot',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset('assets/images/allergyinfo.jpg',
                width: 35, height: 35),
          ),
          label: 'Allergen Info',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Image.asset('assets/images/userprofile.jpg',
                width: 35, height: 35),
          ),
          label: 'Allergy Profile',
        ),
      ],
    );
  }
}
