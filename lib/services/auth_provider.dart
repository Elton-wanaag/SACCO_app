import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  int? _memberId;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  int? get memberId => _memberId;

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _apiService.isAuthenticated();
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.login(email, password);

      if (result['success'] == true) {
        _isAuthenticated = true;
        _memberId = result['member_id'];
        _error = null;
      } else {
        _isAuthenticated = false;
        _memberId = null;
        _error = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      _isAuthenticated = false;
      _memberId = null;
      notifyListeners();
      return {
        'success': false,
        'message': 'An unexpected error occurred',
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.register(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        applicantType: applicantType,
        identificationNo: identificationNo,
        gender: gender,
      );

      if (result['success'] != true) {
        _error = result['message'];
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'error': e.toString(),
      };
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    _isAuthenticated = false;
    _memberId = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
