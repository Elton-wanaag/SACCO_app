import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sacco_app/services/member_provider.dart';
import 'package:sacco_app/widgets/custom_input_field.dart';

class LoanPaymentScreen extends StatefulWidget {
  const LoanPaymentScreen({super.key});

  @override
  LoanPaymentScreenState createState() => LoanPaymentScreenState();
}

class LoanPaymentScreenState extends State<LoanPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      memberProvider.loadCurrentLoan('MEM001');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOAN PAYMENT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<MemberProvider>(
          builder: (context, memberProvider, child) {
            final memberData = memberProvider.memberData;
            final currentLoan = memberProvider.currentLoan;
            
            if (currentLoan == null) {
              return const Center(
                child: Text(
                  'No active loan found',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            
            // Set default installment amount
            if (_amountController.text.isEmpty) {
              _amountController.text = currentLoan.installmentAmount.toStringAsFixed(2);
            }
            
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      CustomInputField(
                        controller: TextEditingController(text: memberData?.memberName ?? 'Loading...'),
                        label: 'Member Name',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomInputField(
                        controller: TextEditingController(text: memberData?.memberNumber ?? 'Loading...'),
                        label: 'Member Number',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomInputField(
                        controller: TextEditingController(text: 'Loan Payment'),
                        label: 'Transaction Type',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomInputField(
                        controller: TextEditingController(text: 'KSH ${currentLoan.installmentAmount.toStringAsFixed(2)}'),
                        label: 'Installment Amount Due',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomInputField(
                        controller: _amountController,
                        label: 'New Repayment Amount',
                        keyboardType: TextInputType.number,
                        hintText: 'Enter payment amount',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Loan Details:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow('Outstanding Balance:', 'KSH ${currentLoan.outstandingBalance.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Monthly Installment:', 'KSH ${currentLoan.installmentAmount.toStringAsFixed(2)}'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Next Payment Date:', currentLoan.nextPaymentDate.toString().split(' ')[0]),
                            const SizedBox(height: 8),
                            _buildDetailRow('Months Remaining:', '${currentLoan.monthsLeft}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _confirmPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(0, 50),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Confirm',
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
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
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

  void _confirmPayment() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      final memberData = memberProvider.memberData;
      
      Navigator.pushNamed(
        context,
        '/payment-confirmation',
        arguments: {
          'type': 'loan',
          'memberName': memberData?.memberName ?? '',
          'memberNumber': memberData?.memberNumber ?? '',
          'amount': amount,
        },
      );
    }
  }
}
