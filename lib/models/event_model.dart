class EventModel {
  final String id;
  final String title;
  final String? group; // Optional, used in some cases
  final DateTime datetime;
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.datetime,
    this.group,
    this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      group: json['group'], // might be null
      imageUrl: json['imageUrl'],
      datetime: DateTime.tryParse(
            json['datetime'] ?? json['date'] ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'group': group,
      'datetime': datetime.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }
}
