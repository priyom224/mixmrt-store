import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/ticket/controllers/ticket_controller.dart';
import 'package:intl/intl.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class TicketDetails extends StatefulWidget {
  final int ticketId;
  const TicketDetails({required this.ticketId, super.key});

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  @override
  void initState() {
    super.initState();
    Get.find<TicketController>().getTicketDetails(widget.ticketId);
  }

  String _formatDate(String dateStr) {
    final dateTime = DateTime.parse(dateStr);
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Ticket Details'),
      body: GetBuilder<ProfileController>(builder: (profileController) {
          return GetBuilder<TicketController>(builder: (ticketController) {
            var ticket = ticketController.ticketDetailsModel;
            return ticket != null ? SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                image: profileController.profileModel?.imageFullUrl ?? "",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "${profileController.profileModel?.fName ?? ""} ${profileController.profileModel?.lName ?? ""}",
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Created At: ${_formatDate(ticket.createdAt ?? "")}", style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 15),

                            const Text('Subject :', style: robotoBold),
                            Text(ticket.subject ?? "-", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
                            const SizedBox(height: 15),

                            const Text('Message :', style: robotoBold),
                            HtmlWidget(ticket.message ?? "-", textStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor)),
                            const SizedBox(height: 15),

                            const Text('Attachments :', style: robotoBold),
                            const SizedBox(height: 10),

                            ticket.filesUrl != null && ticket.filesUrl!.isNotEmpty ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CustomImageWidget(
                                      image: ticket.filesUrl?[index] ?? "",
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ) : Text("No attachments available", style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).colorScheme.error)),

                          ],
                        ),
                      ),

                    ]),
                  ),
                  const Divider(height: 30),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).disabledColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Admin",
                                  style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Response:", style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),

                              ticket.adminResponseMsg != null && ticket.adminResponseMsg!.isNotEmpty ? HtmlWidget(
                                ticket.adminResponseMsg!,
                                textStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                              ) : const Text("No response yet.", style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            )
                : const Center(child: CircularProgressIndicator());
          });
        }
      ),
    );
  }
}
