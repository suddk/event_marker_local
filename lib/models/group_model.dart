import 'event_model.dart';

class GroupModel {
  final String id;
  final String name;
  final List<String> members;
  final List<EventModel> events;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.events,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      events: (json['events'] as List<dynamic>? ?? [])
          .map((e) => EventModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'members': members,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
