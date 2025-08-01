import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/features/ticket/model/ticket_detail_model.dart';
import 'package:orado_customer/features/ticket/model/tickets_model.dart' hide Replies;
import 'package:orado_customer/services/ticket_services.dart';
import 'package:orado_customer/utilities/utilities.dart';

import '../model/reply_model.dart';

class TicketProvider extends ChangeNotifier {
  List<Ticket> tickets = [];

  TicketData? ticketDetails;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // display label -> internal value
  final Map<String, String> _displayToInternal = {
    'All': 'all',
    'Open': 'open',
    'In Progress': 'in_progress',
    'Resolved': 'resolved',
  };

  String selectedFilter = 'All'; // display label

  List<String> get filters => _displayToInternal.keys.toList();

  final formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String selectedPriority = 'Low';
  final List<String> priorities = ['Low', 'Medium', 'High'];

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final TextEditingController replyController = TextEditingController();
  final FocusNode replyFocus = FocusNode();

  void changeFilter(String value) {
    selectedFilter = value.trim();
    notifyListeners();
  }

  String normalizePriority(String? p) {
    if (p == null) return 'Low';
    switch (p.toLowerCase()) {
      case 'high':
        return 'High';
      case 'medium':
        return 'Medium';
      case 'low':
        return 'Low';
      default:
        return p;
    }
  }

  String formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day/$month/$year';
  }

  Reply mapBackendReply(Replies backend) {
    final isAdmin = (backend.sender ?? '').toLowerCase() == 'admin';
    DateTime timestamp;
    if (backend.createdAt != null) {
      timestamp = DateTime.tryParse(backend.createdAt!) ?? DateTime.now();
    } else {
      timestamp = DateTime.now();
    }
    return Reply(
      sender: backend.sender ?? '',
      message: backend.message ?? '',
      timestamp: timestamp,
      isAdmin: isAdmin,
    );
  }

  String normalizeStatus(String? s) {
    if (s == null) return 'Open';
    switch (s.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      default:
        return s;
    }
  }

  void changePriority(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'low':
        selectedPriority = 'Low';
        break;
      case 'medium':
        selectedPriority = 'Medium';
        break;
      case 'high':
        selectedPriority = 'High';
        break;
      default:
        return; // ignore unknown
    }
    notifyListeners();
  }

  Color getStatusColors(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in_progress':
        return Colors.amber;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      default:
        return status;
    }
  }

  List<Ticket> get filteredTickets {
    final internal = _displayToInternal[selectedFilter] ?? 'all';
    if (internal == 'all') return tickets;
    final result = tickets
        .where((ticket) =>
            (ticket.status ?? '').toLowerCase() == internal.toLowerCase())
        .toList();
    log('Filtering: "$selectedFilter" (internal="$internal"), matched ${result.length}/${tickets.length} tickets');
    return result;
  }

  IconData getPriorityIconData(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.access_time;
      case 'low':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
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

  String formatDate(String? dateStr) {
    try {
      if (dateStr != null) {
        final date = DateTime.parse(dateStr);
        final day = date.day.toString().padLeft(2, '0');
        final month = date.month.toString().padLeft(2, '0');
        final year = date.year;
        return '$day/$month/$year';
      } else {
        return dateStr ?? "N/A";
      }
    } catch (e) {
      return dateStr ?? "N/A";
    }
  }

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getAllTicket() async {
    putLoading(true);
    try {
      final response = await TicketServices.getAllTickets();
      if (response != null && response.data != null) {
        tickets = response.data ?? [];
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching tickets: $e");
    }
    putLoading(false);
  }

  Future<void> submitTicket(BuildContext context) async {
    try {
      putLoading(true);
      if (subjectController.text.trim().isNotEmpty &&
          messageController.text.trim().isNotEmpty) {
        final subject = subjectController.text.trim();
        final message = messageController.text.trim();

        final priority = selectedPriority.toLowerCase();

        final response = await TicketServices.raiseATicket(
            subject: subject, priority: priority, message: message);

        if (response != null && response.success == true) {
          showSnackBar(context,
              message: response.message ?? "Ticket Raised Successfully",
              backgroundColor: Colors.green);
          await getAllTicket();
          Navigator.pop(context);
          clearFields();
        }
      } else {
        putLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
      }
    } catch (e) {
      showSnackBar(context,
          message: "Failed to raise the ticket", backgroundColor: Colors.red);
    }

    putLoading(false);
  }

  Future<void> getTicketDetails({required String ticketId}) async {
    putLoading(true);
    try {
      final response =
          await TicketServices.getTicketDetails(ticketId: ticketId);

      if (response != null && response.data != null) {
        ticketDetails = response.data;
      }
    } catch (e) {
      log("$e");
    }
    putLoading(false);
  }

  Future<void> sendTicketReply({required BuildContext context, required String ticketId}) async {
    putLoading(true);
    if (replyController.text.trim().isEmpty) {
      showSnackBar(context,
          message: "Reply can't be empty", backgroundColor: Colors.red);
      putLoading(false);
      return;
    }
    try {
      final reply = replyController.text.trim();

      final response = await TicketServices.sendTicketReply(
          reply: reply, ticketId: ticketId);

      if (response != null) {
        getTicketDetails(ticketId: ticketId);
      }
    } catch (e) {
      log("$e");
      showSnackBar(context,
          message: "Failed to send", backgroundColor: Colors.red);
    }

    putLoading(false);
  }

  clearFields() {
    subjectController.text = "";
    messageController.text = "";
  }
}
