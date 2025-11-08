import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_service.dart';
import '../../../core/state/locale_provider.dart';
import '../../../core/state/auth_provider.dart';
import '../../../app/app_theme.dart';
import '../../../shared/widgets/streak_display.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _fullNameController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(
      text: context.read<AuthProvider>().authenticatedUser.fullName,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final service = Provider.of<UserService>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;

    log("--- Test API: PUT /user/profile ---");
    try {
      final newName = _fullNameController.text;
      log("Gửi Request: {fullName: $newName}");
      final response = await service.updateProfile(newName);

      if (!mounted) return;
      if (response.success) {
        log("[SUCCESS] Tên mới: ${response.data?.fullName}");
        await authProvider.fetchUserProfile();
        setState(() {
          _isEditing = false;
        });
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdateSuccess),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      log("[ERROR]", error: e);
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(l10n.errorPrefix(e.toString())),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String getInitials(String name) {
    return name.isNotEmpty
        ? name
            .trim()
            .split(RegExp(' +'))
            .map((s) => s[0])
            .take(2)
            .join()
            .toUpperCase()
        : "A";
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final user = context.watch<AuthProvider>().authenticatedUser;
    final l10n = AppLocalizations.of(context)!;

    if (!_isEditing && _fullNameController.text != user.fullName) {
      _fullNameController.text = user.fullName;
    }

    String formatDate(DateTime date) {
      return DateFormat('yyyy-MM-dd').format(date);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FadeInDown(
          child: Card(
            elevation: 2,
            shadowColor: AppColors.primaryBlue.withAlpha((255 * 0.1).round()),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.lightBlue,
                        child: Text(
                          getInitials(user.fullName),
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.fullName,
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text(user.email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.textSecondary)),
                            Chip(
                              label: Text(user.role.name.toUpperCase()),
                              avatar: Icon(LucideIcons.shield,
                                  size: 16, color: AppColors.primaryBlue),
                              backgroundColor: AppColors.lightBlue,
                              labelStyle: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600),
                              side: BorderSide.none,
                            ),
                          ],
                        ),
                      ),
                      if (!_isEditing)
                        OutlinedButton(
                          onPressed: () => setState(() => _isEditing = true),
                          child: Text(l10n.editButton),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        FadeInUp(
          delay: const Duration(milliseconds: 100),
          child: Card(
            elevation: 2,
            shadowColor: AppColors.flame.withAlpha((255 * 0.1).round()),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.streakStatsTitle,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      StreakDisplay(
                          streak: user.streak, size: 100, showAnimation: true),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStreakInfo(LucideIcons.flame, l10n.currentStreakLabel,
                                "${user.streak} ngày", AppColors.flame),
                            const SizedBox(height: 16),
                            _buildStreakInfo(LucideIcons.calendar, l10n.lastActiveLabel,
                                formatDate(user.lastStreakActiveDate.toLocal())),
                            const SizedBox(height: 16),
                            _buildStreakInfo(LucideIcons.calendarClock,
                                l10n.currentDateLabel, formatDate(user.currentDate.toLocal())),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        FadeInUp(
          delay: const Duration(milliseconds: 200),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.personalInfoTitle,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _fullNameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: l10n.fullNameLabel,
                      prefixIcon: Icon(LucideIcons.user, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.email),
                    decoration: InputDecoration(
                      labelText: l10n.emailLabel,
                      prefixIcon: const Icon(LucideIcons.mail, size: 20),
                      fillColor: AppColors.background,
                      hintStyle: const TextStyle(color: AppColors.textDisabled),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: user.id),
                    decoration: InputDecoration(
                      labelText: l10n.userIdLabel,
                      prefixIcon: const Icon(LucideIcons.shield, size: 20),
                      fillColor: AppColors.background,
                      hintStyle: const TextStyle(color: AppColors.textDisabled),
                    ),
                  ),
                  if (_isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: _handleSave,
                            child: Text(l10n.saveChangesButton),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _fullNameController.text = user.fullName;
                              });
                            },
                            child: Text(l10n.cancelButton),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        FadeInUp(
          delay: const Duration(milliseconds: 300),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.changeLanguageLabel),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              localeProvider.setLocale(const Locale('vi'));
                            },
                            child: Text(l10n.vietnameseButton),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              localeProvider.setLocale(const Locale('en'));
                            },
                            child: Text(l10n.englishButton),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.welcomeMessage(user.fullName),
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakInfo(IconData icon, String label, String value,
      [Color? color]) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color ?? AppColors.textPrimary)),
          ],
        ),
      ],
    );
  }
}