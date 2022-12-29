import 'package:get/get.dart';

import '../../../../domain/features/note/usecases/get_note_by_id_uc.dart';
import '../../../../domain/features/note/usecases/insert_note_uc.dart';
import '../../../../domain/features/note/usecases/update_note_uc.dart';
import '../../../../presentation/add_note/controllers/add_note.controller.dart';

class AddNoteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<InsertNoteUc>(InsertNoteUc(Get.find()));
    Get.put<GetNoteByIdUc>(GetNoteByIdUc(Get.find()));
    Get.put<AddNoteController>(
      AddNoteController(
        insertNoteUc: Get.find(),
        updateNoteUc: Get.find(),
        getNoteByIdUc: Get.find(),
      ),
    );
  }
}
