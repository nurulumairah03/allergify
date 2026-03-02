import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'custom_widgets.dart';
import 'package:Allergify/gemini_service.dart';
import 'homepage.dart'; // Import HomePage
import 'package:audioplayers/audioplayers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _messageController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;

  bool get _showSuggestions {
    return _messages.length == 1 && _messages.first["sender"] == "bot";
  }

  List<Map<String, String>> _messages = [];
  bool _isTyping = false; // Track if chatbot is typing

  final List<Map<String, String>> _allSuggestedQuestions = [
    {"emoji": "❓", "text": "What are the symptoms of a peanut allergy?"},
    {"emoji": "🧯", "text": "How do I treat a mild allergic reaction?"},
    {"emoji": "📛", "text": "When should I use an epinephrine injection?"},
    {
      "emoji": "🚫",
      "text": "What foods should I avoid if I'm allergic to soy?"
    },
    {"emoji": "🍤", "text": "What happens during a shellfish allergy?"},
    {"emoji": "🍼", "text": "Is milk allergy the same as lactose intolerance?"},
    {"emoji": "🌰", "text": "Which nuts are most likely to cause allergies?"},
    {"emoji": "🏥", "text": "When should I seek emergency help for allergies?"},
    {"emoji": "🌾", "text": "Can I be allergic to wheat and not gluten?"},
    {"emoji": "👃", "text": "What are signs of airborne food allergies?"},
    {"emoji": "🥛", "text": "Is lactose-free milk safe for milk allergy?"},
    {"emoji": "👶", "text": "How to manage allergies in young children?"},
    {"emoji": "🍱", "text": "How can I eat out safely with food allergies?"},
    {"emoji": "📦", "text": "How do I read food labels for allergens?"},
    {"emoji": "🔁", "text": "Can allergic reactions get worse over time?"},
    {"emoji": "📋", "text": "What should I include in an allergy action plan?"},
    {"emoji": "💉", "text": "Are allergy shots effective for food allergies?"},
    {"emoji": "🍽️", "text": "How do I prepare allergen-free meals?"},
    {"emoji": "🎒", "text": "What should I pack in an allergy emergency kit?"},
    {
      "emoji": "🍳",
      "text": "Can I still eat baked goods if I have an egg allergy?"
    },
    {"emoji": "🥜", "text": "Are peanuts and tree nuts the same in allergies?"},
    {
      "emoji": "🚨",
      "text": "What are the signs of a severe allergic reaction?"
    },
    {"emoji": "💊", "text": "What medication should I carry for allergies?"},
    {
      "emoji": "👨‍⚕️",
      "text": "When should I consult a doctor about my allergies?"
    },
    {
      "emoji": "🍔",
      "text": "How can I avoid cross-contact with allergens when eating out?"
    },
    {
      "emoji": "🧃",
      "text": "Can juice or processed drinks contain hidden allergens?"
    },
    {
      "emoji": "🧠",
      "text": "What should I do if someone is having an allergic reaction?"
    },
    {
      "emoji": "🧴",
      "text": "Can lotions or soaps cause allergic reactions too?"
    },
    {
      "emoji": "🍽",
      "text":
          "What’s a safe diet plan for someone with multiple food allergies?"
    },
    {
      "emoji": "🚸",
      "text": "How do I help kids learn to manage their food allergies?"
    },
    {
      "emoji": "🔍",
      "text": "How can I spot hidden allergens in ingredient labels?"
    },
    {"emoji": "👩‍🍳", "text": "What are some allergen-free recipe ideas?"},
    {
      "emoji": "📆",
      "text": "Should I track my allergy reactions in a journal?"
    },
    {
      "emoji": "📞",
      "text": "What should I say in an emergency call for an allergic reaction?"
    },
    {
      "emoji": "🏕",
      "text": "How do I stay allergy-safe while traveling or camping?"
    },
    {"emoji": "🧺", "text": "Can laundry products trigger allergic reactions?"}
  ];

  List<Map<String, String>> _suggestedQuestions = [];

  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _speechToText.initialize();
    _messageController.addListener(() {
      setState(() {}); // This ensures UI updates when text is typed or cleared
    });

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.offset;
      bool atBottom = currentScroll >= maxScroll - 20;

      setState(() {
        _showScrollToBottomButton =
            !atBottom; // Show button only if not at bottom
      });
    });
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final String? messagesString = prefs.getString('chat_messages');

    if (messagesString != null) {
      try {
        List<dynamic> messagesList = jsonDecode(messagesString);
        setState(() {
          _messages = List<Map<String, String>>.from(
              messagesList.map((msg) => Map<String, String>.from(msg)));
        });
      } catch (e) {
        print("Error loading messages: $e");
        setState(() {
          _messages = [];
        });
      }
    }

    if (_messages.isEmpty) {
      setState(() {
        _messages.add({
          "sender": "bot",
          "message":
              "Hi there! I'm the Allergify AI. Ask me anything about food allergies, safety tips, or common allergens like eggs, wheat, soy, fish, shellfish, milk, tree nuts, and peanuts only."
        });
      });

      // ✅ Shuffle suggestions when no chat history
      _shuffleSuggestions();
    }
  }

  void _shuffleSuggestions() {
    final random = _allSuggestedQuestions.toList()..shuffle();
    setState(() {
      _suggestedQuestions = random.take(4).toList();
    });
  }

  Future<void> _playSound(String fileName) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _startListening() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        if (status == "done") {
          _stopListening(); // Ensure it stops properly when speech ends
        }
      },
      onError: (error) {
        print("Speech Recognition Error: $error");
        _stopListening(); // Stop in case of errors
      },
    );

    if (available && !_isListening) {
      setState(() => _isListening = true); // Only update when ready

      _speechToText.listen(
        onResult: (result) {
          if (result.recognizedWords.isNotEmpty) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          }
        },
        listenFor: Duration(seconds: 5), // Keeps mic on for 5 seconds
        cancelOnError: true,
      );

      // Ensure mic shrinks if no text is captured after listening
      Future.delayed(Duration(seconds: 6), () {
        if (_messageController.text.isEmpty) {
          _stopListening();
        }
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      setState(() {
        _isListening = false; // Ensure mic icon shrinks back
      });
      _speechToText.stop();
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    String messagesString = jsonEncode(_messages);
    await prefs.setString('chat_messages', messagesString);
  }

  /// Scroll instantly to the bottom
  void _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _sendMessage([String? message]) async {
    String userMessage = message ?? _messageController.text.trim();
    if (userMessage.isEmpty) return;

    // Play send message sound
    _playSound('send.mp3');

    setState(() {
      _messages.add({"sender": "user", "message": userMessage});
      _messageController.clear();
      _isTyping = true; // Show typing animation
      _isListening = false; // Reset mic icon after sending
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Get chatbot response
    String botResponse = await _geminiService.getChatbotResponse(userMessage);

    setState(() {
      _isTyping = false; // Hide typing animation
      _messages.add({"sender": "bot", "message": botResponse});
    });

    // Play chatbot reply sound
    _playSound('reply.mp3');

    _saveMessages();

    // Scroll to bottom when bot responds
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _clearChat() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages'); // Clear stored chat history

    setState(() {
      _messages = [
        {
          "sender": "bot",
          "message":
              "Hi there! I'm the Allergify AI. Ask me anything about food allergies, safety tips, or common allergens like eggs, wheat, soy, fish, shellfish, milk, tree nuts, and peanuts only."
        }
      ];
    });
    _shuffleSuggestions();
  }

  void _navigateToPage(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatbotPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wpchatbot.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 15,
                    bottom: 20,
                  ),
                  color: const Color(0xFF6EA08D),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: const [
                            Text(
                              "Ask Allergify AI",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Your Food Safety Assistant",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 5,
                        child: PopupMenuButton<String>(
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          position: PopupMenuPosition.under,
                          onSelected: (String choice) {
                            if (choice == "Clear Chat") {
                              _clearChat();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: "Clear Chat",
                                child: Row(
                                  children: [
                                    Text(
                                      "   Clear Chat",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 70),
                                    Icon(Icons.delete, color: Colors.black),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _showSuggestions
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              Image.asset('assets/images/bot.png',
                                  width: 50, height: 50),
                              const SizedBox(height: 16),
                              const Text(
                                "Hi! I'm Allergify AI",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "What would you like to know?",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                alignment: WrapAlignment.center,
                                children: _suggestedQuestions.map((q) {
                                  return GestureDetector(
                                    onTap: () => _sendMessage(q["text"]!),
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(minWidth: 150),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                            color: const Color(0xFF6EA08D)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${q["emoji"]} ${q["text"]}",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF6EA08D),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: _shuffleSuggestions,
                                icon: const Icon(Icons.shuffle,
                                    size: 20, color: Colors.white),
                                label: const Text(
                                  "Shuffle Questions",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF6EA08D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  elevation: 3,
                                ),
                              ),

                              const SizedBox(
                                  height: 100), // prevent keyboard overlap
                            ],
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(15),
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (_isTyping && index == _messages.length) {
                              return _buildTypingIndicator();
                            }

                            final msg = _messages[index];
                            bool isUser = msg["sender"] == "user";

                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: isUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isUser)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Image.asset(
                                        'assets/images/bot.png',
                                        width: 30,
                                        height: 30,
                                      ),
                                    ),
                                  Flexible(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isUser
                                            ? const Color.fromARGB(
                                                255, 65, 65, 65)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            color: isUser
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          children:
                                              _formatMessage(msg["message"]!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          onChanged: (text) {
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Type your question...",
                            hintStyle: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _messageController.text.trim().isEmpty
                          ? GestureDetector(
                              onTap: () {
                                if (_isListening) {
                                  _stopListening();
                                } else {
                                  _startListening();
                                }
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: _isListening ? 60 : 40,
                                height: _isListening ? 60 : 40,
                                decoration: BoxDecoration(
                                  color: _isListening
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isListening ? Icons.mic : Icons.mic_none,
                                  color: Colors.black,
                                  size: _isListening ? 40 : 28,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: _sendMessage,
                              child: const Icon(Icons.send,
                                  color: Colors.black, size: 28),
                            ),
                    ],
                  ),
                ),
              ],
            ),

            // Scroll-to-bottom Floating Action Button
            if (_showScrollToBottomButton)
              Positioned(
                bottom: 80,
                right: 20,
                child: GestureDetector(
                  onTap: _scrollToBottom,
                  child: Container(
                    width: 40, // Smaller size
                    height: 40, // Smaller size
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7), // Transparent white
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.keyboard_arrow_down, // Chevron icon
                        color: Colors.grey, // Grey color
                        size: 26, // Adjust icon size
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: _navigateToPage,
      ),
    );
  }

  List<TextSpan> _formatMessage(String message) {
    List<TextSpan> spans = [];
    RegExp regExp = RegExp(r'\*\*(.*?)\*\*'); // Match **bold** text
    int lastMatchEnd = 0;

    message.replaceAllMapped(regExp, (match) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: message.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastMatchEnd = match.end;
      return "";
    });

    if (lastMatchEnd < message.length) {
      spans.add(TextSpan(text: message.substring(lastMatchEnd)));
    }

    return spans;
  }

  /// Typing Indicator Widget
  Widget _buildTypingIndicator() {
    return Row(
      children: [
        Image.asset('assets/images/bot.png', width: 30, height: 30),
        Lottie.asset('assets/images/typing.json', width: 65, height: 65),
      ],
    );
  }
}
