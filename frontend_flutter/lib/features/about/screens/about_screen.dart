import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // --- THÔNG TIN ---
  final String ten = "Kiều Thanh Tùng";
  final String msv = "22010214";
  final String githubUser = "kieutung52";
  final String tenTruong = "Trường Công nghệ thông tin, ĐH Phenikaa";
  final String tenLop = "LTTBDD N02";
  // --------------------------

  Future<void> _launchGithub() async {
    final uri = Uri.parse('https://github.com/$githubUser');
    if (!await launchUrl(uri)) {
    }
  }

  @override
  Widget build(BuildContext context) {
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
                maxWidth: 500, 
              ),
              child: FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Card(
                  elevation: 8.0,
                  shadowColor: AppColors.primaryPurple.withAlpha(80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeInDown(
                          delay: const Duration(milliseconds: 200),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(LucideIcons.bookUser,
                                color: Colors.white, size: 32),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeInDown(
                          delay: const Duration(milliseconds: 300),
                          child: const Text(
                            "Bài tập lớn: Ứng dụng học từ vựng",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeInDown(
                          delay: const Duration(milliseconds: 400),
                          child: const Text(
                            "EnglishMaster App",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Divider(height: 40),
                        
                        _buildInfoRow(LucideIcons.user, "Họ và tên:", ten),
                        _buildInfoRow(LucideIcons.keyRound, "Mã sinh viên:", msv),
                        _buildInfoRow(LucideIcons.school, "Trường:", tenTruong),
                        _buildInfoRow(LucideIcons.award, "Lớp:", tenLop),
                        _buildInfoRow(
                          LucideIcons.github,
                          "Github:",
                          "github.com/$githubUser",
                          onTap: _launchGithub,
                        ),
                        
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.go('/login'),
                            child: const Text("Vào ứng dụng"),
                          ),
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

  Widget _buildInfoRow(IconData icon, String label, String value,
      {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, size: 20, color: AppColors.primaryPurple),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        value,
        style: TextStyle(
          color: onTap != null ? AppColors.primaryBlue : AppColors.textPrimary,
          decoration: onTap != null ? TextDecoration.underline : null,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}