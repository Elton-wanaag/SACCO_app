import 'package:flutter/material.dart';

class LoanRequestSuccessScreen extends StatelessWidget {
  const LoanRequestSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final memberName = args['memberName'] as String;
    final memberNumber = args['memberNumber'] as String;
    final requestedAmount = args['requestedAmount'] as double;
    final loanRequestNumber = args['loanRequestNumber'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOAN REQUEST SUCCESS PAGE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green[600],
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Your Request for Loan is Submitted Successfully.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Once approved, the amount will be disbursed',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Name:', memberName),
                      const SizedBox(height: 12),
                      _buildDetailRow('Acc:', memberNumber),
                      const SizedBox(height: 12),
                      _buildDetailRow('Amount Requested:', 'KSH ${requestedAmount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _buildDetailRow('Loan Request Number:', loanRequestNumber),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(0, 50),
                  ),
                  child: const Text(
                    'Return to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
