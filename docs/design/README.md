# Design system

## Direction

`Competitive / Cinematic / Clean`: информация и следующее действие важнее декора; dark-first; fighter artwork является частью identity. Flutter mobile-first с перестройкой desktop composition. Spectator web desktop-first и читается с расстояния.

## Token source

Visual values задаются semantic tokens в одном versioned source и экспортируются во Flutter/Web. Literal values в component запрещены, кроме документированного artwork/platform/math exception.

### Spacing

Base 4 px: `0=0`, `1=4`, `2=8`, `3=12`, `4=16`, `5=20`, `6=24`, `8=32`, `10=40`, `12=48`, `16=64`, `20=80`, `24=96`.

### Breakpoints

| Class | Width | Composition |
|---|---:|---|
| compact | <600 | single column, bottom navigation, 16 px page padding |
| medium | 600–959 | 24–32 px padding, selective two-column |
| expanded | 960–1279 | navigation rail, master/detail where useful |
| large | 1280–1599 | dense operational panels, 32–48 px padding |
| xlarge | ≥1600 | centered max width, no uncontrolled stretch |

Host content max 1200–1440; Spectator 1440–1600. Layout branches by available width, not OS name. Text scale and split-screen can force a narrower composition.

### Typography

| Token | Size/line | Weight | Use |
|---|---|---:|---|
| display.xl/lg/md | 56/64, 48/56, 40/48 | 700 | Spectator/champion only |
| heading.xl/lg/md/sm | 32/40, 28/36, 24/32, 20/28 | 600–700 | page/section/card hierarchy |
| body.lg/md/sm | 18/28, 16/24, 14/20 | 400–500 | content |
| label.lg/md/sm | 16/20, 14/20, 12/16 | 600 | control/badge |

Score/table uses tabular figures. Font family/fallback remains OD-011; до решения platform fonts не должны создавать layout assumptions.

### Colors

| Token | Value |
|---|---|
| bg.canvas/subtle/elevated | `#0B0D10` / `#111419` / `#171B21` |
| surface.primary/secondary/tertiary/hover | `#15191F` / `#1B2027` / `#232A33` / `#29313B` |
| text.primary/secondary/tertiary/disabled | `#F5F7FA` / `#B9C0CA` / `#7F8996` / `#58616D` |
| accent.primary | `#F0B429` |
| status.success/danger/warning/info | `#36C98F` / `#F05D5E` / `#F5A623` / `#4DA3FF` |

Нужно добавить semantic `border.*`, `focus.ring`, `overlay.scrim`, `surface/status container` пары до component implementation. `text.disabled` не несёт значимой информации. Цвет всегда дополнен text/icon/shape.

### Shape/elevation

Radius: 6/10/14/20/full. Base border 1 px semantic. Разделение: surface tone → border → spacing → shadow. Heavy glow/blur не baseline.

### Motion

120/200/320/450 ms (`fast/normal/slow/presentation`). Motion объясняет state change. Infinite blinking/glow/autoplay запрещены. Reduced Motion заменяет movement на fade/instant change без потери информации.

## Interaction

- Mobile target минимум 44×44, предпочтительно 48×48.
- Standard control height 44–48; compact 36–40 только при сохранении target; large 52–56.
- В visual region одна dominant Primary action.
- Destructive action отделена, описывает последствие и требует confirmation.
- Disabled action по возможности сопровождается причиной.
- Keyboard order совпадает с visual/logical order; visible focus обязателен.
- Hover не раскрывает единственный путь к информации/action.

## Core components

Каждый component имеет default, hover/focus/pressed, disabled, loading и error semantics по необходимости.

- `ParticipantIdentity`: до assignment nickname/status; после — artwork + fighter name + nickname + Guest badge.
- `FighterAvatar`: stable crop variants, semantic label, fallback/placeholder.
- `MatchCard/CurrentMatch`: stage, identities, score/result type, Current emphasis, permitted actions.
- `StandingsTable`: place, identity, points/tie context; table desktop, compact rows/scroll mobile.
- `Bracket`: relationships первичны, затем identity/result/metadata; pan/zoom/keyboard альтернативы.
- `StatusBadge`: text + icon/shape, не color-only.
- `ConnectionBanner`: live/reconnecting/stale/incompatible и recovery.
- `Empty/ErrorState`: конкретная причина и одно recovery action.
- `ConfirmationDialog`: объект, необратимое последствие, safe default focus.
- `ChampionHero`: fighter identity, champion participant, tournament context; не скрывает ranking.

## Screen compositions

- Main: active state и next action above fold; create/join только когда разрешены.
- Draft: form + persistent summary; validation рядом с field.
- Open: roster primary, connection card secondary на compact; requests/actions отделены.
- Distribution: full identity grid/list; `Reroll All`; start confirmation.
- Running: Current match strongest; tournament structure and progress below/alongside by width.
- Result entry: two unambiguous identities; technical action отделено; correction condition visible.
- Finished: champion hero + complete ranking + Main/History.
- History: scannable list + adaptive detail; snapshot read-only obvious.
- Spectator: large typography, previous/current/next, connection state, no controls resembling mutation.

## Participant identity rule

После Distribution любое упоминание participant в tournament context обязано включать fighter asset, fighter name и participant nickname. Это касается cards, current/next, standings, bracket slots, results, dialogs, notifications where image possible, history и spectator. Compact variant может уменьшать artwork, но не удалять fighter name.

## Loading, error and stale

- Loading локален; existing content не исчезает без необходимости.
- Optimistic mutation допускается только если rollback и authoritative reconciliation формализованы; по умолчанию success показывается после commit.
- Error не показывает exception/stack; сохраняет введённые данные и предлагает retry/correction.
- Offline/stale сохраняет last-known data, блокирует mutation и явно показывает время/состояние sync.
- Empty отличается от loading и permission denied.

## Accessibility gates

- Normal text ≥4.5:1, large ≥3:1; interactive/non-text boundaries ≥3:1 где применимо.
- Semantic labels содержат fighter, nickname, status и score.
- Text scale 200% не обрезает critical actions/data.
- Keyboard и screen reader проходят основной Host/Participant flow.
- Focus не теряется после async update; dialogs возвращают focus trigger.
- Touch, color, motion, sound и hover не являются единственным carrier.
- Locale strings не собираются конкатенацией, допускают длинный русский текст.

## Visual QA checklist

Проверяются все width classes, 100/200% text scale, long nickname/title, missing artwork, empty/error/loading/stale, keyboard focus, reduced motion, high contrast и screenshot/golden ключевых components. Изменение token требует Flutter+Web regression review.
