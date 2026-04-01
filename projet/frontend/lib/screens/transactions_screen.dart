import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/account_provider.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await account.fetchTransactions();
          },
          color: AppTheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transactions',
                  style: TextStyle(
                    color:      AppTheme.textPrimary,
                    fontSize:   26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                // Solde + Ajouter
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:        AppTheme.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Solde actuel',
                            style: TextStyle(
                              color:   AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${account.balance.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              color:      Colors.white,
                              fontSize:   26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _showTransferDialog(context, account),
                        icon:  const Icon(Icons.add, size: 16),
                        label: const Text('Virer'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Virements
                _SectionTitle(
                  title:    'Virements',
                  onAction: () => _showTransferDialog(context, account),
                  actionLabel: 'Nouveau',
                ),
                const SizedBox(height: 8),
                _ActionTile(
                  icon:  Icons.people_outline,
                  title: 'Gérer les bénéficiaires',
                  subtitle: 'Ajouter, modifier ou supprimer',
                  onTap: () {},
                ),
                _ActionTile(
                  icon:  Icons.sync,
                  title: 'Gérer les virements',
                  subtitle: 'Programmés et récurrents',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                // Wero
                _SectionTitle(
                  title:       'Wero',
                  onAction:    () {},
                  actionLabel: 'Utiliser',
                ),
                const SizedBox(height: 8),
                _ActionTile(
                  icon:  Icons.flash_on_outlined,
                  title: 'Paramètres Wero',
                  subtitle: 'Paiement instantané entre particuliers',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                // Chèques
                _SectionTitle(
                  title:       'Chèques',
                  onAction:    () {},
                  actionLabel: 'Nouvelle remise',
                ),
                const SizedBox(height: 8),
                _ActionTile(
                  icon:  Icons.description_outlined,
                  title: 'Suivre les remises',
                  subtitle: 'Voir l\'état de vos chèques',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                // Prélèvements
                const _SectionTitle(
                  title: 'Prélèvements',
                ),
                const SizedBox(height: 8),
                _ActionTile(
                  icon:  Icons.upload_outlined,
                  title: 'Gérer les prélèvements',
                  subtitle: 'Voir et gérer vos prélèvements',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                // Historique
                const Text(
                  'Historique',
                  style: TextStyle(
                    color:      AppTheme.textPrimary,
                    fontSize:   16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                account.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics:    const NeverScrollableScrollPhysics(),
                        itemCount:  account.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = account.transactions[index];
                          final isCredit = tx['type'] == 'credit';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppTheme.card,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    AppTheme.primary.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width:  40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isCredit
                                        ? AppTheme.green.withOpacity(0.15)
                                        : AppTheme.red.withOpacity(0.15),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    isCredit
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: isCredit
                                        ? AppTheme.green
                                        : AppTheme.red,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tx['label'] ?? '',
                                        style: const TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize:   14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        tx['status'] ?? '',
                                        style: const TextStyle(
                                          color:   AppTheme.textMuted,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${isCredit ? '+' : '-'}${tx['amount']} €',
                                  style: TextStyle(
                                    color: isCredit
                                        ? AppTheme.green
                                        : AppTheme.red,
                                    fontSize:   14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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

  void _showTransferDialog(
    BuildContext context,
    AccountProvider account,
  ) {
    final beneficiaryCtrl = TextEditingController();
    final amountCtrl      = TextEditingController();
    final motifCtrl       = TextEditingController();

    showModalBottomSheet(
      context:         context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left:   24,
          right:  24,
          top:    24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nouveau virement',
              style: TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: beneficiaryCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Bénéficiaire (IBAN ou nom)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller:   amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Montant (€)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: motifCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Motif (optionnel)',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final success = await account.transfer(
                    beneficiary: beneficiaryCtrl.text,
                    amount: double.tryParse(amountCtrl.text) ?? 0,
                    motif:  motifCtrl.text,
                  );
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Virement effectué avec succès'),
                        backgroundColor: AppTheme.green,
                      ),
                    );
                  }
                },
                child: const Text('Envoyer le virement'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final String? actionLabel;

  const _SectionTitle({
    required this.title,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color:      AppTheme.textPrimary,
            fontSize:   16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (onAction != null && actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              '+ $actionLabel',
              style: const TextStyle(color: AppTheme.primary),
            ),
          ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color:        AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color:      AppTheme.textPrimary,
                      fontSize:   14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color:   AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
