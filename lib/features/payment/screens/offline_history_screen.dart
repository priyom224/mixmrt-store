
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/features/payment/controllers/payment_controller.dart';
import 'package:sixam_mart_store/features/payment/widgets/offline_list_widget.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfflineHistoryScreen extends StatefulWidget {
  final bool fromNotification;
  const OfflineHistoryScreen({Key? key, required this.fromNotification}) : super(key: key);

  @override
  State<OfflineHistoryScreen> createState() => _OfflineHistoryScreenState();
}

class _OfflineHistoryScreenState extends State<OfflineHistoryScreen> {

  @override
  void initState() {
    super.initState();
    Get.find<PaymentController>().getOfflineList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(widget.fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
          return true;
        } else {
          Get.back();
          return true;
        }
      },
      child: Scaffold(

        appBar: CustomAppBarWidget(title: 'offline_history'.tr, menuWidget: PopupMenuButton(
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              getMenuItem(Get.find<PaymentController>().offlineStatusList[0], context),
              const PopupMenuDivider(),
              getMenuItem(Get.find<PaymentController>().offlineStatusList[1], context),
              const PopupMenuDivider(),
              getMenuItem(Get.find<PaymentController>().offlineStatusList[2], context),
              const PopupMenuDivider(),
              getMenuItem(Get.find<PaymentController>().offlineStatusList[3], context),
            ];
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          offset: const Offset(-25, 25),
          child: Container(
            width: 40, height: 40,
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: const Icon(Icons.arrow_drop_down, size: 30),
          ),
          onSelected: (dynamic value) {
            int index = Get.find<PaymentController>().offlineStatusList.indexOf(value);
            Get.find<PaymentController>().filterOfflineList(index);
          },
        )),

        body: GetBuilder<PaymentController>(builder: (paymentController) {
          return paymentController.offlineList!.isNotEmpty ? ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: paymentController.offlineList!.length,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            itemBuilder: (context, index) {
              return OfflineListWidget(
                offlineListModel: paymentController.offlineList![index],
                showDivider: index != paymentController.offlineList!.length - 1,
              );
            },
          ) : Center(child: Text('no_history_found'.tr));
        }),

      ),
    );
  }

  PopupMenuItem getMenuItem(String status, BuildContext context) {
    return PopupMenuItem(
      value: status,
      height: 30,
      child: Text(status.toLowerCase().tr, style: robotoRegular.copyWith(
        color: status == 'Pending' ? Theme.of(context).primaryColor : status == 'Approved' ? Colors.green
            : status == 'Denied' ? Colors.red : null,
      )),
    );
  }
}
