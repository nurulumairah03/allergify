import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets.dart';

class AllergyProfilePage extends StatefulWidget {
  const AllergyProfilePage({super.key});

  @override
  _AllergyProfilePageState createState() => _AllergyProfilePageState();
}

class _AllergyProfilePageState extends State<AllergyProfilePage> {
  int _selectedIndex = 3; // Set to "Allergy Profile" tab
  Map<String, bool> selectedAllergens = {
    "Milk": false,
    "Egg": false,
    "Wheat": false,
    "Soy": false,
    "Tree nuts": false,
    "Peanut": false,
    "Fish": false,
    "Shellfish": false,
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigation logic (if needed)
    });
  }

  @override
void initState() {
  super.initState();
  _loadPreferences(); // Load saved allergens
}

void _savePreferences() async {
  final prefs = await SharedPreferences.getInstance();
  selectedAllergens.forEach((key, value) {
    prefs.setBool(key, value);
  });
}

void _loadPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    selectedAllergens.forEach((key, _) {
      selectedAllergens[key] = prefs.getBool(key) ?? false;
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8), // Background color
      appBar: CustomAppBar(),
      drawer: buildSideBarMenu(context), // Add the sidebar menu here
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Text(
              "My Allergy Profile",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3), // Reduced spacing

            // Left-aligned Green Line Divider
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 8), // Reduced spacing

            // Description
            const Text(
              "Select your allergens to receive personalized warnings when scanning products.",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12), // Reduced spacing

            // List of Allergens with Switches (Moved Up)
            Expanded(
              child: ListView(
                shrinkWrap: true, // Allows ListView to adjust to content size
                physics: const NeverScrollableScrollPhysics(), // Disable scrolling
                children: selectedAllergens.keys.map((allergen) {
                  return allergenToggle(allergen, getAllergenImage(allergen));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Allergen Toggle Widget
  Widget allergenToggle(String name, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0), // Reduced vertical spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(imagePath, width: 35, height: 35), // Icon size
              const SizedBox(width: 8), // Reduced spacing
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Switch(
            value: selectedAllergens[name]!,
            activeColor: const Color(0xFF6EA08D),
onChanged: (bool value) {
  setState(() {
    selectedAllergens[name] = value;
    _savePreferences(); // save to SharedPreferences
  });
}
          ),
        ],
      ),
    );
  }

  // Map allergen name to image path
  String getAllergenImage(String name) {
    Map<String, String> allergenImages = {
      "Milk": "assets/images/milkr.png",
      "Egg": "assets/images/eggr.png",
      "Wheat": "assets/images/wheatr.png",
      "Soy": "assets/images/soyr.png",
      "Tree nuts": "assets/images/treenutr.png",
      "Peanut": "assets/images/peanutr.png",
      "Fish": "assets/images/fishr.png",
      "Shellfish": "assets/images/shellfishr.png",
    };
    return allergenImages[name] ?? "";
  }
}
