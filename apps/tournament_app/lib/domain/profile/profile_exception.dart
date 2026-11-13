enum ProfileFailureReason { invalidName, read, write, corrupt, notFound }

final class ProfileException implements Exception {
  const ProfileException(this.reason, {this.cause});

  final ProfileFailureReason reason;
  final Object? cause;

  @override
  String toString() => 'ProfileException($reason, cause: ${cause.runtimeType})';
}
