# Отчёт architecture scan — задача104

Дата: 2026-11-10. Команда: dart run bin/check_flutter_architecture.dart; cwd tools/domain-check. Exit1 — найдены существующие нарушения, не ошибка запуска. Scope: Flutter lib/test,536 файлов. Без исправления исходников.

R-008.a: 346; R-008.b: 127; затронуто файлов: 189. Полный вывод ниже. Новые generated/framework исключения не добавлялись. Отсутствие других findings означает отсутствие обнаруженных этим checker нарушений, не полный семантический аудит.

```text
lib/presentation/design_system/components/button/app_button_theme.dart:52 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/button/app_button_theme.dart:53 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/components/button/app_button_theme.dart:54 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/components/button/app_button_theme.dart:55 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/button/app_button_theme.dart:57 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/components/button/app_button_theme.dart:82 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:84 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:89 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:91 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:95 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:127 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:136 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:143 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:143 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:145 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:147 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:149 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:150 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:152 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:155 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/button/app_button_theme.dart:162 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/field/app_field.dart:68 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/field/app_field_theme.dart:20 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/field/app_field_theme.dart:21 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/field/app_field_theme.dart:22 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/components/field/app_field_theme.dart:23 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/components/field/app_field_theme.dart:24 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/components/field/app_field_theme.dart:25 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/field/app_field_theme.dart:30 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric.dart:23 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/metric/app_metric.dart:85 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/metric/app_metric_theme.dart:18 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/metric/app_metric_theme.dart:19 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/metric/app_metric_theme.dart:20 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/components/metric/app_metric_theme.dart:21 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/components/metric/app_metric_theme.dart:22 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/metric/app_metric_theme.dart:29 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:30 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:32 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:39 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:41 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:50 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:51 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:68 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/metric/app_metric_theme.dart:73 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/navigation_item/app_navigation_item.dart:70 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart:12 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart:13 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart:14 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart:15 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart:16 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart:25 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart:37 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/notice/app_notice.dart:19 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/notice/app_notice_theme.dart:11 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper.dart:49 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper.dart:82 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper.dart:185 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper.dart:193 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper_theme.dart:16 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper_theme.dart:17 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper_theme.dart:18 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper_theme.dart:19 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/number_stepper/app_number_stepper_theme.dart:20 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/components/progress_indicator/app_progress_indicator.dart:11 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/qr_code/app_qr_code.dart:18 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/qr_code/app_qr_code_theme.dart:11 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/qr_code/app_qr_code_theme.dart:12 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/qr_code/app_qr_code_theme.dart:13 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/components/qr_code/app_qr_code_theme.dart:14 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/components/qr_code/app_qr_painter.dart:20 R-008.a: Сокращённое имя n: укажите назначение переменной полностью
lib/presentation/design_system/components/score/app_score.dart:26 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/score/app_score_theme.dart:12 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/score/app_score_theme.dart:13 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/components/score/app_score_theme.dart:14 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/components/score/app_score_theme.dart:16 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/score_choice/app_score_choice.dart:26 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/score_choice/app_score_choice.dart:83 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/score_choice/app_score_choice.dart:87 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/score_choice/app_score_choice_theme.dart:11 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/score_choice/app_score_choice_theme.dart:12 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/score_choice/app_score_choice_theme.dart:13 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/components/score_choice/app_score_choice_theme.dart:14 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/segmented_choice/app_segmented_choice.dart:76 R-008.a: Сокращённое имя o: укажите назначение переменной полностью
lib/presentation/design_system/components/segmented_choice/app_segmented_choice.dart:87 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/segmented_choice/app_segmented_choice.dart:150 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/segmented_choice/app_segmented_choice.dart:189 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/segmented_choice/app_segmented_choice_theme.dart:11 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/segmented_choice/app_segmented_choice_theme.dart:12 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/segmented_choice/app_segmented_choice_theme.dart:13 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/segmented_choice/app_segmented_choice_theme.dart:14 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select.dart:70 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select.dart:98 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select.dart:99 R-008.a: Сокращённое имя o: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_sheet.dart:26 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_sheet.dart:107 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_theme.dart:14 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_theme.dart:15 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_theme.dart:16 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_theme.dart:17 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_theme.dart:18 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_theme.dart:20 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/components/select/app_select_theme.dart:21 R-008.a: Сокращённое имя f: укажите назначение переменной полностью
lib/presentation/design_system/components/stage_progress/app_stage_progress.dart:9 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/stage_progress/app_stage_progress_theme.dart:7 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/stage_progress/app_stage_progress_theme.dart:7 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/status_label/app_status_label.dart:20 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/status_label/app_status_label_theme.dart:20 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/status_label/app_status_label_theme.dart:21 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/components/status_label/app_status_label_theme.dart:40 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/components/surface/app_surface_theme.dart:24 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/components/surface/app_surface_theme.dart:25 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/foundation/borders/app_border_metrics.dart:29 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/colors/app_status_colors.dart:47 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/elevation/app_elevation.dart:23 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/icons/app_glyph_metrics.dart:10 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/icons/app_icon_metrics.dart:37 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/icons/app_icon_theme.dart:23 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/foundation/icons/app_icon_theme.dart:24 R-008.a: Сокращённое имя g: укажите назначение переменной полностью
lib/presentation/design_system/foundation/layout/foundation_layout.dart:69 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/layout/foundation_sample_metrics.dart:32 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/motion/app_motion.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/motion/app_progress_metrics.dart:39 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_avatar_metrics.dart:85 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_bracket_metrics.dart:31 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:63 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:68 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:70 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:73 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:74 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:75 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:76 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_control_metrics.dart:78 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_dialog_metrics.dart:31 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_field_metrics.dart:33 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_field_metrics.dart:43 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_field_metrics.dart:45 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_field_metrics.dart:46 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_identity_metrics.dart:51 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_identity_metrics.dart:55 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_identity_metrics.dart:56 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_identity_metrics.dart:57 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_identity_metrics.dart:58 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_metric_metrics.dart:40 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_metric_metrics.dart:57 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_qr_metrics.dart:55 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_qr_metrics.dart:73 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_qr_metrics.dart:74 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_responsive.dart:61 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_roster_metrics.dart:16 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_score_metrics.dart:13 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:374 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:408 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:410 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:424 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:425 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:443 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:444 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:460 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_screen_metrics.dart:461 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_select_metrics.dart:55 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_select_metrics.dart:59 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_select_metrics.dart:71 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_select_metrics.dart:72 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_stepper_metrics.dart:31 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_stepper_metrics.dart:39 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_stepper_metrics.dart:40 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_stepper_metrics.dart:41 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_table_metrics.dart:19 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/responsive/app_table_metrics.dart:23 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/responsive/app_table_metrics.dart:25 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/shape/app_shape.dart:43 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/spacing/app_spacing.dart:53 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/typography/app_status_metrics.dart:12 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/typography/app_status_metrics.dart:17 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/foundation/typography/app_text_metrics.dart:18 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/foundation/typography/app_type_roles.dart:23 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid.dart:15 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid_theme.dart:7 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid_theme.dart:8 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid_theme.dart:9 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_map/app_bracket_map.dart:55 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_map/app_bracket_map.dart:103 R-008.a: Сокращённое имя x: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_map/app_bracket_map.dart:104 R-008.a: Сокращённое имя y: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_map/app_bracket_map_theme.dart:7 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_map/app_bracket_map_theme.dart:7 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_node/app_bracket_node.dart:24 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_node/app_bracket_node_theme.dart:19 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_node/app_bracket_node_theme.dart:20 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_node/app_bracket_node_theme.dart:21 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_node/app_bracket_node_theme.dart:22 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/widgets/bracket_node/app_bracket_node_theme.dart:23 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table.dart:20 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table.dart:97 R-008.a: Сокращённое имя p: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table_theme.dart:18 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table_theme.dart:19 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table_theme.dart:20 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table_theme.dart:21 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table_theme.dart:22 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/data_table/app_data_table_theme.dart:23 R-008.a: Сокращённое имя f: укажите назначение переменной полностью
lib/presentation/design_system/widgets/dialog/app_dialog.dart:25 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/dialog/app_dialog_theme.dart:15 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/dialog/app_dialog_theme.dart:16 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/dialog/app_dialog_theme.dart:17 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/dialog/app_dialog_theme.dart:18 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/dialog/app_dialog_theme.dart:19 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/widgets/dialog/app_dialog_theme.dart:20 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/widgets/disclosure/app_disclosure.dart:58 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/disclosure/app_disclosure_theme.dart:14 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/disclosure/app_disclosure_theme.dart:15 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/disclosure/app_disclosure_theme.dart:16 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/disclosure/app_disclosure_theme.dart:17 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/widgets/disclosure/app_disclosure_theme.dart:18 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/widgets/history_entry/app_history_entry.dart:23 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/history_entry/app_history_entry_theme.dart:11 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/history_entry/app_history_entry_theme.dart:12 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/design_system/widgets/history_entry/app_history_entry_theme.dart:14 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:38 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:39 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:40 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:41 R-008.a: Сокращённое имя a: укажите назначение переменной полностью
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:42 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:50 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:51 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:62 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:68 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:71 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:80 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:85 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:90 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:93 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:100 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/identity/app_identity_theme.dart:126 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/ranking_row/app_ranking_row.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:21 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:22 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:23 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:28 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:29 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:31 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:55 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:66 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/ranking_row/app_ranking_row_theme.dart:68 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/roster_row/app_roster_row.dart:83 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/roster_row/app_roster_row.dart:111 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/design_system/widgets/roster_row/app_roster_row.dart:115 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/roster_row/app_roster_row.dart:116 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/roster_row/app_roster_row_theme.dart:28 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/roster_row/app_roster_row_theme.dart:29 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/roster_row/app_roster_row_theme.dart:30 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/roster_row/app_roster_row_theme.dart:31 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/roster_row/app_roster_row_theme.dart:33 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_centered_screen.dart:19 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_modal_canvas.dart:19 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart:16 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart:17 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_layout.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_layout.dart:23 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_layout.dart:96 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/screen_layout/app_screen_layout.dart:150 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_layout.dart:154 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart:12 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart:13 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart:14 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_simple_form_layout.dart:17 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/screen_layout/app_simple_form_layout.dart:32 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/section_header/app_section_header.dart:43 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/section_header/app_section_header.dart:70 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/design_system/widgets/section_header/app_section_header_theme.dart:10 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/section_header/app_section_header_theme.dart:11 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/section_header/app_section_header_theme.dart:12 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/design_system/widgets/share_link/app_share_link.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/share_link/app_share_link_theme.dart:9 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/design_system/widgets/share_link/app_share_link_theme.dart:10 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/design_system/widgets/share_link/app_share_link_theme.dart:11 R-008.a: Сокращённое имя r: укажите назначение переменной полностью
lib/presentation/screens/about/about_screen.dart:23 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/about/about_screen.dart:24 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/bootstrap/bootstrap_screen.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/bootstrap/bootstrap_screen.dart:23 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/bootstrap/bootstrap_screen.dart:64 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/screens/bootstrap/bootstrap_screen.dart:66 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/screens/bootstrap/bootstrap_screen_theme.dart:8 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/screens/bootstrap/bootstrap_screen_theme.dart:11 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/screens/bracket/bracket_screen.dart:30 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/bracket/bracket_screen.dart:31 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/champion/champion_screen.dart:26 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/champion/champion_screen.dart:27 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/champion/champion_screen_theme.dart:8 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/champion/champion_screen_theme.dart:8 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/screens/contact/contact_screen.dart:27 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/contact/contact_screen.dart:28 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/distribution/distribution_screen.dart:29 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/distribution/distribution_screen.dart:30 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/forfeit/forfeit_screen.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/forfeit/forfeit_screen.dart:23 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/guest_add/guest_add_screen.dart:26 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/guest_add/guest_add_screen.dart:27 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/guest_remove/guest_remove_screen.dart:20 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/guest_remove/guest_remove_screen.dart:21 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/history/history_screen.dart:25 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/history/history_screen.dart:26 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/home/home_screen.dart:28 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/home/home_screen.dart:29 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/home/home_screen.dart:120 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/screens/home/home_screen.dart:135 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/screens/home/home_screen_theme.dart:8 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/screens/match_result/match_result_screen.dart:40 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/match_result/match_result_screen.dart:41 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/match_result/match_result_screen_theme.dart:10 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/match_result/match_result_screen_theme.dart:11 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/screens/participant_access/participant_access_screen.dart:20 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/participant_access/participant_access_screen.dart:21 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/profile/profile_screen.dart:38 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/profile/profile_screen.dart:39 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/profile/profile_screen.dart:83 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/screens/profile/profile_screen.dart:192 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/screens/profile_edit/profile_edit_screen.dart:25 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/profile_edit/profile_edit_screen.dart:26 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/results/results_screen.dart:28 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/results/results_screen.dart:29 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/results/results_screen_theme.dart:7 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/results/results_screen_theme.dart:7 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/screens/result_locked/result_locked_screen.dart:24 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/result_locked/result_locked_screen.dart:25 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/roster/roster_screen.dart:27 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/roster/roster_screen.dart:28 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/settings/settings_screen.dart:24 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/settings/settings_screen.dart:25 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/setup/setup_screen.dart:32 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/setup/setup_screen.dart:33 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/setup/setup_screen_theme.dart:7 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/screens/spectator_access/spectator_access_screen.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/spectator_access/spectator_access_screen.dart:23 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/tie/tie_screen.dart:28 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/tie/tie_screen.dart:29 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/tournament/tournament_screen.dart:30 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/tournament/tournament_screen.dart:31 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/tournament/tournament_screen_theme.dart:8 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/utility/utility_screen.dart:23 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/utility/utility_screen.dart:24 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/screens/withdraw/withdraw_screen.dart:22 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/screens/withdraw/withdraw_screen.dart:23 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/comparison/comparison_catalog.dart:71 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/widgetbook/comparison/comparison_spec.dart:66 R-008.a: Сокращённое имя p: укажите назначение переменной полностью
lib/presentation/widgetbook/comparison/comparison_spec.dart:118 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
lib/presentation/widgetbook/comparison/comparison_spec.dart:155 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/widgetbook/components/avatar/avatar_comparison.dart:98 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
lib/presentation/widgetbook/components/button/button_fixture.dart:58 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/field/field_fixture.dart:26 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/field/field_fixture.dart:30 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/field/field_fixture.dart:41 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/field/field_fixture.dart:45 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/field/field_fixture.dart:65 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/metric/metric_comparison.dart:67 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/metric/metric_fixture.dart:16 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/metric/metric_fixture.dart:23 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/navigation_item/navigation_comparison.dart:17 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/components/navigation_item/navigation_comparison.dart:70 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/components/navigation_item/navigation_fixture.dart:52 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/notice/notice_comparison.dart:38 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/notice/notice_fixture.dart:15 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/notice/notice_fixture.dart:19 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/number_stepper/stepper_comparison.dart:53 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/components/number_stepper/stepper_fixture.dart:76 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/number_stepper/stepper_fixture.dart:86 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/number_stepper/stepper_fixture.dart:87 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/number_stepper/stepper_fixture.dart:94 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/number_stepper/stepper_fixture.dart:95 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/score/score_fixture.dart:17 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/score_choice/score_choice_fixture.dart:35 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/segmented_choice/segmented_fixture.dart:53 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/select/select_comparison.dart:113 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/components/select/select_comparison.dart:151 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/components/select/select_fixture.dart:14 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/select/select_fixture.dart:67 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/select/select_fixture.dart:68 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/components/status_label/status_comparison.dart:25 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/status_label/status_comparison.dart:29 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/components/status_label/status_fixture.dart:12 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/components/surface/surface_fixture.dart:13 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/components/surface/surface_fixture.dart:13 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/borders/borders_comparison.dart:48 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/foundation/borders/catalog/catalog_use_case.dart:38 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/borders/catalog/catalog_use_case.dart:39 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/borders/catalog/catalog_use_case.dart:40 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/colors/colors_comparison.dart:360 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/colors/colors_comparison.dart:360 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/elevation/elevation_comparison.dart:74 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/elevation/elevation_comparison.dart:75 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/elevation/elevation_comparison.dart:76 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/elevation/elevation_comparison.dart:77 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/elevation/scrim/scrim_use_case.dart:19 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/elevation/scrim/scrim_use_case.dart:19 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/responsive/responsive_comparison.dart:20 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/shape/shape_comparison.dart:80 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/shape/shape_comparison.dart:81 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/shape/shape_comparison.dart:82 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/spacing/spacing_comparison.dart:56 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/spacing/spacing_comparison.dart:57 R-008.a: Сокращённое имя s: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/spacing/spacing_comparison.dart:58 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/typography/typography_comparison.dart:76 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/foundation/typography/typography_comparison.dart:78 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/bracket/bracket_fixture.dart:443 R-008.a: Сокращённое имя m: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/match_result/match_result_fixture.dart:41 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/match_result/match_result_fixture.dart:55 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/match_result/match_result_fixture.dart:59 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/match_result/match_result_fixture.dart:62 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/match_result/match_result_fixture.dart:64 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/match_result/match_result_fixture.dart:74 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/match_result/match_result_fixture.dart:96 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/results/results_fixture.dart:16 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/results/results_fixture.dart:25 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/results/results_fixture.dart:90 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/results/results_fixture.dart:103 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/setup/setup_fixture.dart:27 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/setup/setup_fixture.dart:36 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/setup/setup_fixture.dart:41 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/setup/setup_fixture.dart:46 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/setup/setup_fixture.dart:58 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/spectator_access/spectator_access_fixture.dart:12 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/tie/tie_fixture.dart:12 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/tournament/tournament_fixture.dart:16 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/screens/tournament/tournament_fixture.dart:119 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/screens/utility/distribution/distribution_use_case.dart:15 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/bracket_node/bracket_comparison.dart:57 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/bracket_node/bracket_comparison.dart:106 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/bracket_node/bracket_fixture.dart:17 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/bracket_node/bracket_fixture.dart:30 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/widgets/data_table/table_comparison.dart:48 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/data_table/table_comparison.dart:61 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/data_table/table_fixture.dart:11 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/dialog/dialog_comparison.dart:77 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/dialog/dialog_fixture.dart:20 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/dialog/overlay/overlay_use_case.dart:51 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/disclosure/disclosure_fixture.dart:33 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/ranking_row/default/default_use_case.dart:19 R-008.a: Сокращённое имя t: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/roster_row/roster_comparison.dart:22 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/widgets/roster_row/roster_comparison.dart:24 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/widgets/section_header/header_comparison.dart:25 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/widgets/section_header/header_comparison.dart:44 R-008.b: Вложенный ?: запрещён; выделите именованный метод с явными if/switch
lib/presentation/widgetbook/widgets/section_header/header_fixture.dart:19 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
lib/presentation/widgetbook/widgets/share_link/share_fixture.dart:11 R-008.a: Сокращённое имя l: укажите назначение переменной полностью
test/presentation/design_system/components/avatar/avatar_visual_test.dart:107 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/components/field/app_field_test.dart:61 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
test/presentation/design_system/components/field/app_field_test.dart:79 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
test/presentation/design_system/components/field/app_field_test.dart:110 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
test/presentation/design_system/components/field/app_field_test.dart:126 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/components/field/app_field_test.dart:133 R-008.a: Сокращённое имя w: укажите назначение переменной полностью
test/presentation/design_system/components/number_stepper/app_number_stepper_test.dart:114 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
test/presentation/design_system/components/qr_code/app_qr_code_test.dart:84 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
test/presentation/design_system/components/qr_code/qr_matrix_encoder_test.dart:42 R-008.a: Сокращённое имя a: укажите назначение переменной полностью
test/presentation/design_system/components/score/app_score_test.dart:63 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/components/surface/app_surface_test.dart:53 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/foundation/borders/app_borders_test.dart:39 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/foundation/elevation/app_elevation_test.dart:71 R-008.a: Сокращённое имя w: укажите назначение переменной полностью
test/presentation/design_system/foundation/icons/app_icon_test.dart:50 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/foundation/motion/app_motion_test.dart:103 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/foundation/responsive/app_responsive_test.dart:86 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/foundation/shape/app_shape_test.dart:71 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/foundation/spacing/app_spacing_test.dart:65 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/foundation/theme_propagation_test.dart:121 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/design_system/widgets/roster_row/app_roster_row_test.dart:243 R-008.a: Сокращённое имя e: укажите назначение переменной полностью
test/presentation/foundation_preview_test.dart:109 R-008.a: Сокращённое имя a: укажите назначение переменной полностью
test/presentation/foundation_preview_test.dart:110 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:65 R-008.a: Сокращённое имя f: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:314 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:323 R-008.a: Сокращённое имя y: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:324 R-008.a: Сокращённое имя x: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:325 R-008.a: Сокращённое имя i: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:327 R-008.a: Сокращённое имя c: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:328 R-008.a: Сокращённое имя a: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:331 R-008.a: Сокращённое имя b: укажите назначение переменной полностью
test/visual_comparison/component_comparison_test.dart:334 R-008.a: Сокращённое имя d: укажите назначение переменной полностью
```
