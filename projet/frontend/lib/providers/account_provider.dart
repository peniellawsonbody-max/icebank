import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AccountProvider extends ChangeNotifier {
  bool _isLoading = false;
  double _balance = 0.0;
  List<dynamic> _transactions = [];
  Map<String, dynamic>? _rib;

  bool get isLoading => _isLoading;
  double get balance => _balance;
  List<dynamic> get transactions => _transactions;
  Map<String, dynamic>? get rib => _rib;

  Future<void> fetchBalance() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/balance');
      _balance = double.parse(response['balance'].toString());
    } catch (e) {
      debugPrint('Erreur fetchBalance: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/transactions');
      _transactions = response['data'] ?? [];
    } catch (e) {
      debugPrint('Erreur fetchTransactions: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRib() async {
    try {
      _rib = await ApiService.get('/rib');
      notifyListeners();
    } catch (e) {
      debugPrint('Erreur fetchRib: $e');
    }
  }

  Future<bool> transfer({
    required String beneficiary,
    required double amount,
    String? motif,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.post('/transfer', {
        'beneficiary': beneficiary,
        'amount':      amount,
        'motif':       motif ?? '',
      });

      await fetchBalance();
      await fetchTransactions();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur transfer: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
