#!/bin/bash

# Остановить скрипт при любой ошибке
set -e

# === НАСТРОЙКИ ПУТЕЙ ===
DIR="keymap-drawer"
# Если конфиг лежит в корне, а не в папке, раскомментируй нижнюю строку и закомментируй текущую:
# CONFIG="keymap_drawer.config.yaml"
CONFIG="$DIR/keymap_drawer.config.yaml"
KEYMAP="config/kin36_sweep36key.keymap"
PARSED="$DIR/kin36_parsed.yaml"
OUTPUT="$DIR/kin36.svg"

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
    echo "   Пожалуйста, убедись, что файл лежит по правильному пути"
    exit 1
fi

# 2. Парсим
echo "⚙️  Парсинг $KEYMAP..."
keymap -c "$CONFIG" parse -z "$KEYMAP" > "$PARSED"

# 3. Рисуем
echo "🖌️  Рисование SVG..."
# Используем физический макет crkbd (Corne) в модификации 3x5+3
keymap -c "$CONFIG" draw --qmk-keyboard crkbd/rev1 --qmk-layout LAYOUT_split_3x5_3 "$PARSED" > "$OUTPUT"

# 4. Убираем мусор
rm "$PARSED"

echo "✅ Готово! Новая схема: $OUTPUT"