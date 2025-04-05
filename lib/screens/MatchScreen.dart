// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hecto_clash_frontend/controllers/GameControler.dart';


// class MatchScreen extends StatefulWidget {
//   const MatchScreen({super.key});

//   @override
//   State<MatchScreen> createState() => _MatchScreenState();
// }

// class _MatchScreenState extends State<MatchScreen> with SingleTickerProviderStateMixin {
//   final GameController controller = Get.find<GameController>();
//   late AnimationController _animationController;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     )..repeat(reverse: true);
//     _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA), // Light grayish-blue
//       body: Stack(
//         children: [
//           // Subtle vector background
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.1,
//               child: Image.network(
//                 "https://img.freepik.com/free-vector/seamless-pattern-with-school-office-stationery_107791-9568.jpg?t=st=1743824048~exp=1743827648~hmac=a5b0e7132b4884ef1dfd6de7d47658df4136902d1024b3c13f5087fa48830bb0&w=1380",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // AppBar-like header
//                   Text(
//                     "HectoClash Calculator",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[900],
//                       fontFamily: 'Comic Sans MS', // Playful font
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Input Display
//                   _buildDisplayContainer(
//                     child: Obx(() => Text(
//                           controller.input.value,
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey[800],
//                           ),
//                         )),
//                     color: const Color(0xFFE3F2FD), // Light blue
//                   ),
//                   const SizedBox(height: 15),
//                   // Output Display with Navigation
//                   _buildDisplayContainer(
//                     child: Obx(() {
//                       String output = controller.output.value;
//                       if (output == "100") {
//                         Future.delayed(Duration.zero, () {
//                           Get.to(() => const ResultsScreen(isCorrect: true));
//                         });
//                       } else if (output.isNotEmpty && output != "0") {
//                         Future.delayed(Duration.zero, () {
//                           Get.to(() => const ResultsScreen(isCorrect: false));
//                         });
//                       }
//                       return ScaleTransition(
//                         scale: _pulseAnimation,
//                         child: Text(
//                           output,
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blue[700],
//                           ),
//                         ),
//                       );
//                     }),
//                     color: const Color(0xFFFFF3E0), // Light orange
//                   ),
//                   const SizedBox(height: 30),
//                   // Calculator Buttons
//                   Expanded(
//                     child: GridView.builder(
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         childAspectRatio: 1.3,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                       ),
//                       itemCount: controller.buttons.length,
//                       itemBuilder: (context, index) {
//                         return _buildButton(
//                           text: controller.buttons[index],
//                           onTap: () => controller.onButtonPressed(controller.buttons[index]),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Reusable Display Container
//   Widget _buildDisplayContainer({required Widget child, required Color color}) {
//     return Container(
//       height: 100,
//       width: double.infinity,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.15),
//             blurRadius: 10,
//             spreadRadius: 2,
//             offset: const Offset(2, 4),
//           ),
//         ],
//       ),
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: child,
//       ),
//     );
//   }

//   // Reusable Button Widget
//   Widget _buildButton({required String text, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.blue[200]!.withOpacity(0.5),
//               blurRadius: 8,
//               spreadRadius: 1,
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.blue[900],
//               fontFamily: 'Comic Sans MS',
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }