import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart';

import '../../domain/core/interfaces/form_utils.dart';
import '../../domain/core/interfaces/snackbar_utils.dart';
import 'controllers/add_note.controller.dart';

class AddNoteScreen extends GetView<AddNoteController> {
  AddNoteScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final List<DropdownMenuItem<int>> menuItems = const [
    DropdownMenuItem(
        value: 0,
        child: Text(
          "Only once",
        )),
    DropdownMenuItem(
        value: 24,
        child: Text(
          "1 day",
        )),
    DropdownMenuItem(
        value: 3,
        child: Text(
          "3 hours",
        )),
    DropdownMenuItem(
        value: 1,
        child: Text(
          "1 hour",
        )),
  ];

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
              Obx(
                () => Text(
                  controller.noteEntity.value != null ? 'Update Note' : 'Add Note',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              const SizedBox()
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Title',
            style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Obx(
            () => FormUtils.textField(
              hint: controller.noteEntity.value?.title ?? 'Enter Title',
              icon: Icons.title,
              showicon: false,
              maxlength: 20,
              validator: (value) {
                return value!.isEmpty ? "Please Enter A Title" : null;
              },
              textEditingController: _titleController,
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            'Description',
            style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
          ),
          SizedBox(
            height: 1.h,
          ),
          Obx(
            () => FormUtils.textField(
              hint: controller.noteEntity.value?.description ?? 'Enter Description',
              icon: Icons.ac_unit,
              showicon: false,
              maxlength: 70,
              maxLines: 2,
              validator: (value) {
                return value!.isEmpty ? "Please Enter A Note" : null;
              },
              textEditingController: _descController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reminder',
                style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
              ),
              Obx(
                () => Switch(
                  value: controller.isReminder.value,
                  onChanged: (value) => controller.onReminderChanged(value),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Obx(
            () => controller.isReminder.value
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date',
                                    style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Obx(
                                    () => FormUtils.textField(
                                      hint: controller.dateSelected.value != null
                                          ? DateFormat('dd/MM/yyyy').format(controller.dateSelected.value!)
                                          : '',
                                      icon: Icons.calendar_today,
                                      readonly: true,
                                      showicon: false,
                                      ontap: () async {
                                        var selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: controller.dateSelected.value ?? TZDateTime.now(local),
                                          firstDate: TZDateTime.now(local),
                                          lastDate: TZDateTime(local, 2300),
                                          currentDate: TZDateTime.now(local),
                                        );
                                        if (selectedDate != null) {
                                          controller.dateSelected.value = TZDateTime.from(selectedDate, local);
                                        }
                                      },
                                      textEditingController: TextEditingController(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
                                  ),
                                  SizedBox(
                                    height: 1.h,
                                  ),
                                  Obx(
                                    () => FormUtils.textField(
                                      hint: controller.startTimeSelected.value != null
                                          ? controller.startTimeSelected.value!.format(context)
                                          : '',
                                      icon: Icons.watch_outlined,
                                      showicon: false,
                                      readonly: true,
                                      ontap: () async {
                                        var selectedTime = await showTimePicker(
                                          context: context,
                                          initialTime: controller.startTimeSelected.value ?? TimeOfDay.now(),
                                        );
                                        if (selectedTime != null) {
                                          controller.startTimeSelected.value = selectedTime;
                                        }
                                      },
                                      textEditingController: TextEditingController(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'Reminder Interval',
                          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Obx(
                          () => FormUtils.dropdown(
                            value: controller.reminderInterval.value,
                            items: menuItems,
                            onChanged: (value) {
                              controller.reminderInterval.value = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
          SizedBox(
            height: 4.h,
          ),
          Obx(
            () => FormUtils.button(
              color: Colors.deepPurple,
              width: Get.width,
              title: controller.noteEntity.value != null ? 'Update Note' : 'Create Note',
              func: () {
                bool? isTitleAndDescValidated = true;
                if (controller.noteEntity.value == null) {
                  isTitleAndDescValidated = _formKey.currentState?.validate() ?? false;
                }
                if (isTitleAndDescValidated) {
                  if (controller.isReminder.value == true) {
                    bool dateValidate = controller.dateSelected.value != null;
                    if (dateValidate == false) {
                      SnackbarUtils.generalSnackbar(
                          title: 'Validation',
                          message: 'Date cant be empty',
                          colorText: Colors.red,
                          backgroundColor: Colors.grey[200]);
                      return;
                    }
                    bool startTimeValidate = controller.startTimeSelected.value != null;
                    if (startTimeValidate == false) {
                      SnackbarUtils.generalSnackbar(
                          title: 'Validation',
                          message: 'Start Time cant be empty',
                          colorText: Colors.red,
                          backgroundColor: Colors.grey[200]);
                      return;
                    }
                    bool remindTimeValidate = controller.reminderInterval.value != null;
                    if (remindTimeValidate == false) {
                      SnackbarUtils.generalSnackbar(
                          title: 'Validation',
                          message: 'please select remin time',
                          colorText: Colors.red,
                          backgroundColor: Colors.grey[200]);
                      return;
                    }
                    final dateTime = TZDateTime(
                      local,
                      controller.dateSelected.value?.year ?? TZDateTime.now(local).year,
                      controller.dateSelected.value?.month ?? TZDateTime.now(local).month,
                      controller.dateSelected.value?.day ?? TZDateTime.now(local).day,
                      controller.startTimeSelected.value?.hour ?? 0,
                      controller.startTimeSelected.value?.minute ?? 0,
                    );
                    if (dateTime.isBefore(TZDateTime.now(local))) {
                      SnackbarUtils.generalSnackbar(
                          title: 'Validation',
                          message: 'date and time cant be before now',
                          colorText: Colors.red,
                          backgroundColor: Colors.grey[200]);
                      return;
                    }
                  }
                  controller.insertOrUpdateNote(
                    title: _titleController.text,
                    description: _descController.text,
                    onSuccess: () {
                      Get.back();
                      SnackbarUtils.generalSnackbar(
                        title: controller.noteEntity.value != null ? 'Update Note' : 'Add Note',
                        message: controller.noteEntity.value != null ? 'Update note success' : 'Add note success',
                        colorText: Colors.green,
                      );
                    },
                    onFailed: () {
                      SnackbarUtils.generalSnackbar(
                          title: controller.noteEntity.value != null ? 'Update Note' : 'Add Note',
                          message: controller.noteEntity.value != null
                              ? 'Update note failed, please check form again or try again'
                              : 'Add note failed, please check form again or try again',
                          colorText: Colors.red,
                          backgroundColor: Colors.grey[200]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
