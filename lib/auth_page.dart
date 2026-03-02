import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Allergify/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_ui.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isSignIn = true;

Future<void> authenticate() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();
  String username = usernameController.text.trim();
  String confirmPassword = confirmPasswordController.text.trim();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    // Check for empty fields
    if (email.isEmpty ||
        password.isEmpty ||
        (!isSignIn && username.isEmpty) ||
        (!isSignIn && confirmPassword.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    if (isSignIn) {
      // Sign in logic
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }

      if (password.length < 6) {
        throw FirebaseAuthException(
          code: "weak-password",
          message: "Password must be at least 6 characters.",
        );
      }

      // Step 1: Create User in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? newUser = userCredential.user;
      if (newUser != null) {
        // Step 2: Save User Data to Firestore
        await FirebaseFirestore.instance.collection('users').doc(newUser.uid).set({
          'name': username,
          'email': newUser.email,
          'phone': '',
          'cityState': '',
          'country': '',
          'profileImagePath': 'assets/images/default_profile_picture.png',
        });

        // Step 3: Show Success Message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account created successfully! Please sign in.")),
        );

        setState(() {
          isSignIn = true; // Switch to sign-in mode after successful sign-up
        });
      }
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage;

    switch (e.code) {
      case "wrong-password":
      case "invalid-credential":
        errorMessage = "Incorrect password. Please try again.";
        break;
      case "user-not-found":
        errorMessage = "No user found with this email.";
        break;
      case "email-already-in-use":
        errorMessage = "This email is already registered. Try signing in.";
        break;
      case "weak-password":
        errorMessage = "Password must be at least 6 characters.";
        break;
      case "invalid-email":
        errorMessage = "Please enter a valid email address.";
        break;
      case "too-many-requests":
        errorMessage = "Too many failed attempts. Please try again later.";
        break;
      default:
        errorMessage = e.message ?? "An error occurred. Please try again.";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  } catch (e) {
    print("Unexpected Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong. Please try again.")),
    );
  }
}

  void toggleAuthMode(int index) {
    setState(() {
      isSignIn = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthUI(
      emailController: emailController,
      passwordController: passwordController,
      usernameController: usernameController,
      confirmPasswordController: confirmPasswordController,
      isSignIn: isSignIn,
      onAuthenticate: authenticate,
      onToggleAuthMode: () {
        setState(() {
          isSignIn = !isSignIn;
        });
      },
    );
  }
}
