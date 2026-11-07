// Только раскрытие визуального действия: состав турнира не изменяется.
(function mountRosterGestures() {
  const swipeThreshold = 24;
  const horizontalIntentRatio = 1.5;

  document.querySelectorAll('.flow-roster-gesture').forEach(function attachRosterGesture(row) {
    let origin = null;
    let dragged = false;
    const action = row.querySelector('.flow-roster-remove');
    if (row.closest('.desktop-screen')) {
      row.tabIndex = -1;
      row.classList.remove('is-revealed');
      action.tabIndex = 0;
      action.removeAttribute('aria-hidden');
      return;
    }
    row.tabIndex = 0;
    row.setAttribute('aria-keyshortcuts', 'ArrowLeft ArrowRight Escape');

    function setRevealed(revealed) {
      row.classList.toggle('is-revealed', revealed);
      action.tabIndex = revealed ? 0 : -1;
      action.setAttribute('aria-hidden', String(!revealed));
    }
    setRevealed(row.classList.contains('is-revealed'));

    function beginSwipe(event) {
      dragged = false;
      if (!event.isPrimary || event.button !== 0 || event.target.closest('a,button')) return;
      origin = {
        x: event.clientX, y: event.clientY, pointerId: event.pointerId,
        revealed: row.classList.contains('is-revealed'),
        width: parseFloat(getComputedStyle(row).getPropertyValue('--flow-roster-action-width')),
      };
    }

    function moveSwipe(event) {
      if (!origin || event.pointerId !== origin.pointerId) return;
      const dx = event.clientX - origin.x;
      const dy = event.clientY - origin.y;
      if (!dragged) {
        if (Math.abs(dy) > 8 && Math.abs(dy) >= Math.abs(dx)) { origin = null; return; }
        if (Math.abs(dx) < 8 || Math.abs(dx) <= Math.abs(dy) * horizontalIntentRatio) return;
        dragged = true;
        row.setPointerCapture(event.pointerId);
        row.classList.add('is-dragging');
      }
      const offset = Math.max(-origin.width, Math.min(0, (origin.revealed ? -origin.width : 0) + dx));
      row.style.setProperty('--roster-drag-offset', `${offset}px`);
    }

    function finishSwipe(event) {
      if (!origin || event.pointerId !== origin.pointerId) return;
      const dx = event.clientX - origin.x;
      const revealed = event.type === 'pointercancel' || !dragged || Math.abs(dx) < swipeThreshold
        ? origin.revealed : dx < 0;
      setRevealed(revealed);
      row.classList.remove('is-dragging');
      row.style.removeProperty('--roster-drag-offset');
      if (row.hasPointerCapture(event.pointerId)) row.releasePointerCapture(event.pointerId);
      origin = null;
    }

    function suppressDragClick(event) {
      if (!dragged) return;
      event.preventDefault();
      event.stopPropagation();
      dragged = false;
    }

    function handleKey(event) {
      if (event.key === 'ArrowLeft') { event.preventDefault(); setRevealed(true); }
      if (event.key === 'ArrowRight' || event.key === 'Escape') {
        event.preventDefault();
        setRevealed(false);
        row.focus();
      }
    }
    row.addEventListener('pointerdown', beginSwipe);
    row.addEventListener('pointermove', moveSwipe);
    row.addEventListener('pointerup', finishSwipe);
    row.addEventListener('pointercancel', finishSwipe);
    row.addEventListener('click', suppressDragClick, true);
    row.addEventListener('keydown', handleKey);
  });
})();
