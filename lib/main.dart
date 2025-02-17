import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'home.dart';
import 'signup.dart';


// Main entry point of the app where Firebase is initialized and the app starts.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp()); // Runs the app after Firebase is initialized.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babylon Radio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(247, 251, 249, 0.49),
      ),
      home: const LoginPage(), // Sets the home page of the app to LoginPage.
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 236, 232, 1),
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
                  "LOGIN",
                  style: TextStyle(
                    color: Color.fromRGBO(31, 96, 66, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 25),
                const LoginForm(),
                const SizedBox(height: 20),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) {
                    // Change the cursor to a hand on hover
                  },
                  child: GestureDetector(
                    // Navigates to the SignupPage when the user taps on the text.
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupPage()),
                      );
                    },
                    child: const Text(
                      "New User? Click here to register", // Text linking to the signup page.
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
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Full Name TextFormField for Login Page
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your full name";  // Validation for non-empty input.
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
                validator: (value) {
                  if (value == null || value.isEmpty) {  // Validation for non-empty input.
                    return "Please enter your email";
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) { // Validation for email format.
                    return "Please enter a valid email";
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Password TextFormField for login.
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
                obscureText: true, // Hides the input text for the password field.
                validator: (value) {
                  if (value == null || value.isEmpty) {  // Validation for non-empty input.
                    return "Please enter your password";
                  } else if (value.length < 6) {  // Validation for password length.
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton( 
         onPressed: () async {
              try {
                // Authenticate using Firebase with Email and Password
                UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                );

                // Get the user UID
                String uid = userCredential.user!.uid;

                // Access Firestore to get the user's full name
                DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();

                if (!userDoc.exists) {
                  throw FirebaseAuthException(code: "user-not-found");
                }

                String storedFullName = userDoc["fullName"];
                if (_fullNameController.text.trim() != storedFullName) {
                  throw FirebaseAuthException(code: "invalid-fullname");
                }

                 // Navigate to the HomePage after successful login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              } on FirebaseAuthException catch (e) {
                String message = "Login failed";
                if (e.code == 'invalid-credential') {
                  message = "Invalid email or password";
                } else if (e.code == 'invalid-fullname') {
                  message = "Full Name does not match with the email";
                }

                // Display error message in a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message), backgroundColor: Colors.red),
                );
              }
            },

            style: ElevatedButton.styleFrom(
              minimumSize: const Size(130, 50),
              backgroundColor: Color.fromRGBO(15, 82, 42, 0.8),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),

        ],
      ),
    );
  }
}

