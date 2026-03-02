import 'package:Allergify/scanningpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 1.0);
  late Timer _timer;
  int _currentIndex = 0;

  final List<Widget> scrollItems = [
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/family.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "   Eat with confidence. Protect your health\nand your loved ones.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/check.png',
          width: 265,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Check food labels for allergens before\nconsuming any product.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/allergifyb.png',
          width: 260,
          height: 250,
        ),
        const SizedBox(height: 10),
        const Text(
          "Use our scanner to detect potential\nallergens instantly!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 97, 125, 115),
          ),
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        if (_currentIndex < scrollItems.length - 1) {
          // Scroll to the next page
          _currentIndex++;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        } else {
          // When reaching the last page, jump instantly to the first one
          _currentIndex = 0;
          _pageController.jumpToPage(_currentIndex);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = kToolbarHeight;
    double navBarHeight = kBottomNavigationBarHeight;

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: buildSideBarMenu(context), // Add the sidebar menu here
      body: SizedBox(
        height: screenHeight - appBarHeight - navBarHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/home.png',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: -70, // Push it downwards
              left: -40,
              right: -40,
              child: Center(
                // Center the ellipse
                child: Container(
                  width: 450, // Set your desired width
                  height: 325, // Control height for the half-ellipse look
                  decoration: BoxDecoration(
                    color: Color(0xFFBCE1D3),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(250), // Half-circle shape
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 117, 117, 117)
                            .withOpacity(0.4),
                        blurRadius: 25,
                        spreadRadius: 5,
                        offset: Offset(5, 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.02,
              left: 20,
              right: 20,
              child: SizedBox(
                height: 300, // Scrolling content height
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Center(
                        child: scrollItems[index % scrollItems.length]);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.20,
              child: const Text(
                "ALLERGIFY",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 247, 247, 247),
                  shadows: [
                    Shadow(
                      blurRadius: 3.0,
                      color: Colors.grey,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.00,
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanningPage(),
                        ),
                      );
                    },
                    icon:
                        const Icon(Icons.qr_code_scanner, color: Colors.black),
                    label: const Text(
                      "Start Scanning",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDEFFF2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      elevation: 5,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// 🚨 Full-Width Banner Ad with Play Store Redirect
                  GestureDetector(
                    onTap: () async {
                      const url =
                          'https://play.google.com/store/apps/details?id=com.watsons.mcommerce';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
