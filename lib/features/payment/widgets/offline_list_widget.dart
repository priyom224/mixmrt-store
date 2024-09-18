import 'package:get/get.dart';
import 'package:sixam_mart_store/features/store/domain/models/offline_list_model.dart';
import 'package:sixam_mart_store/helper/date_converter_helper.dart';
import 'package:sixam_mart_store/helper/price_converter_helper.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';
import 'package:flutter/material.dart';

class OfflineListWidget extends StatelessWidget {
  final OfflineListModel offlineListModel;
  final bool showDivider;
  const OfflineListWidget({super.key, required this.offlineListModel, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
        child: Row(children: [

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(PriceConverterHelper.convertPrice(offlineListModel.amount), style: robotoMedium),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text('${'payment_method'.tr} ${offlineListModel.paymentInfo?.methodName}', style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor,
            )),
          ])),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

            Text(
              DateConverterHelper.formatDateTime(offlineListModel.createdAt!),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(offlineListModel.status!.tr, style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: offlineListModel.status == 'verified' ? Theme.of(context).primaryColor : offlineListModel.status == 'denied'
                  ? Theme.of(context).colorScheme.error : Colors.blue,
            )),

          ]),

        ]),
      ),

      Divider(color: showDivider ? Theme.of(context).disabledColor : Colors.transparent),

    ]);
  }
}
