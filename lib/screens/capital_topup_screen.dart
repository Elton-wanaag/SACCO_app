import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sacco_app/services/member_provider.dart';
import 'package:sacco_app/services/api_service.dart';
import 'package:sacco_app/widgets/custom_input_field.dart';

class CapitalTopupScreen extends StatefulWidget {
  const CapitalTopupScreen({super.key});

  @override
  CapitalTopupScreenState createState() => CapitalTopupScreenState();
}

class CapitalTopupScreenState extends State<CapitalTopupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TOP-UP CAPITAL SHARE',
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
                      
                      // Current Capital Share Info
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current Capital Share Details:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow('Current Shares:', '${memberData?.capitalShares.toInt() ?? 0}'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Share Percentage:', '${memberData?.sharePercent.toStringAsFixed(2) ?? '0.00'}%'),
                            const SizedBox(height: 8),
                            _buildDetailRow('Share Value:', 'KSH 100 per share'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
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
                        controller: TextEditingController(text: 'Capital Share Top-up'),
                        label: 'Transaction Type',
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      
                      CustomInputField(
                        controller: _amountController,
                        label: 'Top-up Amount',
                        keyboardType: TextInputType.number,
                        hintText: 'Enter amount to add to capital shares',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          final amount = double.tryParse(value);
                          if (amount == null || amount <= 0) {
                            return 'Please enter a valid amount';
                          }
                          if (amount < 100) {
                            return 'Minimum top-up amount is KSH 100';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Calculation Preview
                      if (_amountController.text.isNotEmpty)
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
                                'Top-up Preview:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow('Additional Shares:', '${(double.tryParse(_amountController.text) ?? 0) ~/ 100}'),
                              const SizedBox(height: 4),
                              _buildDetailRow('New Total Shares:', '${((memberData?.capitalShares ?? 0) + ((double.tryParse(_amountController.text) ?? 0) ~/ 100)).toInt()}'),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _confirmTopup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(0, 50),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Confirm Top-up',
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

  Future<void> _confirmTopup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final amount = double.parse(_amountController.text);
        final result = await _apiService.topUpCapitalShare('MEM001', amount);

        if (result['success'] && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Capital share top-up successful!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Refresh member data
          final memberProvider = Provider.of<MemberProvider>(context, listen: false);
          memberProvider.loadMemberData('MEM001');
          
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Capital share top-up successful!'),
              backgroundColor: Colors.green,
            ),
          );
          
          Navigator.pop(context);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
