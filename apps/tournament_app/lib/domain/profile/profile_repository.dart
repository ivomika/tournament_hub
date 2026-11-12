import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';

abstract interface class ProfileRepository {
  OperationRequest<LocalProfile?> read();

  OperationRequest<void> save(LocalProfile profile);
}
