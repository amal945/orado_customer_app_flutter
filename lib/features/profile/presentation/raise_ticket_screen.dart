import 'package:flutter/material.dart';

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
      initialMessage: 'My order was supposed to be delivered yesterday but I haven\'t received it yet.',
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
                Text('🔘 Filter: ', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: ticket.status == 'Open' ? Colors.green :
                            ticket.status == 'In Progress' ? Colors.blue : Colors.grey,
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
                          builder: (context) => TicketDetailScreen(ticket: ticket),
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

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  TicketDetailScreen({required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final TextEditingController _replyController = TextEditingController();
  late List<Reply> replies;
  String selectedStatus = 'Open';
  String selectedPriority = 'Medium';

  List<String> statusOptions = ['Open', 'In Progress', 'Resolved'];
  List<String> priorityOptions = ['Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    replies = List.from(widget.ticket.replies);
    selectedStatus = widget.ticket.status;
    selectedPriority = widget.ticket.priority;
  }

  String formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _addReply() {
    if (_replyController.text.trim().isNotEmpty) {
      setState(() {
        replies.add(Reply(
          sender: 'You',
          message: _replyController.text.trim(),
          timestamp: DateTime.now(),
        ));
        _replyController.clear();
      });
    }
  }

  void _closeTicket() {
    setState(() {
      selectedStatus = 'Resolved';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket has been closed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.build, size: 20),
            SizedBox(width: 8),
            Text('Ticket #${widget.ticket.id}'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Status and Priority Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Text('Status: '),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: statusOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedStatus = newValue!;
                    });
                  },
                ),
                SizedBox(width: 20),
                Text('Priority: '),
                DropdownButton<String>(
                  value: selectedPriority,
                  items: priorityOptions.map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject and Initial Message
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Subject: "${widget.ticket.subject}"',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Initial Message:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 4),
                          Text(widget.ticket.initialMessage),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Replies Section
                  Text(
                    '🗨️ Replies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  ...replies.map((reply) => Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                reply.isAdmin ? '🛡 ${reply.sender}' : '👤 ${reply.sender}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: reply.isAdmin ? Colors.blue : Colors.green,
                                ),
                              ),
                              Spacer(),
                              Text(
                                formatDateTime(reply.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(reply.message),
                        ],
                      ),
                    ),
                  )).toList(),

                  SizedBox(height: 16),

                  // Add Reply Section
                  Text(
                    '✏️ Add a Reply',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _replyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type your reply here...',
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addReply,
                      child: Text('Send Reply'),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedStatus != 'Resolved' ? _closeTicket : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text('Close Ticket'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: Text('Back'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateTicketScreen extends StatefulWidget {
  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _submitTicket() {
    if (_subjectController.text.trim().isNotEmpty &&
        _messageController.text.trim().isNotEmpty) {
      // Here you would typically save the ticket to a database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket created successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.add_circle, size: 20),
            SizedBox(width: 8),
            Text('Create Ticket'),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subject:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter ticket subject',
              ),
            ),

            SizedBox(height: 16),

            Text(
              'Message:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 6,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe your issue in detail...',
              ),
            ),

            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTicket,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Submit Ticket',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}