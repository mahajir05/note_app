import 'package:equatable/equatable.dart';
import 'package:timezone/timezone.dart';

class NoteEntity extends Equatable {
  final int? userId;
  final int? id;
  final String? title;
  final String? description;
  final TZDateTime? dateTime;
  final TZDateTime? dateTimeReminder;
  final int? hourInterval;
  final bool? isRemind;

  const NoteEntity({
    this.userId,
    this.id,
    this.title,
    this.description,
    this.dateTime,
    this.dateTimeReminder,
    this.hourInterval,
    this.isRemind,
  });

  @override
  List<Object?> get props => [userId, id, title, description, dateTime, dateTimeReminder, hourInterval];
}
