import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/share_fixture.dart';

final shareShortUseCase = WidgetbookUseCase(
  name: 'short',
  builder: ShareShortUseCase.build,
);

abstract final class ShareShortUseCase {
  static Widget build(BuildContext context) => const ShareFixture();
}
