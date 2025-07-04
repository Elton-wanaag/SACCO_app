import 'package:flutter/material.dart';

class QuickActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final bool isSmallScreen;

  const QuickActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: backgroundColor ?? const Color.fromARGB(255, 200, 245, 210),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: isSmallScreen ? 70 : 80,
            padding: EdgeInsets.all(isSmallScreen ? 6.0 : 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: isSmallScreen ? 20 : 24,
                  color: Colors.black,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
