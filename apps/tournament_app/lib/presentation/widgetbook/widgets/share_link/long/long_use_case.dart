import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/share_fixture.dart';

final shareLongUseCase = WidgetbookUseCase(
  name: 'long',
  builder: ShareLongUseCase.build,
);

abstract final class ShareLongUseCase {
  static Widget build(BuildContext context) => const ShareFixture(long: true);
}
