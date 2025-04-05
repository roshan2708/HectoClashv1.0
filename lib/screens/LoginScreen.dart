import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import
import 'package:hecto_clash_frontend/components/CustomHeader.dart';
import 'package:hecto_clash_frontend/components/CustomImageContainer.dart';
import 'package:hecto_clash_frontend/components/CustomTextInputField.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Header(text: "Welcome Back"),
              
              CustomTextInputField(
                hint: "User Name",
                controller: emailController,
                isPassword: true,
              ),
              
              SizedBox(height: 15),
              
              CustomTextInputField(
                hint: "Password",
                controller: passwordController,
                isPassword: true,
              ),
              
             
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Forgot Password?",
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              SizedBox(height: 25),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                       
                      ),
                    ),
                  );
                  // Login action
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7, 
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 15),
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text(
                  "New user? Click here to sign up",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              
              CustomImageContainer(),
              
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}