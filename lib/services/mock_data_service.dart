import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/user_model.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import '../models/notification_model.dart';

class MockDataService {
  static Future<List<UserModel>> loadUsers() async {
    final String jsonStr = await rootBundle.loadString('assets/users.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => UserModel.fromJson(e)).toList();
  }

  static Future<List<GroupModel>> loadGroups() async {
    final String jsonStr = await rootBundle.loadString('assets/groups.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => GroupModel.fromJson(e)).toList();
  }

  static Future<List<EventModel>> loadEvents() async {
    final String jsonStr = await rootBundle.loadString('assets/events.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => EventModel.fromJson(e)).toList();
  }

  static Future<List<NotificationModel>> loadNotifications() async {
    final String jsonStr =
        await rootBundle.loadString('assets/notifications.json');
    final List<dynamic> data = json.decode(jsonStr);
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
