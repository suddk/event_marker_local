import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import 'group_members_screen.dart';
import 'calendar_view_screen.dart';
import 'package:intl/intl.dart';
import 'event_create_screen.dart';

class EventListScreen extends StatelessWidget {
  final GroupModel group;

  const EventListScreen({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final List<EventModel> events = group.events;

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            tooltip: 'View Members',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupMembersScreen(group: group),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Calendar View',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarViewScreen(group: group),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Event',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EventCreateScreen(group: group),
                ),
              );

              if (result == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event added (not saved).')),
                );
              }
            },
          ),
        ],
      ),
      body: events.isEmpty
          ? const Center(child: Text('No events in this group.'))
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(event.title),
                    subtitle: Text(
                      DateFormat('yyyy-MM-dd – hh:mm a')
                          .format(event.datetime),
                    ),
                    trailing: const Icon(Icons.event),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Event: ${event.title}')),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
