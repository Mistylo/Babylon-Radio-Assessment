import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart'; 


// The SignupPage widget allows users to register for the app.
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

// State class for SignupPage
class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Authentication & Firestore logic for signup
  Future<void> _signup() async {
    try {
      // Create user with email and password using Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final User? user = userCredential.user; // Get the user object from the credential

      if (user != null) {
        // Update the user's display name
        await user.updateDisplayName(_fullNameController.text.trim());

         // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': _fullNameController.text.trim(),
          'email': _emailController.text.trim(),
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(), // Record the registration timestamp
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup successful! Please log in.")),
        );

        // Navigate to the login page after successful registration
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()), 
          );
        });
      }
    } catch (e) {   // If an error occurs during signup, show an error message
      debugPrint("Error signing up: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(234, 236, 232, 1),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Image.asset(
                    "assets/babylon_radio_logo.png",
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "SIGN UP",
                  style: TextStyle(
                    color: Color.fromRGBO(31, 96, 66, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 25),
                Form(
                  key: _formKey, // Form key to manage form validation
                  child: Column(
                    children: [
                       // Full Name TextFormField
                      Center(
                        child: SizedBox(
                          width: 400,
                          child: TextFormField(
                            controller: _fullNameController,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              fillColor: const Color.fromARGB(255, 252, 252, 251),
                              filled: true,
                            ),
                            validator: (value) { // Validation for the full name input
                              if (value == null || value.isEmpty) {
                                return "Please enter your full name";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Email Address TextFormField
                      Center(
                        child: SizedBox(
                          width: 400,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              fillColor: const Color.fromARGB(255, 252, 252, 251),
                              filled: true,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {  // Validation for the email input
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Password TextFormField
                      Center(
                        child: SizedBox(
                          width: 400,
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                              fillColor: const Color.fromARGB(255, 252, 252, 251),
                              filled: true,
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () { // Check if the form is valid before attempting signup
                          if (_formKey.currentState!.validate()) {
                            _signup();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(130, 50),
                          backgroundColor: const Color.fromRGBO(15, 82, 42, 0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      const SizedBox(height: 20),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: const Text(
                            "Existing User? Click here to log in", // Link to log in if the user already has an account
                            style: TextStyle(
                              color: Color.fromRGBO(15, 82, 42, 1),
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
