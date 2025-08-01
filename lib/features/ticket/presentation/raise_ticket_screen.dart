import 'package:flutter/material.dart';
import 'package:orado_customer/features/ticket/presentation/ticket_detail_screen.dart';

import 'create_ticket_screen.dart';

class Ticket {
  final String id;
  final String subject;
  final String status;
  final String priority;
  final DateTime createdDate;
  final String initialMessage;
  final List<Reply> replies;

  Ticket({
    required this.id,
    required this.subject,
    required this.status,
    required this.priority,
    required this.createdDate,
    required this.initialMessage,
    this.replies = const [],
  });
}

class Reply {
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isAdmin;

  Reply({
    required this.sender,
    required this.message,
    required this.timestamp,
    this.isAdmin = false,
  });
}

class TicketListScreen extends StatefulWidget {
  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  String selectedFilter = 'All';
  List<String> filters = ['All', 'Open', 'In Progress', 'Resolved'];

  List<Ticket> tickets = [
    Ticket(
      id: '1234',
      subject: 'Payment not reflected',
      status: 'Open',
      priority: 'Medium',
      createdDate: DateTime(2025, 7, 28),
      initialMessage: 'I paid for the order but it still shows pending.',
      replies: [
        Reply(
          sender: 'You',
          message: 'Payment made via UPI at 3 PM.',
          timestamp: DateTime(2025, 7, 28),
        ),
        Reply(
          sender: 'Admin',
          message: 'Please wait 24 hours; it\'s under process.',
          timestamp: DateTime(2025, 7, 29),
          isAdmin: true,
        ),
      ],
    ),
    Ticket(
      id: '1235',
      subject: 'Order not delivered',
      status: 'Resolved',
      priority: 'High',
      createdDate: DateTime(2025, 7, 25),
      initialMessage:
          'My order was supposed to be delivered yesterday but I haven\'t received it yet.',
    ),
  ];

  List<Ticket> get filteredTickets {
    if (selectedFilter == 'All') return tickets;
    return tickets.where((ticket) => ticket.status == selectedFilter).toList();
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return '⚠';
      case 'medium':
        return '⏰';
      case 'low':
        return '🔵';
      default:
        return '⚪';
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.build, size: 20),
            SizedBox(width: 8),
            Text('Support Tickets'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Text('🔘 Filter: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: filters.map((String filter) {
                    return DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Tickets List
          Expanded(
            child: ListView.builder(
              itemCount: filteredTickets.length,
              itemBuilder: (context, index) {
                final ticket = filteredTickets[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text('#${ticket.id}'),
                        SizedBox(width: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: ticket.status == 'Open'
                                ? Colors.green
                                : ticket.status == 'In Progress'
                                    ? Colors.blue
                                    : Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            ticket.status,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${getPriorityIcon(ticket.priority)} ${ticket.priority}',
                          style: TextStyle(
                            color: getPriorityColor(ticket.priority),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Subject: "${ticket.subject}"',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text('Created: ${formatDate(ticket.createdDate)}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketDetailScreen(ticket: ticket),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          // Create New Ticket Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTicketScreen()),
                );
              },
              icon: Icon(Icons.add),
              label: Text('Create New Ticket'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
