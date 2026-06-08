import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';
import 'package:frontend_eco_2/theme/app_colors.dart';
import 'package:frontend_eco_2/routing/app_routes.dart';
import 'package:frontend_eco_2/widgets/common/custom_status_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationsProvider>(context);

    // Grouping notifications (For simplicity in this mock, we split today's vs older)
    final todayNotifications = notifProvider.notifications
        .where((n) => DateTime.now().difference(n.sentAt).inHours <= 12)
        .toList();
    final weekNotifications = notifProvider.notifications
        .where((n) => DateTime.now().difference(n.sentAt).inHours > 12)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CustomStatusBar(),
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row matching Perfil/Figma style
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withValues(alpha: 0.1),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.chevron_left_rounded,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Notificaciones',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: AppColors.primary,
                            size: 28,
                          ),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
                        ),
                        if (notifProvider.unreadCount > 0)
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${notifProvider.unreadCount}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Main content
                  Expanded(
                    child: notifProvider.notifications.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('No tienes notificaciones por ahora.', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              if (notifProvider.unreadCount > 0)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0, top: 0.0),
                                    child: TextButton(
                                      onPressed: () {
                                        notifProvider.markAllAsRead();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Todas las notificaciones marcadas como leídas.'),
                                            duration: Duration(seconds: 1),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Marcar todas como leídas',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  children: [
                                    if (todayNotifications.isNotEmpty) ...[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        child: Text(
                                          'HOY',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            letterSpacing: 1.2,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      ...todayNotifications.map((n) => _buildNotificationItem(context, n)),
                                      const SizedBox(height: 16),
                                    ],
                                    if (weekNotifications.isNotEmpty) ...[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                        child: Text(
                                          'ESTA SEMANA',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                            letterSpacing: 1.2,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      ...weekNotifications.map((n) => _buildNotificationItem(context, n)),
                                    ],
                                    const SizedBox(height: 24),
                                    const Center(
                                      child: Text(
                                        'Eso es todo por ahora',
                                        style: TextStyle(color: Colors.grey, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, dynamic notification) {
    final theme = Theme.of(context);
    final isUnread = notification.readAt == null;

    IconData icon;
    Color iconColor;
    switch (notification.type) {
      case 'warning':
        icon = Icons.water_drop;
        iconColor = Colors.blue;
        break;
      case 'achievement':
        icon = Icons.emoji_events;
        iconColor = Colors.amber;
        break;
      case 'mission':
        icon = Icons.assignment;
        iconColor = theme.colorScheme.primary;
        break;
      case 'tip':
        icon = Icons.lightbulb;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.info;
        iconColor = Colors.grey;
    }

    // Splitting the notification title (mock title has 'Title: Body' format)
    final parts = notification.title.split(': ');
    final titleText = parts[0];
    final bodyText = parts.length > 1 ? parts[1] : '';

    return Container(
      color: isUnread ? theme.colorScheme.primary.withOpacity(0.04) : Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                titleText,
                style: TextStyle(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isUnread)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 6),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bodyText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                bodyText,
                style: TextStyle(
                  color: theme.colorScheme.onBackground.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              _formatTimeAgo(notification.sentAt),
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          Provider.of<NotificationsProvider>(context, listen: false).markAsRead(notification.id);
        },
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return 'Hace ${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return 'Hace ${diff.inHours}h';
    } else if (diff.inDays == 1) {
      return 'Ayer';
    } else {
      final weekday = date.weekday;
      switch (weekday) {
        case 1: return 'Lun';
        case 2: return 'Mar';
        case 3: return 'Mié';
        case 4: return 'Jue';
        case 5: return 'Vie';
        case 6: return 'Sáb';
        case 7: return 'Dom';
        default: return '${date.day}/${date.month}';
      }
    }
  }
}
