import {icon} from './ui-kit-library.js?v=13';

// Только взаимодействие визуального образца: одна панель на все mobile triggers.
class MobileSelectSheet {
  constructor() {
    this.trigger = null;
    this.dialog = document.createElement('dialog');
    this.dialog.className = 'kit-select-sheet';
    this.dialog.setAttribute('aria-labelledby', 'kit-select-sheet-title');
    this.dialog.innerHTML = `<div class="kit-sheet-handle" aria-hidden="true"></div><header><h2 id="kit-select-sheet-title">Оформление</h2><button type="button" class="kit-sheet-close" aria-label="Закрыть выбор оформления">${icon('close')}</button></header><p class="kit-sheet-description">Выбери оформление интерфейса</p><div class="kit-sheet-options" role="group" aria-label="Варианты оформления">${['Тёмное','Светлое','Как в системе'].map(label=>`<button type="button" class="kit-sheet-option" aria-pressed="false"><span>${label}</span>${icon('check')}</button>`).join('')}</div>`;
    document.body.append(this.dialog);
    this.dialog.addEventListener('click', this.handleDialogClick.bind(this));
    this.dialog.addEventListener('close', this.handleClosed.bind(this));
    this.dialog.querySelector('.kit-sheet-close').addEventListener('click', this.close.bind(this));
    for (const trigger of document.querySelectorAll('[data-mobile-select]')) {
      trigger.addEventListener('click', this.handleOpen.bind(this));
    }
  }

  handleOpen(event) {
    this.trigger = event.currentTarget;
    const value = this.trigger.querySelector('[data-selected-value]').textContent;
    for (const option of this.dialog.querySelectorAll('.kit-sheet-option')) {
      option.setAttribute('aria-pressed', String(option.querySelector('span').textContent === value));
    }
    this.trigger.setAttribute('aria-expanded', 'true');
    document.documentElement.classList.add('kit-sheet-open');
    this.dialog.showModal();
    this.dialog.querySelector('[aria-pressed="true"]').focus();
  }

  handleDialogClick(event) {
    const option = event.target.closest('.kit-sheet-option');
    if (option) {
      this.trigger.querySelector('[data-selected-value]').textContent = option.querySelector('span').textContent;
      this.close();
      return;
    }
    if (event.target === this.dialog) {
      const rect = this.dialog.getBoundingClientRect();
      if (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom) this.close();
    }
  }

  close() {
    this.dialog.close();
  }

  handleClosed() {
    document.documentElement.classList.remove('kit-sheet-open');
    this.trigger?.setAttribute('aria-expanded', 'false');
    this.trigger?.focus();
  }
}

export function mountMobileSelectSheet() {
  return new MobileSelectSheet();
}
