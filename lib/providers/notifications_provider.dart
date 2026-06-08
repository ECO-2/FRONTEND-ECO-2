import 'package:flutter/material.dart';
import 'package:frontend_eco_2/models/models.dart';

class NotificationsProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: 'n1',
      userId: 'mock-id-123',
      type: 'warning',
      title: 'Riego urgente — Mi Monstera: Lleva 8 días sin riego. Riégala hoy.',
      sentAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'n2',
      userId: 'mock-id-123',
      type: 'achievement',
      title: "¡Logro desbloqueado!: Completaste 'Jardín Saludable' (+30 semillas)",
      sentAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    NotificationModel(
      id: 'n3',
      userId: 'mock-id-123',
      type: 'mission',
      title: 'Misión: Jardín Urbano: 2 de 5 plantas registradas. ¡Sigue así!',
      sentAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    NotificationModel(
      id: 'n4',
      userId: 'mock-id-123',
      type: 'info',
      title: 'Nueva planta agregada: Agregaste Pothos a tu colección.',
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      id: 'n5',
      userId: 'mock-id-123',
      type: 'tip',
      title: 'Consejo del día: La Monstera prefiere luz indirecta brillante.',
      sentAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      id: 'n6',
      userId: 'mock-id-123',
      type: 'info',
      title: '240 semillas acumuladas: Sigue cuidando tus plantas para ganar más.',
      sentAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<NotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => n.readAt == null).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && _notifications[index].readAt == null) {
      _notifications[index] = _notifications[index].copyWith(readAt: DateTime.now());
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      if (_notifications[i].readAt == null) {
        _notifications[i] = _notifications[i].copyWith(readAt: DateTime.now());
      }
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
