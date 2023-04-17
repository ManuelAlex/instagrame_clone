import 'package:instagram_clone/views/component/animation/lottie_animation_view.dart';
import 'package:instagram_clone/views/component/animation/models/lottie_animation_model.dart';

class EmptyContentAnimationView extends LottieAnimationView {
  const EmptyContentAnimationView({super.key})
      : super(
          animation: LottieAnimation.empty,
        );
}
