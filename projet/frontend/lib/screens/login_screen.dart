import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth    = context.read<AuthProvider>();
    final success = await auth.login(
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
          content:          Text('Email ou mot de passe incorrect'),
          backgroundColor:  AppTheme.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width:  80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.secondary],
                        begin:  Alignment.topLeft,
                        end:    Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size:  40,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Connexion',
                  style: TextStyle(
                    color:      AppTheme.textPrimary,
                    fontSize:   28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connectez-vous à votre compte IceBank',
                  style: TextStyle(
                    color:    AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                // Email
                TextFormField(
                  controller:   _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Email',
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
                  controller:     _passwordCtrl,
                  obscureText:    _obscurePassword,
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
                  validator: (v) =>
                      v!.isEmpty ? 'Mot de passe requis' : null,
                ),
                const SizedBox(height: 32),
                // Bouton connexion
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _login,
                    child: auth.isLoading
                        ? const CircularProgressIndicator(
                            color:       Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text('Se connecter'),
                  ),
                ),
                const SizedBox(height: 16),
                // Lien inscription
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen(),
                      ),
                    ),
                    child: const Text(
                      'Pas de compte ? Créer un compte',
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
