import '../models/user_model.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import '../models/notification_model.dart';
import 'mock_data_service.dart';

class DataService {
  final bool useMock;

  DataService({this.useMock = true});

  Future<List<UserModel>> loadUsers() async {
    if (useMock) return await MockDataService.loadUsers();
    // TODO: Replace with actual API call
    throw UnimplementedError('API not implemented yet');
  }

  Future<List<GroupModel>> loadGroups() async {
    if (useMock) return await MockDataService.loadGroups();
    // TODO: Replace with actual API call
    throw UnimplementedError('API not implemented yet');
  }

  Future<List<EventModel>> loadEvents() async {
    if (useMock) return await MockDataService.loadEvents();
    // TODO: Replace with actual API call
    throw UnimplementedError('API not implemented yet');
  }

  Future<List<NotificationModel>> loadNotifications() async {
    if (useMock) return await MockDataService.loadNotifications();
    // TODO: Replace with actual API call
    throw UnimplementedError('API not implemented yet');
  }

  Future<void> createEvent(EventModel event) async {
    if (useMock) {
      // For now, mock handles data only in memory
      print('[Mock] createEvent called with: ${event.toJson()}');
      return;
    }
    // TODO: Implement actual API call
    throw UnimplementedError('API not implemented yet');
  }

  Future<void> createUser(UserModel user) async {
    if (useMock) {
      print('[Mock] createUser called with: ${user.toJson()}');
      return;
    }
    // TODO: Implement actual API call
    throw UnimplementedError('API not implemented yet');
  }

  Future<void> deleteEvent(String eventId) async {
    if (useMock) {
      print('[Mock] deleteEvent called for ID: $eventId');
      return;
    }
    // TODO: Implement actual API call
    throw UnimplementedError('API not implemented yet');
  }

  // Add more methods as your backend grows...
}
