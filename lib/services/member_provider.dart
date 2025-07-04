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

  // Load member data
  Future<void> loadMemberData(String memberNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _memberData = await _apiService.getMemberData(memberNumber);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load transaction history
  Future<void> loadTransactionHistory(String memberNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await _apiService.getTransactionHistory(memberNumber);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load current loan
  Future<void> loadCurrentLoan(String memberNumber) async {
    try {
      _currentLoan = await _apiService.getCurrentLoan(memberNumber);
      notifyListeners();
    } catch (e) {
      // No current loan or error - this is acceptable
      _currentLoan = null;
      notifyListeners();
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