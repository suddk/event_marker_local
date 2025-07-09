import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class CalendarViewScreen extends StatelessWidget {
  final GroupModel group;

  const CalendarViewScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final List<EventModel> sortedEvents = [...group.events]
      ..sort((a, b) => a.datetime.compareTo(b.datetime));

    return Scaffold(
      appBar: AppBar(
        title: Text('${group.name} Calendar'),
      ),
      body: sortedEvents.isEmpty
          ? const Center(child: Text('No events to show.'))
          : ListView.builder(
              itemCount: sortedEvents.length,
              itemBuilder: (context, index) {
                final event = sortedEvents[index];
                return ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(event.title),
                  subtitle: Text(
                    DateFormat('EEEE, MMM d yyyy – hh:mm a')
                        .format(event.datetime),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
    );
  }
}
