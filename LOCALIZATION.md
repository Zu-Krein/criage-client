# 🌐 Система динамической локализации Criage

## 📋 Обзор

Criage поддерживает полностью **динамическую систему локализации**, которая автоматически определяет доступные языки на основе файлов переводов. Добавление нового языка требует только создания соответствующего JSON файла - **без изменения кода**.

### ✨ Основные возможности

- **🔍 Автоматическое определение языков** - сканирование файлов `translations_*.json`
- **🌍 Стандартные коды языков** - поддержка ISO 639-1 (ru, en, de, fr, es, zh, ja...)
- **🤖 Автоопределение системного языка** - на основе переменных окружения
- **📁 Гибкая структура** - отдельные файлы для основного приложения и repository сервера
- **🔄 Fallback система** - автоматический откат на английский или доступный язык
- **🔧 Thread-safe** - безопасность в многопоточной среде

## 🗂️ Структура файлов

```
criage/
├── locale/                           # Локализация основного приложения
│   ├── translations_en.json         # Английский
│   ├── translations_ru.json         # Русский
│   ├── translations_de.json         # Немецкий
│   └── translations_es.json         # Испанский
└── repository/
    └── locale/                       # Локализация repository сервера
        ├── translations_en.json     # Английский
        ├── translations_ru.json     # Русский
        ├── translations_de.json     # Немецкий
        └── translations_es.json     # Испанский
```

## 🆕 Добавление нового языка

### Шаг 1: Создать файл переводов

Создайте файл с именем `translations_<код_языка>.json` в соответствующей директории:

```bash
# Для основного приложения
locale/translations_fr.json        # Французский
locale/translations_zh.json        # Китайский
locale/translations_ja.json        # Японский

# Для repository сервера
repository/locale/translations_fr.json  # Французский
repository/locale/translations_zh.json  # Китайский
repository/locale/translations_ja.json  # Японский
```

### Шаг 2: Добавить переводы

```json
{
  "app_description": "Gestionnaire de paquets haute performance",
  "cmd_install": "Installer le paquet",
  "cmd_search": "Rechercher des paquets",
  "installing_package": "Installation du paquet %s...",
  "packages_found": "%d paquets trouvés:",
  "no_packages_found": "Aucun paquet trouvé"
}
```

### Шаг 3: Перезапустить приложение

Система автоматически обнаружит новый язык при следующем запуске.

## 🔧 Использование в коде

### Основное API

```go
// Получить экземпляр локализации
loc := pkg.GetLocalization()

// Узнать текущий язык
currentLang := loc.GetLanguage()

// Получить список доступных языков
languages := loc.GetSupportedLanguages()

// Установить язык
err := loc.SetLanguage("fr")

// Получить перевод
text := loc.Get("app_description")
formatted := loc.Get("installing_package", "my-package")
```

### Глобальные функции

```go
// Простое использование
title := pkg.T("app_description")
message := pkg.T("packages_found", 5)

// Смена языка
pkg.SetLanguage("de")
```

## 🌍 Поддерживаемые языки

Система автоматически поддерживает любые языки с ISO 639-1 кодами:

| Код | Язык | Файл |
|-----|------|------|
| `en` | English | `translations_en.json` |
| `ru` | Русский | `translations_ru.json` |
| `de` | Deutsch | `translations_de.json` |
| `fr` | Français | `translations_fr.json` |
| `es` | Español | `translations_es.json` |
| `zh` | 中文 | `translations_zh.json` |
| `ja` | 日本語 | `translations_ja.json` |
| `it` | Italiano | `translations_it.json` |
| `pt` | Português | `translations_pt.json` |

### Расширенные коды языков

Поддерживается формат `язык-регион`:

```
translations_en-US.json  # Английский (США)
translations_en-GB.json  # Английский (Великобритания)
translations_zh-CN.json  # Китайский (упрощенный)
translations_zh-TW.json  # Китайский (традиционный)
```

## 🎯 Автоопределение языка

Система проверяет переменные окружения в порядке:

1. `LANG`
2. `LC_ALL`
3. `LC_MESSAGES`
4. `LANGUAGE`

### Примеры

```bash
LANG=de_DE.UTF-8    # → немецкий (de)
LANG=fr_FR.UTF-8    # → французский (fr)
LANG=es_ES.UTF-8    # → испанский (es)
LANG=zh_CN.UTF-8    # → китайский (zh)
```

## 📋 Ключи переводов

### Команды приложения

- `app_description` - Описание приложения
- `cmd_install` - Команда установки
- `cmd_uninstall` - Команда удаления  
- `cmd_search` - Команда поиска
- `cmd_list` - Команда списка пакетов
- `cmd_info` - Информация о пакете

### Флаги и опции

- `flag_global` - Глобальная установка
- `flag_version` - Версия пакета
- `flag_force` - Принудительная установка

### Сообщения операций

- `installing_package` - "Установка пакета %s..."
- `uninstalling_package` - "Удаление пакета %s..."
- `packages_found` - "Найдено %d пакетов:"
- `package_installed` - "Пакет %s версии %s успешно установлен"

### Ошибки и предупреждения

- `error_init_package_manager` - Ошибка инициализации
- `error_failed_to_find` - Пакет не найден
- `no_packages_found` - Пакеты не найдены

## 🔍 Тестирование

### Запуск тестов локализации

```bash
# Тест динамической системы
go run test_dynamic_localization.go

# Создание файлов переводов  
go run test_localization.go
```

### Тестирование с разными языками

```bash
# Установить язык через переменную окружения
LANG=de_DE.UTF-8 go run test_dynamic_localization.go
LANG=es_ES.UTF-8 go run test_dynamic_localization.go
LANG=fr_FR.UTF-8 go run test_dynamic_localization.go
```

## 🛠️ Архитектура

### Сканирование языков

Система использует регулярное выражение для поиска файлов:

```regex
^translations_([a-z]{2}(?:-[A-Z]{2})?)\.json$
```

### Структура Localization

```go
type Localization struct {
    currentLanguage     string
    supportedLanguages  []string
    translations        map[string]map[string]string
    translationsDir     string
    mutex               sync.RWMutex
}
```

### Методы

- `scanAvailableLanguages()` - Сканирование файлов
- `detectSystemLanguage()` - Определение языка системы
- `initializeTranslations()` - Загрузка переводов
- `getDefaultTranslations()` - Fallback переводы

## 🎯 Лучшие практики

### 1. Именование файлов

```bash
✅ translations_en.json
✅ translations_ru.json  
✅ translations_zh-CN.json
❌ translations_english.json
❌ en_translations.json
```

### 2. Структура переводов

```json
{
  "category_key": "Перевод",
  "cmd_install": "Установить пакет",
  "error_not_found": "Не найдено: %s"
}
```

### 3. Параметризация

```go
// Правильно
T("packages_found", count)
T("installing_package", packageName)

// Избегать
T("found") + " " + strconv.Itoa(count) + " " + T("packages")
```

### 4. Fallback

- Всегда включать английский язык (`translations_en.json`)
- Использовать осмысленные ключи как fallback
- Предоставлять базовые переводы в коде

## 🚀 Примеры использования

### Добавление португальского языка

1. Создать `locale/translations_pt.json`:

```json
{
  "app_description": "Gerenciador de pacotes de alto desempenho",
  "cmd_install": "Instalar pacote",
  "cmd_search": "Pesquisar pacotes",
  "installing_package": "Instalando pacote %s...",
  "packages_found": "%d pacotes encontrados:"
}
```

2. Создать `repository/locale/translations_pt.json`:

```json
{
  "repository_name": "Repositório de Pacotes Criage",
  "server_started": "Servidor iniciado em http://localhost:%d",
  "package_uploaded": "Pacote enviado",
  "upload_successful": "Pacote enviado com sucesso"
}
```

3. Перезапустить приложение:

```bash
go run test_locale_structure.go
# Вывод: Поддерживаемые языки: [de en es pt ru]
```

### Тестирование с португальским

```bash
LANG=pt_BR.UTF-8 ./criage --help
# Интерфейс будет на португальском языке
```

## 📈 Будущие улучшения

- 🔄 **Горячая перезагрузка** переводов без перезапуска
- 🌐 **Веб-интерфейс** для управления переводами
- 📊 **Валидация** полноты переводов
- 🔍 **Автоматический поиск** недостающих ключей
- 📝 **Экспорт/импорт** переводов в различных форматах

Система локализации Criage обеспечивает максимальную гибкость и простоту добавления новых языков без изменения исходного кода! 🎉
