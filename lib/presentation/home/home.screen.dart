// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

import '../../domain/core/interfaces/app_date_utils.dart';
import '../../domain/core/interfaces/assets/my_assets.dart';
import '../../domain/core/interfaces/bottom_sheet_utils.dart';
import '../../domain/core/interfaces/form_utils.dart';
import '../../domain/core/interfaces/snackbar_utils.dart';
import '../../infrastructure/dal/services/notification_service.dart';
import '../../infrastructure/navigation/routes.dart';
import '../../infrastructure/theme/colors.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed(Routes.PROFILE, arguments: controller.userData.value?.id);
                    },
                    child: Obx(
                      () => controller.userData.value?.photoProfile != null
                          ? SizedBox(
                              height: 8.h,
                              child: Image.asset(
                                controller.userData.value!.photoProfile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Icons.account_circle,
                              size: 8.h,
                              color: Appcolors.pink,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  Expanded(
                    child: Obx(
                      () => Text(
                        'Hello ${controller.userData.value?.firstName}',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 15.sp),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      BottomSheetUtils.settings(
                        onUpdatePressed: () {
                          Get.toNamed(Routes.PROFILE, arguments: controller.userData.value?.id);
                        },
                        onLogoutPressed: () {
                          controller.logout(
                            onSuccess: () {
                              Get.offAllNamed(Routes.AUTH);
                            },
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.settings,
                      size: 25.sp,
                      color: Appcolors.black,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    DateFormat('MMMM, dd').format(tz.TZDateTime.now(tz.local)),
                    style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: 17.sp),
                  ),
                  const Spacer(),
                  FormUtils.button(
                    color: Colors.deepPurple,
                    width: 40.w,
                    title: '+ Add Note',
                    func: () {
                      Get.toNamed(Routes.ADD_NOTE, arguments: [controller.userData.value?.id]);
                    },
                  )
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Obx(
                () => Expanded(
                  child: controller.notesData.value.isNotEmpty
                      ? GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          children: controller.notesData.value
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.ADD_NOTE, arguments: [controller.userData.value?.id, e.id]);
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16, bottom: 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.title ?? '-',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Appcolors.purple,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                                Text(
                                                  e.description ?? '-',
                                                  style: TextStyle(fontSize: 10.sp),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  e.dateTime != null
                                                      ? DateFormat('dd MMMM yyyy hh:mm a').format(e.dateTime!)
                                                      : '',
                                                  style: TextStyle(fontSize: 8.sp),
                                                ),
                                                if (e.dateTime != null &&
                                                    e.dateTimeReminder != null &&
                                                    e.dateTimeReminder!.isAfter(e.dateTime!))
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'remind at ',
                                                      style: TextStyle(fontSize: 8.sp, color: Colors.black87),
                                                      children: [
                                                        TextSpan(
                                                          text: e.dateTimeReminder != null
                                                              ? DateFormat('hh:mm a').format(e.dateTimeReminder!)
                                                              : '-',
                                                        ),
                                                        if (AppDateUtils.daysBetween(e.dateTime!, e.dateTimeReminder!) >
                                                            0)
                                                          const TextSpan(
                                                            text: ' next day',
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                SizedBox(
                                                  height: 1.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (e.dateTime != null)
                                              Switch(
                                                value: e.isRemind ?? false,
                                                onChanged: (value) =>
                                                    controller.toogleIsReminder(value, e, onImposible: () {
                                                  SnackbarUtils.generalSnackbar(
                                                    title: 'Toogle Reminder',
                                                    message: 'cant turn on note, because time reminder is passed',
                                                    colorText: Colors.orange,
                                                    backgroundColor: Colors.grey[200],
                                                  );
                                                }, onSuccess: () {
                                                  SnackbarUtils.generalSnackbar(
                                                    title: 'Toogle Reminder',
                                                    message: 'note reminder turned ${value ? 'on' : 'off'}',
                                                    colorText: value ? Colors.green : Colors.orange,
                                                    backgroundColor: Colors.grey[200],
                                                  );
                                                }, onFailed: () {
                                                  SnackbarUtils.generalSnackbar(
                                                    title: 'Toogle Reminder',
                                                    message: 'update note failed',
                                                    colorText: Colors.red,
                                                    backgroundColor: Colors.grey[200],
                                                  );
                                                }),
                                              ),
                                            const Spacer(),
                                            IconButton(
                                                onPressed: () => controller.deleteNote(e.id!),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : Center(child: _nodatawidget()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nodatawidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            MyAssets.clipboard,
            height: 30.h,
          ),
          SizedBox(height: 3.h),
          Text(
            'There Is No Notes',
            style: Get.textTheme.headline1!.copyWith(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
