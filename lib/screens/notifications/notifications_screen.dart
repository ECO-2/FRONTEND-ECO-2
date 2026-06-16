import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/screens/profile/green_footprint_screen.dart'
    show _FigmaHeader;

const _kDark = Color(0xFF10454F);
const _kBg = Color(0xFFF8FAF9);
const _kTextMuted = Color(0xFF807F7F);
const _kTextDark = Color(0xFF0D2B31);

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationsProvider>(context);

    final todayNotifications = notifProvider.notifications
        .where((n) => DateTime.now().difference(n.sentAt).inHours <= 12)
        .toList();
    final weekNotifications = notifProvider.notifications
        .where((n) => DateTime.now().difference(n.sentAt).inHours > 12)
        .toList();

    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          // ── Dark teal header ──────────────────────────────────
          _NotifHeader(unreadCount: notifProvider.unreadCount),
          // ── List ─────────────────────────────────────────────
          Expanded(
            child: notifProvider.notifications.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_none,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No tienes notificaciones por ahora.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: 32),
                    children: [
                      // Mark all read
                      if (notifProvider.unreadCount > 0)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16, top: 6),
                            child: TextButton(
                              onPressed: () {
                                notifProvider.markAllAsRead();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Todas las notificaciones marcadas como leídas.'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const Text(
                                'Marcar todas como leídas',
                                style: TextStyle(
                                  color: _kDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            ),
                          ),
                        ),

                      // HOY
                      if (todayNotifications.isNotEmpty) ...[
                        _sectionLabel('HOY'),
                        ...todayNotifications
                            .map((n) => _buildNotifItem(context, n)),
                        const SizedBox(height: 8),
                      ],

                      // ESTA SEMANA
                      if (weekNotifications.isNotEmpty) ...[
                        _sectionLabel('ESTA SEMANA'),
                        ...weekNotifications
                            .map((n) => _buildNotifItem(context, n)),
                      ],

                      // Footer
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Eso es todo por ahora',
                            style: TextStyle(
                              color: _kTextMuted,
                              fontSize: 13,
                              fontFamily: 'DM Sans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Column(
      children: [
        Container(
          height: 1,
          color: const Color(0xFFE2E8E4),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: _kTextMuted,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotifItem(BuildContext context, dynamic notification) {
    final isUnread = notification.readAt == null;

    // Icon config per notification type
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (notification.type) {
      case 'warning':
        icon = Icons.water_drop_rounded;
        iconColor = const Color(0xFF2196F3);
        iconBg = const Color(0xFFE3F2FD);
        break;
      case 'achievement':
        icon = Icons.emoji_events_rounded;
        iconColor = const Color(0xFFFABF2E);
        iconBg = const Color(0xFFFFF8E1);
        break;
      case 'mission':
        icon = Icons.assignment_rounded;
        iconColor = _kDark;
        iconBg = const Color(0xFFE0EFF1);
        break;
      case 'tip':
        icon = Icons.lightbulb_rounded;
        iconColor = const Color(0xFFFF9800);
        iconBg = const Color(0xFFFFF3E0);
        break;
      default:
        icon = Icons.info_rounded;
        iconColor = Colors.grey;
        iconBg = const Color(0xFFF0F0F0);
    }

    final parts = notification.title.split(': ');
    final titleText = parts[0];
    final bodyText = parts.length > 1 ? parts[1] : '';

    return InkWell(
      onTap: () {
        Provider.of<NotificationsProvider>(context, listen: false)
            .markAsRead(notification.id);
      },
      child: Container(
        color: isUnread
            ? _kDark.withValues(alpha: 0.04)
            : Colors.transparent,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon circle
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          titleText,
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 13,
                            color: _kTextDark,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8, top: 4),
                          decoration: const BoxDecoration(
                            color: _kDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  if (bodyText.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      bodyText,
                      style: const TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: _kTextMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTimeAgo(notification.sentAt),
                    style: const TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 11,
                      color: _kTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
    if (diff.inDays == 1) return 'Ayer';
    const days = ['', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return days[date.weekday];
  }
}

// ── Notifications header with settings icon ──────────────────────────────
class _NotifHeader extends StatelessWidget {
  final int unreadCount;

  const _NotifHeader({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 10,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Notificaciones',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          // Settings icon
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: Colors.white, size: 24),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.settings),
          ),
          // Unread badge
          if (unreadCount > 0)
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFBDE038),
              ),
              alignment: Alignment.center,
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: _kTextDark,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DM Sans',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
