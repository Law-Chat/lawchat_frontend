import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../theme/colors.dart';
import '../../services/chat_history_refresh_bus.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = GoRouterState.of(context).uri.toString();
    bool sel(String path) => loc == path || loc.startsWith('$path/');

    return Scaffold(
      extendBody: true,
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/chatting');

          if (!context.mounted) return;

          final locAfter = GoRouterState.of(context).uri.toString();

          if (locAfter == '/history') {
            ChatHistoryRefreshBus.instance.refresh();
          }
        },
        backgroundColor: cs.primary,
        child: const Icon(LucideIcons.plus, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Builder(
          builder: (context) {
            final bottomInset = MediaQuery.of(context).viewPadding.bottom;
            final barHeight = 64.0 + bottomInset;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.black.withOpacity(0.08)),
                ),
              ),
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 6,
                color: AppColors.white,
                child: SizedBox(
                  height: barHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _NavItem(
                        icon: LucideIcons.home,
                        selected: sel('/home') || loc == '/',
                        onTap: () => context.go('/home'),
                        selectedColor: cs.primary,
                      ),
                      _NavItem(
                        icon: LucideIcons.clock,
                        selected: sel('/history'),
                        onTap: () => context.go('/history'),
                        selectedColor: cs.primary,
                      ),
                      const SizedBox(width: 56),
                      _NavItem(
                        icon: LucideIcons.user,
                        selected: sel('/profile'),
                        onTap: () => context.go('/profile'),
                        selectedColor: cs.primary,
                      ),
                      _NavItem(
                        icon: LucideIcons.bell,
                        selected: sel('/alerts'),
                        onTap: () => context.go('/alerts'),
                        selectedColor: cs.primary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    double size = 24;
    if (icon == LucideIcons.user) size = 26;
    if (icon == LucideIcons.bell) size = 23;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: size,
              color: selected ? selectedColor : AppColors.disable,
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: selected ? selectedColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
