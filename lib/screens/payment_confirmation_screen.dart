import 'package:flutter/material.dart';
import 'package:sacco_app/services/api_service.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  PaymentConfirmationScreenState createState() => PaymentConfirmationScreenState();
}

class PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final type = args['type'] as String;
    final memberName = args['memberName'] as String;
    final memberNumber = args['memberNumber'] as String;
    final amount = args['amount'] as double;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PAYMENT PAGE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              const Text(
                'Confirm the following and click Pay',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
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
                      _buildDetailRow('Acc:', type == 'loan' ? '$memberNumber - loan payment' : memberNumber),
                      const SizedBox(height: 12),
                      _buildDetailRow('Amount:', 'KSH ${amount.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'When prompted, enter MPESA PIN',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _processPayment(type, memberNumber, amount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(0, 50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'PAY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Follow the Steps Below. Once you receive a successful reply from Mpesa. Click the PAY button below.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
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
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Future<void> _processPayment(String type, String memberNumber, double amount) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> result;
      if (type == 'savings') {
        result = await _apiService.initiateSavingsPayment(memberNumber, amount);
      } else {
        result = await _apiService.initiateLoanPayment(memberNumber, amount);
      }

      if (result['success']) {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/payment-success',
            arguments: {
              'type': type,
              'memberName': (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['memberName'] ?? '',
              'memberNumber': memberNumber,
              'amount': amount,
              'paybill': result['paybill'] ?? '8751990',
            },
          );
        }
      }
    } catch (e) {
      // Handle error - for now just proceed to success page
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/payment-success',
          arguments: {
            'type': type,
            'memberName': (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['memberName'] ?? '',
            'memberNumber': memberNumber,
            'amount': amount,
            'paybill': '8751990',
          },
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
