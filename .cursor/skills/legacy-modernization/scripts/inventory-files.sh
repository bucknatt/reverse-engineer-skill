#!/usr/bin/env bash
# List file facts for a legacy tree. Does not describe architecture.
set -euo pipefail

root="${1:-.}"
if [[ ! -d "$root" ]]; then
  echo "inventory-files: not a directory: $root" >&2
  exit 1
fi

cd "$root"

echo "# inventory"
echo "root: $(pwd)"

# Prune dependency and build trees. Count source-like files only.
mapfile -d '' files < <(
  find . \
    -path './.git' -prune -o \
    -path './vendor' -prune -o \
    -path './node_modules' -prune -o \
    -path './dist' -prune -o \
    -path './build' -prune -o \
    -path './target' -prune -o \
    -path './.idea' -prune -o \
    -type f -print0
)

declare -A counts=()
total=0
for file in "${files[@]}"; do
  total=$((total + 1))
  base="${file##*/}"
  if [[ "$base" == *.* ]]; then
    ext="${base##*.}"
  else
    ext="(none)"
  fi
  ext="${ext,,}"
  counts["$ext"]=$((${counts["$ext"]:-0} + 1))
done

echo "files: $total"
echo
echo "# extensions"
for ext in "${!counts[@]}"; do
  printf '%s\t%s\n' "${counts[$ext]}" "$ext"
done | sort -nr

echo
echo "# entry-point candidates"
candidates=(
  index.php
  public/index.php
  artisan
  bin/console
  manage.py
  app.py
  main.py
  Program.cs
  Startup.cs
  pom.xml
  build.gradle
  build.gradle.kts
  package.json
  composer.json
  go.mod
  Cargo.toml
  Makefile
)
found=0
for candidate in "${candidates[@]}"; do
  if [[ -f "$candidate" ]]; then
    echo "$candidate"
    found=1
  fi
done
if [[ "$found" -eq 0 ]]; then
  echo "(none of the known candidate names)"
fi
