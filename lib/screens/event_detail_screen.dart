import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../models/group_model.dart';
import '../models/user_model.dart';
import '../services/session_service.dart';
import 'event_create_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final GroupModel group;
  final EventModel event;

  const EventDetailScreen({
    super.key,
    required this.group,
    required this.event,
  });

  bool _canDeleteEvent(UserModel user) {
    if (user.isAdmin) return true;
    final now = DateTime.now();
    final diff = event.datetime.difference(now);
    return diff.inHours >= 2;
  }

  void _deleteEvent(BuildContext context) {
    group.events.removeWhere((e) => e.id == event.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event deleted')),
    );
    Navigator.pop(context, true);
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              group.events.removeWhere((e) => e.id == event.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Go back and refresh list
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final UserModel? user = SessionService.loggedInUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event: ${event.title}',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(event.datetime)}'),
            Text('Time: ${DateFormat('hh:mm a').format(event.datetime)}'),
            const SizedBox(height: 12),
            if (event.amount != null) Text('Amount: ₹${event.amount}'),
            if (event.paymentMode != null)
              Text('Payment: ${event.paymentMode}'),
            if (event.imageUrl != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text('Voucher:'),
                  const SizedBox(height: 6),
                  Image.network(
                    event.imageUrl!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Text("Image couldn't load."),
                  ),
                ],
              ),
            const Spacer(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventCreateScreen(group: group, existingEvent: event),
                        ),
                      );
                      if (result == true) Navigator.pop(context, true);
                    },
                  ),
                  if (SessionService.isAdmin ||
                      DateTime.now().isBefore(event.datetime.subtract(const Duration(hours: 2))))
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        _confirmDelete(context);
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
