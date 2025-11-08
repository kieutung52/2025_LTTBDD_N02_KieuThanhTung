import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app_theme.dart';
import 'package:frontend_flutter/core/models/user/user_response.dart';
import 'package:frontend_flutter/core/state/auth_provider.dart';
import 'package:frontend_flutter/shared/widgets/app_bar_user_info.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveShell extends StatefulWidget {
  final Widget child;
  const ResponsiveShell({super.key, required this.child});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  bool _isDesktopSidebarExpanded = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().authenticatedUser;

    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        if (sizingInfo.isMobile) {
          return _buildMobileLayout(context, widget.child, user);
        } else {
          return _buildDesktopLayout(context, widget.child, user);
        }
      },
    );
  }

  Widget _buildDesktopLayout(
      BuildContext context, Widget child, UserResponse user) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.menu, color: AppColors.textSecondary),
          tooltip: "Thu/gọn menu",
          onPressed: () {
            setState(() {
              _isDesktopSidebarExpanded = !_isDesktopSidebarExpanded;
            });
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppBarUserInfo(user: user),
          ),
        ],
      ),
      body: Row(
        children: [
          _DesktopSidebar(isExpanded: _isDesktopSidebarExpanded),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, Widget child, UserResponse user) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(LucideIcons.menu, color: AppColors.textSecondary),
          tooltip: "Mở menu",
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: AppBarUserInfo(user: user, showName: false),
          ),
        ],
      ),
      drawer: _MobileSidebarDrawer(),
      body: child,
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  final bool isExpanded;
  const _DesktopSidebar({required this.isExpanded});

  int _currentIndex(BuildContext context) {
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/learn')) return 1;
    if (location.startsWith('/exercise')) return 2;
    if (location.startsWith('/profile')) return 3;
    if (location.startsWith('/search')) return 4;
    return 0;
  }

  void _onTap(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/learn');
        break;
      case 2:
        context.go('/exercise');
        break;
      case 3:
        context.go('/profile');
        break;
      case 4:
        context.go('/search');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

    return NavigationRail(
      extended: isExpanded,
      selectedIndex: _currentIndex(context),
      onDestinationSelected: (index) => _onTap(index, context),
      minWidth: 80,
      minExtendedWidth: 256,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 20.0, horizontal: isExpanded ? 24.0 : 0),
        child: isExpanded
            ? Text(
                'EnglishMaster',
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(
                LucideIcons.bookOpenCheck,
                color: AppColors.primaryBlue,
                size: 32,
              ),
      ),
      trailing: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: isExpanded
                ? _DesktopLogoutButton(
                    onPressed: () => authProvider.logout(),
                  )
                : IconButton(
                    icon: Icon(LucideIcons.logOut, color: AppColors.error),
                    tooltip: "Đăng xuất",
                    onPressed: () => authProvider.logout(),
                  ),
          ),
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(LucideIcons.house),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.bookOpen),
          label: Text('Học'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.clipboardList),
          label: Text('Bài tập'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.user),
          label: Text('Hồ sơ'),
        ),
        NavigationRailDestination(
          icon: Icon(LucideIcons.search),
          label: Text('Tra từ'),
        ),
      ],
    );
  }
}

class _MobileSidebarDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    
    final user = authProvider.authenticatedUser;

    
    void navigate(BuildContext context, String route) {
      Navigator.pop(context);
      context.go(route);
    }

    return Drawer(
      width: 280,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.fullName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white)),
            accountEmail:
                Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.8))),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.lightBlue,
              child: Text(
                user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "A",
                style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
            ),
          ),
          _MobileSidebarTile(
            icon: LucideIcons.house,
            title: 'Home',
            onTap: () => navigate(context, '/home'), 
          ),
          _MobileSidebarTile(
            icon: LucideIcons.bookOpen,
            title: 'Học',
            onTap: () => navigate(context, '/learn'), 
          ),
          _MobileSidebarTile(
            icon: LucideIcons.clipboardList,
            title: 'Bài tập',
            onTap: () => navigate(context, '/exercise'), 
          ),
           _MobileSidebarTile(
            icon: LucideIcons.search,
            title: 'Tra từ',
            onTap: () => navigate(context, '/search'), 
          ),
          _MobileSidebarTile(
            icon: LucideIcons.user,
            title: 'Hồ sơ',
            onTap: () => navigate(context, '/profile'), 
          ),
          const Divider(indent: 16, endIndent: 16),
          _MobileSidebarTile(
            icon: LucideIcons.logOut,
            title: 'Đăng xuất',
            color: AppColors.error,
            onTap: () {
              Navigator.pop(context);
              authProvider.logout();
            },
          ),
        ],
      ),
    );
  }
}

class _MobileSidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _MobileSidebarTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textSecondary, size: 22),
      title: Text(title,
          style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}

class _DesktopLogoutButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _DesktopLogoutButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        hoverColor: AppColors.error.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(LucideIcons.logOut, size: 20, color: AppColors.error),
              const SizedBox(width: 12),
              Text(
                'Đăng xuất',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}