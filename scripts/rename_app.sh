#!/usr/bin/env bash
set -euo pipefail

# ============================================
# ULTIMATE Flutter App Renamer
# Safe • Cross-platform • CI-ready
# ============================================

if [[ $# -lt 2 ]]; then
  echo "Usage:"
  echo "  $0 \"New App Name\" com.company.app"
  exit 1
fi

NEW_APP_NAME="$1"
NEW_PACKAGE="$2"

if ! [[ $NEW_PACKAGE =~ ^[a-z][a-z0-9_]*(\.[a-z0-9_]+)+$ ]]; then
  echo "❌ Invalid package name"
  exit 1
fi

ROOT=$(pwd)
PUBSPEC="$ROOT/pubspec.yaml"

[[ -f "$PUBSPEC" ]] || { echo "❌ Run in Flutter project root"; exit 1; }

# ---------- Helpers ----------

backup() {
  [[ -f "$1" ]] && cp "$1" "$1.bak"
}

escape_sed() {
  printf '%s\n' "$1" | sed 's/[\/&]/\\&/g'
}

sed_inplace() {
  local expr="$1"
  local file="$2"

  [[ -f "$file" ]] || return
  backup "$file"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$expr" "$file"
  else
    sed -i "$expr" "$file"
  fi
}

replace_line() {
  local file="$1"
  local pattern="$2"
  local replacement
  replacement=$(escape_sed "$3")

  sed_inplace "s|$pattern|$replacement|g" "$file"
}

replace_plist_key() {
  local file="$1"
  local key="$2"
  local value="$3"
  local escaped
  escaped=$(escape_sed "$value")

  sed_inplace "/<key>$key<\/key>/{n;s|<string>.*</string>|<string>$escaped</string>|;}" "$file"
}

echo "🔍 Reading project info..."

OLD_DART_NAME=$(grep '^name:' "$PUBSPEC" | awk '{print $2}')
NEW_DART_NAME=$(echo "$NEW_APP_NAME" \
  | tr '[:upper:]' '[:lower:]' \
  | tr ' ' '_' \
  | tr '-' '_')

echo "Old Dart name: $OLD_DART_NAME"
echo "New Dart name: $NEW_DART_NAME"
echo "New Package:   $NEW_PACKAGE"
echo

read -p "Proceed? (y/N): " yn
[[ "$yn" =~ ^[Yy]$ ]] || exit 0

echo "🚀 Renaming..."

# ============================================
# ANDROID
# ============================================

echo "📱 Android"

# build.gradle & kts
for f in android/app/build.gradle android/app/build.gradle.kts; do
  [[ -f "$f" ]] || continue
  # Шукаємо будь-які лапки (одинарні або подвійні)
  sed_inplace "s|applicationId.*['\"].*['\"]|applicationId \"$NEW_PACKAGE\"|g" "$f"
  sed_inplace "s|namespace.*['\"].*['\"]|namespace \"$NEW_PACKAGE\"|g" "$f"
done

# strings.xml
replace_line \
  android/app/src/main/res/values/strings.xml \
  '<string name="app_name">.*</string>' \
  "<string name=\"app_name\">$NEW_APP_NAME</string>"

# Manifest package
replace_line \
  android/app/src/main/AndroidManifest.xml \
  'package="[^"]*"' \
  "package=\"$NEW_PACKAGE\""

# Detect old package
OLD_PACKAGE=$(sed -n "s/.*namespace *[=]* *['\"]\(.*\)['\"].*/\1/p" android/app/build.gradle android/app/build.gradle.kts 2>/dev/null | head -n 1 || true)

if [[ -z "$OLD_PACKAGE" ]]; then
  OLD_PACKAGE=$(sed -n 's/.*package="\([^"]*\)".*/\1/p' android/app/src/main/AndroidManifest.xml 2>/dev/null | head -n 1 || true)
fi


if [[ -n "$OLD_PACKAGE" ]]; then
  OLD_PATH=${OLD_PACKAGE//./\/}
  NEW_PATH=${NEW_PACKAGE//./\/}

  for base in java kotlin; do
    SRC="android/app/src/main/$base/$OLD_PATH"
    DST="android/app/src/main/$base/$NEW_PATH"

    if [[ -d "$SRC" ]]; then
      mkdir -p "$DST"
      mv "$SRC"/* "$DST"/ || true
      rm -rf "android/app/src/main/$base/$OLD_PATH"
      
      # Clean up empty parent directories (e.g., com/company)
      DIR_TO_CLEAN="android/app/src/main/$base/$(echo "$OLD_PATH" | cut -d'/' -f1)"
      find "$DIR_TO_CLEAN" -type d -empty -delete 2>/dev/null || true
    fi
  done

  find android/app/src \( -name "*.kt" -o -name "*.java" \) -print0 |
  while IFS= read -r -d '' f; do
    replace_line "$f" "^package .*" "package $NEW_PACKAGE"
  done
fi

# ============================================
# iOS + macOS
# ============================================

echo "🍎 Apple platforms"

for plist in ios/Runner/Info.plist macos/Runner/Info.plist; do
  [[ -f "$plist" ]] || continue

  replace_plist_key "$plist" CFBundleName "$NEW_APP_NAME"
  replace_plist_key "$plist" CFBundleDisplayName "$NEW_APP_NAME"
done

# Bundle ID — через Xcode project
for proj in ios/Runner.xcodeproj/project.pbxproj \
            macos/Runner.xcodeproj/project.pbxproj; do
  replace_line "$proj" 'PRODUCT_BUNDLE_IDENTIFIER = .*;' \
    "PRODUCT_BUNDLE_IDENTIFIER = $NEW_PACKAGE;"
done

# ============================================
# WEB
# ============================================

echo "🌐 Web"

replace_line web/index.html '<title>.*</title>' "<title>$NEW_APP_NAME</title>"
replace_line web/manifest.json '"name": ".*"' "\"name\": \"$NEW_APP_NAME\""
replace_line web/manifest.json '"short_name": ".*"' "\"short_name\": \"$NEW_APP_NAME\""

# ============================================
# DESKTOP
# ============================================

echo "🖥 Desktop"

for f in windows/CMakeLists.txt linux/CMakeLists.txt; do
  replace_line "$f" 'set\(APPLICATION_ID ".*"\)' \
    "set(APPLICATION_ID \"$NEW_PACKAGE\")"
done

# ============================================
# PUBSPEC
# ============================================

echo "📦 pubspec"

replace_line "$PUBSPEC" '^name: .*' "name: $NEW_DART_NAME"

# Update imports
find lib test -name "*.dart" -print0 2>/dev/null |
while IFS= read -r -d '' f; do
  replace_line "$f" "package:$OLD_DART_NAME" "package:$NEW_DART_NAME"
done

# ============================================
# DONE
# ============================================

echo
echo "✅ SUCCESS!"
echo
echo "Next steps:"
echo "  flutter clean"
echo "  flutter pub get"
echo "  flutter run"
echo
echo "Backups saved as *.bak"