import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import '../services/service_locator.dart';
import 'event_create_screen.dart';
import 'event_detail_screen.dart';
import 'group_members_screen.dart';
import 'calendar_view_screen.dart';

class EventListScreen extends StatefulWidget {
  final GroupModel group;

  const EventListScreen({super.key, required this.group});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    // Simulate fetch from backend or mock
    setState(() {
      events = widget.group.events;
    });
  }

  void _navigateToCreateEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventCreateScreen(group: widget.group),
      ),
    );

    if (result == true) {
      setState(() {
        events = widget.group.events;
      });
    }
  }

  void _navigateToEventDetails(EventModel event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(group: widget.group, event: event),
      ),
    );

    if (result == true) {
      setState(() {
        events = widget.group.events;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarViewScreen(events: events),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupMembersScreen(group: widget.group),
                ),
              );
            },
          ),
        ],
      ),
      body: events.isEmpty
          ? const Center(child: Text('No events found.'))
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final e = events[index];
                return ListTile(
                  title: Text(e.title),
                  subtitle: Text(DateFormat('yyyy-MM-dd hh:mm a').format(e.datetime)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _navigateToEventDetails(e),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateEvent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
