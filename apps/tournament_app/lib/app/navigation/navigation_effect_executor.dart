import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/app/navigation/navigation_execution_result.dart';

abstract interface class NavigationEffectExecutor {
  Future<NavigationExecutionResult> execute(NavigationEffect effect);
}
