import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CarteScreen extends StatefulWidget {
  const CarteScreen({super.key});

  @override
  State<CarteScreen> createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen> {
  bool _contactless    = true;
  bool _onlinePayment  = true;
  bool _international  = true;
  bool _blocked        = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ma Carte',
                    style: TextStyle(
                      color:      AppTheme.textPrimary,
                      fontSize:   26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Gérer l\'offre',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Carte visuelle
              Container(
                width:   double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1a1a2e),
                      Color(0xFF16213e),
                      Color(0xFF0f3460),
                    ],
                    begin: Alignment.topLeft,
                    end:   Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ICE BANK',
                      style: TextStyle(
                        color:         Colors.white,
                        fontSize:      18,
                        fontWeight:    FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Chip
                    Container(
                      width:  40,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFd4a843), Color(0xFFf5c842)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '5290 XXXX XXXX 1109',
                      style: TextStyle(
                        color:         Color(0xCCFFFFFF),
                        fontSize:      16,
                        letterSpacing: 3,
                        fontFamily:    'monospace',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TEVI LAWSON BODY',
                              style: TextStyle(
                                color:         Color(0x99FFFFFF),
                                fontSize:      12,
                                letterSpacing: 1,
                              ),
                            ),
                            Text(
                              'Expire 11/30',
                              style: TextStyle(
                                color:   Color(0x66FFFFFF),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width:  28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFeb001b),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(-10, 0),
                              child: Container(
                                width:  28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFf79e1b)
                                      .withOpacity(0.85),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Actions carte
              Row(
                children: [
                  Expanded(
                    child: _CardAction(
                      icon:  Icons.block,
                      label: 'Opposition',
                      color: AppTheme.red,
                      onTap: () => _showOppositionDialog(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _CardAction(
                      icon:  Icons.tune,
                      label: 'Plafonds',
                      color: AppTheme.primary,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _CardAction(
                      icon:  Icons.lock_outline,
                      label: 'Code PIN',
                      color: AppTheme.gold,
                      onTap: () => _showPinDialog(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Paramètres carte
              const Text(
                'Paramètres de carte',
                style: TextStyle(
                  color:         AppTheme.textMuted,
                  fontSize:      12,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              _ToggleRow(
                label: 'Paiements sans contact',
                value: _contactless,
                onChanged: (v) => setState(() => _contactless = v),
              ),
              _ToggleRow(
                label: 'Paiements sur internet',
                value: _onlinePayment,
                onChanged: (v) => setState(() => _onlinePayment = v),
              ),
              _ToggleRow(
                label: 'Paiements à l\'étranger',
                value: _international,
                onChanged: (v) => setState(() => _international = v),
              ),
              _ToggleRow(
                label: 'Bloquer temporairement',
                value: _blocked,
                onChanged: (v) => setState(() => _blocked = v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOppositionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text(
          'Faire opposition',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir bloquer définitivement votre carte ? '
          'Cette action est irréversible.',
          style: TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppTheme.textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.red,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Confirmer l\'opposition'),
          ),
        ],
      ),
    );
  }

  void _showPinDialog(BuildContext context) {
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
              'Code PIN',
              style: TextStyle(
                color:      AppTheme.textPrimary,
                fontSize:   18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '● ● ● ●',
              style: TextStyle(
                color:    AppTheme.primary,
                fontSize: 32,
                letterSpacing: 12,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre code PIN est sécurisé',
              style: TextStyle(
                color:   AppTheme.textMuted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CardAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:        AppTheme.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color:    color,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical:   12,
      ),
      decoration: BoxDecoration(
        color:        AppTheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color:   AppTheme.textPrimary,
              fontSize: 14,
            ),
          ),
          Switch(
            value:           value,
            onChanged:       onChanged,
            activeColor:     AppTheme.green,
            inactiveThumbColor: AppTheme.textMuted,
          ),
        ],
      ),
    );
  }
}
