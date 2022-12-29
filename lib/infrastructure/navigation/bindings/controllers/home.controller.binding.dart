import 'package:get/get.dart';

import '../../../../domain/features/note/repositories/i_note_repository.dart';
import '../../../../domain/features/note/usecases/delete_note_uc.dart';
import '../../../../domain/features/note/usecases/get_notes_by_user_id_uc.dart';
import '../../../../domain/features/note/usecases/update_note_uc.dart';
import '../../../../domain/features/user/repositories/i_user_repository.dart';
import '../../../../domain/features/user/usecases/get_user_data_uc.dart';
import '../../../../domain/features/user/usecases/logout_uc.dart';
import '../../../../presentation/home/controllers/home.controller.dart';
import '../../../dal/daos/note/data_sources/note_db_data_source.dart';
import '../../../dal/daos/note/repositories/note_repository.dart';
import '../../../dal/daos/user/data_sources/i_user_data_source.dart';
import '../../../dal/daos/user/data_sources/user_db_data_source.dart';
import '../../../dal/daos/user/repositories/user_repository.dart';

class HomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IUserDataSource>(
      UserDbDataSource(dbService: Get.find(), localStorageService: Get.find()),
      tag: TAG_INJECT_USER_DB_DATA_SOURCE,
    );
    Get.put<INoteDbDataSource>(
      NoteDbDataSource(dbService: Get.find()),
    );

    Get.put<IUserRepository>(UserRepository(
      dbDataSource: Get.find(tag: TAG_INJECT_USER_DB_DATA_SOURCE),
    ));
    Get.put<INoteRepository>(NoteRepository(
      dbDataSource: Get.find(),
    ));

    Get.put<GetUserDataUc>(GetUserDataUc(Get.find()));
    Get.put<GetNotesByUserIdUc>(GetNotesByUserIdUc(Get.find()));
    Get.put<UpdateNoteUc>(UpdateNoteUc(Get.find()));
    Get.put<DeleteNoteUc>(DeleteNoteUc(Get.find()));
    Get.put<LogoutUc>(LogoutUc(Get.find()));

    Get.lazyPut<HomeController>(
      () => HomeController(
        getUserDataUc: Get.find(),
        getNotesByUserIdUc: Get.find(),
        updateNoteUc: Get.find(),
        deleteNoteUc: Get.find(),
        logoutUc: Get.find(),
      ),
    );
  }
}
