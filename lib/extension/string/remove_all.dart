extension RemoveAll on String {
  String removeAll(Iterable<String> stringValue) => stringValue.fold(
      this,
      (
        result,
        pattern,
      ) =>
          result.replaceAll(
            pattern,
            '',
          ));
}
