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
      // Load the registration status when screen is opened
      if (authProvider.currentEmail != null) {
        authProvider.loadRegistrationStatus(authProvider.currentEmail!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'REGISTRATION STATUS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Registration Status Header
                  Text(
                    'Your Registration Status',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete the registration process to access your dashboard',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Progress Indicator
                  _buildProgressIndicator(authProvider.registrationStage),

                  const SizedBox(height: 40),

                  // Status Details
                  _buildStatusDetails(authProvider),

                  const SizedBox(height: 40),

                  // Action Button
                  _buildActionButton(authProvider),

                  const Spacer(),

                  // Logout Button
                  TextButton(
                    onPressed: () => authProvider.logout(),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: stages.asMap().entries.map((entry) {
            int index = entry.key;
            String stageName = entry.value;
            bool isActive = index <= stageIndex;
            bool isCompleted = index < stageIndex;

            return Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? Colors.green : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: isActive ? Colors.white : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stageName,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.green : Colors.grey[600],
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: (stageIndex + 1) / stages.length,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
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

  Widget _buildStatusDetails(AuthProvider authProvider) {
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

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
              Text(
                'Member Number: ${authProvider.memberNumber}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(AuthProvider authProvider) {
    String stage = authProvider.registrationStage.toLowerCase();
    String buttonText = '';
    Color buttonColor = Colors.grey;
    bool isEnabled = false;
    VoidCallback? onPressed;

    if (stage == 'submitted') {
      buttonText = 'Pay Now';
      buttonColor = Colors.green;
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
      buttonColor = Colors.green;
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
          minimumSize: const Size(0, 50),
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
