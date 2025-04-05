import 'package:flutter/material.dart';
import 'package:hecto_clash_frontend/components/CustomAvatarSelection.dart';
import 'package:hecto_clash_frontend/components/CustomImageContainer.dart';
import 'package:hecto_clash_frontend/screens/HomeScreen.dart';
import 'package:hecto_clash_frontend/screens/LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String selectedAvatar = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Text("Welcome New User", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
              SizedBox(height: 20),
              // Assuming AvatarSelector is a custom widget
              // AvatarSelector(onAvatarSelected: (avatar) => setState(() => selectedAvatar = avatar)),
              SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: Color(0xFFF8EDEB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: Color(0xFFF8EDEB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: Color(0xFFF8EDEB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
  ),
  child: Text(
    "Sign Up",
    style: TextStyle(fontSize: 18),
  ),
  style: ElevatedButton.styleFrom(
    minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
    backgroundColor: Color.fromARGB(255, 236, 116, 56), // Custom button color
    foregroundColor: Colors.black, // Optional: changes text/icon color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Optional: rounded corners
    ),
  ),
),

              SizedBox(height: 15),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                child: Text("Already a user? Click here to login", style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
              ),
                CustomImageContainer(
                imagePath: 'assets/images/signup.jpg',
              )
            ],
          ),
        ),
      ),
    );
  }
}