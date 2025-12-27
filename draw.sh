#!/bin/bash

# Остановить скрипт при любой ошибке
set -e

# === НАСТРОЙКИ ПУТЕЙ ===
DIR="keymap-drawer"
CONFIG="$DIR/keymap_drawer.config.yaml"
KEYMAP="config/sofle.keymap"
PARSED="$DIR/sofle_parsed.yaml"
OUTPUT="$DIR/sofle.svg"

echo "🎨 Начинаю генерацию схемы..."

# 0. Удаляем старый SVG
if [ -f "$OUTPUT" ]; then
    echo "🗑️  Удаляю старый файл $OUTPUT..."
    rm "$OUTPUT"
fi

# 1. Создаем папку
mkdir -p "$DIR"

# Проверка: существует ли конфиг?
if [ ! -f "$CONFIG" ]; then
    echo "❌ ОШИБКА: Не найден файл конфига: $CONFIG"
    echo "   Пожалуйста, убедись, что файл лежит в папке $DIR"
    echo "   Содержимое папки $DIR:"
    ls -1 "$DIR"
    exit 1
fi

# 2. Парсим
echo "⚙️  Парсинг $KEYMAP..."
keymap -c "$CONFIG" parse -z "$KEYMAP" > "$PARSED"

# 3. Рисуем
echo "🖌️  Рисование SVG..."
keymap -c "$CONFIG" draw --qmk-keyboard sofle/rev1 --qmk-layout LAYOUT "$PARSED" > "$OUTPUT"

# 4. Убираем мусор
rm "$PARSED"

echo "✅ Готово! Новая схема: $OUTPUT"