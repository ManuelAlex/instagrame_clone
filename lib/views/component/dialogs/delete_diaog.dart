import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/dialogs/alart_dialogs_model.dart';
//import 'package:instagram_clone/views/constant/strings.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({required String titleOfObject})
      : super(
          title: '${Strings.delete} $titleOfObject ?',
          message: '${Strings.areYouSureYouWantToDeleteThis} $titleOfObject ?',
          buttons: const {
            Strings.cancel: false,
            Strings.delete: true,
          },
        );
}
