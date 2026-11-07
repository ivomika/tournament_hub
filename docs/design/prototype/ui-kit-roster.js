import {dialog} from './ui-kit-library.js?v=21';

// UI-kit демонстрация подтверждения. Данные турнира не затрагиваются.
class RosterConfirmation {
  constructor() {
    this.row = null;
    this.returnFocus = null;
    this.dialog = document.createElement('dialog');
    this.dialog.className = 'kit-roster-confirm';
    this.dialog.setAttribute('aria-label', 'Подтверждение удаления участника');
    this.dialog.innerHTML = dialog({title:'Удалить участника?',text:'Участник будет исключён из состава турнира.',action:'Удалить'});
    document.body.append(this.dialog);
    this.dialog.querySelector('.flow-danger-action').addEventListener('click', this.confirm.bind(this));
    this.dialog.querySelector('.secondary-action').addEventListener('click', this.cancel.bind(this));
    this.dialog.addEventListener('close', this.handleClosed.bind(this));
    for (const button of document.querySelectorAll('.kit-roster-example .flow-roster-remove')) {
      button.addEventListener('click', this.open.bind(this));
    }
  }

  open(event) {
    event.preventDefault();
    this.row = event.currentTarget.closest('.flow-roster-gesture');
    this.returnFocus = event.currentTarget;
    const name = this.row.querySelector('.flow-person strong').textContent;
    this.dialog.querySelector('h2').textContent = `Удалить участника «${name}»?`;
    document.documentElement.classList.add('kit-sheet-open');
    this.dialog.showModal();
    this.dialog.querySelector('.secondary-action').focus();
  }

  confirm() {
    const result = document.createElement('li');
    result.className = 'kit-roster-removed';
    const text = document.createElement('p');
    text.setAttribute('role', 'status');
    text.textContent = 'Участник удалён';
    const restore = document.createElement('button');
    restore.type = 'button';
    restore.textContent = 'Восстановить пример';
    restore.className = 'secondary-action';
    const row = this.row;
    function restoreExample() {
      row.hidden = false;
      result.remove();
      row.querySelector('.flow-roster-remove').focus();
    }
    restore.addEventListener('click', restoreExample);
    result.append(text, restore);
    this.row.hidden = true;
    this.row.after(result);
    this.returnFocus = restore;
    this.dialog.close();
  }

  cancel() { this.dialog.close(); }

  handleClosed() {
    document.documentElement.classList.remove('kit-sheet-open');
    this.returnFocus?.focus();
  }
}

export function mountRosterConfirmation() { return new RosterConfirmation(); }
