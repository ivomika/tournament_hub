import * as C from './ui-kit-library.js?v=21';
import {mountMobileSelectSheet} from './ui-kit-select.js?v=21';
import {mountRosterConfirmation} from './ui-kit-roster.js?v=21';
const {Style,State,Density,Identity,Row}=C;
const e=C.esc;
let partCount=0;
function sample(html,{title='',desktop=false,context=''}={}){return `<div class="kit-specimen"><div class="kit-caption">${e(title)}</div><div class="kit-scope ${desktop?'desktop-gallery':''}"><div class="kit-context flow-screen ${desktop?'desktop-screen':''} ${context}">${html}</div></div></div>`;}
function variant(title,html,options={}){return sample(html,{title,...options});}
function part(name,purpose,rows,render,{context='',note='',desktopRender=render}={}){
 const id=`kit-part-${++partCount}`;
 const adaptation=render?`<details class="kit-adaptation" open><summary>Адаптация</summary>${sample(render(),{title:'Mobile',context})}${sample(desktopRender(),{title:'Desktop',desktop:true,context})}</details>`:'';
 return `<section class="kit-component" aria-labelledby="${id}"><header><span class="kit-component-mark">◇</span><h4 id="${id}">${e(name)}</h4></header><p class="kit-purpose">${e(purpose)}</p><div class="kit-component-states">${rows.join('')}</div>${adaptation}${note?`<p class="kit-note">${e(note)}</p>`:''}</section>`;
}
const families=[];
function family(id,name,parts,note=''){families.push(`<article id="c-${id}" class="kit-family kit-span-all"><header class="kit-family-header"><div><span class="kit-family-number">${String(families.length+1).padStart(2,'0')}</span><h3>${e(name)}</h3></div><a href="#m-${id}" aria-label="Источники ${e(name)}">Источники ↗</a></header><div class="kit-component-boards">${parts.join('')}</div>${note?`<p class="kit-note">${e(note)}</p>`:''}</article>`);}
function buttonPart(name,purpose,options,states,note=''){
 const render=()=>C.button(options);
 return part(name,purpose,states.map(([title,state])=>variant(title,C.button({...options,state}))),render,{note});
}
const baseStates=[['Default',State.default],['Hover · CSS',State.hover],['Pressed · CSS',State.pressed],['Focus · CSS',State.focus],['Disabled · CSS',State.disabled]];
const neutralStates=[['Default',State.default],['Hover · CSS',State.hover],['Focus · CSS',State.focus]];
const staticStates=[['Default',State.default],['Focus · CSS',State.focus]];
family('button','Buttons',[
 buttonPart('Primary action','Главное действие: продолжение или подтверждение.',{text:'Продолжить',iconName:'arrow'},baseStates),
 buttonPart('Secondary action','Альтернативное действие рядом с основным.',{text:'Отмена',style:Style.secondary},neutralStates,'Pressed/disabled отдельно не определены исходником.'),
 buttonPart('Destructive action','Подтверждение необратимого действия в диалоге.',{text:'Снять участника',style:Style.danger},staticStates,'В исходнике нет отдельных hover/pressed/disabled образцов.'),
 buttonPart('Icon button · neutral','Навигация назад и нейтральные действия без текста.',{text:'Назад',style:Style.icon,iconName:'back'},neutralStates,'Hit area: Mobile56 / Desktop48. Иконка — входные данные.'),
 buttonPart('Icon button · accent','Акцентное сохранение или подтверждение.',{text:'Сохранить',style:Style.accentIcon,iconName:'check'},staticStates,'Акцентная кнопка имеет собственное назначение и собственный набор состояний.'),
 buttonPart('Text action','Вторичное текстовое действие без подложки.',{text:'Исправить результат',style:Style.link},staticStates),
]);
function fieldPart(name,purpose,options){const render=()=>C.field(options);return part(name,purpose,[variant('Filled',render()),variant('Empty',C.field({...options,value:''})),variant('Read only',C.field({...options,readonly:true})),variant('Focus · CSS',C.field({...options,state:State.focus})),variant('Invalid · предложено',C.field({...options,state:State.invalid,error:'Проверь значение'})),variant('Disabled · предложено',C.field({...options,state:State.disabled}))],render,{note:'Mobile/Desktop: единая заливка surface, граница и радиус. Размеры адаптируются. Invalid message/disabled восстановлены по ролям прототипа.'});}
family('field','Fields',[
 fieldPart('Text input','Однострочный ввод названия или имени.',{label:'Название',value:'Пятничный турнир'}),
 fieldPart('Text area','Многострочное сообщение с собственной высотой.',{label:'Сообщение',value:'Хочу предложить улучшение…',multiline:true}),
]);
family('select','Select',[
 part('Theme select','Выбор одного значения из списка.',[variant('Default · Desktop',C.select(),{desktop:true}),variant('Focus · CSS',C.select().replace('<select ','<select class="kit-focus" '),{desktop:true}),variant('Disabled · Desktop · предложено',C.select({disabled:true}),{desktop:true}),variant('Default · Mobile',C.mobileSelect()),variant('Focus · Mobile',C.mobileSelect({state:State.focus})),variant('Disabled · Mobile · предложено',C.mobileSelect({state:State.disabled}))],()=>C.mobileSelect(),{desktopRender:()=>C.select(),note:'Mobile: рабочая строка настроек из прототипа. Desktop: поле выбора. Mobile открывает bottom sheet с выбором; Desktop — native select. Тема приложения не меняется.'}),
]);
family('segmented','Segmented choices',[
 part('Tournament format','Взаимоисключающий выбор формата.',['DE','SE','RR'].map((x,i)=>variant(`Selected ${x}`,C.segmented({selected:i}))),()=>C.segmented(),{note:'Текст вариантов — данные. Группа сохраняет анатомию; отступы меняются по платформе.'}),
]);
family('stepper','Steppers',[
 part('Format stepper','Изменение количества побед FT в настройках.',[variant('Minimum · decrease disabled',C.stepper()),variant('Intermediate · восстановлено',C.stepper({value:5})),variant('Maximum · предложено',C.stepper({value:10}))],()=>C.stepper(),{note:'Mobile = Desktop: геометрия, заливка и кнопки одинаковы. min/max задаёт приложение; значения демонстрационные.'}),
 part('Score stepper','Ввод результата одного игрока.',[variant('Zero',C.stepper({label:'Счёт Алексея',value:0,min:0,max:2,score:true})),variant('Editable',C.stepper({label:'Счёт Алексея',value:1,min:0,max:2,score:true})),variant('Upper boundary · данные',C.stepper({label:'Счёт Алексея',value:2,min:0,max:2,score:true}))],()=>C.stepper({label:'Счёт Алексея',value:1,min:0,max:2,score:true}),{note:'Mobile = Desktop: один размер и оформление без платформенных overrides.'}),
]);
family('score-choice','Score choices',[
 part('FT1 result choice','Выбор победителя матча из двух результатов.',[variant('Left selected',C.scoreChoice()),variant('Right selected',C.scoreChoice({selected:1}))],()=>C.scoreChoice(),{context:'competition competition-result',note:'Оба состояния одной группы. Loading/error отсутствуют в эталоне.'}),
]);
family('score','Scores',[
 part('Match score','Пара результатов матча, только чтение.',[variant('Initial',C.score(),{context:'competition'}),variant('Result · данные',C.score({left:'2',right:'1'}),{context:'competition'}),variant('Two digits · данные',C.score({left:'10',right:'8'}),{context:'competition'})],()=>C.score(),{context:'competition'}),
 part('Fixed winner score','Фиксированная часть результата победителя.',[variant('Value',C.score({left:'2',fixed:true})),variant('Two digits · данные',C.score({left:'10',fixed:true}))],()=>C.score({left:'2',fixed:true})),
]);
function sizedAvatar(size,{round=false,withText=false,longName=false}={}) {
 const content=withText?C.identity({initials:'И',tone:'unassigned',character:'Иван',name:longName?'Александр Константинопольский':'Участник турнира',layout:size<=64?Identity.inline:Identity.fighter}):C.avatar({initials:'И',tone:'unassigned',profile:round});
 return `<div class="kit-avatar-size kit-avatar-size-${size} ${withText?'kit-avatar-composition':''}">${content}</div>`;
}
family('avatar','Avatars',[
 ...[
  [28,'Компактный слот турнирной сетки.'],
  [40,'Небольшая строка списка.'],
  [48,'Состав, таблица и результаты.'],
  [64,'Основной аватар участника.'],
  [96,'Профиль и выделенный участник.'],
  [112,'Портрет в карточке матча.'],
  [128,'Крупный аватар профиля.'],
 ].map(([size,purpose])=>part(`Avatar · ${size} px`,purpose,[
  variant('Без подписи',sizedAvatar(size)),
  variant('Круглая форма',sizedAvatar(size,{round:true})),
  variant('С именем и подписью',sizedAvatar(size,{withText:true})),
  ...(size===64?[variant('Длинная подпись · данные',sizedAvatar(size,{withText:true,longName:true}))]:[]),
 ],()=>sizedAvatar(size,{withText:true}),{note:'Один размер на Mobile и Desktop. Форма и подпись — варианты композиции; цвета персонажей не создают компоненты. Без рамки.'})),
]);
family('metric','Metrics',[
 part('Achievement metric','Победы в турнирах с акцентом и trophy.',[variant('Zero · данные',C.metric({value:'0',label:'Победы в турнирах',accent:true})),variant('Populated',C.metric({value:'3',label:'Победы в турнирах',accent:true}))],()=>C.metric({value:'3',label:'Победы в турнирах',accent:true}),{desktopRender:()=>C.metric({value:'3',label:'Победы в турнирах',accent:true,desktop:true}),note:'Desktop меняет emphasis на золотую плитку. Mobile сохраняет тёмную поверхность.'}),
 part('Plain metric','Число и подпись статистики без акцентной иконки.',[variant('Zero · данные',C.metric({value:'0'})),variant('Populated',C.metric())],()=>C.metric(),{desktopRender:()=>C.metric({desktop:true})}),
]);
const navigation=(desktop=false)=>desktop?C.navigation({desktop:true}):`<nav class="profile-menu">${C.navigation()}</nav>`;
family('navigation','Navigation',[
 part('Profile navigation item','Переход в раздел из профиля.',[variant('Default',navigation()),variant('Hover · CSS',navigation().replace('profile-menu-item','profile-menu-item kit-hover')),variant('Focus · CSS',navigation().replace('profile-menu-item','profile-menu-item kit-focus'))],()=>navigation(),{desktopRender:()=>navigation(true),note:'Одна цель перехода: Mobile row / Desktop tile. Иконка и подпись — данные.'}),
]);
family('header','Section headers',[
 part('Back header','Заголовок с навигацией назад.',[variant('Default',C.header()),variant('Long title · данные',C.header({title:'Параметры пятничного турнира'}))],()=>C.header()),
 part('Save header','Редактирование с акцентным действием сохранения.',[variant('Default',C.header({title:'Редактирование',action:true}))],()=>C.header({title:'Редактирование',action:true})),
 part('Edit header','Просмотр с нейтральным действием редактирования.',[variant('Default',C.header({title:'Профиль',action:true,trailingIcon:'edit',accent:false}))],()=>C.header({title:'Профиль',action:true,trailingIcon:'edit',accent:false})),
]);
family('row','List rows',[
 part('Roster row · Mobile','Строка 72 px · аватар 48 px · имя 18 px. Потяни справа налево.',[
  variant('Default',C.row({kind:Row.roster})),
  variant('Revealed · справа, на всю высоту',C.row({kind:Row.roster,revealed:true})),
 ],null,{note:'Отдельная строка без внешнего padding списка. Delete начинается у правого края и занимает всю высоту 72 px. Ширина строки следует контейнеру.'}),
 part('Roster card · Desktop','Плитка 208 px. Удаление — явная кнопка, без свайпа.',[
  variant('Default · кнопка доступна сразу',`<div class="bento-roster kit-roster-example">${C.row({kind:Row.roster,desktop:true})}</div>`,{desktop:true}),
  variant('Keyboard focus',`<div class="bento-roster kit-roster-example">${C.row({kind:Row.roster,desktop:true}).replace('class="flow-roster-remove"','class="flow-roster-remove kit-focus"')}</div>`,{desktop:true}),
 ],null,{note:'Кнопка корзины 40×40 px всегда доступна. Нажатие открывает подтверждение; пример можно восстановить после удаления.'}),
 part('Assignment row','Сопоставление игрока и персонажа.',[variant('Default',C.row()),variant('Long name · данные',C.row({name:'Александр Константинопольский'}))],()=>C.row()),
 part('Ranking row','Позиция участника в результатах турнира.',[variant('Place',C.row({kind:Row.ranking}),{context:'competition competition-results'}),variant('Shared place · данные',C.row({kind:Row.ranking,place:'3–4'}),{context:'competition competition-results'}),variant('Points · данные',C.row({kind:Row.ranking,points:'12'}),{context:'competition competition-results competition-results-points'})],()=>C.row({kind:Row.ranking}),{context:'competition competition-results'}),
 part('History row','Запись турнира с датой и победителем.',[variant('Default',C.row({kind:Row.history})),variant('Long title · данные',C.row({kind:Row.history,title:'Пятничный турнир клуба Mortal Kombat'}))],()=>C.row({kind:Row.history})),
]);
family('status','Statuses and outcomes',[
 part('Live status','Текущий процесс с live indicator.',[variant('In progress',C.status())],()=>C.status()),
 part('Technical outcome','Текстовый исход без дополнительной подложки.',[variant('Win',C.status({text:'Техническая победа',dot:false})),variant('Loss',C.status({text:'Техническое поражение',dot:false,error:true}))],()=>C.status({text:'Техническая победа',dot:false})),
 part('Points label','Число очков результата.',[variant('Value', '<span class="competition-points-badge">2 очка</span>')],()=>'<span class="competition-points-badge">2 очка</span>'),
]);
family('disclosure','Disclosures',[
 part('Disclosure','Раскрытие дополнительного содержимого в потоке.',[variant('Closed',C.disclosure(),{context:'competition'}),variant('Open',C.disclosure({open:true}),{context:'competition'})],()=>C.disclosure({open:true}),{context:'competition',note:'Можно раскрыть/свернуть нативный details. Высота зависит от содержимого.'}),
]);
family('notice','Messages',[
 part('Information notice','Пояснение к настройке или области.',[variant('Default',C.notice()),variant('Long content · данные',C.notice({text:'Bracket Reset включён всегда. Второй финал проводится при победе участника из нижней сетки.'}))],()=>C.notice()),
 part('Operation error','Ошибка действия в области интерфейса.',[variant('Default',C.notice({text:'Не удалось сохранить. Повтори.',error:true}))],()=>C.notice({text:'Не удалось сохранить. Повтори.',error:true})),
 part('Inline error','Компактное сообщение рядом с контентом.',[variant('Default',C.notice({text:'Не удалось сохранить. Повтори.',error:true,inline:true}))],()=>C.notice({text:'Не удалось сохранить. Повтори.',error:true,inline:true})),
]);
function source(id,code=true){const wrapper=document.createElement('div');wrapper.append(document.querySelector(`#kit-source-${id}`).content.cloneNode(true));if(!code)wrapper.querySelector('.flow-qr-session')?.remove();return wrapper.innerHTML;}
family('progress','Progress',[
 part('Indeterminate progress','Исходная волна загрузки без процента.',[variant('Animated',source('progress')),variant('Reduced motion · CSS',`<div class="kit-reduced-motion">${source('progress')}</div>`)],()=>source('progress'),{note:'HTML waveform — ошибочный исторический образец. В приложении нужен штатный Material 3 ProgressIndicator из основной темы; эту волну не переносить.'}),
]);
family('surface','Surfaces',[
 part('Panel surface','Основная контейнерная поверхность.',[variant('Default',C.surface('<p class="flow-caption">Поверхность</p>'))],()=>C.surface('<p class="flow-caption">Поверхность</p>'),{note:'Read only. Hover применим только при отдельном интерактивном контракте.'}),
 part('Raised surface','Вложенная приподнятая поверхность.',[variant('Proposed · token role',C.surface('<p class="flow-caption">Приподнятая область</p>',{raised:true}))],()=>C.surface('<p class="flow-caption">Приподнятая область</p>',{raised:true}),{note:'Композиционный образец существующего токена raised; предложено.'}),
]);
family('table','Tables',[
 part('Standings table','Участники, очки и количество матчей.',[variant('Populated',C.standings(),{context:'competition'})],()=>C.standings(),{context:'competition',note:'Сохраняет заголовки и соответствие колонок. Empty/loading/error не определены исходником.'}),
]);
family('bracket','Bracket nodes',[
 part('Match node','Один матч сетки и его участники.',[variant('Ready',C.bracketNode()),variant('Current',C.bracketNode({current:true})),variant('Pending',C.bracketNode({pending:true}))],()=>C.bracketNode(),{note:'Связи, zoom/pan и раунды принадлежат layout. Selected/finished не специфицированы.'}),
]);
family('dialog','Dialogs',[
 part('Destructive confirmation','Подтверждение снятия участника.',[variant('Default',C.dialog()),variant('Action unavailable · предложено',C.dialog({disabled:true}))],()=>C.dialog(),{note:'Mobile/Desktop поверхности без device frame. Modal focus/clipboard здесь не реализуются.'}),
]);
family('qr','QR and access',[
 part('Participant access code','QR с текстовым кодом подключения.',[variant('Static demonstration',source('qr'))],()=>source('qr'),{note:'Исходный демонстрационный QR. Генерация сессии не выполняется.'}),
 part('QR graphic','Графический QR без текстового кода.',[variant('Without code · slot variant',source('qr',false))],()=>source('qr',false),{note:'Вариант optional code slot, не новая схема доступа.'}),
]);
family('share','Share links',[
 part('Spectator share link','Адрес просмотра с действием копирования.',[variant('Short address',C.share()),variant('Long address · данные',C.share({url:'http://host.local/spectator/tournament-with-a-long-session-address'}))],()=>C.share(),{note:'Copied/error отсутствуют в исходнике. Длинный адрес переносится, copy сохраняет место.'}),
]);
document.querySelector('#kit-components').innerHTML=families.join('');
// Старые ссылки Identity ведут к единой категории Avatar.
const identityAnchor=document.createElement('span');identityAnchor.id='c-identity';identityAnchor.setAttribute('aria-hidden','true');document.querySelector('#c-avatar').prepend(identityAnchor);
const index=document.createElement('nav');index.className='kit-component-index';index.setAttribute('aria-label','Категории компонентов');index.innerHTML=families.map(html=>{const doc=new DOMParser().parseFromString(html,'text/html');const article=doc.querySelector('article');return `<a href="#${article.id}">${e(article.querySelector('h3').textContent)}</a>`;}).join('');document.querySelector('#kit-components').before(index);
document.querySelector('#kit-setup-mobile').innerHTML=C.setupRecipe(Density.mobile);
document.querySelector('#kit-setup-desktop').innerHTML=C.setupRecipe(Density.desktop);
document.querySelector('#kit-profile-mobile').innerHTML=C.profileRecipe(Density.mobile);
document.querySelector('#kit-profile-desktop').innerHTML=C.profileRecipe(Density.desktop);
document.querySelector('#kit-family-count').textContent=String(families.length);
document.querySelector('#components .kit-section-intro').textContent=`${families.length} категории · ${partCount} отдельных компонентов по назначению. У каждого — собственные состояния или варианты данных и адаптация. Исходный внешний вид сохранён; отсутствующие состояния отмечены явно.`;

mountMobileSelectSheet();

const rosterScript=document.createElement('script');rosterScript.src='roster-gestures.js?v=21';document.body.append(rosterScript);

mountRosterConfirmation();
