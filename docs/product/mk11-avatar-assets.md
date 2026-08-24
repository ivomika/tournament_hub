# Chibi avatars Mortal Kombat 11 Ultimate

Набор содержит 37 локальных PNG — по одному для каждого stable fighter ID из `Mk11UltimateFighterRegistry`. Изображения создавались встроенным image generation workflow отдельным prompt для каждого персонажа, затем были нормализованы до 512×512 RGBA.

## Визуальная спецификация

- premium 3D chibi game character render;
- голова и верхняя часть корпуса, единый масштаб и safe area;
- мягкий нейтральный студийный свет с тёплым rim light;
- прозрачный фон, без рамки, текста, логотипов и watermark;
- без крови, gore и оружия, пересекающего crop;
- canonical color и узнаваемые costume cues конкретного бойца.

Базовый prompt относится к use case `stylized-concept`; к нему добавляется отдельное описание персонажа. Для Joker использована нейтральная формулировка «theatrical comic-book mastermind», поскольку более буквальные варианты дважды отклонялись safety-фильтром на этапе генерации результата.

## Runtime-контракт

`FighterAvatarResolver` скрывает конкретные пути от UI. Bundled-реализация разрешает `FighterAvatarId` в `assets/fighters/<id>.png`. `manifest.json` фиксирует версию, формат, размер и соответствие ID; автоматический тест проверяет roster, manifest, наличие файлов, PNG signature, dimensions и alpha color type.
