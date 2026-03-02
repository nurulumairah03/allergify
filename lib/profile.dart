import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  const ProfileScreen({Key? key, required this.onProfileUpdated})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  String? _profileImagePath;
  String? _name;
  String? _email;
  String? _phone;
  String? _cityState;
  String? _country;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email; // Load email from FirebaseAuth first
      });

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['name'];
          _phone = userDoc['phone'];
          _cityState = userDoc['cityState'];
          _country = userDoc['country'];
          _profileImagePath =
              userDoc.data().toString().contains('profileImagePath')
                  ? userDoc['profileImagePath']
                  : 'assets/images/default_profile_picture.png';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          child: AppBar(
            backgroundColor: const Color.fromARGB(
                193, 114, 164, 147), // Transparent so gradient shows
            elevation: 0, // Remove shadow for a clean look
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left, // Use chevron icon instead of arrow
                color: Colors.white, // Make it white like the text
                size: 30, // Adjust size for better visibility
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back when pressed
              },
            ),
            title: const Text(
              ' ',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white, // Make text white
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              color:
                  Color.fromARGB(193, 114, 164, 147), // Single color background
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImagePath != null
                      ? AssetImage(_profileImagePath!)
                      : const AssetImage(
                          'assets/images/default_profile_picture.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  _name ?? 'Not provided',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProfileItem('Your Name', _name),
                _buildProfileItem('Your Email', _email),
              //  _buildProfileItem('Your Phone', _phone),
              //  _buildProfileItem('City, State', _cityState),
              //  _buildProfileItem('Country', _country),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      name: _name,
                      profileImage: _profileImage,
                      email: _email, // Ensure email is passed
                      phone: _phone,
                      cityState: _cityState,
                      country: _country,
                      onProfileUpdated: () {
                        _loadProfileData(); // Reload profile after update
                        widget.onProfileUpdated(); // Notify parent
                      },
                    ),
                  ),
                );
                _loadProfileData(); // Refresh data after editing
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 134, 188, 168),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value ?? 'Not provided',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Divider(height: 20, thickness: 1, color: Colors.grey),
      ],
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String? name;
  final File? profileImage;
  final String? email;
  final String? password;
  final String? phone;
  final String? cityState;
  final String? country;
  final VoidCallback onProfileUpdated;

  const EditProfileScreen({
    Key? key,
    this.name,
    this.profileImage,
    this.email,
    this.password,
    this.phone,
    this.cityState,
    this.country,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  File? _profileImage;
  String? _profileImagePath;

  final List<String> _iconPaths = [
    'assets/images/milkc.png',
    'assets/images/peanutc.png',
    'assets/images/soyc.png',
    'assets/images/fishc.png',
    'assets/images/shellfishc.png',
    'assets/images/wheatc.png',
    'assets/images/treenutc.png',
    'assets/images/eggc.png',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _cityController = TextEditingController(text: widget.cityState ?? '');
    _countryController = TextEditingController(text: widget.country ?? '');
    _profileImage = widget.profileImage;
    _profileImagePath = widget.profileImage?.path;

    _loadProfileImage(); // Load latest profile image from Firestore
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists &&
          userDoc.data().toString().contains('profileImagePath')) {
        setState(() {
          _profileImagePath = userDoc['profileImagePath']; // Update UI
        });
      }
    }
  }

  Future<void> _pickImage() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseAvatarScreen(
          iconPaths: _iconPaths,
          onAvatarSelected: (selectedPath) async {
            setState(() {
              _profileImagePath = selectedPath;
              _profileImage = null; // Clear file image
            });
            await _saveProfileImagePath();
          },
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'cityState': _cityController.text,
        'country': _countryController.text,
      }, SetOptions(merge: true));
    }
    widget.onProfileUpdated();
  }

  Future<void> _saveProfileImagePath() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _profileImagePath != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profileImagePath': _profileImagePath,
      }, SetOptions(merge: true));

      setState(() {}); // Refresh UI immediately
      widget.onProfileUpdated(); // Notify parent screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          child: AppBar(
            backgroundColor: const Color.fromARGB(
                193, 114, 164, 147), // Transparent so gradient shows
            elevation: 0, // Remove shadow for a clean look
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left, // Use chevron icon instead of arrow
                color: Colors.white, // Make it white like the text
                size: 30, // Adjust size for better visibility
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back when pressed
              },
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white, // Make text white
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (_profileImagePath != null &&
                                _profileImagePath!.startsWith('assets/'))
                            ? AssetImage(_profileImagePath!)
                            : const AssetImage(
                                    'assets/images/default_profile_picture.png')
                                as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 134, 188, 168),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildEditableField('Your Name', _nameController),
            _buildEditableField('Your Phone', _phoneController),
       //     _buildEditableField('City, State', _cityController),
       //     _buildEditableField('Country', _countryController),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  _saveProfile(); // Save immediately when button is pressed
                  Navigator.pop(context); // Close the screen after saving
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 134, 188, 168),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            _saveProfile(); // Save profile immediately when a field is edited
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class ChooseAvatarScreen extends StatelessWidget {
  final List<String> iconPaths;
  final Function(String) onAvatarSelected;

  const ChooseAvatarScreen({
    Key? key,
    required this.iconPaths,
    required this.onAvatarSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          child: AppBar(
            backgroundColor: const Color.fromARGB(
                255, 255, 255, 255), // Transparent so gradient shows
            elevation: 0, // Remove shadow for a clean look
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left, // Use chevron icon instead of arrow
                color:
                    Color.fromARGB(255, 0, 0, 0), // Make it white like the text
                size: 30, // Adjust size for better visibility
              ),
              onPressed: () {
                Navigator.pop(context); // Navigate back when pressed
              },
            ),
            title: const Text(
              'Choose Avatar',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                color: Color.fromARGB(255, 0, 0, 0), // Make text white
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: iconPaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onAvatarSelected(iconPaths[index]);
                Navigator.pop(context);
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 50,
                backgroundImage: AssetImage(iconPaths[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
