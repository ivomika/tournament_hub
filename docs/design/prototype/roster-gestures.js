// Только раскрытие визуального действия: состав турнира не изменяется.
const swipeThreshold = 24;
const horizontalIntentRatio = 1.5;

document.querySelectorAll('.flow-roster-gesture').forEach(function attachRosterGesture(row) {
  let origin = null;

  row.addEventListener('pointerdown', function beginSwipe(event) {
    if (!event.isPrimary || event.button !== 0 || event.target.closest('a')) return;
    origin = { x: event.clientX, y: event.clientY, pointerId: event.pointerId };
  });

  row.addEventListener('pointermove', function revealSwipe(event) {
    if (!origin || event.pointerId !== origin.pointerId) return;
    const dx = event.clientX - origin.x;
    const dy = event.clientY - origin.y;
    if (Math.abs(dx) < swipeThreshold || Math.abs(dx) <= Math.abs(dy) * horizontalIntentRatio) return;
    row.classList.toggle('is-revealed', dx < 0);
  });

  function endSwipe() { origin = null; }
  row.addEventListener('pointerup', endSwipe);
  row.addEventListener('pointercancel', endSwipe);
  row.addEventListener('pointerleave', endSwipe);
  row.addEventListener('keydown', function dismissSwipe(event) {
    if (event.key !== 'Escape') return;
    row.classList.remove('is-revealed');
    if (document.activeElement instanceof HTMLElement && row.contains(document.activeElement)) {
      document.activeElement.blur();
    }
  });
});
