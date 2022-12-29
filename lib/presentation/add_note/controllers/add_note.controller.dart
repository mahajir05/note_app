import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';

import '../../../domain/features/note/entities/note_entity.dart';
import '../../../domain/features/note/usecases/get_note_by_id_uc.dart';
import '../../../domain/features/note/usecases/insert_note_uc.dart';
import '../../../domain/features/note/usecases/update_note_uc.dart';
import '../../../infrastructure/dal/services/notification_service.dart';
import '../../home/controllers/home.controller.dart';

class AddNoteController extends GetxController {
  final InsertNoteUc insertNoteUc;
  final UpdateNoteUc updateNoteUc;
  final GetNoteByIdUc getNoteByIdUc;
  AddNoteController({required this.insertNoteUc, required this.updateNoteUc, required this.getNoteByIdUc});

  RxBool isReminder = false.obs;

  Rx<int?> noteId = Rxn<int>();
  Rx<NoteEntity?> noteEntity = Rxn<NoteEntity>();

  Rx<int?> userId = Rxn<int>();
  Rx<TZDateTime?> dateSelected = Rxn<TZDateTime>();
  Rx<TimeOfDay?> startTimeSelected = Rxn<TimeOfDay>();
  Rx<int?> reminderInterval = Rxn<int>();

  @override
  void onInit() {
    super.onInit();

    userId.value = Get.arguments.asMap()[0] as int?;
    noteId.value = Get.arguments.asMap()[1] as int?;
    getNoteById(noteId.value);
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  void getNoteById(int? noteId) async {
    if (noteId == null) return;
    final result = await getNoteByIdUc(noteId);
    if (result != null) {
      noteEntity.value = result;
      isReminder.value = result.dateTime != null && result.dateTimeReminder != null;
      dateSelected.value = result.dateTime != null
          ? TZDateTime.local(result.dateTime!.year, result.dateTime!.month, result.dateTime!.day)
          : null;
      startTimeSelected.value = result.dateTime != null ? TimeOfDay.fromDateTime(result.dateTime!) : null;
      reminderInterval.value = result.hourInterval;
    }
  }

  void onReminderChanged(bool value) {
    isReminder.value = value;

    dateSelected.value = null;
    startTimeSelected.value = null;
    reminderInterval.value = null;
  }

  void insertOrUpdateNote({
    String? title,
    String? description,
    Function()? onSuccess,
    Function()? onFailed,
  }) {
    final dateTime = TZDateTime(
      local,
      dateSelected.value?.year ?? TZDateTime.now(local).year,
      dateSelected.value?.month ?? TZDateTime.now(local).month,
      dateSelected.value?.day ?? TZDateTime.now(local).day,
      startTimeSelected.value?.hour ?? 0,
      startTimeSelected.value?.minute ?? 0,
    );

    String? fTitle =
        title != null && title.isNotEmpty && title != noteEntity.value?.title ? title : noteEntity.value?.title;
    String? fDesc = description != null && description.isNotEmpty && description != noteEntity.value?.description
        ? description
        : noteEntity.value?.description;
    TZDateTime? fDateTime = isReminder.value && dateTime != noteEntity.value?.dateTime ? dateTime : null;
    int? freminderInterval = isReminder.value
        ? reminderInterval.value != noteEntity.value?.hourInterval
            ? reminderInterval.value
            : noteEntity.value?.hourInterval
        : null;

    debugPrint('User ID: ${userId.value}');
    debugPrint('Final Title: $fTitle');
    debugPrint('Final Note: $fDesc');
    debugPrint('Date: ${dateSelected.value}');
    debugPrint('StartTime: ${startTimeSelected.value}');
    debugPrint('Final Datetime: $fDateTime');
    debugPrint('Final Datetime reminder: $fDateTime');
    debugPrint('Final Hour Interval: $freminderInterval');

    if (noteEntity.value == null) {
      _insertNote(
        title: fTitle,
        description: fDesc,
        dateTime: fDateTime,
        dateTimeReminder: fDateTime,
        hourInterval: freminderInterval,
        onSuccess: onSuccess,
        onFailed: onFailed,
      );
    } else {
      if (noteId.value == null) {
        debugPrint('note id cant be null');
        return;
      }
      bool fIsRemind = fDateTime != null ? fDateTime.isAfter(TZDateTime.now(local)) : false;
      _updateNote(
        noteId: noteId.value!,
        title: fTitle,
        description: fDesc,
        dateTime: fDateTime,
        dateTimeReminder: fDateTime,
        hourInterval: freminderInterval,
        isRemind: fIsRemind,
        onSuccess: onSuccess,
        onFailed: onFailed,
      );
    }
  }

  void _insertNote({
    String? title,
    String? description,
    TZDateTime? dateTime,
    TZDateTime? dateTimeReminder,
    int? hourInterval,
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    final result = await insertNoteUc(NoteEntity(
      userId: userId.value,
      title: title,
      description: description,
      dateTime: isReminder.value ? dateTime : null,
      dateTimeReminder: isReminder.value ? dateTimeReminder : null,
      hourInterval: hourInterval,
      isRemind: true,
    ));

    if (result != null) {
      if (isReminder.value) {
        await NotificationService.showNotification(
          type: NotificationType.zonedSchedule,
          notifId: result,
          title: title,
          body: description,
          datetimeForSchedule: dateTimeReminder,
        );
      }
      HomeController.instance.getNotesByUserId(userId.value!);
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailed != null) onFailed();
    }
  }

  void _updateNote({
    required int noteId,
    String? title,
    String? description,
    TZDateTime? dateTime,
    TZDateTime? dateTimeReminder,
    int? hourInterval,
    bool? isRemind,
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    final result = await updateNoteUc(NoteEntity(
      userId: userId.value,
      id: noteId,
      title: title,
      description: description,
      dateTime: isReminder.value ? dateTime : null,
      dateTimeReminder: isReminder.value ? dateTimeReminder : null,
      hourInterval: hourInterval,
      isRemind: isRemind,
    ));

    if (result != null) {
      if (isReminder.value) {
        await NotificationService.showNotification(
          type: NotificationType.zonedSchedule,
          notifId: noteId,
          title: title,
          body: description,
          datetimeForSchedule: dateTimeReminder,
        );
      }
      HomeController.instance.getNotesByUserId(userId.value!);
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailed != null) onFailed();
    }
  }
}
