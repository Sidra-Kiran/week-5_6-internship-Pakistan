import 'package:flutter/material.dart';
import '../models/event.dart';
import '../database/database_helper.dart';

class RegisteredEventsScreen extends StatefulWidget {
  @override
  _RegisteredEventsScreenState createState() => _RegisteredEventsScreenState();
}

class _RegisteredEventsScreenState extends State<RegisteredEventsScreen> {
  List<Event> registeredEvents = [];

  @override
  void initState() {
    super.initState();
    _loadRegisteredEvents();
  }

  void _loadRegisteredEvents() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<Event> events = await dbHelper.getEvents();
    setState(() {
      registeredEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Registered Events'),
      ),
      body: registeredEvents.isEmpty
          ? Center(
              child: Text(
                'No events registered yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: registeredEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: registeredEvents[index]);
              },
            ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Image.network(
          event.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(
          event.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(event.description),
            SizedBox(height: 8),
            Text('${event.date.day}/${event.date.month}/${event.date.year} • ${event.location}'),
          ],
        ),
      ),
    );
  }
}
