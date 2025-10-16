// lib/screens/registration_status_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';

class RegistrationStatusScreen extends StatefulWidget {
  const RegistrationStatusScreen({super.key});

  @override
  State<RegistrationStatusScreen> createState() =>
      _RegistrationStatusScreenState();
}

class _RegistrationStatusScreenState extends State<RegistrationStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentEmail != null) {
        authProvider.loadRegistrationStatus(authProvider.currentEmail!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Arrow + Logout Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(), // Go back to login/register
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        alignment: Alignment.centerLeft,
                      ),
                      TextButton(
                        onPressed: () => authProvider.logout(),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Your Registration Status',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete the registration process to access your dashboard',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),

                  // Progress Indicator
                  _buildProgressIndicator(authProvider.registrationStage),

                  const SizedBox(height: 40),

                  // Status Card
                  _buildStatusCard(authProvider),

                  const Spacer(), // Push button to bottom
                  // Action Button
                  _buildActionButton(authProvider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String stage) {
    final stages = [
      'Draft',
      'Submitted',
      'Payment Process',
      'Paid',
      'Approved',
    ];
    final stageIndex = _getStageIndex(stage);

    return Column(
      children: [
        // Stage Circles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(stages.length, (index) {
            bool isActive = index <= stageIndex;
            bool isCompleted = index < stageIndex;

            return Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFC53E4A)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stages[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive ? const Color(0xFFC53E4A) : Colors.grey,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }),
        ),
        const SizedBox(height: 20),
        // Progress Line
        LinearProgressIndicator(
          value: (stageIndex + 1) / stages.length,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC53E4A)),
          minHeight: 6,
        ),
      ],
    );
  }

  int _getStageIndex(String stage) {
    switch (stage.toLowerCase()) {
      case 'draft':
        return 0;
      case 'submitted':
        return 1;
      case 'process':
      case 'payment process':
        return 2;
      case 'paid':
        return 3;
      case 'approved':
        return 4;
      default:
        return 0;
    }
  }

  Widget _buildStatusCard(AuthProvider authProvider) {
    String statusText = '';
    String statusColor = '';
    String statusIcon = '';

    switch (authProvider.registrationStage.toLowerCase()) {
      case 'draft':
        statusText = 'Registration form not submitted';
        statusColor = 'grey';
        statusIcon = '📝';
        break;
      case 'submitted':
        statusText = 'Registration submitted. Payment required to proceed.';
        statusColor = 'orange';
        statusIcon = '📋';
        break;
      case 'process':
      case 'payment process':
        statusText = 'Payment in process. Please complete your payment.';
        statusColor = 'orange';
        statusIcon = '💳';
        break;
      case 'paid':
        statusText = 'Payment completed. Awaiting approval.';
        statusColor = 'blue';
        statusIcon = '✅';
        break;
      case 'approved':
        statusText =
            'Registration approved! You can now access your dashboard.';
        statusColor = 'green';
        statusIcon = '🎉';
        break;
      default:
        statusText = 'Unknown status';
        statusColor = 'grey';
        statusIcon = '❓';
    }

    Color color = statusColor == 'green'
        ? Colors.green
        : statusColor == 'orange'
        ? Colors.orange
        : statusColor == 'blue'
        ? Colors.blue
        : Colors.grey;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Text(statusIcon, style: const TextStyle(fontSize: 40)),
          const SizedBox(height: 16),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (authProvider.memberNumber != null &&
              authProvider.memberNumber!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                'Member Number: ${authProvider.memberNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(AuthProvider authProvider) {
    String stage = authProvider.registrationStage.toLowerCase();
    String buttonText = '';
    Color buttonColor = const Color(0xFFC53E4A); // Default to red
    bool isEnabled = false;
    VoidCallback? onPressed;

    if (stage == 'submitted') {
      buttonText = 'Pay Now';
      isEnabled = true;
      onPressed = () => _handlePayNow(authProvider);
    } else if (stage == 'process' || stage == 'payment process') {
      buttonText = 'Check Payment';
      buttonColor = Colors.orange;
      isEnabled = true;
      onPressed = () => _handleCheckPayment(authProvider);
    } else if (stage == 'paid') {
      buttonText = 'Check Approval';
      buttonColor = Colors.blue;
      isEnabled = true;
      onPressed = () => _handleCheckApproval(authProvider);
    } else if (stage == 'approved') {
      buttonText = 'Go to Dashboard';
      isEnabled = true;
      onPressed = () =>
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled && !authProvider.isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: authProvider.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _handlePayNow(AuthProvider authProvider) async {
    final result = await authProvider.initiateRegistrationPayment();
    if (result['success'] != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to initiate payment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCheckPayment(AuthProvider authProvider) async {
    final result = await authProvider.checkRegistrationPayment();
    if (result['success'] != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to check payment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCheckApproval(AuthProvider authProvider) async {
    final result = await authProvider.checkRegistrationPayment();
    if (result['success'] != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to check approval'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
