import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';

class EventCreateScreen extends StatefulWidget {
  final GroupModel group;

  const EventCreateScreen({super.key, required this.group});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _eventController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  String _selectedTimeSlot = 'Morning';
  String _selectedPaymentMode = 'Cash';

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields.')),
      );
      return;
    }

    final newEvent = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _eventController.text.trim(),
      datetime: _selectedDate!.add(
        _selectedTimeSlot == 'Morning'
            ? const Duration(hours: 8)
            : _selectedTimeSlot == 'Evening'
                ? const Duration(hours: 17)
                : const Duration(hours: 12),
      ),
      imageUrl: null, // Not supported in this mock flow
    );

    widget.group.events.add(newEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created successfully')),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _eventController,
                decoration: const InputDecoration(labelText: 'Event'),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'No date selected'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                decoration: const InputDecoration(labelText: 'Time Slot'),
                items: const [
                  DropdownMenuItem(value: 'Morning', child: Text('Morning: 6AM–2PM')),
                  DropdownMenuItem(value: 'Evening', child: Text('Evening: 4PM–10PM')),
                  DropdownMenuItem(value: 'Full Day', child: Text('Full Day')),
                ],
                onChanged: (val) =>
                    setState(() => _selectedTimeSlot = val ?? 'Morning'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedPaymentMode,
                decoration: const InputDecoration(labelText: 'Payment Mode'),
                items: const [
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                  DropdownMenuItem(value: 'Check', child: Text('Check')),
                  DropdownMenuItem(value: 'Online', child: Text('Online')),
                ],
                onChanged: (val) =>
                    setState(() => _selectedPaymentMode = val ?? 'Cash'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Create'),
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
