#!/bin/bash

# Универсальный скрипт сборки всего проекта Criage
# Собирает клиент и repository сервер с встроенной локализацией

set -e

echo "🏗️  Полная сборка проекта Criage с помощью собственного пакетного менеджера"
echo "======================================================================"

# Функция для красивого вывода времени
print_time() {
    echo "⏰ $(date '+%H:%M:%S'): $1"
}

# Функция для проверки успешности операции
check_success() {
    if [ $? -eq 0 ]; then
        echo "✅ $1 - успешно!"
    else
        echo "❌ $1 - ошибка!"
        exit 1
    fi
}

print_time "Начало сборки"

# 1. Проверяем и собираем основной пакетный менеджер
echo "📦 Этап 1: Подготовка пакетного менеджера..."
if [ ! -f "./criage" ]; then
    print_time "Сборка пакетного менеджера"
    go build -o criage .
    check_success "Сборка пакетного менеджера"
else
    echo "✅ Пакетный менеджер уже существует"
fi

# 2. Сборка клиента
echo ""
echo "🖥️  Этап 2: Сборка клиента с встроенной локализацией..."
print_time "Начало сборки клиента"

# Показываем информацию о клиенте
echo "📋 Информация о пакете клиента:"
echo "  • Имя: criage"
echo "  • Версия: 1.0.0"
echo "  • Тип: Пакетный менеджер с embedded локализацией"

./criage build -o criage-client-embedded.tar.zst -f tar.zst -c 6
check_success "Сборка клиента"

if [ -f "criage-client-embedded.tar.zst" ]; then
    client_size=$(du -h criage-client-embedded.tar.zst | cut -f1)
    echo "📏 Размер архива клиента: $client_size"
fi

# 3. Сборка repository сервера
echo ""
echo "🌐 Этап 3: Сборка repository сервера с встроенной локализацией..."
print_time "Начало сборки repository"

# Переходим в директорию repository
cd repository

# Показываем информацию о repository
echo "📋 Информация о пакете repository:"
echo "  • Имя: criage-repository"
echo "  • Версия: 1.0.0"
echo "  • Тип: Repository сервер с embedded локализацией"

../criage build -o criage-repository-embedded.tar.zst -f tar.zst -c 6
check_success "Сборка repository сервера"

if [ -f "criage-repository-embedded.tar.zst" ]; then
    repo_size=$(du -h criage-repository-embedded.tar.zst | cut -f1)
    echo "📏 Размер архива repository: $repo_size"
fi

# Возвращаемся в корневую директорию
cd ..

# 4. Итоговая информация
echo ""
echo "🎉 СБОРКА ЗАВЕРШЕНА УСПЕШНО!"
echo "======================================================================"
print_time "Конец сборки"

echo ""
echo "📦 Созданные архивы:"
if [ -f "criage-client-embedded.tar.zst" ]; then
    client_size=$(du -h criage-client-embedded.tar.zst | cut -f1)
    echo "  • criage-client-embedded.tar.zst ($client_size)"
fi

if [ -f "repository/criage-repository-embedded.tar.zst" ]; then
    repo_size=$(du -h repository/criage-repository-embedded.tar.zst | cut -f1)
    echo "  • repository/criage-repository-embedded.tar.zst ($repo_size)"
fi

echo ""
echo "🚀 Готово к развертыванию:"
echo "  • Клиент: полностью автономный пакетный менеджер"
echo "  • Сервер: репозиторий с веб-интерфейсом"
echo "  • Локализация: встроена в оба архива (ru, en, de, es)"
echo ""
echo "💡 Для тестирования используйте команды:"
echo "  ./criage metadata criage-client-embedded.tar.zst"
echo "  ./criage metadata repository/criage-repository-embedded.tar.zst" 