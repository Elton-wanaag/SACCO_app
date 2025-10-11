import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sacco_app/services/member_provider.dart';
import 'package:sacco_app/widgets/custom_input_field.dart';

class LoanRequestScreen extends StatefulWidget {
  const LoanRequestScreen({super.key});
  @override
  LoanRequestScreenState createState() => LoanRequestScreenState();
}

class LoanRequestScreenState extends State<LoanRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final bool _isLoading = false;
  double _maxLoanAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _loadLoanEligibility();
  }

  Future<void> _loadLoanEligibility() async {
    try {
      final memberProvider = Provider.of<MemberProvider>(
        context,
        listen: false,
      );
      final memberNumber = 'MEM001'; // Should come from auth provider

      final result = await memberProvider.calculateLoanEligibility(
        memberNumber,
      );
      if (result['success'] && result['data'] != null) {
        setState(() {
          _maxLoanAmount = result['data']['max_loan_amount']?.toDouble() ?? 0.0;
        });
      } else {
        setState(() {
          _maxLoanAmount = 150000.0; // Default max amount
        });
      }
    } catch (e) {
      setState(() {
        _maxLoanAmount = 150000.0; // Default max amount
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'REQUEST FOR A LOAN',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<MemberProvider>(
          builder: (context, memberProvider, child) {
            final memberData = memberProvider.memberData;
            final memberNumber = memberData?.memberNumber ?? 'MEM001';
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
                        controller: TextEditingController(
                          text: memberData?.memberName ?? 'Loading...',
                        ),
                        label: 'Member Name',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        controller: TextEditingController(text: memberNumber),
                        label: 'Member Number',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        controller: TextEditingController(
                          text: 'Request for Loan',
                        ),
                        label: 'Transaction Type',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        controller: _amountController,
                        label: 'Requested Amount',
                        keyboardType: TextInputType.number,
                        hintText: 'Enter loan amount',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          if (amount > _maxLoanAmount) {
                            return 'Amount exceeds maximum loan limit';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_maxLoanAmount > 0)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Loan-able Amount member qualifies for:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'KSH ${_maxLoanAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () => _confirmLoanRequest(
                                  context,
                                  memberProvider,
                                  memberNumber,
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(0, 50),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
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

  void _confirmLoanRequest(
    BuildContext context,
    MemberProvider memberProvider,
    String memberNumber,
  ) {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      final memberData = memberProvider.memberData;
      Navigator.pushNamed(
        context,
        '/guarantor-selection',
        arguments: {
          'memberName': memberData?.memberName ?? '',
          'memberNumber': memberNumber,
          'requestedAmount': amount,
        },
      );
    }
  }
}
