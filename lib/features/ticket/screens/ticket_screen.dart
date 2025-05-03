import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/features/ticket/controllers/ticket_controller.dart';
import 'package:sixam_mart_store/features/ticket/screens/create_ticket_screen.dart';
import 'package:sixam_mart_store/features/ticket/screens/ticket_details.dart';
import 'package:sixam_mart_store/helper/string_extensions.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<TicketController>().getTicketList('vendor');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Ticket'),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const CreateTicketScreen());
        },
        label: const Text('Create Ticket'),
      ),

      body: GetBuilder<TicketController>(builder: (ticketController) {
        return ticketController.ticketList != null ? ticketController.ticketList!.isNotEmpty ? ListView.builder(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          itemCount: ticketController.ticketList!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(() => TicketDetails(ticketId: ticketController.ticketList![index].id!));
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)],
                ),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Text('Ticket #${ticketController.ticketList![index].id}', style: robotoBold),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Text('${ticketController.ticketList![index].subject}', style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                    ]),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: ticketController.ticketList![index].status == 'pending' ? Colors.blue.withValues(alpha: 0.1) :
                      ticketController.ticketList![index].status == 'resolved' ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Text('${ticketController.ticketList![index].status?.toTitleCase()}', style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: ticketController.ticketList![index].status == 'pending' ? Colors.blue :
                      ticketController.ticketList![index].status == 'resolved' ? Colors.green : Colors.red),
                    ),
                  ),

                ]),
              ),
            );
            
          },
        ) : const Center(
          child: Text('No tickets available'),
        ) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
