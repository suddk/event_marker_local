import 'package:flutter/material.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventCreateScreen extends StatefulWidget {
  final GroupModel group;

  const EventCreateScreen({super.key, required this.group});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _titleController = TextEditingController();
  DateTime? _selectedDateTime;
  bool _isSubmitting = false;

  void _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submitEvent() {
    if (_titleController.text.trim().isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final newEvent = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      datetime: _selectedDateTime!,
      imageUrl: null,
    );

    widget.group.events.add(newEvent);

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pop(context, true); // pop with result = true
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  _selectedDateTime == null
                      ? 'No date selected'
                      : DateFormat('yyyy-MM-dd hh:mm a').format(_selectedDateTime!),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickDateTime,
                  child: const Text('Pick Date & Time'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Add Event'),
                    onPressed: _submitEvent,
                  ),
          ],
        ),
      ),
    );
  }
}
