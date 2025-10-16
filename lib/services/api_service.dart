// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // static const String baseUrl =
  //     'http://165.22.28.112:8069';
  static const String baseUrl = 'http://localhost:8069';

  // Token management
  Future<String?> _getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('session_id');
    print('[ApiService] Retrieved session ID: $sessionId');
    return sessionId;
  }

  Future<void> _saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_id', sessionId);
    print('[ApiService] Saved session ID: $sessionId');
  }

  Future<void> _removeSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
    print('[ApiService] Removed session ID');
  }

  // Helper method to get headers
  Future<Map<String, String>> _getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    print('[ApiService] Headers: $headers');
    return headers;
  }

  // Authentication APIs
  Future<Map<String, dynamic>> login(String email, String password) async {
    print('[ApiService] Login called with email: $email');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: await _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('[ApiService] Login response status: ${response.statusCode}');
      print('[ApiService] Login response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Save session ID if provided
        if (data['session_id'] != null) {
          await _saveSessionId(data['session_id']);
        }
        print('[ApiService] Login successful for email: $email');
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
          'member_id': data['member_id'],
          'session_id': data['session_id'],
        };
      } else {
        print('[ApiService] Login failed for email: $email, response: $data');
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('[ApiService] Login error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String applicantType,
    required String identificationNo,
    required String gender,
  }) async {
    print('[ApiService] Register called with email: $email');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'phone': phone,
          'password': password,
          'applicant_type': applicantType,
          'identification_no': identificationNo,
          'gender': gender,
        }),
      );

      print('[ApiService] Register response status: ${response.statusCode}');
      print('[ApiService] Register response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('[ApiService] Registration successful for email: $email');
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'member_id': data['member_id'],
        };
      } else {
        print(
          '[ApiService] Registration failed for email: $email, response: $data',
        );
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print('[ApiService] Registration error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
      };
    }
  }

  // NEW: Get registration status
  Future<Map<String, dynamic>> getRegistrationStatus(String email) async {
    print('[ApiService] getRegistrationStatus called with email: $email');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/get_registration_status'),
        headers: await _getHeaders(),
        body: jsonEncode({'email': email}),
      );

      print(
        '[ApiService] getRegistrationStatus response status: ${response.statusCode}',
      );
      print(
        '[ApiService] getRegistrationStatus response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] getRegistrationStatus successful,  $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] getRegistrationStatus failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to fetch registration status',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] getRegistrationStatus error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  // NEW: Initiate registration payment
  Future<Map<String, dynamic>> initiateRegistrationPayment(String email) async {
    print('[ApiService] initiateRegistrationPayment called with email: $email');
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] initiateRegistrationPayment headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/initiate_registration_payment'),
        headers: headers,
        body: jsonEncode({'email': email}),
      );

      print(
        '[ApiService] initiateRegistrationPayment response status: ${response.statusCode}',
      );
      print(
        '[ApiService] initiateRegistrationPayment response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] initiateRegistrationPayment successful,  $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] initiateRegistrationPayment failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to initiate registration payment',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] initiateRegistrationPayment error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  // NEW: Check registration payment status
  Future<Map<String, dynamic>> checkRegistrationPayment(String email) async {
    print('[ApiService] checkRegistrationPayment called with email: $email');
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] checkRegistrationPayment headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/check_registration_payment'),
        headers: headers,
        body: jsonEncode({'email': email}),
      );

      print(
        '[ApiService] checkRegistrationPayment response status: ${response.statusCode}',
      );
      print(
        '[ApiService] checkRegistrationPayment response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] checkRegistrationPayment successful, data: $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] checkRegistrationPayment failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to check registration payment',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] checkRegistrationPayment error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  // Logout
  Future<void> logout() async {
    print('[ApiService] Logout called');
    await _removeSessionId();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final sessionId = await _getSessionId();
    final isAuthenticated = sessionId != null;
    print('[ApiService] isAuthenticated: $isAuthenticated');
    return isAuthenticated;
  }

  // API Methods - All real API calls
  Future<Map<String, dynamic>> getMemberData(String memberNumber) async {
    print('[ApiService] getMemberData called with memberNumber: $memberNumber');
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] getMemberData headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/member_data'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber}),
      );

      print(
        '[ApiService] getMemberData response status: ${response.statusCode}',
      );
      print('[ApiService] getMemberData response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] getMemberData successful, data: $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] getMemberData failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to fetch member data',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] getMemberData error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> getTransactionHistory(
    String memberNumber,
  ) async {
    print(
      '[ApiService] getTransactionHistory called with memberNumber: $memberNumber',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] getTransactionHistory headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/transaction_history'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber}),
      );

      print(
        '[ApiService] getTransactionHistory response status: ${response.statusCode}',
      );
      print(
        '[ApiService] getTransactionHistory response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
          '[ApiService] getTransactionHistory successful, data count: ${data.length}',
        );
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] getTransactionHistory failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to fetch transaction history',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] getTransactionHistory error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> calculateLoanEligibility(
    String memberNumber,
  ) async {
    print(
      '[ApiService] calculateLoanEligibility called with memberNumber: $memberNumber',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] calculateLoanEligibility headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/loan_eligibility'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber}),
      );

      print(
        '[ApiService] calculateLoanEligibility response status: ${response.statusCode}',
      );
      print(
        '[ApiService] calculateLoanEligibility response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] calculateLoanEligibility successful,  $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] calculateLoanEligibility failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to calculate loan eligibility',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] calculateLoanEligibility error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> getAvailableGuarantors(
    String memberNumber,
  ) async {
    print(
      '[ApiService] getAvailableGuarantors called with memberNumber: $memberNumber',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] getAvailableGuarantors headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/available_guarantors'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber}),
      );

      print(
        '[ApiService] getAvailableGuarantors response status: ${response.statusCode}',
      );
      print(
        '[ApiService] getAvailableGuarantors response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
          '[ApiService] getAvailableGuarantors successful, data count: ${data.length}',
        );
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] getAvailableGuarantors failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to fetch available guarantors',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] getAvailableGuarantors error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> submitLoanRequest({
    required String memberNumber,
    required double requestedAmount,
    required List<Map<String, dynamic>> guarantors,
  }) async {
    print(
      '[ApiService] submitLoanRequest called with memberNumber: $memberNumber, amount: $requestedAmount, guarantors: ${guarantors.length}',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] submitLoanRequest headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/submit_loan_request'),
        headers: headers,
        body: jsonEncode({
          'member_number': memberNumber,
          'requested_amount': requestedAmount,
          'guarantors': guarantors,
        }),
      );

      print(
        '[ApiService] submitLoanRequest response status: ${response.statusCode}',
      );
      print('[ApiService] submitLoanRequest response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] submitLoanRequest successful,  $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] submitLoanRequest failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to submit loan request',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] submitLoanRequest error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> getCurrentLoan(String memberNumber) async {
    print(
      '[ApiService] getCurrentLoan called with memberNumber: $memberNumber',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] getCurrentLoan headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/current_loan'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber}),
      );

      print(
        '[ApiService] getCurrentLoan response status: ${response.statusCode}',
      );
      print('[ApiService] getCurrentLoan response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] getCurrentLoan successful,  $data');
        return {'success': true, 'data': data['data']};
      } else if (response.statusCode == 404) {
        // No current loan is valid
        print('[ApiService] getCurrentLoan - No current loan found');
        return {'success': true, 'data': null};
      } else {
        print(
          '[ApiService] getCurrentLoan failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to fetch current loan',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] getCurrentLoan error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> initiateSavingsPayment({
    required String memberNumber,
    required double amount,
  }) async {
    print(
      '[ApiService] initiateSavingsPayment called with memberNumber: $memberNumber, amount: $amount',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] initiateSavingsPayment headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/initiate_savings_payment'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber, 'amount': amount}),
      );

      print(
        '[ApiService] initiateSavingsPayment response status: ${response.statusCode}',
      );
      print(
        '[ApiService] initiateSavingsPayment response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] initiateSavingsPayment successful,  $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] initiateSavingsPayment failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to initiate savings payment',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] initiateSavingsPayment error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> confirmSavingsPayment(
    String transactionId,
  ) async {
    print(
      '[ApiService] confirmSavingsPayment called with transactionId: $transactionId',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] confirmSavingsPayment headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/confirm_savings_payment'),
        headers: headers,
        body: jsonEncode({'transaction_id': transactionId}),
      );

      print(
        '[ApiService] confirmSavingsPayment response status: ${response.statusCode}',
      );
      print(
        '[ApiService] confirmSavingsPayment response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] confirmSavingsPayment successful, data: $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] confirmSavingsPayment failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to confirm savings payment',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] confirmSavingsPayment error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> initiateLoanPayment({
    required String memberNumber,
    required double amount,
  }) async {
    print(
      '[ApiService] initiateLoanPayment called with memberNumber: $memberNumber, amount: $amount',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] initiateLoanPayment headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/initiate_loan_payment'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber, 'amount': amount}),
      );

      print(
        '[ApiService] initiateLoanPayment response status: ${response.statusCode}',
      );
      print('[ApiService] initiateLoanPayment response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] initiateLoanPayment successful, data: $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] initiateLoanPayment failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to initiate loan payment',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] initiateLoanPayment error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> confirmLoanPayment(String transactionId) async {
    print(
      '[ApiService] confirmLoanPayment called with transactionId: $transactionId',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] confirmLoanPayment headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/confirm_loan_payment'),
        headers: headers,
        body: jsonEncode({'transaction_id': transactionId}),
      );

      print(
        '[ApiService] confirmLoanPayment response status: ${response.statusCode}',
      );
      print('[ApiService] confirmLoanPayment response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] confirmLoanPayment successful, data: $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] confirmLoanPayment failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to confirm loan payment',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] confirmLoanPayment error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> topUpCapitalShare({
    required String memberNumber,
    required double amount,
  }) async {
    print(
      '[ApiService] topUpCapitalShare called with memberNumber: $memberNumber, amount: $amount',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] topUpCapitalShare headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/top_up_capital_share'),
        headers: headers,
        body: jsonEncode({'member_number': memberNumber, 'amount': amount}),
      );

      print(
        '[ApiService] topUpCapitalShare response status: ${response.statusCode}',
      );
      print('[ApiService] topUpCapitalShare response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] topUpCapitalShare successful,  $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] topUpCapitalShare failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to top up capital share',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] topUpCapitalShare error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }

  Future<Map<String, dynamic>> submitContactMessage({
    required String memberNumber,
    required String subject,
    required String message,
  }) async {
    print(
      '[ApiService] submitContactMessage called with memberNumber: $memberNumber, subject: $subject',
    );
    try {
      final headers = await _getHeaders();
      final sessionId = await _getSessionId();
      if (sessionId != null) {
        headers['Cookie'] = 'session_id=$sessionId';
      }

      print('[ApiService] submitContactMessage headers: $headers');

      final response = await http.post(
        Uri.parse('$baseUrl/api/submit_contact_message'),
        headers: headers,
        body: jsonEncode({
          'member_number': memberNumber,
          'subject': subject,
          'message': message,
        }),
      );

      print(
        '[ApiService] submitContactMessage response status: ${response.statusCode}',
      );
      print(
        '[ApiService] submitContactMessage response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('[ApiService] submitContactMessage successful, data: $data');
        return {'success': true, 'data': data['data']};
      } else {
        print(
          '[ApiService] submitContactMessage failed with status: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': 'Failed to submit contact message',
          'data': null,
        };
      }
    } catch (e) {
      print('[ApiService] submitContactMessage error: $e');
      return {
        'success': false,
        'message': 'Network error: Unable to connect to server',
        'error': e.toString(),
        'data': null,
      };
    }
  }
}
