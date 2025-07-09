class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String? eventId;
  final DateTime timestamp;
  final bool read;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
    this.eventId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      eventId: json['eventId'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'eventId': eventId,
      'timestamp': timestamp.toIso8601String(),
      'read': read,
    };
  }
}
