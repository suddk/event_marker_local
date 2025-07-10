class EventModel {
  final String id;
  final String title;
  final DateTime datetime;
  final double? amount;           
  final String? paymentMode;      
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.datetime,
    this.amount,
    this.paymentMode,
    this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
  return EventModel(
    id: json['_id'] ?? json['id'] ?? '',// ← supports both for flexibility
    title: json['title'] ?? 'Untitled Event',
    datetime: DateTime.parse(
      json['datetime'] ?? json['date'] ?? DateTime.now().toIso8601String(),
    ),
    amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
    paymentMode: json['paymentMode'] ?? '',
    imageUrl: json['imageUrl'],
  );
}

Map<String, dynamic> toJson() {
  return {
    '_id': id, // ← use _id to mimic MongoDB
    'title': title,
    'datetime': datetime.toIso8601String(),
    'amount': amount,
    'paymentMode': paymentMode,
    'imageUrl': imageUrl,
  };
}

}
