import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';

final class LoadProfileUseCase {
  const LoadProfileUseCase(this.repository);

  final ProfileRepository repository;

  OperationRequest<LocalProfile?> start() => repository.read();
}
