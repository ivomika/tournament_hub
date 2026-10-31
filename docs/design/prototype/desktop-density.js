// Только визуальные stress fixtures. Не рассчитывает турнир, места или результаты.
(() => {
  const requestedCount = new URLSearchParams(location.search).get('items');
  const count = requestedCount === '24' ? 24 : requestedCount === '48' ? 48 : 0;
  const controls = document.createElement('nav');
  controls.className = 'density-controls';
  controls.setAttribute('aria-label', 'Плотность демонстрационных данных');
  const title = document.createElement('span');
  title.textContent = 'Проверка списков:';
  controls.append(title);
  for (const option of [{ label: 'Исходные', value: 0 }, { label: '24 элемента', value: 24 }, { label: '48 элементов', value: 48 }]) {
    const link = document.createElement('a');
    link.textContent = option.label;
    link.href = `${location.pathname}${option.value ? `?items=${option.value}` : ''}${location.hash}`;
    if (option.value === count) link.setAttribute('aria-current', 'page');
    controls.append(link);
  }
  document.querySelector('.gallery-header').append(controls);
  if (!count) return;
  document.body.classList.add('is-density-preview');
  const notice = document.createElement('output');
  notice.className = 'density-preview-label';
  notice.textContent = 'Синтетические данные: проверка layout, не модель турнира';
  controls.append(notice);

  function populate(container, selector, decorate) {
    if (!container) return;
    const templates = [...container.querySelectorAll(selector)];
    if (!templates.length) return;
    for (const item of templates) item.remove();
    for (let index = 0; index < count; index += 1) {
      const item = templates[index % templates.length].cloneNode(true);
      item.removeAttribute('id');
      item.querySelectorAll('[id]').forEach(element => element.removeAttribute('id'));
      decorate(item, index);
      container.append(item);
    }
  }
  function playerName(index) {
    return index % 6 === 0 ? `Участник ${index + 1} с очень длинным никнеймом` : `Участник ${index + 1}`;
  }
  populate(document.querySelector('#lobby-roster .flow-roster'), ':scope > li', (item, index) => {
    item.querySelector('.flow-person strong').textContent = playerName(index);
    const remove = item.querySelector('.flow-roster-remove');
    remove.setAttribute('aria-label', `Удалить участника: ${playerName(index)}`);
    remove.title = remove.getAttribute('aria-label');
  });
  document.querySelector('#lobby-roster .bento-roster-context .flow-caption').textContent = `Пятничный турнир · ${count} гостей`;
  populate(document.querySelector('#distribution-ready .bento-assigned'), ':scope > .flow-player-row', (item, index) => {
    item.querySelector('.flow-person small').textContent = playerName(index);
  });
  populate(document.querySelector('#history-list .desktop-secondary'), ':scope > .flow-history-row', (item, index) => {
    item.querySelector('h3').textContent = index % 4 === 0 ? `Турнир ${index + 1} — длинное название вечернего чемпионата` : `Турнир ${index + 1}`;
    item.querySelector('.flow-person small').textContent = playerName(index);
  });
  document.querySelectorAll('.bento-results .flow-ranking').forEach(list => {
    populate(list, ':scope > li', (item, index) => {
      item.querySelector('.flow-person small').textContent = playerName(index);
      const place = item.querySelector('.flow-place');
      // Нумерация синтетического списка — не расчёт итоговых мест формата.
      if (place) place.textContent = String(index + 1);
    });
    const context = list.closest('.bento-results').querySelector('.competition-context');
    context.textContent = `Синтетический список · ${count} участников`;
  });
  document.querySelectorAll('.flow-standings tbody').forEach(body => {
    populate(body, ':scope > tr', (item, index) => {
      item.querySelector('.flow-person small').textContent = playerName(index);
    });
    body.closest('table').querySelector('caption').textContent = `Демонстрационная таблица · ${count} строк`;
  });
})();
