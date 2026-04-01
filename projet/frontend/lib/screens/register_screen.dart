import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth    = context.read<AuthProvider>();
    final success = await auth.register(
      _nameCtrl.text.trim(),
      _emailCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:         Text('Erreur lors de la création du compte'),
          backgroundColor: AppTheme.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue sur IceBank',
                  style: TextStyle(
                    color:      AppTheme.textPrimary,
                    fontSize:   28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Créez votre compte en quelques secondes',
                  style: TextStyle(
                    color:    AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                // Nom
                TextFormField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText:  'Nom complet',
                    prefixIcon: Icon(
                      Icons.person_outlined,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Nom requis' : null,
                ),
                const SizedBox(height: 16),
                // Email
                TextFormField(
                  controller:   _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText:  'Email',
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Email requis' : null,
                ),
                const SizedBox(height: 16),
                // Mot de passe
                TextFormField(
                  controller:  _passwordCtrl,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: InputDecoration(
                    labelText:  'Mot de passe',
                    prefixIcon: const Icon(
                      Icons.lock_outlined,
                      color: AppTheme.textMuted,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.textMuted,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                  validator: (v) => v!.length < 6
                      ? 'Minimum 6 caractères'
                      : null,
                ),
                const SizedBox(height: 32),
                // Bouton inscription
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _register,
                    child: auth.isLoading
                        ? const CircularProgressIndicator(
                            color:       Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text('Créer mon compte'),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Déjà un compte ? Se connecter',
                      style: TextStyle(color: AppTheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
