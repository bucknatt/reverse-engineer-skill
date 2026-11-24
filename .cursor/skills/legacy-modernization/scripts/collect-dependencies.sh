#!/usr/bin/env bash
# List dependency manifests and declared dependency names. Does not install or resolve.
set -euo pipefail

root="${1:-.}"
if [[ ! -d "$root" ]]; then
  echo "collect-dependencies: not a directory: $root" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "collect-dependencies: python3 is required to read manifests" >&2
  exit 1
fi

cd "$root"
echo "# dependencies"
echo "root: $(pwd)"

found=0

if [[ -f composer.json ]]; then
  found=1
  echo
  echo "## composer.json"
  python3 - "$PWD/composer.json" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as handle:
    data = json.load(handle)
php = (data.get("require") or {}).get("php")
if php:
    print(f"php: {php}")
for section in ("require", "require-dev"):
    deps = data.get(section) or {}
    print(f"{section}: {len(deps)}")
    for name in sorted(deps):
        print(f"  {name} {deps[name]}")
PY
  if [[ -f composer.lock ]]; then
    echo "composer.lock: present"
  else
    echo "composer.lock: absent"
  fi
fi

if [[ -f package.json ]]; then
  found=1
  echo
  echo "## package.json"
  python3 - "$PWD/package.json" <<'PY'
import json, sys
with open(sys.argv[1], encoding="utf-8") as handle:
    data = json.load(handle)
for section in ("dependencies", "devDependencies", "peerDependencies"):
    deps = data.get(section) or {}
    print(f"{section}: {len(deps)}")
    for name in sorted(deps):
        print(f"  {name} {deps[name]}")
PY
  if [[ -f package-lock.json || -f yarn.lock || -f pnpm-lock.yaml ]]; then
    echo "js-lock: present"
  else
    echo "js-lock: absent"
  fi
fi

if [[ -f pom.xml ]]; then
  found=1
  echo
  echo "## pom.xml"
  python3 - "$PWD/pom.xml" <<'PY'
import sys
import xml.etree.ElementTree as ET
tree = ET.parse(sys.argv[1])
root = tree.getroot()
ns = ""
if root.tag.startswith("{"):
    ns = root.tag.split("}")[0] + "}"
count = 0
for dep in root.iter(f"{ns}dependency"):
    group = dep.findtext(f"{ns}groupId") or ""
    artifact = dep.findtext(f"{ns}artifactId") or ""
    version = dep.findtext(f"{ns}version") or ""
    if group or artifact:
        print(f"  {group}:{artifact} {version}".rstrip())
        count += 1
print(f"dependencies: {count}")
PY
fi

if [[ -f build.gradle || -f build.gradle.kts ]]; then
  found=1
  gradle_file="build.gradle"
  [[ -f build.gradle.kts ]] && gradle_file="build.gradle.kts"
  echo
  echo "## $gradle_file"
  grep -E "^[[:space:]]*(implementation|api|compileOnly|runtimeOnly|testImplementation|classpath)[[:space:]]*[(\"]" "$gradle_file" || true
fi

shopt -s nullglob
csprojs=(*.csproj)
shopt -u nullglob
if [[ ${#csprojs[@]} -gt 0 ]]; then
  found=1
  echo
  echo "## csproj"
  python3 - "${csprojs[@]}" <<'PY'
import sys
import xml.etree.ElementTree as ET
for path in sys.argv[1:]:
    print(path)
    tree = ET.parse(path)
    root = tree.getroot()
    count = 0
    for node in root.iter():
        if node.tag.endswith("PackageReference"):
            name = node.attrib.get("Include") or node.attrib.get("Update") or ""
            version = node.attrib.get("Version") or ""
            print(f"  {name} {version}".rstrip())
            count += 1
    print(f"package-references: {count}")
PY
fi

if [[ "$found" -eq 0 ]]; then
  echo "manifest: none"
fi
