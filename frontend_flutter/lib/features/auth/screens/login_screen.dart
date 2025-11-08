import 'dart:developer';
import 'package:animate_do/animate_do.dart'; 
import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart'; 
import 'package:provider/provider.dart';
import '../../../core/state/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _testLogin() async { 
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final email = _emailController.text;
    final password = _passwordController.text;

    log("--- Bắt đầu test API: /login ---");
    log("Gửi Request: {email: $email, password: $password}");

    try {
      bool success = await authProvider.login(email, password);
      if (success) {
        log("[SUCCESS] Đăng nhập thành công. Provider state đã cập nhật.");
      }
    } catch (e) {
      log("[ERROR] Lỗi khi gọi API /login:", error: e);
      
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Đăng nhập thất bại: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.lightBlue, Colors.white, AppColors.lightPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Card(
                  elevation: 8.0, 
                  shadowColor: AppColors.primaryPurple.withAlpha((255 * 0.2).round()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(LucideIcons.bookOpen, color: Colors.white, size: 32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInDown(
                          delay: const Duration(milliseconds: 300),
                          child: Text(
                            l10n.appName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeInDown(
                          delay: const Duration(milliseconds: 400),
                          child: Text(
                            l10n.loginButton,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: l10n.emailHint,
                            prefixIcon: Icon(LucideIcons.mail, size: 20),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            hintText: l10n.passwordHint,
                            prefixIcon: Icon(LucideIcons.lock, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword ? LucideIcons.eyeOff : LucideIcons.eye,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _testLogin,
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                  )
                                : Text(l10n.loginButton),
                          ),
                        ),
                        const SizedBox(height: 24),

                        TextButton(
                          onPressed: isLoading ? null : () => context.go('/register'),
                          child: Text(l10n.registerButton),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}