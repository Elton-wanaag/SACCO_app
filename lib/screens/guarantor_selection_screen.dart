import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sacco_app/services/member_provider.dart';
import 'package:sacco_app/models/member_data.dart';

class GuarantorSelectionScreen extends StatefulWidget {
  const GuarantorSelectionScreen({super.key});
  @override
  GuarantorSelectionScreenState createState() =>
      GuarantorSelectionScreenState();
}

class GuarantorSelectionScreenState extends State<GuarantorSelectionScreen> {
  List<GuarantorData> _availableGuarantors = [];
  final List<GuarantorData> _selectedGuarantors = [];
  final Map<String, TextEditingController> _amountControllers = {};
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableGuarantors();
  }

  Future<void> _loadAvailableGuarantors() async {
    try {
      final memberProvider = Provider.of<MemberProvider>(
        context,
        listen: false,
      );
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final memberNumber = args['memberNumber'] as String;

      final result = await memberProvider.getAvailableGuarantors(memberNumber);
      if (result['success'] && result['data'] != null) {
        setState(() {
          _availableGuarantors = (result['data'] as List<dynamic>)
              .map((json) => GuarantorData.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to load guarantors'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final memberName = args['memberName'] as String;
    final requestedAmount = args['requestedAmount'] as double;
    final memberNumber = args['memberNumber'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GUARANTOR PAGE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Each loan must be guaranteed by a member, whether individually or by other members. Select the guarantor/s below',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Member Name: $memberName',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Requested Amount: KSH ${requestedAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Available Guarantors:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._availableGuarantors.asMap().entries.map((entry) {
                        final index = entry.key;
                        final guarantor = entry.value;
                        final controllerId = 'guarantor_$index';
                        if (!_amountControllers.containsKey(controllerId)) {
                          _amountControllers[controllerId] =
                              TextEditingController();
                        }
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guarantor ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Member Name: ${guarantor.memberName}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Available Amount: KSH ${guarantor.availableAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green[600],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _amountControllers[controllerId],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Amount Guaranteed',
                                    hintText: 'Enter amount to guarantee',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    prefixText: 'KSH ',
                                  ),
                                  onChanged: (value) {
                                    _updateSelectedGuarantors();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      if (_getTotalGuaranteedAmount() > 0)
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
                                'Total Guaranteed Amount:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'KSH ${_getTotalGuaranteedAmount().toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                              if (_getTotalGuaranteedAmount() < requestedAmount)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'Remaining: KSH ${(requestedAmount - _getTotalGuaranteedAmount()).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red[600],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isSubmitting ||
                                  _getTotalGuaranteedAmount() < requestedAmount
                              ? null
                              : () => _submitLoanRequest(
                                  context,
                                  memberName,
                                  memberNumber,
                                  requestedAmount,
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(0, 50),
                          ),
                          child: _isSubmitting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Request',
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
      ),
    );
  }

  void _updateSelectedGuarantors() {
    _selectedGuarantors.clear();
    _amountControllers.forEach((key, controller) {
      final amount = double.tryParse(controller.text);
      if (amount != null && amount > 0) {
        final index = int.parse(key.split('_')[1]);
        final guarantor = _availableGuarantors[index];
        _selectedGuarantors.add(
          GuarantorData(
            memberName: guarantor.memberName,
            memberNumber: guarantor.memberNumber,
            guaranteedAmount: amount,
            availableAmount: guarantor.availableAmount,
          ),
        );
      }
    });
    setState(() {});
  }

  double _getTotalGuaranteedAmount() {
    return _selectedGuarantors.fold(
      0.0,
      (sum, guarantor) => sum + guarantor.guaranteedAmount,
    );
  }

  Future<void> _submitLoanRequest(
    BuildContext context,
    String memberName,
    String memberNumber,
    double requestedAmount,
  ) async {
    setState(() {
      _isSubmitting = true;
    });
    try {
      final guarantorsList = _selectedGuarantors
          .map(
            (g) => {
              'memberName': g.memberName,
              'memberNumber': g.memberNumber,
              'guaranteedAmount': g.guaranteedAmount,
            },
          )
          .toList();

      final memberProvider = Provider.of<MemberProvider>(
        context,
        listen: false,
      );
      final result = await memberProvider.submitLoanRequest(
        memberNumber: memberNumber,
        requestedAmount: requestedAmount,
        guarantors: guarantorsList,
      );

      if (result['success'] && mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/loan-request-success',
          arguments: {
            'memberName': memberName,
            'memberNumber': memberNumber,
            'requestedAmount': requestedAmount,
            'loanRequestNumber':
                result['data']?['loanRequestNumber'] ??
                'LRQ${DateTime.now().millisecondsSinceEpoch}',
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result['message'] ?? 'Failed to submit loan request',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
