import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CryptoProvider extends ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic> _prices = {};
  List<dynamic> _portfolio = [];
  double _totalValueEur = 0.0;

  bool get isLoading => _isLoading;
  Map<String, dynamic> get prices => _prices;
  List<dynamic> get portfolio => _portfolio;
  double get totalValueEur => _totalValueEur;

  Future<void> fetchPrices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _prices = await ApiService.get('/crypto/prices');
    } catch (e) {
      debugPrint('Erreur fetchPrices: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPortfolio() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('/crypto/portfolio');
      _portfolio    = response['wallets'] ?? [];
      _totalValueEur = double.parse(
        response['total'].toString(),
      );
    } catch (e) {
      debugPrint('Erreur fetchPortfolio: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> buyCrypto({
    required String crypto,
    required double amountEur,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.post('/crypto/buy', {
        'crypto':      crypto,
        'amount_eur':  amountEur,
      });

      await fetchPortfolio();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur buyCrypto: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sellCrypto({
    required String crypto,
    required double amountEur,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.post('/crypto/sell', {
        'crypto':     crypto,
        'amount_eur': amountEur,
      });

      await fetchPortfolio();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur sellCrypto: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendCrypto({
    required String crypto,
    required String address,
    required double amount,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.post('/crypto/send', {
        'crypto':  crypto,
        'address': address,
        'amount':  amount,
      });

      await fetchPortfolio();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erreur sendCrypto: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
