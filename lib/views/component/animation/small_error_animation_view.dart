import 'package:instagram_clone/views/component/animation/lottie_animation_view.dart';
import 'package:instagram_clone/views/component/animation/models/lottie_animation_model.dart';

class SmallErrorAnimationView extends LottieAnimationView {
  const SmallErrorAnimationView({super.key})
      : super(
          animation: LottieAnimation.smallError,
        );
}
