import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecto_clash_frontend/components/CustomImageContainer.dart';
import 'package:hecto_clash_frontend/screens/HomeScreen.dart';
import 'package:hecto_clash_frontend/screens/SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
              SizedBox(height: 90),
              Text("Welcome Back", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
              SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "User Name",
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
                  hintText: "Password",
                  hintStyle: TextStyle(color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: Color(0xFFF8EDEB),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
             
              SizedBox(height: 15),
             ElevatedButton(
  onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomeScreen()),
  ),
  child: Text(
    "Login",
    style: TextStyle(fontSize: 18),
  ),
  style: ElevatedButton.styleFrom(
    minimumSize: Size(MediaQuery.of(context).size.width * 0.7, 50),
    backgroundColor: Color.fromARGB(255, 32, 238, 197), // Custom button color
    foregroundColor: Colors.black, // Optional: changes text/icon color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Optional: rounded corners
    ),
  ),
),
 Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text("Forgot Password?", style: GoogleFonts.roboto(fontSize: 16, color: Color(0xFF3B82F6), fontWeight: FontWeight.w500)),
              ),

              SizedBox(height: 15),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())),
                child: Text("New user? Click here to sign up", style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
              ),
              SizedBox(height: 25),
              CustomImageContainer(
                imagePath: 'assets/images/login.jpg',
              )
            ],
          ),
        ),
      ),
    );
  }
}