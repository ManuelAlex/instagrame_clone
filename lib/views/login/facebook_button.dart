import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_clone/views/constant/app_color.dart';
import 'package:instagram_clone/views/constant/strings.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.facebook,
            color: AppColor.facebookColor,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            Strings.facebook,
          )
        ],
      ),
    );
  }
}
