import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hecto_clash_frontend/constans/colors.dart';
import 'package:hecto_clash_frontend/screens/LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _hectoSlideAnimation;
  late Animation<double> _clashSlideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Hecto slides from the left
    _hectoSlideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Clash slides from the right
    _clashSlideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
       
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Brick dust effect (placeholder)
            CustomPaint(
              painter: BrickDustPainter(_animationController.value),
              child: const SizedBox.expand(),
            ),
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hecto coming from the left
                    AnimatedBuilder(
                      animation: _hectoSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              _hectoSlideAnimation.value *
                                  MediaQuery.of(context).size.width /
                                  2,
                              0),
                          child: child,
                        );
                      },
                      child: Text(
                        "Hecto",
                        style: GoogleFonts.nosifer(
                          fontSize: 38,
                          
                          color: AppColor.spalshScreen,
                          // shadows: [
                          //   Shadow(
                          //     blurRadius: 10.0,
                          //     color: Colors.black.withOpacity(0.5),
                          //     offset: const Offset(0, 3),
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Space between Hecto and Clash
                    // Clash coming from the right
                    AnimatedBuilder(
                      animation: _clashSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(
                              _clashSlideAnimation.value *
                                  MediaQuery.of(context).size.width /
                                  2,
                              0),
                          child: child,
                        );
                      },
                      child: Text(
                        "Clash",
                        style: GoogleFonts.nosifer(
                          fontSize: 38,
                         
                         color: AppColor.spalshScreen,
                          // shadows: [
                          //   Shadow(
                          //     blurRadius: 10.0,
                          //     color: Colors.black.withOpacity(0.5),
                          //     offset: const Offset(0, 3),
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
  bottom: 20,
  left: 0,
  right: 0,
  child: Center(
    child: Text(
      'Developed by Tech_Titans',
      style: GoogleFonts.arya(
        fontSize: 18,
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),


          ],
        ),
      ),
    );
  }
}

// Basic Brick Dust Painter (simplified effect)
class BrickDustPainter extends CustomPainter {
  final double animationValue;

  BrickDustPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Simulate dust particles with random positions
    for (int i = 0; i < 20; i++) {
      double x = (size.width * (i / 20)) * animationValue;
      double y = size.height * (i % 5) / 5 + (animationValue * 50);
      canvas.drawCircle(
        Offset(x, y),
        2.0 + (i % 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}