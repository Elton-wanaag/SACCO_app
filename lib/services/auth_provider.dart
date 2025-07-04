import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await _apiService.isAuthenticated();
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String emailOrId, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.login(emailOrId, password);
      
      if (result['success'] == true) {
        _isAuthenticated = true;
        _userData = result['data'];
        _error = null;
      } else {
        _isAuthenticated = false;
        _userData = null;
        _error = result['message'];
      }
      
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _error = 'An unexpected error occurred';
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> register(String fullName, String applicantType, String idNumber, String gender, String dob) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.register(fullName, applicantType, idNumber, gender, dob);
      
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
    _userData = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
