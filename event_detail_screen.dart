import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/event.dart';
import '../database/database_helper.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event image with error handling
            Container(
              width: double.infinity,
              height: 200,
              child: Image.network(
                event.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.event,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                  );
                },
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              event.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            // Event details section
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20, color: Colors.blue),
                        SizedBox(width: 12),
                        Text(
                          '${event.date.day}/${event.date.month}/${event.date.year}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 20, color: Colors.blue),
                        SizedBox(width: 12),
                        Text(
                          event.time,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, size: 20, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Register button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  // Register for the event
                  try {
                    DatabaseHelper dbHelper = DatabaseHelper();
                    await dbHelper.insertEvent(event);
                    
                    // Show confirmation dialog with QR code
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Registration Successful!', 
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('You have successfully registered for:'),
                              SizedBox(height: 8),
                              Text(
                                event.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: QrImageView(
                                  data: 'EVENT-${event.id}-${DateTime.now().millisecondsSinceEpoch}',
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  errorStateBuilder: (cxt, err) {
                                    return Container(
                                      height: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.error_outline, color: Colors.red, size: 40),
                                            SizedBox(height: 8),
                                            Text(
                                              'Failed to generate QR code',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Show this QR code at the event entrance',
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    // Show error message if registration fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to register for event: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Text('Register for Event'),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}