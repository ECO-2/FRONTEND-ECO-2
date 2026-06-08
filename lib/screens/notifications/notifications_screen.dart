import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_eco_2/providers/providers.dart';

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
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (notifProvider.unreadCount > 0)
            TextButton(
              onPressed: () {
                notifProvider.markAllAsRead();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todas las notificaciones marcadas como leídas.'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Marcar como leídas'),
            ),
        ],
      ),
      body: notifProvider.notifications.isEmpty
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
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
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
