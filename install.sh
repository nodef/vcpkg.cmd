#!/usr/bin/env bash
REPO="https://github.com/Microsoft/vcpkg"
TEMP_DIR="repo"

# We want to download vcpkg in the current directory
# 1. Download the repo to a temp folder
if ! git --version >/dev/null 2>&1; then
  echo "Git is not installed. Please install Git and ensure it is in your PATH." >&2
  exit 1
fi
git clone --depth 1 "$REPO" "$TEMP_DIR"
rm -f "vcpkg"
# 2. Move the contents of the temp folder to the current directory
if rsync --version >/dev/null 2>&1; then
  rsync -a --exclude='.git' "$TEMP_DIR"/ .
else
  shopt -s dotglob nullglob
  for f in "$TEMP_DIR"/* "$TEMP_DIR"/.[!.]* "$TEMP_DIR"/..?*; do
    if [[ ! -e "$f" ]]; then continue; fi
    if [[ $(basename "$f") == ".git" ]]; then continue; fi
    mv -f "$f" .
  done
fi

# Now, lets install vcpkg
./bootstrap-vcpkg.sh -disableMetrics
./vcpkg integrate install
