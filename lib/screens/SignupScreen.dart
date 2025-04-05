import 'package:flutter/material.dart';
import 'package:hecto_clash_frontend/components/CustomAvatarSelection.dart';
import 'package:hecto_clash_frontend/components/CustomHeader.dart';
import 'package:hecto_clash_frontend/components/CustomTextInputField.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Header(text: "Welcome New User"),
              SizedBox(height: 20),
                 
           
              AvatarSelector(
                onAvatarSelected: (avatar) {
                  setState(() {
                    selectedAvatar = avatar;
                  });
                },
              ),
              CustomTextInputField(
                hint: "Enter your name",
                controller: nameController, isPassword: true,
              ),
              SizedBox(height: 15),
              CustomTextInputField(
                hint: "Enter your email",
                controller: emailController, isPassword: true,
              ),
              SizedBox(height: 15),
              CustomTextInputField(
                hint: "Enter your password",
                controller: passwordController, isPassword: true,
                
              ),
              SizedBox(height: 25),
           
              SizedBox(height: 30),
              
              GestureDetector(
                onTap: () {
                  if (nameController.text.isNotEmpty && selectedAvatar.isNotEmpty) {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          // username: nameController.text,
                          // avatarPath: selectedAvatar,
                        ),
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter your name and select an avatar"),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      "Signup",
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Already a user? Click here to login", 
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}