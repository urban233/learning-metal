#!/bin/sh
# Links this project's metal-tutor skill into the Codex configuration of Xcode's
# coding assistant, for an Xcode whose Codex does not read the project's
# .agents/skills folder. Creates one symbolic link; never overwrites anything.
set -eu

project_dir=$(cd "$(dirname "$0")" && pwd)
skill_dir="$project_dir/.agents/skills/metal-tutor"
target_dir="$HOME/Library/Developer/Xcode/CodingAssistant/codex/skills"
link="$target_dir/metal-tutor"

if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "error: $skill_dir/SKILL.md not found; run this script from the learning-metal repository." >&2
    exit 1
fi

if [ -L "$link" ]; then
    if [ "$(readlink "$link")" = "$skill_dir" ]; then
        echo "Already installed: $link -> $skill_dir"
        exit 0
    fi
    echo "error: $link already links to $(readlink "$link"); remove that link first if it is stale." >&2
    exit 1
fi
if [ -e "$link" ]; then
    echo "error: $link already exists and is not a link; leaving it untouched." >&2
    exit 1
fi

mkdir -p "$target_dir"
ln -s "$skill_dir" "$link"
echo "Installed: $link -> $skill_dir"
echo "Start a new Codex conversation in Xcode so it loads the skill."
