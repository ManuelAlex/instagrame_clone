enum LottieAnimation {
  smallError(name: 'small_error'),
  error(name: 'error'),
  loading(name: 'loading'),
  empty(name: 'empty'),
  dataNotFound(name: 'data_not_found');

  final String name;
  const LottieAnimation({
    required this.name,
  });
}
