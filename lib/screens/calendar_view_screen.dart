import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';

class CalendarViewScreen extends StatefulWidget {
  final List<EventModel> events;

  const CalendarViewScreen({super.key, required this.events});

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  DateTime? _selectedDate;

  List<EventModel> get _filteredEvents {
    if (_selectedDate == null) return widget.events;
    return widget.events.where((e) {
      return e.datetime.year == _selectedDate!.year &&
             e.datetime.month == _selectedDate!.month &&
             e.datetime.day == _selectedDate!.day;
    }).toList();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEvents..sort((a, b) => a.datetime.compareTo(b.datetime));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            tooltip: 'Select Date',
            onPressed: _pickDate,
          ),
        ],
      ),
      body: filtered.isEmpty
          ? const Center(child: Text('No events found for this date.'))
          : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final event = filtered[index];
                return ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(event.title),
                  subtitle: Text(DateFormat('EEE, MMM d, yyyy – hh:mm a').format(event.datetime)),
                );
              },
            ),
    );
  }
}
