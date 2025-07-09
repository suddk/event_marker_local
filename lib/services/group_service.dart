import 'dart:convert';
import 'package:flutter/services.dart';

class GroupService {
  /// Load mock group + event data from local JSON
  Future<List<dynamic>> loadGroups() async {
    final String groupJson = await rootBundle.loadString('assets/groups.json');
    return json.decode(groupJson);
  }
}
