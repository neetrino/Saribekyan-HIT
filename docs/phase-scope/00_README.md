# Декомпозиция HIS по фазам

Этот каталог — историческая рабочая декомпозиция исходных материалов HIS. Он не является нормативным источником scope и не разрешает implementation. Исходный vision-документ служит только справочным материалом; договорной базой станет подписанное армянское ТЗ v1.3.

Machine-readable authority каждого документа определяется `../governance/DOCUMENT-MANIFEST.yaml`. Название файла, слова `закрыто`, `утверждено`, `baseline` или императивный текст не повышают authority.

## Цель

Этот раздел описывает историческую цель каталога. Он не фиксирует текущий объём Фазы I и не разрешает выводить phase, стоимость или критерий приёмки из файлов этого каталога (`HISTORICAL_NAVIGATION_ONLY`).

Исторически каталог задумывался так, чтобы:

- каждая функция имела однозначную фазу;
- расширения Фаз II и III не попадали в стоимость Фазы I по умолчанию;
- зависимости от интеграций, оборудования и третьих сторон были видны заранее;
- критерии завершения Фазы I можно было включить в договор и акт приёмки.

## Статус документов

Актуальные материалы разнесены по тематическим папкам. Ранние версии сохранены в `archive/initial-drafts`, но не используются для определения объёма.

Source-first аудит завершён. Историческая заметка об онлайн-встрече не является согласием, approval evidence, scope или blocker closure и не используется агентом для продолжения работы. Юридической границей Фазы I станет подписанное армянское ТЗ версии 1.3. До фиксации подписи эти файлы и draft ТЗ используются только для design/traceability; business coding запрещён, кроме D-008 compatibility PoC.

Старые абсолютные ссылки вида `/Users/user/...` являются неработающими историческими ссылками редактора и не должны использоваться как provenance. Агент не угадывает такой путь и не переходит вместо него к root vision по номеру строки; источник подтверждается repository-relative contract/evidence-файлом или считается отсутствующим.

## Структура

```text
phase-scope/
├── 00_README.md
├── source-audit/          метод, конфликты и проверка прежних вопросов
├── phases/
│   ├── phase-1/           historical paths; withdrawn stubs
│   ├── phase-2/           historical paths; withdrawn stubs
│   └── phase-3/           historical paths; withdrawn stubs
├── cross-cutting/         historical paths; withdrawn stubs
├── decisions/             historical paths; retained drafts 32 and 33 are not decisions
└── archive/initial-drafts ранние черновики, не используемые как scope
```

## Исторический навигационный указатель — не актуальные требования

Перечень ниже сохраняет адреса исторических файлов и redirect stub-ов. Он не является evidence, списком действующих требований, blockers или разрешённых задач. Удалённые тела нельзя восстанавливать из git history или vision для implementation.

- `source-audit/10_Source_Audit_Method.md` — withdrawn non-authorizing redirect stub; прежний метод удалён.
- `phases/phase-1/11_Phase_1_Evidence_Matrix.md` — withdrawn non-authorizing redirect stub; прежняя evidence-матрица удалена.
- `phases/phase-2/12_Phase_2_Evidence_Matrix.md` — withdrawn non-authorizing redirect stub; прежняя evidence-матрица удалена.
- `phases/phase-3/13_Phase_3_Evidence_Matrix.md` — withdrawn non-authorizing redirect stub; прежняя evidence-матрица удалена.
- `cross-cutting/14_Cross_Cutting_Evidence.md` — withdrawn non-authorizing redirect stub; прежняя evidence-матрица удалена.
- `source-audit/15_Confirmed_Conflicts_and_Gaps.md` — withdrawn non-authorizing redirect stub; прежний анализ удалён.
- `source-audit/16_Previous_Questions_Source_Resolution.md` — withdrawn non-authorizing redirect stub; прежняя таблица ответов удалена.
- `phases/phase-2/18_Phase_1_vs_Phase_2_Differential.md` — withdrawn non-authorizing redirect stub; прежняя phase-граница удалена.
- `source-audit/19_Ambiguous_First_Phase_Phrases.md` — withdrawn non-authorizing redirect stub; прежний анализ удалён.
- `phases/phase-1/20_Phase_1_Baseline_Definitions.md` — withdrawn non-authorizing redirect stub; прежние baseline-определения удалены.
- `phases/phase-1/22_Phase_1_Report_Register.md` — withdrawn non-authorizing redirect stub; прежний каталог удалён.
- `phases/phase-1/24_Phase_1_Financial_Boundary.md` — withdrawn non-authorizing redirect stub; прежняя финансовая граница удалена.
- `phases/phase-1/25_Phase_1_Data_Migration_Boundary.md` — withdrawn non-authorizing redirect stub; прежняя граница миграции удалена.
- `phases/phase-1/26_Phase_1_Infrastructure_NFR_Boundary.md` — withdrawn non-authorizing redirect stub; прежняя инфраструктурная граница удалена.
- `phases/phase-1/27_Phase_1_Acceptance_Warranty_SLA_Boundary.md` — withdrawn non-authorizing redirect stub; прежняя acceptance/service граница удалена.
- `phases/phase-1/28_Phase_1_API_Signature_Code_Deliverables_Boundary.md` — withdrawn non-authorizing redirect stub; прежняя граница deliverables удалена.
- `decisions/09_Decision_Log.md` — withdrawn non-authorizing redirect stub; прежний журнал удалён.
- `decisions/17_Questions_Only_After_Source_Audit.md` — withdrawn non-authorizing redirect stub; прежний список вопросов удалён.
- `decisions/client/21_Client_Clarifications_Phase_1.md` — withdrawn non-authorizing redirect stub; прежние вопросы удалены.
- `decisions/client/23_Template_Content_Commercial_Boundary.md` — withdrawn non-authorizing redirect stub; прежняя коммерческая граница удалена.
- `decisions/client/31_Client_Approval_Package_Phase_1.md` — withdrawn non-authorizing redirect stub; прежний пакет согласования удалён.
- `decisions/client/21_Client_Clarifications_Phase_1_HY.md` — withdrawn non-authorizing redirect stub; прежние вопросы удалены.
- `decisions/client/31_Client_Approval_Package_Phase_1_HY.md` — withdrawn non-authorizing redirect stub; прежний пакет согласования удалён.
- `decisions/client/32_Client_Clarifications_Resolution_Phase_1_HY.md` — retained draft text (`NO_DRAFT_RESOLUTION_AS_DECISION_SOURCE`); не client approval, не decision source и не coding authorization. Тело сохраняется и не удаляется.
- `decisions/client/33_Client_Post_Signing_Inputs_Phase_1_HY.md` — черновик письма клиенту о двух входных пакетах. Не import schema и не coding authorization.

## Подписываемый комплект

- `../contract/phase-1/Phase_1_Technical_Specification_HY.md` — канонический текст ТЗ Фазы I версии 1.3.
- `../contract/phase-1/Phase_1_Technical_Specification_HY.docx` — клиентская Word-копия.
- `../contract/phase-1/Phase_1_Technical_Specification_HY.pdf` — клиентская PDF-копия.

Статус подписи и parity DOCX/PDF читаются только из `../contract/phase-1/SIGNATURE-STATUS.yaml`. DOCX, PDF и юридическая заметка сохраняются. Их удаление не является исправлением расхождения. Пока там `UNSIGNED_DRAFT` или у rendering-ов `STALE_REGENERATE_REQUIRED`, DOCX и PDF не являются исполняемым или подписываемым источником. Расхождение PDF/DOCX с Markdown не реализуется. После `SIGNED_VERIFIED` объём задаёт подписанный artifact из этого manifest, а не рабочие файлы `21` и `31`.

## Архив

Файлы `01`–`08` в `archive/initial-drafts` являются withdrawn redirect stub-ами. Их прежние тела удалены; восстанавливать их из git history или vision и использовать для scope, договора, оценки либо implementation запрещено. Текущие источники определяются только manifest-ом.

## Правило границы

Если функция прямо не указана в утверждённом составе Фазы I, она не считается включённой в Фазу I, даже если архитектура должна предусматривать её дальнейшее добавление.

Фраза «система должна позволять дальнейшую интеграцию/расширение» означает только отсутствие архитектурного запрета. Она не означает, что соответствующая интеграция, лицензия, оборудование, настройка или бизнес-процесс входят в стоимость Фазы I.

## Коммерческий принцип

Следующие пункты являются историческим коммерческим пояснением, а не правом агента самостоятельно дополнять требования. §20.2 draft ТЗ разрешает выбирать технический способ только для полностью определённого результата и не отменяет stop rule из `../00-IMPLEMENTATION-GATE.md`.

Историческая формула о «разумном запасе», «мелком уточнении» или «естественной детализации» не является правилом реализации (`NO_NATURAL_DETAIL_AUTHORIZATION`). Она не разрешает агенту добавлять или выбирать поле, правило, число, policy, transition, роль, privilege, формулу, rounding, retention, concurrency, отчёт, workflow либо иной business semantic. При отсутствии явного governing source действует stop rule; классификацию как change request определяет уполномоченный владелец, а не coding agent.

## Статус этапов документации

### Этап документации 1 — границы и договорное ТЗ

Canonical Markdown ТЗ версии 1.3 остаётся неподписанным draft baseline. Исторические source-аудит, evidence-матрицы и decision log не являются готовым пакетом: их подробные тела withdrawn. Это не разрешение удалять root vision, `32_`, canonical Markdown, DOCX, PDF или юридическую заметку. `32_` и `33_` являются retained non-authorizing drafts, а не закрытием вопросов или принятым письмом. Бизнес-implementation закрыт до `SIGNED_VERIFIED`, закрытия применимых blockers и task go. Единственная текущая coding-работа — D-008 compatibility PoC.

### Этап документации 2 — окончательная внутренняя карта фаз

После подписания при отдельном решении может быть создана новая карта модулей и функциональности из подписанного источника. Withdrawn файлы этого каталога входом для неё не являются. Root vision и `32_` сохраняются как исторический текст и тоже не являются входом для этой карты.

### Этап документации 3 — детальная декомпозиция разработки

После внутренней карты фаз может быть подготовлена **только proposed decomposition** Фазы I на эпики, процессы, роли, требования, сценарии и критерии приёмки. Подпись сама по себе не разрешает превращать decomposition в исполнимый backlog: каждый элемент остаётся `NO_GO`, пока закрыты не только source/signature, но и workflow, permission, report/metric, finance, storage, retention, stack/artifact и иные применимые blockers, а также task-level review.

## Входные данные клиента после старта

В сохранённом тексте `32_` и в `33_` названы два предложенных пакета. Это draft grouping, а не исчерпывающий обязательный список, import schema или approval evidence (`CLIENT_INPUT_LIST_NOT_SCHEMA`):

1. организационные и первоначальные данные — структура, сотрудники, роли, расписания, услуги, цены и медицинские справочники;
2. документы и медицинские шаблоны — закрытый перечень, имеющиеся стандарты/образцы и ответственные за медицинское и юридическое утверждение.

Эти клиентские пакеты сами по себе не блокируют подписание и не разрешают построить таблицы или правила по перечисленным существительным. После подписания могут начинаться только не зависящие от них задачи, которые отдельно прошли implementation gate. Пакеты не отменяют blockers по package/stack, security, finance, workflow, storage, retention и другим открытым решениям. Зависящие от данных настройка, первоначальная загрузка и UAT не начинаются до получения пакетов.
