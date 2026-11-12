enum ProfileFailureReason { invalidName, read, write, corrupt }

final class ProfileException implements Exception {
  const ProfileException(this.reason, {this.cause});

  final ProfileFailureReason reason;
  final Object? cause;
}
