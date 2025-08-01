import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:orado_customer/features/ticket/presentation/create_ticket_screen.dart';
import 'package:orado_customer/features/ticket/presentation/ticket_detail_screen.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/common/loading_widget.dart';
import 'package:orado_customer/utilities/styles.dart';

import '../provider/ticket_provider.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  static const String route = 'ticket-screen';

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final provider = context.read<TicketProvider>();
        await provider.getAllTicket();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.baseColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Tickets',
          style: AppStyles.getBoldTextStyle(fontSize: 16, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<TicketProvider>(builder: (context, provider, _) {
        if (provider.isLoading) {
          return BuildLoadingWidget(
              withCenter: true, color: AppColors.baseColor);
        } else if (provider.tickets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.support_agent_rounded, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  "You haven't raised any tickets",
                  style: AppStyles.getBoldTextStyle(
                      fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Filter Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Text('🔘 Filter: ',
                      style: AppStyles.getBoldTextStyle(
                          fontSize: 14, color: Colors.black87)),
                  const SizedBox(width: 4),
                  DropdownButton<String>(
                    value: provider.selectedFilter,
                    items: provider.filters.map((String filterLabel) {
                      return DropdownMenuItem<String>(
                        value: filterLabel,
                        child: Text(
                          filterLabel,
                          style: AppStyles.getBoldTextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        provider.changeFilter(newValue);
                      }
                    },
                  ),
                ],
              ),
            ),

            // Tickets List
            Expanded(
              child: ListView.builder(
                itemCount: provider.filteredTickets.length,
                itemBuilder: (context, index) {
                  final ticket = provider.filteredTickets[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Row(
                        children: [
                          Text(
                            '#${(ticket.sId ?? '').length > 4 ? ticket.sId!.substring(0, 4) : (ticket.sId ?? '')}',
                            style: AppStyles.getBoldTextStyle(
                                fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  provider.getStatusColors(ticket.status ?? ""),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              provider.getStatusLabel(ticket.status ?? ""),
                              style: AppStyles.getBoldTextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                provider
                                    .getPriorityIconData(ticket.priority ?? ""),
                                size: 18,
                                color: provider
                                    .getPriorityColor(ticket.priority ?? ""),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ticket.priority ?? "",
                                style: AppStyles.getBoldTextStyle(
                                  fontSize: 12,
                                  color: provider
                                      .getPriorityColor(ticket.priority ?? ""),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Subject: "${ticket.subject}"',
                            style: AppStyles.getBoldTextStyle(
                                fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Created: ${provider.formatDate(ticket.createdAt)}',
                            style: AppStyles.getBoldTextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () {
                        context.pushNamed(TicketDetailScreen.route,
                            extra: ticket.sId);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(CreateTicketScreen.route);
        },
        icon: const Icon(Icons.add),
        label: Text(
          'Ticket',
          style: AppStyles.getBoldTextStyle(fontSize: 14, color: Colors.white),
        ),
        backgroundColor: AppColors.baseColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
