import '../participant_identity/participant_identity.dart';
import 'standing_row_view_data.dart';

const previewStandingsRows = [
  StandingRowViewData(
    placeLabel: '1',
    participant: previewIvan,
    resultLabel: 'Чемпион',
  ),
  StandingRowViewData(
    placeLabel: '2',
    participant: previewMira,
    resultLabel: 'Финалист',
  ),
  StandingRowViewData(
    placeLabel: '3–4',
    participant: previewGuest,
    resultLabel: 'Место требует переигровки',
    tieBreakLabel: 'Переигровка',
  ),
  StandingRowViewData(
    placeLabel: '—',
    participant: previewAlex,
    resultLabel: 'Место ещё не определено',
  ),
];
