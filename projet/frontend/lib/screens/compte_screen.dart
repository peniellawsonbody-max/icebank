import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/account_provider.dart';
import '../providers/auth_provider.dart';

class CompteScreen extends StatelessWidget {
  const CompteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountProvider>();
    final auth    = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await account.fetchBalance();
            await account.fetchTransactions();
          },
          color: AppTheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'IceBank',
                        style: TextStyle(
                          color:      AppTheme.primary,
                          fontSize:   26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: AppTheme.textPrimary,
                            ),
                            onPressed: () {},
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.primary,
                            child: Text(
                              auth.user?['name']
                                      ?.substring(0, 2)
                                      .toUpperCase() ??
                                  'PL',
                              style: const TextStyle(
                                color:      Colors.white,
                                fontSize:   12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Carte solde
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A2F5E), Color(0xFF0F1E3D)],
                      begin:  Alignment.topLeft,
                      end:    Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SOLDE DISPONIBLE',
                        style: TextStyle(
                          color:         AppTheme.textMuted,
                          fontSize:      11,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${account.balance.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   34,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        auth.user?['name'] ?? 'Utilisateur',
                        style: const TextStyle(
                          color:   AppTheme.primary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '5290 XXXX XXXX 1109',
                        style: TextStyle(
                          color:         Color(0x99FFFFFF),
                          fontSize:      13,
                          letterSpacing: 2,
                          fontFamily:    'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Actions rapides
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _QuickAction(
                        icon:  Icons.arrow_upward,
                        label: 'Virer',
                        onTap: () {},
                      ),
                      _QuickAction(
                        icon:  Icons.add,
                        label: 'Recharger',
                        onTap: () {},
                      ),
                      _QuickAction(
                        icon:  Icons.flash_on,
                        label: 'Wero',
                        onTap: () {},
                      ),
                      _QuickAction(
                        icon:  Icons.qr_code,
                        label: 'QR Pay',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Transactions récentes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Opérations récentes',
                        style: TextStyle(
                          color:      AppTheme.textPrimary,
                          fontSize:   16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Tout voir',
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                // Liste transactions
                account.isLoading
                    ? const CircularProgressIndicator(
                        color: AppTheme.primary,
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics:    const NeverScrollableScrollPhysics(),
                        itemCount:  account.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = account.transactions[index];
                          final isCredit = tx['type'] == 'credit';
                          return ListTile(
                            leading: Container(
                              width:  44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.primary.withOpacity(0.15),
                                ),
                              ),
                              child: Icon(
                                isCredit
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: isCredit
                                    ? AppTheme.green
                                    : AppTheme.red,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              tx['label'] ?? '',
                              style: const TextStyle(
                                color:      AppTheme.textPrimary,
                                fontSize:   14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              tx['status'] ?? '',
                              style: const TextStyle(
                                color:   AppTheme.textMuted,
                                fontSize: 11,
                              ),
                            ),
                            trailing: Text(
                              '${isCredit ? '+' : '-'}${tx['amount']} €',
                              style: TextStyle(
                                color: isCredit
                                    ? AppTheme.green
                                    : AppTheme.red,
                                fontSize:   14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppTheme.primary.withOpacity(0.15),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primary, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color:    AppTheme.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
