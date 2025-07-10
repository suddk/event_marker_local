import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import 'calendar_view_screen.dart';
import 'group_members_screen.dart';
import 'event_create_screen.dart';
import 'event_detail_screen.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatefulWidget {
  final GroupModel group;

  const EventListScreen({super.key, required this.group});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  String searchQuery = '';
  DateTime? selectedDate;

  void _pickDateFilter() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = widget.group.events.where((e) {
      final matchName =
          e.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchDate = selectedDate == null
          ? true
          : DateFormat('yyyy-MM-dd').format(e.datetime) ==
              DateFormat('yyyy-MM-dd').format(selectedDate!);
      return matchName && matchDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.group.name} Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Calendar View',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarViewScreen(group: widget.group),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.group),
            tooltip: 'Group Members',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GroupMembersScreen(group: widget.group),
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
                  builder: (_) => EventCreateScreen(group: widget.group),
                ),
              );
              if (result == true) setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() => searchQuery = val),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.date_range),
                  tooltip: 'Filter by Date',
                  onPressed: _pickDateFilter,
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear Filters',
                    onPressed: _clearFilters,
                  ),
              ],
            ),
          ),
          Expanded(
            child: events.isEmpty
                ? const Center(child: Text('No events found.'))
                : ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final e = events[index];
                      return ListTile(
                        title: Text(e.title),
                        subtitle: Text(DateFormat('yyyy-MM-dd hh:mm a').format(e.datetime)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailScreen(group: widget.group, event: e),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
