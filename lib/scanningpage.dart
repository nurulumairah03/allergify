import 'dart:convert';
import 'dart:io';
import 'package:Allergify/allergyprofile.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({super.key});

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _flashOn = false;
  bool hasScanned = false;
  Map<String, List<String>> detectedAllergen = {};
  Map<String, bool> activeAllergens = {};
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadUserAllergyPreferences();
  }

  String formatCategory(String category) {
    category = category.replaceAll('"', ''); // remove quotation marks
    if (category.isEmpty) return category;
    return category[0].toUpperCase() + category.substring(1).toLowerCase();
  }

  String? _getAllergenIconPath(String allergenGroup) {
    final mapping = {
      "Milk": "assets/images/milkr.png",
      "Tree nuts": "assets/images/treenutr.png",
      "Shellfish": "assets/images/shellfishr.png",
      "Fish": "assets/images/fishr.png",
      "Peanut": "assets/images/peanutr.png",
      "Wheat": "assets/images/wheatr.png",
      "Egg": "assets/images/eggr.png",
      "Soy": "assets/images/soyr.png",
    };

    return mapping[formatCategory(allergenGroup)];
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController?.initialize();
    setState(() => _isCameraInitialized = true);
  }

  Future<void> _captureAndScanImage() async {
    if (_cameraController == null || !_isCameraInitialized) return;

    setState(() {
      isProcessing = true;
      hasScanned = false;
    });

    try {
      final image = await _cameraController!.takePicture();
      final response = await sendImageToPython(File(image.path));
      if (response != null) {
        setState(() {
          detectedAllergen = response;
          hasScanned = true;
        });
      }
    } catch (e) {
      print("❌ Capture/scan failed: $e");
    } finally {
      setState(() => isProcessing = false);
    }
  }

  Future<Map<String, List<String>>?> sendImageToPython(File imageFile) async {
    var uri = Uri.parse(
        'https://allergen-api-105702082846.asia-southeast1.run.app/scan');
    var request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      var respStr = await response.stream.bytesToString();
      final decoded = jsonDecode(respStr);

      final Map<String, dynamic> allergens = decoded['detected_allergens'];
      return allergens
          .map((key, value) => MapEntry(key, List<String>.from(value)));
    } else {
      print("❌ Server error: ${response.statusCode}");
      return null;
    }
  }

  void _loadUserAllergyPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = [
      "Milk",
      "Egg",
      "Wheat",
      "Soy",
      "Tree nuts",
      "Peanut",
      "Fish",
      "Shellfish"
    ];

    final Map<String, bool> filtered = {};
    for (var key in keys) {
      if (prefs.getBool(key) == true) {
        filtered[key] = true;
      }
    }

    setState(() {
      activeAllergens = filtered;
    });
  }

  void _toggleFlash() async {
    if (_cameraController != null) {
      _flashOn = !_flashOn;
      await _cameraController!
          .setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredDetectedAllergens = detectedAllergen.entries
        .where(
            (entry) => activeAllergens.containsKey(formatCategory(entry.key)))
        .toList();
    final detectedKeys =
        filteredDetectedAllergens.map((e) => formatCategory(e.key)).toSet();
    final enabledKeys = activeAllergens.keys.toSet();
    final notDetectedAllergens = enabledKeys.difference(detectedKeys);
    final allAllergenGroups = {
  "Milk",
  "Egg",
  "Wheat",
  "Soy",
  "Tree nuts",
  "Peanut",
  "Fish",
  "Shellfish"
};

// Extract detected groups from backend response (regardless of user selection)
final allDetectedGroups = detectedAllergen.keys
    .map((e) => formatCategory(e))
    .where((key) => allAllergenGroups.contains(key))
    .toList();

// Check if no allergens detected at all
final noAllergensDetected = allDetectedGroups.isEmpty;

final allDetectedKeys = detectedAllergen.keys.map((e) => formatCategory(e)).toSet();
final bool hasAnyDetection = allDetectedKeys.isNotEmpty;


    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_cameraController!),

                // Flash Toggle
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: Icon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _toggleFlash,
                  ),
                ),

// Capture Button - Only show when not scanned AND allergen groups are enabled
                if (!hasScanned && activeAllergens.isNotEmpty)
                  Positioned(
                    bottom: 270,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Material(
                        borderRadius: BorderRadius.circular(22),
                        elevation: 6,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isProcessing
                                  ? [Color(0xFFBDBDBD), Color(0xFFE0E0E0)]
                                  : [Color(0xFFB2F7EF), Color(0xFFDEFFF2)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: InkWell(
                            onTap: isProcessing ? null : _captureAndScanImage,
                            borderRadius: BorderRadius.circular(22),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isProcessing
                                        ? 'PROCESSING...'
                                        : 'CAPTURE   📷',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 59, 59, 59),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Transparent white scanning guide box - shown only before scanning
                if (!hasScanned)
                  Positioned(
                    bottom: 350, // adjust this value as needed
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1,
                    child: Container(
                      height: 310,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
// Close Button (Top Right)
                Positioned(
                  top: 50,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: const EdgeInsets.all(16),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // 🔗 Clickable Interstitial Ad Image
                              GestureDetector(
                                onTap: () async {
                                  const url =
                                      'https://play.google.com/store/apps/details?id=com.watsons.mcommerce';
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(
                                      Uri.parse(url),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/images/interstitial.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              // ❌ Close Ad Button
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(Icons.close_rounded,
                                      color: Colors.white, size: 28),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the ad
                                    Navigator.of(context)
                                        .pop(); // Navigate back to Home
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ),

                // Result Panel
                DraggableScrollableSheet(
                  initialChildSize: 0.30,
                  minChildSize: 0.30,
                  maxChildSize: 0.80,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          if (activeAllergens.isEmpty && !hasScanned)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'No allergen groups enabled',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'You need to enable at least one allergen\ngroup to proceed with scanning.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AllergyProfilePage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF91D2B9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  child: const Text(
                                    'OPEN ALLERGY PROFILE',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          // Reset Button
                          if (hasScanned)
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    detectedAllergen = {};
                                    hasScanned = false;
                                  });
                                },
                                icon: const Icon(Icons.refresh, size: 16),
                                label: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  backgroundColor:
                                      const Color.fromARGB(55, 171, 171, 171),
                                  foregroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  elevation: 0,
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),

if (hasScanned) ...[
  // If any detected allergen (after filtering) is found
  if (filteredDetectedAllergens.isNotEmpty) ...[
    const Text(
      '⚠️  THIS PRODUCT MAY CONTAIN',
      style: TextStyle(
        fontSize: 17,
        fontFamily: 'Poppins',
        color: Colors.black87,
      ),
    ),
    const SizedBox(height: 8),

    // List of detected allergen groups
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: filteredDetectedAllergens.map((entry) {
        final category = formatCategory(entry.key);
        final alternatives = entry.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_getAllergenIconPath(category) != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(
                        _getAllergenIconPath(category)!,
                        width: 32,
                        height: 32,
                      ),
                    ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: alternatives.map((alt) {
                  final random = Random(alt.hashCode);
                  final color = Color.fromARGB(
                    255,
                    200 + random.nextInt(55),
                    200 + random.nextInt(55),
                    200 + random.nextInt(55),
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      alt,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  ],if (!hasAnyDetection) ...[
  const Text(
    'No keyword matches found',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 17,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  const SizedBox(height: 10),
  const Text(
    'No relevant ingredients or terms were\nfound in this scan.',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      color: Colors.black54,
    ),
  ),
],


  // Always show this after scanning, if there are allergens enabled but not detected
  if (hasAnyDetection && notDetectedAllergens.isNotEmpty) ...[
    const SizedBox(height: 20),
    const Text(
      '✅  THIS PRODUCT IS FREE FROM',
      style: TextStyle(
        fontSize: 18,
        fontFamily: 'Poppins',
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    ),
    const SizedBox(height: 8),
    Wrap(
      spacing: 10,
      runSpacing: 10,
      children: notDetectedAllergens.map((key) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(200, 230, 201, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            formatCategory(key),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    ),
  ],
],


                          // Instructions
                          if (!hasScanned && activeAllergens.isNotEmpty) ...[
                            const Icon(Icons.arrow_upward,
                                size: 30, color: Colors.black45),
                            const SizedBox(height: 6),
                            const Text(
                              '📸 Position the camera to focus\non the ingredient label, then\ntap Capture.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
