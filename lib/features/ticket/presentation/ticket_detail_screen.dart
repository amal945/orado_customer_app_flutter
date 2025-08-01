import 'package:flutter/material.dart';

import 'raise_ticket_screen.dart';

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