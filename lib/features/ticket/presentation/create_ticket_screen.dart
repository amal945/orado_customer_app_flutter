import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:orado_customer/features/ticket/presentation/widgets/custom_styled_textfield.dart';
import 'package:orado_customer/features/ticket/provider/ticket_provider.dart';
import 'package:provider/provider.dart';

import '../../../utilities/colors.dart';
import '../../../utilities/styles.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  static const String route = 'create-ticket-screen';

  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.baseColor,
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Create Ticket',
            style:
                AppStyles.getBoldTextStyle(fontSize: 16, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Consumer<TicketProvider>(builder: (context, provider, _) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: provider.formKey,
                autovalidateMode: provider.autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subject:',
                      style: AppStyles.getBoldTextStyle(
                          fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    CustomStyledTextField(
                      controller: provider.subjectController,
                      hint: 'Enter ticket subject',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Subject cannot be empty';
                        }
                        return null;
                      },
                      maxLength: 100,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Priority:',
                      style: AppStyles.getBoldTextStyle(
                          fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    _buildPriorityDropdown(),
                    const SizedBox(height: 16),
                    Text(
                      'Message:',
                      style: AppStyles.getBoldTextStyle(
                          fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    CustomStyledTextField(
                      controller: provider.messageController,
                      hint: 'Describe your issue in detail...',
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Message cannot be empty';
                        }
                        return null;
                      },
                      maxLines: 6,
                      maxLength: 1000,
                      textInputAction: TextInputAction.newline,
                      onChanged: (_) {},
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                final isValid =
                                    provider.formKey.currentState?.validate() ??
                                        false;
                                if (!isValid) {
                                  setState(() {
                                    provider.autoValidate = true;
                                  });
                                  return;
                                }
                                // ensure priority is passed into the ticket creation logic;
                                provider.submitTicket(
                                  context,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.baseColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: provider.isLoading
                            ? LoadingAnimationWidget.progressiveDots(
                                color: Colors.white, size: 30)
                            : Text(
                                'Submit Ticket',
                                style: AppStyles.getBoldTextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  Widget _buildPriorityDropdown() {
    return Consumer<TicketProvider>(builder: (context, provider, _) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.baseColor.withOpacity(0.7), width: 1.5),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: provider.selectedPriority,
            isExpanded: true,
            items: provider.priorities.map((p) {
              return DropdownMenuItem<String>(
                value: p,
                child: Text(
                  p,
                  style: AppStyles.getBoldTextStyle(
                      fontSize: 14, color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                provider.changePriority(val);
              }
            },
            dropdownColor: Colors.white,
            icon: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
      );
    });
  }
}
