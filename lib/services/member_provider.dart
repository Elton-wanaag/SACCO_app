// lib/services/member_provider.dart
import 'package:flutter/material.dart';
import 'package:sacco_app/models/member_data.dart';
import 'api_service.dart';

class MemberProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  MemberData? _memberData;
  List<TransactionData> _transactions = [];
  LoanData? _currentLoan;
  bool _isLoading = false;
  String? _error;

  // Getters
  MemberData? get memberData => _memberData;
  List<TransactionData> get transactions => _transactions;
  LoanData? get currentLoan => _currentLoan;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // NEW: Get registration status
  Future<Map<String, dynamic>> getRegistrationStatus(String email) async {
    try {
      final result = await _apiService.getRegistrationStatus(email);
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Load member data
  Future<Map<String, dynamic>> loadMemberData(String memberNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getMemberData(memberNumber);

      if (result['success'] == true && result['data'] != null) {
        final data = result['data'];
        _memberData = MemberData.fromJson(data);
      } else {
        _error = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Load transaction history
  Future<Map<String, dynamic>> loadTransactionHistory(
    String memberNumber,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getTransactionHistory(memberNumber);

      if (result['success'] == true && result['data'] != null) {
        final List<dynamic> transactionsData = result['data'];
        _transactions = transactionsData
            .map((json) => TransactionData.fromJson(json))
            .toList();
      } else {
        _error = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Load current loan
  Future<Map<String, dynamic>> loadCurrentLoan(String memberNumber) async {
    try {
      final result = await _apiService.getCurrentLoan(memberNumber);

      if (result['success'] == true && result['data'] != null) {
        final data = result['data'];
        _currentLoan = LoanData.fromJson(data);
      } else if (result['success'] == true && result['data'] == null) {
        // No current loan is valid
        _currentLoan = null;
      }

      notifyListeners();
      return result;
    } catch (e) {
      // No current loan or error - this is acceptable
      _currentLoan = null;
      notifyListeners();
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Calculate loan eligibility
  Future<Map<String, dynamic>> calculateLoanEligibility(
    String memberNumber,
  ) async {
    try {
      final result = await _apiService.calculateLoanEligibility(memberNumber);
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Get available guarantors
  Future<Map<String, dynamic>> getAvailableGuarantors(
    String memberNumber,
  ) async {
    try {
      final result = await _apiService.getAvailableGuarantors(memberNumber);
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Submit loan request
  Future<Map<String, dynamic>> submitLoanRequest({
    required String memberNumber,
    required double requestedAmount,
    required List<Map<String, dynamic>> guarantors,
  }) async {
    try {
      final result = await _apiService.submitLoanRequest(
        memberNumber: memberNumber,
        requestedAmount: requestedAmount,
        guarantors: guarantors,
      );
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Initiate savings payment
  Future<Map<String, dynamic>> initiateSavingsPayment({
    required String memberNumber,
    required double amount,
  }) async {
    try {
      final result = await _apiService.initiateSavingsPayment(
        memberNumber: memberNumber,
        amount: amount,
      );
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Confirm savings payment
  Future<Map<String, dynamic>> confirmSavingsPayment(
    String transactionId,
  ) async {
    try {
      final result = await _apiService.confirmSavingsPayment(transactionId);
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Initiate loan payment
  Future<Map<String, dynamic>> initiateLoanPayment({
    required String memberNumber,
    required double amount,
  }) async {
    try {
      final result = await _apiService.initiateLoanPayment(
        memberNumber: memberNumber,
        amount: amount,
      );
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Confirm loan payment
  Future<Map<String, dynamic>> confirmLoanPayment(String transactionId) async {
    try {
      final result = await _apiService.confirmLoanPayment(transactionId);
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Top up capital share
  Future<Map<String, dynamic>> topUpCapitalShare({
    required String memberNumber,
    required double amount,
  }) async {
    try {
      final result = await _apiService.topUpCapitalShare(
        memberNumber: memberNumber,
        amount: amount,
      );
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Submit contact message
  Future<Map<String, dynamic>> submitContactMessage({
    required String memberNumber,
    required String subject,
    required String message,
  }) async {
    try {
      final result = await _apiService.submitContactMessage(
        memberNumber: memberNumber,
        subject: subject,
        message: message,
      );
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // NEW: Initiate registration payment
  Future<Map<String, dynamic>> initiateRegistrationPayment(String email) async {
    try {
      final result = await _apiService.initiateRegistrationPayment(email);
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // NEW: Check registration payment
  Future<Map<String, dynamic>> checkRegistrationPayment(String email) async {
    try {
      final result = await _apiService.checkRegistrationPayment(email);
      return result;
    } catch (e) {
      return {'success': false, 'message': e.toString(), 'data': null};
    }
  }

  // Clear data on logout
  void clearData() {
    _memberData = null;
    _transactions = [];
    _currentLoan = null;
    _error = null;
    notifyListeners();
  }
}
