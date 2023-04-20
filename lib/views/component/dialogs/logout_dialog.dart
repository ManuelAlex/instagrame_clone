import 'package:flutter/foundation.dart' show immutable;
import 'package:instagram_clone/views/component/constant/strings.dart';
import 'package:instagram_clone/views/component/dialogs/alart_dialogs_model.dart';

@immutable
class LogOutDialog extends AlertDialogModel<bool> {
  const LogOutDialog()
      : super(
            title: Strings.logOut,
            message: Strings.areYouSureThatYouWantToLogOutOfTheApp,
            buttons: const {
              Strings.cancel: false,
              Strings.logOut: true,
            });
}
