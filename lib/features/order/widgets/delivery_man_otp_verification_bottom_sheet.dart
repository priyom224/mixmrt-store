import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_store/util/app_constants.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/styles.dart';

class DeliveryManOtpVerificationBottomSheet extends StatefulWidget {
  final int orderId;
  const DeliveryManOtpVerificationBottomSheet({super.key, required this.orderId});

  @override
  State<DeliveryManOtpVerificationBottomSheet> createState() => _DeliveryManOtpVerificationBottomSheetState();
}

class _DeliveryManOtpVerificationBottomSheetState extends State<DeliveryManOtpVerificationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 5, width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                color: Theme.of(context).disabledColor,
              ),
            ),

            Column(children: [
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('otp_verification'.tr, style: robotoBold, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              Text('enter_otp_number'.tr, style: robotoRegular, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),

              SizedBox(
                width: 200,
                child: PinCodeTextField(
                  length: 4,
                  appContext: context,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.slide,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    fieldHeight: 30,
                    fieldWidth: 30,
                    borderWidth: 2,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    selectedColor: Theme.of(context).primaryColor,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Theme.of(context).cardColor,
                    inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    activeColor: Theme.of(context).primaryColor.withOpacity(0.7),
                    activeFillColor: Theme.of(context).cardColor,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onChanged: (String text) => orderController.setOtp(text),
                  beforeTextPaste: (text) => true,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text('collect_otp_from_deliveryman'.tr, style: robotoRegular, textAlign: TextAlign.center),
              const SizedBox(height: Dimensions.paddingSizeLarge),
            ]),

            CustomButtonWidget(
              buttonText: 'verify'.tr,
              radius: Dimensions.radiusDefault,
              isLoading: orderController.isLoading,
              margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
              onPressed: () {
                Get.find<OrderController>().updateOrderStatus(widget.orderId, AppConstants.handover);
              },
            ),
          ]),
        );
      }),
    );
  }
}
