import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class IconComparison {
  static final spec = ComparisonSpec(
    component: 'icons',
    title: 'AppIcon · исходные18 SVG',
    goldenDirectory: 'lib/presentation/design_system/foundation/icons/golden',
    scenarios: [
      ComparisonScenario(
        id: 'glyph-share-link',
        title: 'share-link',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#share-link"]) svg',
        builder: _shareLink,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-chevron',
        title: 'chevron',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#chevron"]) svg',
        builder: _chevron,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-settings',
        title: 'settings',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#settings"]) svg',
        builder: _settings,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-info',
        title: 'info',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#info"]) svg',
        builder: _info,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-contact',
        title: 'contact',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#contact"]) svg',
        builder: _contact,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-close',
        title: 'close',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#close"]) svg',
        builder: _close,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-minus',
        title: 'minus',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#minus"]) svg',
        builder: _minus,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-arrow',
        title: 'arrow',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#arrow"]) svg',
        builder: _arrow,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-back',
        title: 'back',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#back"]) svg',
        builder: _back,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-person',
        title: 'person',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#person"]) svg',
        builder: _person,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-history',
        title: 'history',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#history"]) svg',
        builder: _history,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-plus',
        title: 'plus',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#plus"]) svg',
        builder: _plus,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-qr',
        title: 'qr',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#qr"]) svg',
        builder: _qr,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-trash',
        title: 'trash',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#trash"]) svg',
        builder: _trash,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-edit',
        title: 'edit',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#edit"]) svg',
        builder: _edit,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-alert',
        title: 'alert',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#alert"]) svg',
        builder: _alert,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-check',
        title: 'check',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#check"]) svg',
        builder: _check,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        id: 'glyph-trophy',
        title: 'trophy',
        viewport: VisualViewport.mobile,
        webSelector: '#icons .kit-icon:has(use[href="#trophy"]) svg',
        builder: _trophy,
        controls: [
          const ComparisonControl.type(
            id: 'glyph',
            webSelector: ':scope',
            type: CustomPaint,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
    ],
  );
  static Widget _shareLink(BuildContext context) =>
      const AppIcon(AppGlyph.shareLink);
  static Widget _chevron(BuildContext context) =>
      const AppIcon(AppGlyph.chevron);
  static Widget _settings(BuildContext context) =>
      const AppIcon(AppGlyph.settings);
  static Widget _info(BuildContext context) => const AppIcon(AppGlyph.info);
  static Widget _contact(BuildContext context) =>
      const AppIcon(AppGlyph.contact);
  static Widget _close(BuildContext context) => const AppIcon(AppGlyph.close);
  static Widget _minus(BuildContext context) => const AppIcon(AppGlyph.minus);
  static Widget _arrow(BuildContext context) => const AppIcon(AppGlyph.arrow);
  static Widget _back(BuildContext context) => const AppIcon(AppGlyph.back);
  static Widget _person(BuildContext context) => const AppIcon(AppGlyph.person);
  static Widget _history(BuildContext context) =>
      const AppIcon(AppGlyph.history);
  static Widget _plus(BuildContext context) => const AppIcon(AppGlyph.plus);
  static Widget _qr(BuildContext context) => const AppIcon(AppGlyph.qr);
  static Widget _trash(BuildContext context) => const AppIcon(AppGlyph.trash);
  static Widget _edit(BuildContext context) => const AppIcon(AppGlyph.edit);
  static Widget _alert(BuildContext context) => const AppIcon(AppGlyph.alert);
  static Widget _check(BuildContext context) => const AppIcon(AppGlyph.check);
  static Widget _trophy(BuildContext context) => const AppIcon(AppGlyph.trophy);
}
