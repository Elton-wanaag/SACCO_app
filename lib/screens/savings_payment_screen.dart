import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sacco_app/services/member_provider.dart';
import 'package:sacco_app/widgets/custom_input_field.dart';

class SavingsPaymentScreen extends StatefulWidget {
  const SavingsPaymentScreen({super.key});

  @override
  SavingsPaymentScreenState createState() => SavingsPaymentScreenState();
}

class SavingsPaymentScreenState extends State<SavingsPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MAKE SAVINGS PAYMENT',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<MemberProvider>(
          builder: (context, memberProvider, child) {
            final memberData = memberProvider.memberData;
            
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
                        controller: TextEditingController(text: 'Savings Deposit'),
                        label: 'Transaction Type',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomInputField(
                        controller: _amountController,
                        label: 'Amount',
                        keyboardType: TextInputType.number,
                        hintText: 'Enter amount to save',
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

  void _confirmPayment() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      final memberData = memberProvider.memberData;
      
      Navigator.pushNamed(
        context,
        '/payment-confirmation',
        arguments: {
          'type': 'savings',
          'memberName': memberData?.memberName ?? '',
          'memberNumber': memberData?.memberNumber ?? '',
          'amount': amount,
        },
      );
    }
  }
}
