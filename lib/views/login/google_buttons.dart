import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/views/constant/app_color.dart';
import 'package:instagram_clone/views/constant/strings.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.google,
            color: AppColor.googleColor,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            Strings.google,
          )
        ],
      ),
    );
  }
}
