// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
// import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
// import 'package:sixam_mart_store/common/widgets/text_field_widget.dart';
// import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
// import 'package:sixam_mart_store/util/dimensions.dart';
// import 'package:sixam_mart_store/util/styles.dart';
//
//
// class ThirdPartyDialogue extends StatefulWidget {
//   final int? orderId;
//   final String? companyName;
//   final String? trackingUrl;
//   final String? serialNumber;
//   const ThirdPartyDialogue({super.key,required this.orderId, this.companyName, this.trackingUrl, this.serialNumber});
//
//   @override
//   State<ThirdPartyDialogue> createState() => _ThirdPartyDialogueState();
// }
//
// class _ThirdPartyDialogueState extends State<ThirdPartyDialogue> {
//   final TextEditingController orderIdController = TextEditingController();
//   final TextEditingController companyController = TextEditingController();
//   final TextEditingController trackingController = TextEditingController();
//   final TextEditingController serialController = TextEditingController();
//   final FocusNode orderNode = FocusNode();
//   final FocusNode companyNode = FocusNode();
//   final FocusNode trackingNode = FocusNode();
//   final FocusNode serialNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     orderIdController.text = widget.orderId.toString();
//     companyController.text =  widget.companyName != null ?  widget.companyName.toString() : '' ;
//     trackingController.text = widget.trackingUrl != null ? widget.trackingUrl.toString() : '';
//     serialController.text =  widget.serialNumber != null ? widget.serialNumber.toString() : '';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(mainAxisSize: MainAxisSize.min, children: [
//
//       Align(
//         alignment: Alignment.topRight,
//         child: InkWell(
//           onTap: (){
//             Get.back();
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Theme.of(context).cardColor.withOpacity(0.5),
//             ),
//             padding: const EdgeInsets.all(3),
//             child: const Icon(Icons.clear),
//           ),
//         ),
//       ),
//       const SizedBox(height: Dimensions.paddingSizeSmall),
//
//
//       GetBuilder<OrderController>(
//         builder: (orderController) {
//           return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//             color: Theme.of(context).cardColor,
//           ),
//           width: context.width,
//           height: context.height *0.6,
//           padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//           child: Column(
//               children: [
//                 Flexible(
//                   child: SingleChildScrollView(
//                     child: Column(mainAxisSize: MainAxisSize.min, children: [
//                       const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                       Text('third_party_company'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
//                       const SizedBox(height: Dimensions.paddingSizeSmall),
//
//                       TextFieldWidget(
//                         hintText: 'order_id'.tr,
//                         inputType: TextInputType.number,
//                         focusNode: orderNode,
//                         nextFocus: companyNode,
//                         inputAction: TextInputAction.done,
//                         controller: orderIdController,
//                         isEnabled: false,
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeLarge),
//
//
//                       TextFieldWidget(
//                         hintText: 'company_name'.tr,
//                         inputType: TextInputType.text,
//                         focusNode: companyNode,
//                         nextFocus: trackingNode,
//                         inputAction: TextInputAction.done,
//                         controller: companyController,
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text( 'tracking_url'.tr,
//                           style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
//                         ),
//                       ),
//                       TextFieldWidget(
//                         title: false,
//                         hintText: 'https://www.example.com',
//                         inputType: TextInputType.text,
//                         focusNode: trackingNode,
//                         nextFocus: serialNode,
//                         inputAction: TextInputAction.done,
//                         controller: trackingController,
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeLarge),
//
//                       TextFieldWidget(
//                         hintText: 'serial_number'.tr,
//                         inputType: TextInputType.text,
//                         focusNode: serialNode,
//                         inputAction: TextInputAction.done,
//                         controller: serialController,
//                       ),
//                       const SizedBox(height: Dimensions.paddingSizeExtraLarge),
//
//                     ]),
//                   ),
//                 ),
//
//                 CustomButtonWidget(buttonText: 'submit',
//                   onPressed: (){
//                     String company = companyController.text.trim();
//                     String tracking = trackingController.text.trim();
//                     String serial = serialController.text.trim();
//
//                     if(company.isEmpty){
//                       showCustomSnackBar('add_company_name'.tr);
//                     }else if(tracking.isEmpty){
//                       showCustomSnackBar('add_tracking_url'.tr);
//                     }else if(serial.isEmpty){
//                       showCustomSnackBar('add_serial_number'.tr);
//                     }else{
//                       Get.back();
//                       orderController.assignThirdParty(widget.orderId, company, tracking, serial);
//                     }
//
//                   },
//                 ),
//
//               ]),
//           );
//         }
//       )
//     ]);
//   }
// }
