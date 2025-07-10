import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/group_model.dart';
import '../models/event_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EventCreateScreen extends StatefulWidget {
  final GroupModel group;
  final EventModel? existingEvent;

  const EventCreateScreen({super.key, required this.group, this.existingEvent,});

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

  @override
  void initState() {
    super.initState();

    final event = widget.existingEvent;
    if (event != null) {
      _nameController.text = event.title; // Assuming title is reused
      _eventController.text = event.title;
      _amountController.text = event.amount?.toString() ?? '';
      _selectedDate = event.datetime;
      _selectedTimeSlot = _determineTimeSlot(event.datetime);
      _selectedPaymentMode = event.paymentMode ?? 'Cash';
    }
  }

  String _determineTimeSlot(DateTime dt) {
    final hour = dt.hour;
    if (hour >= 6 && hour < 14) return 'Morning';
    if (hour >= 16 && hour < 22) return 'Evening';
    return 'Full Day';
  }

  File? _voucherImage;
  final ImagePicker _picker = ImagePicker();

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

  void _pickVoucherImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _voucherImage = File(pickedFile.path));
    }
  }

  Widget _voucherPreview() {
    if (_voucherImage != null) {
      return Image.file(
        _voucherImage!,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    return const Text('No image selected.');
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
      imageUrl: _voucherImage?.path,
      amount: _amountController.text.trim().isEmpty
          ? null
          : double.tryParse(_amountController.text.trim()),
      paymentMode: _selectedPaymentMode,
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
                // No validator — now optional
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
              const Text('Upload Voucher (optional):'),
              const SizedBox(height: 8),
              _voucherPreview(),
              TextButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text('Select Image'),
                onPressed: _pickVoucherImage,
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
