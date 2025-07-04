import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final type = args['type'] as String;
    final memberName = args['memberName'] as String;
    final memberNumber = args['memberNumber'] as String;
    final amount = args['amount'] as double;
    final paybill = args['paybill'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SUCCESS PAGE',
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
              
              Text(
                type == 'savings' 
                    ? 'Your Savings Transaction is Successful.'
                    : 'Your Loan Payment is Successful.',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
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
                      _buildDetailRow('Paybill:', paybill),
                      const SizedBox(height: 12),
                      _buildDetailRow('Name:', memberName),
                      const SizedBox(height: 12),
                      _buildDetailRow('Acc:', type == 'loan' ? '$memberNumber - Loan Payment' : memberNumber),
                      const SizedBox(height: 12),
                      _buildDetailRow('Amount:', 'KSH ${amount.toStringAsFixed(2)}'),
                      
                      if (type == 'loan') ...[
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildDetailRow('Total Loan Balance:', 'KSH 35,500.00'),
                        const SizedBox(height: 12),
                        _buildDetailRow('Next payment due:', DateTime.now().add(const Duration(days: 30)).toString().split(' ')[0]),
                        const SizedBox(height: 12),
                        _buildDetailRow('Next instalment amount:', 'KSH 2,500.00'),
                        const SizedBox(height: 12),
                        _buildDetailRow('Number of months left:', '14'),
                      ],
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
