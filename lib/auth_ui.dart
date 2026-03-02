import 'package:flutter/material.dart';

class AuthUI extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController usernameController;
  final TextEditingController confirmPasswordController;
  final bool isSignIn;
  final VoidCallback onAuthenticate;
  final VoidCallback onToggleAuthMode;

  const AuthUI({
    required this.emailController,
    required this.passwordController,
    required this.usernameController,
    required this.confirmPasswordController,
    required this.isSignIn,
    required this.onAuthenticate,
    required this.onToggleAuthMode,
  });

  @override
  _AuthUIState createState() => _AuthUIState();
}

class _AuthUIState extends State<AuthUI> {
  bool _obscureText = true;
  bool _isWelcomeScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFBCE1D3), Color(0xFFFFFFFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 205, 240, 226),
                    Color(0xFFFFFFFF)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 350,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 115, 168, 149),
                    Color.fromRGBO(255, 255, 255, 1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 110, 110, 110)
                        .withOpacity(0.2), // Shadow color
                    blurRadius: 25, // Blur intensity
                    spreadRadius: 5, // How much the shadow spreads
                    offset: Offset(5, 10), // Position of the shadow
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -70, // Push it downwards
            left: 0,
            right: 0, // Stretch to fit horizontally
            child: Container(
              width: double.infinity,
              height: 200, // Control height for the half-ellipse look
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 176, 210, 198),
                    Color.fromRGBO(255, 255, 255, 1)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(200), // Half-circle shape
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 110, 110, 110)
                        .withOpacity(0.2),
                    blurRadius: 25,
                    spreadRadius: 5,
                    offset: Offset(5, 10),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: _isWelcomeScreen ? _buildWelcomeScreen() : _buildAuthScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildWelcomeScreen() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/allergifyb.png',
        width: 250,
        height: 250,
        fit: BoxFit.contain,
      ),
      SizedBox(height: 1),
Text(
        "ALLERGIFY",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 247, 247, 247),
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: const Color.fromARGB(255, 129, 129, 129),
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
      ),
      SizedBox(height: 25),
      Text(
        "Your personal allergy shield, anytime,\nanywhere.",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: const Color.fromARGB(255, 118, 154, 141),
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 50),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _isWelcomeScreen = false;
          });
        },
        icon: Icon(Icons.lock, color: Colors.white),
        label: Text(
          "     Login     ",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 134, 188, 168),
          padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            widget.onToggleAuthMode();
            _isWelcomeScreen = false;
          });
        },
        icon: Icon(Icons.person_add, color: Colors.white),
        label: Text(
          "   Sign Up   ",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 134, 188, 168),
          padding: EdgeInsets.symmetric(horizontal: 45, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    ],
  );
}

          Widget _buildAuthScreen() {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align to the left
                  children: [
                    Text(
                      widget.isSignIn ? "Login" : "Sign Up",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: const Color.fromARGB(255, 168, 167, 167),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left, // Left align the title
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.isSignIn
                          ? "Let's get you in"
                          : "Let's create you an account",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(206, 255, 255, 255),
                      ),
                      textAlign: TextAlign.left, // Left align the subtitle
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(widget.emailController, "Email",
                              false, Icons.email),
                          SizedBox(height: 20),
                          if (!widget.isSignIn)
                            _buildTextField(widget.usernameController,
                                "Username", false, Icons.person),
                          if (!widget.isSignIn) SizedBox(height: 20),
                          _buildTextField(widget.passwordController, "Password",
                              true, Icons.lock),
                          SizedBox(height: 20),
                          if (!widget.isSignIn)
                            _buildTextField(widget.confirmPasswordController,
                                "Confirm Password", true, Icons.lock_outline),
                          SizedBox(height: 30),
                          Stack(
                            alignment: Alignment
                                .centerRight, // Align the circle to the right
                            children: [
                              ElevatedButton(
                                onPressed: widget.onAuthenticate,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 134, 188, 168),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 45, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // Rounded edges
                                  ),
                                  elevation: 5, // Add a slight shadow
                                ),
                                child: Text(
                                  widget.isSignIn
                                      ? "Login       "
                                      : "Sign Up     ",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                right:
                                    5, // Adjust distance from the button’s right edge
                                child: Container(
                                  width: 40, // Control circle size here
                                  height: 40, // Control circle size here
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: widget.onToggleAuthMode,
                            child: Text(
                              widget.isSignIn
                                  ? "Don't have an account? Sign up"
                                  : "Already have an account? Login",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(52, 112, 68, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      bool isPassword, IconData icon) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.blue.shade800),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        prefixIcon: Icon(icon, color: const Color.fromRGBO(163, 193, 182, 1)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color.fromRGBO(163, 193, 182, 1),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
