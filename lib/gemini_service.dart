
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey =
      'YOUR_API_KEY'; // Replace with actual API key
  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent';

  Future<String> getChatbotResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": "You are a chatbot named Allergify AI, designed to provide assistance on food allergies, common allergen, allergic reactions, and emergency steps for managing symptoms. "
                      "You can answer questions about common allergens such as eggs, wheat, soy, fish, shellfish, milk, tree nuts, and peanuts, as well as provide guidance on allergy symptoms and their management. "
                      "Your role includes: "
                      "1. Helping users identify symptoms of an allergic reaction. "
                      "2. Providing first-aid instructions for mild to severe reactions. "
                      "3. Advising when to seek medical attention. "
                      "4. Giving dietary precautions to avoid allergens. "
                      "5. Offering practical tips to prevent allergic reactions in daily life. "
                      "If the user asks about non-allergy-related topics, reply with: "
                      "'That's an interesting question. However, I'm here to assist with allergy symptoms, emergency steps, and food allergy management. Feel free to ask me about them.'\n\n"
                      "User: $userMessage"
                }
              ]
            }
          ]
        }),
      );

      print('API Response: ${response.body}'); // Debugging log

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('candidates') && data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        } 
        else {
          return "No response from AI.";
        }
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
