#!/bin/bash

# Скрипт сборки клиента Criage с встроенной локализацией
# Использует собственный пакетный менеджер Criage

set -e

echo "🚀 Сборка клиента Criage с помощью собственного пакетного менеджера..."

# Проверяем, есть ли исполняемый файл criage
if [ ! -f "./criage" ]; then
    echo "⚠️  Исполняемый файл criage не найден. Выполняем предварительную сборку..."
    go build -o criage .
fi

# Показываем информацию о пакете
echo "📋 Информация о пакете клиента:"
echo "  Имя: criage"
echo "  Версия: 1.0.0"
echo "  Описание: Универсальный пакетный менеджер с встроенной локализацией"

# Выполняем сборку с помощью пакетного менеджера
echo "🔨 Выполняем сборку пакета клиента..."
./criage build -o criage-client-embedded.tar.zst -f tar.zst -c 6

if [ $? -eq 0 ]; then
    echo "✅ Сборка клиента завершена успешно!"
    echo "📦 Создан архив: criage-client-embedded.tar.zst"
    
    # Показываем размер архива
    if [ -f "criage-client-embedded.tar.zst" ]; then
        size=$(du -h criage-client-embedded.tar.zst | cut -f1)
        echo "📏 Размер архива: $size"
    fi
else
    echo "❌ Ошибка при сборке клиента"
    exit 1
fi 