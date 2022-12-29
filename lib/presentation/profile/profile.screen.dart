import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart';

import '../../domain/core/interfaces/assets/my_assets.dart';
import '../../domain/core/interfaces/bottom_sheet_utils.dart';
import '../../domain/core/interfaces/form_utils.dart';
import '../../domain/core/interfaces/snackbar_utils.dart';
import '../../domain/core/validators/validator.dart';
import 'controllers/profile.controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final _firstNameTController = TextEditingController();
  final _lastNameTController = TextEditingController();
  final _dobTController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _buildform(context),
          ),
        ),
      ),
    );
  }

  Form _buildform(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.chevron_left,
                  size: 30.sp,
                ),
              ),
              Text(
                'Update Profile',
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox()
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Select Photo',
            style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [MyAssets.profileicon1, MyAssets.profileicon2, MyAssets.profileicon3, MyAssets.profileicon4]
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        controller.photoProfileSelected.value = e;
                      },
                      child: Container(
                          height: 8.h,
                          width: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage(e), fit: BoxFit.cover),
                          ),
                          child: e == controller.photoProfileSelected.value
                              ? Icon(
                                  Icons.done,
                                  color: Colors.deepPurple,
                                  size: 8.h,
                                )
                              : null),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Obx(
            () => _textfield(
              title: 'First Name',
              textEditingController: _firstNameTController,
              hint: controller.userData.value?.firstName ?? 'Enter First Name',
              validator: (value) {
                return value!.isEmpty ? "Please Enter First Name" : null;
              },
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Obx(
            () => _textfield(
              title: 'Last Name',
              textEditingController: _lastNameTController,
              hint: controller.userData.value?.lastName ?? 'Enter Last Name',
              validator: (value) {
                return value!.isEmpty ? "Please Enter Last Name" : null;
              },
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Obx(
            () => _textfield(
              title: 'Email',
              hint: controller.userData.value?.email ?? 'Enter Email',
              readOnly: true,
              validator: (value) {
                return !Validators.isValidEmail(value!) ? 'Enter a valid email' : null;
              },
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Obx(
            () => _textfield(
              title: 'Date Of Birth',
              textEditingController: _dobTController,
              hint: controller.userData.value?.dob != null
                  ? DateFormat('dd MMMM yyyy').format(controller.userData.value!.dob!)
                  : null,
              icon: Icons.calendar_today,
              readOnly: true,
              showIcon: false,
              validator: (value) {
                return value!.isEmpty ? "Please Select Date Of Birth" : null;
              },
              onTap: () async {
                var selecteddate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1800),
                  lastDate: DateTime.now(),
                  currentDate: DateTime.now(),
                );
                if (selecteddate != null) {
                  _dobTController.text = DateFormat('dd MMMM yyyy').format(selecteddate);
                  controller.dobTs.value = selecteddate.millisecondsSinceEpoch;
                }
              },
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Gender',
            style: Get.textTheme.headline1!.copyWith(fontSize: 14.sp),
          ),
          Obx(
            () => FormUtils.radio<String?>(
              group: controller.gender.value,
              dataList: ['L', 'P'],
              title: (data) => data == 'L' ? const Text('Laki-laki') : const Text('Perempuan'),
              onChanged: (value) {
                controller.gender.value = value;
                // hGender.value = value;
                // if (controller.isSubmitPressed.value) {
                //   _formKey.currentState?.validate();
                // }
              },
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          FormUtils.button(
            color: Colors.deepPurple,
            width: Get.width,
            title: 'Update',
            func: () {
              controller.updateUser(
                firstName: _firstNameTController.text,
                lastName: _lastNameTController.text,
                onSuccess: () {
                  Get.back();
                  SnackbarUtils.generalSnackbar(
                    title: 'Success',
                    message: 'Update user success',
                    colorText: Colors.green,
                  );
                },
                onFailed: () {
                  SnackbarUtils.generalSnackbar(
                    title: 'Failed',
                    message: 'Update user failed',
                    colorText: Colors.red,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _textfield({
    required String title,
    String? hint,
    String? Function(String?)? validator,
    TextEditingController? textEditingController,
    bool obscure = false,
    bool readOnly = false,
    bool showIcon = false,
    IconData? icon,
    Function()? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.textTheme.headline1!.copyWith(fontSize: 14.sp),
        ),
        SizedBox(
          height: 1.h,
        ),
        FormUtils.textField(
          hint: hint ?? '',
          obscure: obscure,
          readonly: readOnly,
          showicon: showIcon,
          icon: icon,
          validator: validator,
          ontap: onTap,
          textEditingController: textEditingController,
        ),
      ],
    );
  }
}
