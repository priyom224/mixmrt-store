import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_store/helper/route_helper.dart';
import 'package:sixam_mart_store/util/styles.dart';

class ConditionCheckBoxWidget extends StatelessWidget {
  final AuthController authController;
  final bool isPrivacyPolicy;
  final bool isAgreement;
  const ConditionCheckBoxWidget({super.key, required this.authController, this.isPrivacyPolicy = false, this.isAgreement = false});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [

      Checkbox(
        activeColor: Theme.of(context).primaryColor,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        value: isAgreement ? authController.isAgreement : isPrivacyPolicy ? authController.isPrivacyPolicy : authController.acceptTerms,
        onChanged: (bool? isChecked) => isAgreement ? authController.toggleAgreement() : isPrivacyPolicy ? authController.togglePrivacyPolicy() : authController.toggleTerms(),
      ),

      const Text( '*', style: robotoRegular),

      Flexible(
        child: RichText(
          text: TextSpan(children: [
            TextSpan(text: 'i_agree_with_all_the'.tr, style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color)),
            const TextSpan(text: ' '),
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = () => isAgreement ? Get.toNamed(RouteHelper.getAgreementRoute()) :
              isPrivacyPolicy ? Get.toNamed(RouteHelper.getPrivacyRoute()) :
              Get.toNamed(RouteHelper.getTermsRoute()),
              text:  isAgreement ? 'contact'.tr : isPrivacyPolicy ? 'privacy_policy'.tr : 'terms_conditions'.tr,
              style: robotoMedium.copyWith(color: Theme.of(context).primaryColor),
            ),
          ]),
        ),
      ),

    ]);
  }
}
