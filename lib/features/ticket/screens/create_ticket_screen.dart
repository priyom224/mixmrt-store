import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_store/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_asset_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_drop_down_button.dart';
import 'package:sixam_mart_store/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_store/common/widgets/custom_text_field_widget.dart';
import 'package:sixam_mart_store/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_store/features/ticket/controllers/ticket_controller.dart';
import 'package:sixam_mart_store/util/dimensions.dart';
import 'package:sixam_mart_store/util/images.dart';
import 'package:sixam_mart_store/util/styles.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    Get.find<TicketController>().getTicketCategory();
    Get.find<TicketController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Create Ticket'),

      body: GetBuilder<TicketController>(builder: (ticketController) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Column(children: [

                  ticketController.ticketCategoryList == null ? const Center(child: CircularProgressIndicator())
                   : ticketController.ticketCategoryList!.isEmpty ? const Center(child: Text('No categories available')) : CustomDropdownButton(
                    dropdownMenuItems: ticketController.ticketCategoryList!.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id.toString(),
                        child: Text(category.categoryName!),
                      );
                    }).toList(),
                    hintText: 'Select an option',
                    onChanged: (value) {
                      int id = ticketController.ticketCategoryList!.indexWhere((category) => category.id.toString() == value);
                      ticketController.setSelectedCategoryId(id);
                    },
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextFieldWidget(
                    hintText: 'Subject',
                    showLabelText: false,
                    controller: _subjectController,
                    focusNode: _subjectFocus,
                    nextFocus: _descriptionFocus,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  CustomTextFieldWidget(
                    hintText: 'Description',
                    showLabelText: false,
                    controller: _descriptionController,
                    focusNode: _descriptionFocus,
                    maxLines: 5,
                    inputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Stack(children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        child: ticketController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                      ticketController.pickedFile!.path, width: double.infinity, height: 150, fit: BoxFit.cover) : Image.file(
                      File(ticketController.pickedFile!.path), width: double.infinity, height: 150, fit: BoxFit.cover) : const CustomImageWidget(
                      image: '',
                      width: double.infinity, height: 150, fit: BoxFit.cover,
                    )),

                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => ticketController.pickImage(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.1),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          ),
                          child: ticketController.pickedFile != null ? const SizedBox() : Container(
                            height: 130, width: 220,
                            decoration: BoxDecoration(
                              color: Get.isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFFAFAFA),
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                              CustomAssetImageWidget(Images.image, height: 40, width: 40, color: Get.isDarkMode ? Colors.grey : null),
                              const SizedBox(height: Dimensions.paddingSizeDefault),

                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(text: 'Click to upload'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.blue)),
                                  const TextSpan(text: '\n'),
                                  TextSpan(text: 'or drag and drop'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7))),
                                ]),
                              ),

                            ]),
                          ),
                        ),
                      ),
                    ),

                  ]),

                ]),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
              ),
              child: CustomButtonWidget(
                buttonText: 'submit',
                isLoading: ticketController.isLoading,
                onPressed: () {
                  if (ticketController.selectedCategoryId == null) {
                    showCustomSnackBar('Please select a category');
                  } else if (_subjectController.text.isEmpty) {
                    showCustomSnackBar('Please enter a subject');
                  } else if (_descriptionController.text.isEmpty) {
                    showCustomSnackBar('Please enter a description');
                  } else {
                    Map<String, String> data = {
                      'ticket_system_category_id': ticketController.selectedCategoryId.toString(),
                      'req_from': 'vendor',
                      'foreign_id': '${Get.find<ProfileController>().profileModel!.id}',
                      'subject': _subjectController.text,
                      'message': _descriptionController.text,
                    };
                    ticketController.createTicket(data);
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
