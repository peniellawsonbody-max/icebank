import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/account_provider.dart';
import '../providers/crypto_provider.dart';
import 'compte_screen.dart';
import 'crypto_screen.dart';
import 'transactions_screen.dart';
import 'carte_screen.dart';
import 'ai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CompteScreen(),
    const CryptoScreen(),
    const TransactionsScreen(),
    const CarteScreen(),
    const AIScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final account = context.read<AccountProvider>();
    final crypto  = context.read<CryptoProvider>();
    await Future.wait([
      account.fetchBalance(),
      account.fetchTransactions(),
      crypto.fetchPrices(),
      crypto.fetchPortfolio(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.primary.withOpacity(0.15),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          selectedItemColor:   AppTheme.secondary,
          unselectedItemColor: AppTheme.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon:  Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Compte',
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.currency_bitcoin_outlined),
              activeIcon: Icon(Icons.currency_bitcoin),
              label: 'Crypto',
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.swap_horiz_outlined),
              activeIcon: Icon(Icons.swap_horiz),
              label: 'Mouvements',
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.credit_card_outlined),
              activeIcon: Icon(Icons.credit_card),
              label: 'Carte',
            ),
            BottomNavigationBarItem(
              icon:  Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome),
              label: 'IceAI',
            ),
          ],
        ),
      ),
    );
  }
}
