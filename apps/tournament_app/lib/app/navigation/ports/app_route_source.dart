import '../models/app_route_projection.dart';

abstract interface class AppRouteSource {
  AppRouteProjection get current;

  Stream<AppRouteProjection> get changes;
}
