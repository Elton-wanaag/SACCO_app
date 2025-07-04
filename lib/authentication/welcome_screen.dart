import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate button width as 75% of screen width, capped for larger screens
    final buttonWidth = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to the Home of Collective Prosperity, Individual Growth',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    color: Colors.green[50], // Light green tint
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Center all children
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const CustomArrowIcon(), // Custom arrow with elongated filled triangular head
                                onPressed: () {
                                  SystemNavigator.pop(); // Exit the app
                                },
                                padding: const EdgeInsets.only(left: 0), // Align to left edge
                                alignment: Alignment.centerLeft,
                              ),
                              const Expanded(
                                child: Text(
                                  'Welcome to Anfal Sacco',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed('/register'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700], // Algae-like green
                                minimumSize: const Size(0, 50), // Height only, width controlled by SizedBox
                              ),
                              child: const Text(
                                'Sign Up/Register',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context, rootNavigator: true).pushNamed('/login'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 134, 149, 135), // Green mixed with gray
                                minimumSize: const Size(0, 50), // Height only, width controlled by SizedBox
                              ),
                              child: const Text(
                                'Sign In/Log In',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom arrow icon with elongated filled triangular head and bold outline body
class CustomArrowIcon extends StatelessWidget {
  const CustomArrowIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(30, 30), // Matches IconButton size
      painter: ArrowPainter(),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Draw elongated filled triangular head
    final headPath = Path();
    headPath.moveTo(size.width * 0.3, size.height * 0.3); // Top point of triangle
    headPath.lineTo(size.width * 0.0, size.height * 0.5); // Left point, extended for elongation
    headPath.lineTo(size.width * 0.3, size.height * 0.7); // Bottom point
    headPath.close();
    canvas.drawPath(headPath, paint);

    // Draw bold outline body
    final bodyPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Bold line
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.5), // Connect to head
      Offset(size.width * 0.9, size.height * 0.5), // Right end of body
      bodyPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}