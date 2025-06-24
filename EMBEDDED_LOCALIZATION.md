# 📦 Встроенная система локализации Criage

## 🎯 Обзор

Criage поддерживает **два режима локализации**:

1. **📁 Внешние файлы** - динамическая загрузка из директории `locale/`
2. **📦 Встроенные переводы** - файлы компилируются в исполняемый файл

## ⚡ Преимущества встроенной локализации

### ✅ Плюсы

- **🚀 Портабельность** - один исполняемый файл содержит все переводы
- **🛡️ Надежность** - невозможно потерять файлы переводов
- **⚡ Производительность** - нет файловых операций в runtime
- **📦 Простота развертывания** - не нужно копировать дополнительные файлы
- **🔒 Безопасность** - переводы защищены от изменения

### ❌ Недостатки

- **🔧 Статичность** - нельзя добавить новые языки без перекомпиляции
- **📏 Размер** - больший размер исполняемого файла
- **🔄 Обновления** - нельзя обновить переводы без перекомпиляции

## 🛠️ Способы использования

### 1. 📁 Обычная сборка (внешние файлы)

```bash
# Обычная сборка - использует файлы из директории locale/
go build

# Или явно указать
go build -tags ""
```

**Использование в коде:**

```go
import "github.com/Kelnit/criage/pkg"

// Создает локализацию с загрузкой из locale/
localization := pkg.NewLocalization()

// Проверяем режим
fmt.Println("Embedded:", localization.IsEmbedded()) // false
```

### 2. 📦 Встроенная сборка (embedded)

```bash
# Сборка со встроенными переводами
go build -tags embed

# Или с дополнительными флагами
go build -tags embed -ldflags "-s -w"
```

**Использование в коде:**

```go
import "github.com/Kelnit/criage/pkg"

// Создает локализацию со встроенными переводами
localization := pkg.NewEmbeddedLocalization()

// Проверяем режим
fmt.Println("Embedded:", localization.IsEmbedded()) // true

// Получаем список встроенных языков
embeddedLangs := pkg.GetEmbeddedLanguages()
fmt.Println("Embedded languages:", embeddedLangs)
```

## 🏗️ Подготовка к встроенной сборке

### Шаг 1: Убедитесь, что файлы переводов существуют

```bash
# Проверьте наличие файлов в директории locale/
ls locale/
# Должны быть: translations_en.json, translations_ru.json, etc.
```

### Шаг 2: Выполните встроенную сборку

```bash
# Сборка с embedded тегом
go build -tags embed -o criage-embedded

# Проверьте размер файла
ls -lh criage-embedded
```

### Шаг 3: Протестируйте

```bash
# Удалите директорию locale для тестирования
mv locale locale_backup

# Запустите embedded версию
./criage-embedded --help

# Восстановите директорию
mv locale_backup locale
```

## 🔧 Интеграция с main.go

### Автоматический выбор режима

```go
package main

import (
    "github.com/Kelnit/criage/pkg"
)

func main() {
    var localization *pkg.Localization
    
    // Пробуем создать embedded локализацию
    embeddedLangs := pkg.GetEmbeddedLanguages()
    if len(embeddedLangs) > 0 {
        // Если есть встроенные языки, используем их
        localization = pkg.NewEmbeddedLocalization()
        fmt.Println("🚀 Используются встроенные переводы")
    } else {
        // Иначе используем внешние файлы
        localization = pkg.NewLocalization()
        fmt.Println("📁 Используются внешние файлы переводов")
    }
    
    // Инициализируем глобальную локализацию
    pkg.SetGlobalLocalization(localization)
}
```

### Принудительный выбор режима

```go
// Всегда использовать embedded (может не работать без тега embed)
localization := pkg.NewEmbeddedLocalization()

// Всегда использовать внешние файлы
localization := pkg.NewLocalization()
```

## 📊 Сравнение режимов

| Параметр | 📁 Внешние файлы | 📦 Встроенные |
|----------|------------------|---------------|
| **Портабельность** | ❌ Нужны дополнительные файлы | ✅ Один исполняемый файл |
| **Динамичность** | ✅ Добавление языков без перекомпиляции | ❌ Нужна перекомпиляция |
| **Размер бинарника** | ✅ Меньше | ❌ Больше |
| **Безопасность** | ❌ Файлы можно изменить | ✅ Защищены от изменения |
| **Производительность** | ❌ Файловые операции | ✅ Быстрый доступ |
| **Развертывание** | ❌ Копировать файлы | ✅ Один файл |

## 🚀 Рекомендации использования

### 📦 Используйте встроенные переводы для

- **Production развертывания**
- **Распространения приложения**
- **Контейнеризации (Docker)**
- **Портативных версий**
- **Когда нужна максимальная надежность**

### 📁 Используйте внешние файлы для

- **Разработки и тестирования**
- **Когда планируется добавление новых языков**
- **Частых обновлений переводов**
- **Кастомизации пользователями**

## 🔄 Переход между режимами

### С внешних на встроенные

1. Убедитесь, что все переводы в `locale/` корректны
2. Пересоберите с тегом `embed`
3. Протестируйте без директории `locale/`

### С встроенных на внешние

1. Извлеките переводы из исходного кода в файлы
2. Пересоберите без тега `embed`
3. Убедитесь, что директория `locale/` доступна

## 🏷️ Build теги

Criage использует **Go build теги** для условной компиляции:

```go
//go:build embed          // Компилируется только с тегом embed
//go:build !embed         // Компилируется без тега embed
```

## 📝 Примеры сборки

### Разработка

```bash
go build                 # Быстрая сборка для разработки
go run main.go           # Запуск без сборки
```

### Production

```bash
go build -tags embed -ldflags "-s -w" -o criage
```

### Кросс-компиляция

```bash
# Windows
GOOS=windows GOARCH=amd64 go build -tags embed -o criage.exe

# Linux
GOOS=linux GOARCH=amd64 go build -tags embed -o criage-linux

# macOS
GOOS=darwin GOARCH=amd64 go build -tags embed -o criage-mac
```

## 🧪 Тестирование

Создайте тестовый файл для проверки обеих версий:

```go
package main

import (
    "fmt"
    "github.com/Kelnit/criage/pkg"
)

func main() {
    fmt.Println("🔧 Тестирование локализации")
    
    // Тест внешних файлов
    external := pkg.NewLocalization()
    fmt.Printf("📁 Внешние: %v языков\n", len(external.GetSupportedLanguages()))
    
    // Тест встроенных
    embedded := pkg.NewEmbeddedLocalization()
    fmt.Printf("📦 Встроенные: %v языков\n", len(embedded.GetSupportedLanguages()))
    
    // Информация о встроенных языках
    embeddedLangs := pkg.GetEmbeddedLanguages()
    fmt.Printf("🗂️ Список встроенных: %v\n", embeddedLangs)
}
```

## ✅ Готово

Теперь у вас есть **гибкая система локализации**, которая работает как с внешними файлами, так и со встроенными переводами. Выберите подходящий режим в зависимости от ваших потребностей!
