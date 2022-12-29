// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart';

import '../../../domain/features/note/entities/note_entity.dart';
import '../../../domain/features/note/usecases/delete_note_uc.dart';
import '../../../domain/features/note/usecases/get_notes_by_user_id_uc.dart';
import '../../../domain/features/note/usecases/update_note_uc.dart';
import '../../../domain/features/user/entities/user_data_entity.dart';
import '../../../domain/features/user/usecases/get_user_data_uc.dart';
import '../../../domain/features/user/usecases/logout_uc.dart';
import '../../../infrastructure/dal/services/notification_service.dart';

class HomeController extends GetxController {
  final GetUserDataUc getUserDataUc;
  final GetNotesByUserIdUc getNotesByUserIdUc;
  final UpdateNoteUc updateNoteUc;
  final DeleteNoteUc deleteNoteUc;
  final LogoutUc logoutUc;
  HomeController({
    required this.getUserDataUc,
    required this.getNotesByUserIdUc,
    required this.updateNoteUc,
    required this.deleteNoteUc,
    required this.logoutUc,
  });

  static HomeController get instance => Get.find();

  Timer? _timer;

  Rx<UserDataEntity?> userData = Rxn<UserDataEntity>();
  RxList<NoteEntity> notesData = <NoteEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    int? userId = Get.arguments as int?;
    if (userId != null) {
      getUserData(userId);
      getNotesByUserId(userId);
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 500), () {
      checkIfNoteNeedUpdate(notesData.value);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void getUserData(
    int id, {
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    final result = await getUserDataUc(id);
    if (result != null) {
      debugPrint('getUserData success with userId: ${result.id}, email: ${result.email}');
      userData.value = result;
      if (onSuccess != null) onSuccess();
    } else {
      debugPrint('getUserData failed with userId: $id');
      if (onFailed != null) onFailed();
    }
  }

  void getNotesByUserId(
    int userId, {
    Function(List<NoteEntity>?)? onSuccess,
    Function()? onFailed,
  }) async {
    final result = await getNotesByUserIdUc(userId);
    if (result != null) {
      notesData.value = result;

      List<NoteEntity> notesDataWithReminder = result
          .where((element) =>
              (element.dateTimeReminder ?? TZDateTime.local(1996)).isAfter(TZDateTime.now(local)) &&
              element.isRemind == true)
          .toList();
      _setupTimer(notesDataWithReminder);
      // _isolateService.trigger(notesDataWithReminder);

      if (onSuccess != null) onSuccess(result);
    } else {
      if (onFailed != null) onFailed();
    }
  }

  void toogleIsReminder(
    bool toogle,
    NoteEntity note, {
    Function()? onImposible,
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    if (toogle == true && (note.dateTime ?? TZDateTime.local(1996)).isBefore(TZDateTime.now(local))) {
      if (onImposible != null) onImposible();
      return;
    }
    final result = await updateNoteUc(NoteEntity(
      userId: userData.value!.id,
      id: note.id,
      title: note.title,
      description: note.description,
      dateTime: note.dateTime,
      dateTimeReminder: note.dateTime,
      hourInterval: note.hourInterval,
      isRemind: toogle,
    ));

    if (result != null) {
      if (toogle == false) {
        await NotificationService.turnOffNotification(note.id!);
      }
      if (toogle == true) {
        await NotificationService.showNotification(
          type: NotificationType.zonedSchedule,
          notifId: note.id!,
          title: note.title,
          body: note.description,
          datetimeForSchedule: note.dateTime,
        );
      }
      getNotesByUserId(userData.value!.id!);
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailed != null) onFailed();
    }
  }

  void checkIfNoteNeedUpdate(List<NoteEntity> notes) {
    for (var note in notes) {
      if ((note.dateTimeReminder ?? TZDateTime.local(3000)).isBefore(TZDateTime.now(local)) && note.isRemind == true) {
        _updateNoteDateTimeReminder(note: note);
      }
    }
  }

  void _updateNoteDateTimeReminder({
    required NoteEntity note,
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    final updatedDateTimeReminder = TZDateTime(
      local,
      note.dateTimeReminder?.year ?? TZDateTime.now(local).year,
      note.dateTimeReminder?.month ?? TZDateTime.now(local).month,
      note.dateTimeReminder?.day ?? TZDateTime.now(local).day,
      (note.dateTimeReminder?.hour ?? 0) + (note.hourInterval ?? 0),
      note.dateTimeReminder?.minute ?? 0,
    );
    debugPrint('date reminder updated from ${note.dateTimeReminder} to $updatedDateTimeReminder');
    final result = await updateNoteUc(NoteEntity(
      userId: userData.value!.id,
      id: note.id,
      title: note.title,
      description: note.description,
      dateTime: note.dateTime,
      dateTimeReminder: updatedDateTimeReminder,
      hourInterval: note.hourInterval,
      isRemind: updatedDateTimeReminder.isAfter(TZDateTime.now(local)),
    ));

    if (result != null) {
      if (updatedDateTimeReminder.isAfter(TZDateTime.now(local))) {
        await NotificationService.showNotification(
          type: NotificationType.zonedSchedule,
          notifId: note.id!,
          title: note.title,
          body: note.description,
          datetimeForSchedule: updatedDateTimeReminder,
        );
      }
      getNotesByUserId(userData.value!.id!);
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailed != null) onFailed();
    }
  }

  void deleteNote(
    int noteId, {
    Function()? onSuccess,
    Function()? onFailed,
  }) async {
    final result = await deleteNoteUc(noteId);
    if (result != null) {
      await NotificationService.turnOffNotification(noteId);
      getNotesByUserId(userData.value!.id!);
      if (onSuccess != null) onSuccess();
    } else {
      if (onFailed != null) onFailed();
    }
  }

  void logout({
    required Function() onSuccess,
  }) async {
    final result = await logoutUc();
    if (result) {
      onSuccess();
    }
  }

  void _setupTimer(List<NoteEntity> data) {
    if (data.isEmpty) {
      _timer?.cancel();
      debugPrint('_timer is cancelled because no note will remind');
      return;
    }

    if (_timer != null && _timer!.isActive) _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        debugPrint('[HomeController][_setupTimer] total numbers of notes (remind): ${data.length}');
        var now = TZDateTime.now(local);
        for (var note in data) {
          if (now.difference(note.dateTimeReminder!).inMilliseconds > 0 &&
              now.difference(note.dateTimeReminder!).inMilliseconds < 990) {
            debugPrint('[HomeController][_setupTimer] note reminding now: $note');
            _updateNoteDateTimeReminder(note: note);
          }
        }
      },
    );
  }
}
