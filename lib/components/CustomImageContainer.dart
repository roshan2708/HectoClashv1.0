import 'package:flutter/material.dart';

class CustomImageContainer extends StatelessWidget {
  const CustomImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), 
          child: Image.network(
            "https://img.freepik.com/premium-vector/secure-login-form-page-with-password-computer-padlock-3d-vector-icon-cartoon-minimal-style_365941-1119.jpg?semt=ais_hybrid",
            fit: BoxFit.cover, 
          ),
        ),
      ),
    );
  }
}
