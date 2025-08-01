import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/common/loading_widget.dart';
import '../../../utilities/styles.dart';
import '../model/reply_model.dart';
import '../model/ticket_detail_model.dart';
import '../provider/ticket_provider.dart';

/// UI model for reply (derived from backend Replies)

/// Helpers to adapt backend responses into UI-friendly formats:

/// Convenient wrapper for styled text
TextStyle boldStyle(double size, Color color) =>
    AppStyles.getBoldTextStyle(fontSize: size, color: color);

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  static const String route = 'ticket-detail-screen';

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<TicketProvider>()
            .getTicketDetails(ticketId: widget.ticketId);
      }
    });
  }

  Widget buildSubjectCard(String subject, String message) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subject: "$subject"',
                style: boldStyle(20, Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Initial Message:',
                style: boldStyle(14, Colors.grey.shade800),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyBubble(Reply reply) {
    final provider = context.read<TicketProvider>();
    final isAdmin = reply.isAdmin;
    final alignment =
        isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final bgColor = isAdmin ? Colors.grey.shade100 : const Color(0xFFFFF1EF);
    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isAdmin ? 4 : 16),
      bottomRight: Radius.circular(isAdmin ? 16 : 4),
    );
    final avatar = CircleAvatar(
      radius: 14,
      backgroundColor: isAdmin ? Colors.blue.shade100 : Colors.green.shade100,
      child: Icon(
        isAdmin ? Icons.support_agent_rounded : Icons.person,
        size: 16,
        color: isAdmin ? Colors.blue : Colors.green,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAdmin) avatar,
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Column(
                crossAxisAlignment:
                    isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    reply.message,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        provider.formatDateTime(reply.timestamp),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!isAdmin) const SizedBox(width: 8),
          if (!isAdmin)
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.green.shade100,
              child: const Icon(
                Icons.person,
                size: 16,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.baseColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: Text(
          'Ticket #${widget.ticketId}',
          style: boldStyle(16, Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<TicketProvider>(builder: (context, provider, _) {
        if (provider.isLoading) {
          return BuildLoadingWidget(
              withCenter: true, color: AppColors.baseColor);
        }

        final data = provider.ticketDetails;
        if (data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.support_agent_rounded,
                      size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "Couldn't fetch ticket detail",
                    style: boldStyle(20, Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.baseColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      provider.getTicketDetails(ticketId: widget.ticketId);
                    },
                    child: Text(
                      "Retry",
                      style: boldStyle(16, Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final displayStatus = provider.normalizeStatus(data.status);
        final displayPriority = provider.normalizePriority(data.priority);
        final displayReplies =
            (data.replies ?? []).map(provider.mapBackendReply).toList();

        return SafeArea(
          child: Column(
            children: [
              // Top info: status & priority
              Container(
                width: double.infinity,
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: provider.getStatusColors(displayStatus),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        provider.getStatusLabel(displayStatus),
                        style: boldStyle(12, Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: provider.getPriorityColor(displayPriority)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            provider.getPriorityIconData(displayPriority),
                            size: 16,
                            color: provider.getPriorityColor(displayPriority),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            displayPriority,
                            style: boldStyle(
                                12, provider.getPriorityColor(displayPriority)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSubjectCard(data.subject ?? '', data.message ?? ''),
                      if (displayReplies.isNotEmpty) ...[
                        const Text(
                          ' Replies',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                      ] else ...[
                        const Text(
                          'No replies yet',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                      ],
                      ...displayReplies.map((r) => _buildReplyBubble(r)),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              // Reply input area
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: provider.replyController,
                      focusNode: provider.replyFocus,
                      maxLines: null,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Add a Message to this Ticket',
                        hintStyle: AppStyles.getBoldTextStyle(
                            fontSize: 14, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () {
                                provider.sendTicketReply(
                                    context: context,
                                    ticketId: widget.ticketId);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.baseColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: provider.isLoading
                            ? LoadingAnimationWidget.progressiveDots(
                                color: Colors.white, size: 30)
                            : Text(
                                'Send Reply',
                                style: boldStyle(16, Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
