import 'package:flutter/material.dart';
import 'package:dignito/custom_colors.dart';

class EventsTextField extends StatelessWidget {
  final Map<String, String> events; // Change to Map<String, String>

  const EventsTextField({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // Create a list to hold event display strings
    List<String> eventDisplayList = [];

    // Loop through the events map and create display strings
    events.forEach((eventName, paymentStatus) {
      String status = paymentStatus.contains('NOT') ? 'Not Paid' : 'Paid';
      eventDisplayList.add('$eventName - $status');
    });

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2), // Black border
        borderRadius: BorderRadius.circular(15), // Rounded corners
        color: CustomColors.backgroundColor, // Background color
      ),
      padding: const EdgeInsets.all(16), // Padding around the content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floating label effect
          const SizedBox(height: 8),
          // Display events in a big text are
            Column(
              children: eventDisplayList.map((eventDisplay) {
                // Split the event name and status for color coding
                String eventName = eventDisplay.split(' - ')[0];
                String paymentStatus = eventDisplay.split(' - ')[1];

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon for each event
                    Icon(
                      paymentStatus == 'Paid' ? Icons.check_circle : Icons.cancel,
                      color: paymentStatus == 'Paid' ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8), // Space between icon and text
                    Expanded(
                      child: Text(
                        eventName.trim(), // Show event name
                        style: const TextStyle(color: Colors.black), // Event name color
                      ),
                    ),
                    
                    Text(
                      paymentStatus,
                      style: TextStyle(
                        color: paymentStatus == 'Paid' ? Colors.green : Colors.red, // Payment status color
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          
        ],
      ),
    );
  }
}
