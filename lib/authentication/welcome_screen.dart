import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double buttonWidth = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo Placeholder — Replace with your image later
                  Container(
                    width: 180,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      // Replace this with your actual logo image later
                      // image: DecorationImage(
                      //   image: AssetImage('assets/anfal_sacco_logo.png'),
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                    child: Center(
                      child: Text(
                        'Anfal Sacco',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Every coin counts,\nstart building your future today.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamed('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFC53E4A,
                        ), // Deep red from image
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Start',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
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
