import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/member_data.dart';

class ApiService {
  static const String baseUrl = 'http://165.22.28.112:8069/api/';
  
  // Token management
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Helper method to get headers
  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Authentication APIs
  Future<Map<String, dynamic>> login(String emailOrId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'email_or_id': emailOrId,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Save token if provided
        if (data['token'] != null) {
          await _saveToken(data['token']);
        } else if (data['data'] != null && data['data']['token'] != null) {
          await _saveToken(data['data']['token']);
        }
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'data': data['data'] ?? data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> register(String fullName, String applicantType, String idNumber, String gender, String dob) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'full_name': fullName,
          'applicant_type': applicantType,
          'id_number': idNumber,
          'gender': gender,
          'date_of_birth': dob,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'data': data['data'] ?? data,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
      };
    }
  }

  // Logout
  Future<void> logout() async {
    await _removeToken();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null;
  }

  // Mock APIs for other functionality (to be updated later)
  Future<MemberData> getMemberData(String memberNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return MemberData(
      memberName: 'Fabron Naligu',
      memberNumber: memberNumber,
      savingsBalance: 116000.00,
      loansBalance: 46000.00,
      capitalShares: 2000,
      sharePercent: 13.69,
      guaranteeableAmount: 70000.00,
    );
  }

  Future<List<TransactionData>> getTransactionHistory(String memberNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      TransactionData(
        id: 'TXN001',
        type: 'Savings Deposit',
        amount: 5000.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        status: 'Completed',
        description: 'Monthly savings deposit',
      ),
    ];
  }

  Future<Map<String, dynamic>> calculateLoanEligibility(String memberNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'maxLoanAmount': 150000.00,
      'interestRate': 1.0,
      'maxTerm': 36,
    };
  }

  Future<List<GuarantorData>> getAvailableGuarantors(String memberNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      GuarantorData(
        memberName: 'Elton Nyamato',
        memberNumber: 'MEM002',
        guaranteedAmount: 0,
        availableAmount: 50000.00,
      ),
    ];
  }

  Future<Map<String, dynamic>> submitLoanRequest(
    String memberNumber,
    double requestedAmount,
    List<Map<String, dynamic>> guarantors,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'loanRequestNumber': 'LRQ${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Loan request submitted successfully',
    };
  }

  Future<LoanData> getCurrentLoan(String memberNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return LoanData(
      loanId: 'LOAN001',
      requestedAmount: 50000.00,
      approvedAmount: 46000.00,
      outstandingBalance: 38000.00,
      installmentAmount: 2500.00,
      nextPaymentDate: DateTime.now().add(const Duration(days: 15)),
      monthsLeft: 15,
      status: 'Active',
      guarantors: [],
    );
  }

  Future<Map<String, dynamic>> initiateSavingsPayment(String memberNumber, double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'transactionId': 'SAV${DateTime.now().millisecondsSinceEpoch}',
      'paybill': '8751990',
      'accountNumber': memberNumber,
      'amount': amount,
    };
  }

  Future<Map<String, dynamic>> confirmSavingsPayment(String transactionId) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'message': 'Savings payment confirmed',
      'newBalance': 121000.00,
    };
  }

  Future<Map<String, dynamic>> initiateLoanPayment(String memberNumber, double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'transactionId': 'LP${DateTime.now().millisecondsSinceEpoch}',
      'paybill': '8751990',
      'accountNumber': '$memberNumber - loan payment',
      'amount': amount,
    };
  }

  Future<Map<String, dynamic>> confirmLoanPayment(String transactionId) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'success': true,
      'message': 'Loan payment confirmed',
      'newBalance': 35500.00,
      'nextPaymentDate': DateTime.now().add(const Duration(days: 30)),
      'nextInstallmentAmount': 2500.00,
      'monthsLeft': 14,
    };
  }

  Future<Map<String, dynamic>> topUpCapitalShare(String memberNumber, double amount) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'transactionId': 'CS${DateTime.now().millisecondsSinceEpoch}',
      'newShareBalance': 2500,
      'newSharePercent': 15.2,
    };
  }

  Future<Map<String, dynamic>> submitContactMessage(String memberNumber, String subject, String message) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'ticketNumber': 'TKT${DateTime.now().millisecondsSinceEpoch}',
      'message': 'Your message has been submitted successfully',
    };
  }
}