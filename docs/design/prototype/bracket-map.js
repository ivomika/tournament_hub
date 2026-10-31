document.querySelectorAll('[data-bracket-map]').forEach(function initializeBracket(map) {
  const viewport = map.querySelector('.bracket-map-viewport');
  const canvas = map.querySelector('.bracket-map-canvas');
  const space = map.querySelector('.bracket-map-space');
  const output = map.querySelector('output');
  const current = canvas.querySelector('.is-current');
  let scale = 1;
  const width = canvas.classList.contains('is-se') ? 840 : 1420;
  const height = canvas.classList.contains('is-se') ? 720 : 1000;
  function renderScale() {
    canvas.style.transform = `scale(${scale})`;
    space.style.width = `${width * scale}px`;
    space.style.height = `${height * scale}px`;
    output.value = `${Math.round(scale * 100)}%`;
    map.querySelector('[data-map-action="minus"]').disabled = scale <= .2;
    map.querySelector('[data-map-action="plus"]').disabled = scale >= 1.6;
  }
  function zoomTo(next) {
    const x = (viewport.scrollLeft + viewport.clientWidth / 2) / scale;
    const y = (viewport.scrollTop + viewport.clientHeight / 2) / scale;
    scale = Math.max(.2, Math.min(1.6, next));
    renderScale();
    viewport.scrollLeft = x * scale - viewport.clientWidth / 2;
    viewport.scrollTop = y * scale - viewport.clientHeight / 2;
  }
  function focusCurrent() {
    scale = 1;
    renderScale();
    viewport.scrollLeft = current.offsetLeft + current.offsetWidth / 2 - viewport.clientWidth / 2;
    viewport.scrollTop = current.offsetTop + current.offsetHeight / 2 - viewport.clientHeight / 2;
  }
  function handleMapClick(event) {
    const control = event.target.closest('[data-map-action]');
    if (control) {
      switch (control.dataset.mapAction) {
        case 'minus': zoomTo(scale - .15); break;
        case 'plus': zoomTo(scale + .15); break;
        case 'fit': scale = Math.min(viewport.clientWidth / width, viewport.clientHeight / height); renderScale(); viewport.scrollTo(0, 0); break;
        case 'current': focusCurrent(); break;
        case 'fullscreen':
          if (document.fullscreenElement === map) document.exitFullscreen();
          else if (map.requestFullscreen) map.requestFullscreen().catch(function reportFullscreen() { map.querySelector('.bracket-map-detail').textContent = 'Полноэкранный режим недоступен в этом браузере.'; });
          break;
      }
      if (control.dataset.mapAction !== 'minus' && control.dataset.mapAction !== 'plus') {
        map.querySelector('.bracket-map-controls').open = false;
      }
    }
    const match = event.target.closest('.bracket-map-match');
    if (match) {
      map.querySelector('.bracket-map-controls').open = false;
      canvas.querySelectorAll('.is-selected').forEach(function clearSelection(item) { item.classList.remove('is-selected'); });
      match.classList.add('is-selected');
      map.querySelector('.bracket-map-detail').textContent = match.dataset.detail;
    }
  }
  map.addEventListener('click', handleMapClick);
  requestAnimationFrame(focusCurrent);
});
