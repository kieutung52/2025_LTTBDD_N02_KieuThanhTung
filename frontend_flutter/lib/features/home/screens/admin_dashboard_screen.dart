import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../../core/services/seeding_service.dart';
import '../../../core/state/auth_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Widget child;
  const AdminDashboardScreen({super.key, required this.child});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isExpanded = true;

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/admin');
        break;
      case 1:
        break;
    }
  }

  int _currentIndex(BuildContext context) {
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    if (location.startsWith('/admin')) return 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.authenticatedUser;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.menu, color: AppColors.textSecondary),
          tooltip: "Thu/gọn menu",
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.white,
        elevation: 1.0,
        shadowColor: Colors.black.withAlpha((255 * 0.1).round()),
        actions: [
          IconButton(
            tooltip: "Đăng xuất",
            icon: Icon(LucideIcons.logOut, color: AppColors.error),
            onPressed: () {
              authProvider.logout();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: _isExpanded,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 20.0, horizontal: _isExpanded ? 0 : 16.0),
              child: Column(
                children: [
                  Icon(LucideIcons.shieldCheck,
                      color: AppColors.primaryPurple, size: 32),
                  if (_isExpanded) ...[
                    const SizedBox(height: 8),
                    Text(user.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(user.email,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
            selectedIndex: _currentIndex(context),
            onDestinationSelected: (index) => _onTap(index, context),
            labelType: _isExpanded
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            minExtendedWidth: 256,
            minWidth: 80,
            indicatorColor: AppColors.lightPurple,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(LucideIcons.database),
                selectedIcon: Icon(LucideIcons.database, color: AppColors.primaryPurple),
                label: Text('Seeding'),
              ),
              NavigationRailDestination(
                icon: Icon(LucideIcons.users),
                selectedIcon: Icon(LucideIcons.users, color: AppColors.primaryPurple),
                label: Text('Users'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _wordController = TextEditingController();
  bool _isAdding = false;
  bool _isRunning = false;

  Future<void> _addWord() async {
    if (_wordController.text.isEmpty) {
      return;
    }
    setState(() {
      _isAdding = true;
    });

    final seedingService = context.read<SeedingService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await seedingService.addWord(_wordController.text);

      if (!mounted) return;
      if (response.success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text(response.message ?? "Thêm từ thành công"),
              backgroundColor: AppColors.success),
        );
        _wordController.clear();
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
            content: Text("Lỗi: ${e.toString()}"),
            backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  Future<void> _runSeeding() async {
    setState(() {
      _isRunning = true;
    });

    final seedingService = context.read<SeedingService>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final response = await seedingService.runSeeding();

      if (!mounted) return;
      if (response.success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text(response.message ?? "Bắt đầu seeding..."),
              backgroundColor: AppColors.success),
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
            content: Text("Lỗi: ${e.toString()}"),
            backgroundColor: AppColors.error),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeIn(
        child: Card(
          elevation: 4,
          shadowColor: AppColors.primaryPurple.withAlpha((255 * 0.1).round()),
          child: Container(
            padding: const EdgeInsets.all(32.0),
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("1. Thêm từ vựng vào hàng đợi",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                TextField(
                  controller: _wordController,
                  decoration: const InputDecoration(
                    hintText: "Nhập từ vựng mới (vd: persistence)",
                    prefixIcon: Icon(LucideIcons.plus, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple),
                    onPressed: _isAdding ? null : _addWord,
                    child: _isAdding
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3))
                        : const Text("Thêm từ"),
                  ),
                ),
                const Divider(height: 48),
                const Text("2. Chạy Seeding",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text(
                    "Kích hoạt tra cứu và lưu tất cả từ trong hàng đợi vào DB.",
                    style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isRunning ? null : _runSeeding,
                    child: _isRunning
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 3))
                        : const Text("Chạy Seeding (Run)"),
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