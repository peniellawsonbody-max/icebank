import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/crypto_provider.dart';

class CryptoScreen extends StatelessWidget {
  const CryptoScreen({super.key});

  final List<Map<String, dynamic>> _cryptos = const [
    {
      'name':   'Bitcoin',
      'symbol': 'BTC',
      'id':     'bitcoin',
      'icon':   '₿',
      'color':  Color(0xFFF7931A),
    },
    {
      'name':   'Ethereum',
      'symbol': 'ETH',
      'id':     'ethereum',
      'icon':   'Ξ',
      'color':  Color(0xFF627EEA),
    },
    {
      'name':   'Tether',
      'symbol': 'USDT',
      'id':     'tether',
      'icon':   '₮',
      'color':  Color(0xFF26A17B),
    },
    {
      'name':   'Solana',
      'symbol': 'SOL',
      'id':     'solana',
      'icon':   'S',
      'color':  Color(0xFF00FFA3),
    },
    {
      'name':   'XRP',
      'symbol': 'XRP',
      'id':     'ripple',
      'icon':   'X',
      'color':  Color(0xFF1DA1F2),
    },
    {
      'name':   'Avalanche',
      'symbol': 'AVAX',
      'id':     'avalanche-2',
      'icon':   'A',
      'color':  Color(0xFFE84142),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final crypto = context.watch<CryptoProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await crypto.fetchPrices();
            await crypto.fetchPortfolio();
          },
          color: AppTheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Crypto',
                  style: TextStyle(
                    color:      AppTheme.textPrimary,
                    fontSize:   26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                // Portefeuille
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:        AppTheme.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Portefeuille crypto',
                        style: TextStyle(
                          color:   AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${crypto.totalValueEur.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          color:      Colors.white,
                          fontSize:   30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '▲ +3,42% aujourd\'hui',
                        style: TextStyle(
                          color:   AppTheme.green,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Boutons actions
                      Row(
                        children: [
                          _CryptoActionBtn(
                            label: 'Acheter',
                            color: AppTheme.secondary,
                            textColor: AppTheme.background,
                            onTap: () => _showBuyDialog(context, crypto),
                          ),
                          const SizedBox(width: 8),
                          _CryptoActionBtn(
                            label: 'Vendre',
                            color: AppTheme.red,
                            textColor: Colors.white,
                            onTap: () => _showSellDialog(context, crypto),
                          ),
                          const SizedBox(width: 8),
                          _CryptoActionBtn(
                            label: 'Envoyer',
                            color: AppTheme.purple,
                            textColor: Colors.white,
                            onTap: () => _showSendDialog(context, crypto),
                          ),
                          const SizedBox(width: 8),
                          _CryptoActionBtn(
                            label: 'Recevoir',
                            color: AppTheme.green,
                            textColor: AppTheme.background,
                            onTap: () => _showReceiveDialog(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Marchés',
                  style: TextStyle(
                    color:      AppTheme.textPrimary,
                    fontSize:   16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // Liste cryptos
                ListView.builder(
                  shrinkWrap: true,
                  physics:    const NeverScrollableScrollPhysics(),
                  itemCount:  _cryptos.length,
                  itemBuilder: (context, index) {
                    final c     = _cryptos[index];
                    final price = crypto.prices[c['id']]?['eur'] ?? 0.0;
                    final change = crypto.prices[c['id']]
                            ?['eur_24h_change'] ??
                        0.0;
                    final isUp = change >= 0;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color:        AppTheme.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width:  44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: (c['color'] as Color)
                                  .withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                c['icon'],
                                style: TextStyle(
                                  color:      c['color'] as Color,
                                  fontSize:   18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['name'],
                                  style: const TextStyle(
                                    color:      AppTheme.textPrimary,
                                    fontSize:   14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  c['symbol'],
                                  style: const TextStyle(
                                    color:   AppTheme.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${price.toStringAsFixed(2)} €',
                                style: const TextStyle(
                                  color:      AppTheme.textPrimary,
                                  fontSize:   14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${isUp ? '▲' : '▼'} ${change.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color:    isUp
                                      ? AppTheme.green
                                      : AppTheme.red,
                                  fontSize: 11,
                                ),
                              ),
                            ],
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

  void _showBuyDialog(BuildContext context, CryptoProvider crypto) {
    final amountCtrl = TextEditingController();
    String selected  = 'bitcoin';
    showModalBottomSheet(
      context:       context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Acheter des cryptos',
              style: TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller:   amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Montant en €',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final amount = double.tryParse(amountCtrl.text) ?? 0;
                  if (amount > 0) {
                    await crypto.buyCrypto(
                      crypto:    selected,
                      amountEur: amount,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Confirmer l\'achat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellDialog(BuildContext context, CryptoProvider crypto) {
    final amountCtrl = TextEditingController();
    showModalBottomSheet(
      context:         context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Vendre des cryptos',
              style: TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller:   amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Montant en €',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.red,
                ),
                onPressed: () async {
                  final amount = double.tryParse(amountCtrl.text) ?? 0;
                  if (amount > 0) {
                    await crypto.sellCrypto(
                      crypto:    'bitcoin',
                      amountEur: amount,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Confirmer la vente'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSendDialog(BuildContext context, CryptoProvider crypto) {
    final addressCtrl = TextEditingController();
    final amountCtrl  = TextEditingController();
    showModalBottomSheet(
      context:         context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Envoyer des cryptos',
              style: TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Adresse wallet',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller:   amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Montant',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.purple,
                ),
                onPressed: () async {
                  await crypto.sendCrypto(
                    crypto:  'bitcoin',
                    address: addressCtrl.text,
                    amount:  double.tryParse(amountCtrl.text) ?? 0,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Envoyer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReceiveDialog(BuildContext context) {
    showModalBottomSheet(
      context:         context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Recevoir des cryptos',
              style: TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:        AppTheme.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2),
                ),
              ),
              child: const Text(
                '0x3Fa8e2B1C9d047A6b3E5c8F2A10B4D7E9C2F3A84',
                style: TextStyle(
                  color:      AppTheme.primary,
                  fontSize:   12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  foregroundColor: AppTheme.background,
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Copier l\'adresse'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CryptoActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _CryptoActionBtn({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color:        color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:      textColor,
              fontSize:   11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
