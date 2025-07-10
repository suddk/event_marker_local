import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../models/group_model.dart';
import 'event_create_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final GroupModel group;
  final EventModel event;

  const EventDetailScreen({
    super.key,
    required this.group,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
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
                        builder: (_) => EventCreateScreen(
                          group: group,
                          existingEvent: event,
                        ),
                      ),
                    );
                    if (result == true) Navigator.pop(context, true);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
