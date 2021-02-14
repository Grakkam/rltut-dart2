class Impossible implements Exception {
  final String msg;

  const Impossible([this.msg]);

  @override
  String toString() => msg ?? 'Impossible';
}
