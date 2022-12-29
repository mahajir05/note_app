import 'package:deptech_app/domain/features/note/entities/note_entity.dart';
import 'package:timezone/timezone.dart';

class NoteModel extends NoteEntity {
  NoteModel({
    int? userId,
    int? id,
    String? title,
    String? description,
    num? datetimeTs,
    num? datetimeReminderTs,
    int? hourInterval,
    int? isRemind,
  }) : super(
          userId: userId,
          id: id,
          title: title,
          description: description,
          dateTime: datetimeTs != null ? TZDateTime.fromMillisecondsSinceEpoch(local, datetimeTs.toInt()) : null,
          dateTimeReminder: datetimeReminderTs != null
              ? TZDateTime.fromMillisecondsSinceEpoch(local, datetimeReminderTs.toInt())
              : null,
          hourInterval: hourInterval,
          isRemind: isRemind == 0 ? false : true,
        );

  NoteModel.fromJson(Map<String, dynamic> json)
      : super(
          userId: json['userId'],
          id: json['id'],
          title: json['title'],
          description: json['description'],
          dateTime: json['datetimeTs'] != null
              ? TZDateTime.fromMillisecondsSinceEpoch(local, (json['datetimeTs'] as num).toInt())
              : null,
          dateTimeReminder: json['datetimeReminderTs'] != null
              ? TZDateTime.fromMillisecondsSinceEpoch(local, (json['datetimeReminderTs'] as num).toInt())
              : null,
          hourInterval: json['hourInterval'],
          isRemind: json['isRemind'] == 0 ? false : true,
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = super.userId;
    data['id'] = super.id;
    data['title'] = super.title;
    data['description'] = super.description;
    data['datetimeTs'] = super.dateTime?.millisecondsSinceEpoch;
    data['datetimeReminderTs'] = super.dateTimeReminder?.millisecondsSinceEpoch;
    data['hourInterval'] = super.hourInterval;
    data['isRemind'] = super.isRemind == true ? 1 : 0;
    return data;
  }
}
