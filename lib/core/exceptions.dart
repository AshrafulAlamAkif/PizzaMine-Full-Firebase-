//এটি Firebase বা API যেকোনো source-এর error-কে application-এর নিজস্ব error format-এ প্রকাশ করতে সাহায্য করবে।
class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}