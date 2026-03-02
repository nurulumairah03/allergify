import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F8EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6EA08D),
        centerTitle: false, // Not centered
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white, // Set title color to white
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FAQs',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                'How to use the app?',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'You can scan ingredient labels, view allergen information, manage your profile, and use the AI chatbot for help.',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'How to contact support?',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'You can reach us via email, phone, or live chat (see below).',
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Contact Us',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Icon(Icons.email, size: 24, color: Colors.black87),
              title: Text(
                'Email',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'nnurulumairah13@gmail.com',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Icon(Icons.phone, size: 24, color: Colors.black87),
              title: Text(
                'Phone',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                '+6016-833 6035',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              leading: Icon(Icons.chat_bubble_outline,
                  size: 24, color: Colors.black87),
              title: Text(
                'Live Chat',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'Chat via WhatsApp',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              tileColor: Color(0xFFE8F8EF),
              onTap: () async {
                final Uri url = Uri.parse(
                    'https://wa.me/60168336035?text=Hi!%20I%20need%20help%20with%20the%20Allergify%20app.');
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open WhatsApp')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
