import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_preview.dart';

final avatar48UseCase = WidgetbookUseCase(
  name: '48 px',
  builder: Avatar48UseCase.build,
);

abstract final class Avatar48UseCase {
  static Widget build(BuildContext context) =>
      const AvatarPreview(size: AppAvatarSize.medium);
}
