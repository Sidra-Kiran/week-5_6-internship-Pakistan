import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/event.dart';
import 'event_detail_screen.dart';
import 'registered_events_screen.dart';
import '../database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = [];
  List<Event> filteredEvents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    // Dummy data for events
    setState(() {
      events = [
        Event(
          id: 1,
          title: 'Tech Conference 2024',
          description: 'Annual technology conference with speakers from top tech companies.',
          date: DateTime(2024, 10, 15),
          time: '9:00 AM - 5:00 PM',
          location: 'Convention Center, New York',
          imageUrl: 'https://picsum.photos/300/200?random=1',
        ),
        Event(
          id: 2,
          title: 'Music Festival',
          description: 'Weekend music festival featuring popular artists and local bands.',
          date: DateTime(2024, 11, 20),
          time: '12:00 PM - 10:00 PM',
          location: 'Central Park, New York',
          imageUrl: 'https://picsum.photos/300/200?random=2',
        ),
        Event(
          id: 3,
          title: 'Startup Workshop',
          description: 'Learn how to launch your startup from industry experts.',
          date: DateTime(2024, 9, 30),
          time: '10:00 AM - 4:00 PM',
          location: 'Business Hub, Brooklyn',
          imageUrl: 'https://picsum.photos/300/200?random=3',
        ),
        Event(
          id: 4,
          title: 'Art Exhibition',
          description: 'Contemporary art exhibition featuring emerging artists.',
          date: DateTime(2024, 10, 5),
          time: '11:00 AM - 7:00 PM',
          location: 'Modern Art Museum, Manhattan',
          imageUrl: 'https://picsum.photos/300/200?random=4',
        ),
      ];
      filteredEvents = events;
    });
  }

  void _filterEvents(String query) {
    setState(() {
      filteredEvents = events.where((event) {
        return event.title.toLowerCase().contains(query.toLowerCase()) ||
            event.description.toLowerCase().contains(query.toLowerCase()) ||
            event.location.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.pushNamed(context, '/registered');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: _filterEvents,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                return EventCard(event: filteredEvents[index]);
              },
            ),
          ),
        ],
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
        leading:
        Image.network(
  event.imageUrl,
  width: 60,
  height: 60,
  fit: BoxFit.cover,
  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
    return Icon(Icons.error, size: 60);
  },
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
      ),
    );
  }
}