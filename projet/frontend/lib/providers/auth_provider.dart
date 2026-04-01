import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  bool _isAuthenticated = false;
  bool _isLoading       = false;
  String? _token;
  Map<String, dynamic>? _user;

  bool   get isAuthenticated => _isAuthenticated;
  bool   get isLoading       => _isLoading;
  String? get token          => _token;
  Map<String, dynamic>? get user => _user;

  Future<void> checkAuth() async {
    _token = await _storage.read(key: 'token');
    if (_token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/login', {
        'email':    email,
        'password': password,
      });

      if (response['token'] != null) {
        _token           = response['token'];
        _user            = response['user'];
        _isAuthenticated = true;
        await _storage.write(key: 'token', value: _token);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('/register', {
        'name':     name,
        'email':    email,
        'password': password,
      });

      if (response['token'] != null) {
        _token           = response['token'];
        _user            = response['user'];
        _isAuthenticated = true;
        await _storage.write(key: 'token', value: _token);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> logout() async {
    await ApiService.post('/logout', {});
    await _storage.delete(key: 'token');
    _token           = null;
    _user            = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
