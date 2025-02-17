import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';


// The HomePage widget allows users to access the home page after logged in
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the currently logged-in user from FirebaseAuth
    final User? user = FirebaseAuth.instance.currentUser;
    
     // Get the user's displayName, if null, display "User"
    final String userName = user?.displayName ?? "User";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: Color.fromRGBO(247, 251, 249, 0.49),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome message displaying the user's name
              Text(
                "Hey, $userName! You’re successfully logged in.",
                style: TextStyle(
                  color: Color.fromRGBO(31, 96, 66, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Logout button
              ElevatedButton(
                onPressed: () async {
                  // Sign out the current user from Firebase
                  await FirebaseAuth.instance.signOut();
                  // After signing out, navigate to the login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(130, 50),
                  backgroundColor: Color.fromRGBO(15, 82, 42, 0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
