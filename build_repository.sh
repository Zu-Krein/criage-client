#!/bin/bash

# Скрипт сборки repository сервера Criage с встроенной локализацией
# Использует собственный пакетный менеджер Criage

set -e

echo "🚀 Сборка repository сервера Criage с помощью собственного пакетного менеджера..."

# Проверяем, есть ли исполняемый файл criage
if [ ! -f "./criage" ]; then
    echo "⚠️  Исполняемый файл criage не найден. Выполняем предварительную сборку..."
    go build -o criage .
fi

# Переходим в директорию repository
cd repository

# Показываем информацию о пакете
echo "📋 Информация о пакете repository:"
echo "  Имя: criage-repository"
echo "  Версия: 1.0.0"
echo "  Описание: Repository сервер с встроенной локализацией"

# Выполняем сборку с помощью пакетного менеджера
echo "🔨 Выполняем сборку пакета repository..."
../criage build -o criage-repository-embedded.tar.zst -f tar.zst -c 6

if [ $? -eq 0 ]; then
    echo "✅ Сборка repository сервера завершена успешно!"
    echo "📦 Создан архив: criage-repository-embedded.tar.zst"
    
    # Показываем размер архива
    if [ -f "criage-repository-embedded.tar.zst" ]; then
        size=$(du -h criage-repository-embedded.tar.zst | cut -f1)
        echo "📏 Размер архива: $size"
    fi
    
    # Возвращаемся в корневую директорию
    cd ..
else
    echo "❌ Ошибка при сборке repository сервера"
    cd ..
    exit 1
fi 