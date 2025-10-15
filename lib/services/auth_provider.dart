// lib/services/auth_provider.dart
import 'package:flutter/material.dart';
import 'api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  int? _memberId;
  String? _currentEmail; // To track current user's email

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  int? get memberId => _memberId;
  String? get currentEmail => _currentEmail; // NEW: Getter for current email

  // NEW: Get current user's registration status
  String _registrationStage = 'draft';
  bool _isApproved = false;
  String? _memberNumber;

  String get registrationStage => _registrationStage;
  bool get isApproved => _isApproved;
  String? get memberNumber => _memberNumber;

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
        _currentEmail = email; // Store current email
        _error = null;

        // NEW: Load registration status after successful login
        await _loadRegistrationStatus(email);
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
      } else {
        // NEW: Set registration stage to 'submitted' after successful registration
        _registrationStage = 'submitted';
        _isApproved = false;
        _currentEmail = email;
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

  // NEW: Load registration status
  Future<void> _loadRegistrationStatus(String email) async {
    try {
      final result = await _apiService.getRegistrationStatus(email);
      if (result['success'] == true && result['data'] != null) {
        final data = result['data'];
        _registrationStage = data['stage'] ?? 'draft';
        _isApproved = data['is_approved'] ?? false;
        _memberNumber = data['member_number'] ?? data['memberNumber'] ?? '';
      }
    } catch (e) {
      print('Error loading registration status: $e');
    }
  }

  // NEW: Public method to load registration status
  Future<void> loadRegistrationStatus(String email) async {
    await _loadRegistrationStatus(email);
    notifyListeners();
  }

  // NEW: Initiate registration payment
  Future<Map<String, dynamic>> initiateRegistrationPayment() async {
    if (_currentEmail == null) {
      return {
        'success': false,
        'message': 'No email available for payment initiation',
      };
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.initiateRegistrationPayment(
        _currentEmail!,
      );
      if (result['success'] == true) {
        _registrationStage = 'process'; // Update stage to payment process
        notifyListeners();
      } else {
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

  // NEW: Check registration payment status
  Future<Map<String, dynamic>> checkRegistrationPayment() async {
    if (_currentEmail == null) {
      return {
        'success': false,
        'message': 'No email available for payment check',
      };
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.checkRegistrationPayment(_currentEmail!);
      if (result['success'] == true) {
        final data = result['data'];
        _registrationStage = data['stage'] ?? _registrationStage;
        _isApproved = data['is_approved'] ?? _isApproved;
        _memberNumber = data['member_number'] ?? _memberNumber;

        if (_isApproved) {
          _isAuthenticated = true; // User is now fully authenticated
        }

        notifyListeners();
      } else {
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

  // NEW: Check if user can access dashboard
  bool canAccessDashboard() {
    return _isAuthenticated && _isApproved;
  }

  Future<void> logout() async {
    await _apiService.logout();
    _isAuthenticated = false;
    _memberId = null;
    _error = null;
    _registrationStage = 'draft';
    _isApproved = false;
    _memberNumber = null;
    _currentEmail = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
