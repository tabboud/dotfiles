#!/usr/bin/env bash
# Symlinks the dotfiles in this repo into $HOME using only bash and ln, so it works on a fresh machine.
#
# Every entry in config/ is linked into ~/.config, and every dotfile in home/ is linked into $HOME.
# Broken links that point into this repo, e.g. after a config is moved or deleted, are removed.
set -eo pipefail
shopt -s nullglob

DOTFILES="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN=false
OS="$(uname)"

# Linked only on macOS.
declare -a DARWIN_ONLY=(
    config/ghostty
    home/.hammerspoon
)

declare -a SRCS=()
declare -a DSTS=()

# Directories created so far, so a dry run prints each mkdir once.
declare -a MADE_DIRS=()

# Returns 0 if $1 equals any of the remaining arguments.
function contains() {
    local needle="$1" item
    shift
    for item in "$@"; do
        [[ "$item" == "$needle" ]] && return 0
    done
    return 1
}

# Prints $1 with $HOME shortened to ~.
function pretty() {
    case "$1" in
        "$HOME"/*) echo \~/"${1#"$HOME"/}" ;;
        *) echo "$1" ;;
    esac
}

# Runs a command that changes $HOME, or prints it in dry-run mode.
function run() {
    if [[ "$DRY_RUN" == true ]]; then
        printf '$'
        printf ' %q' "$@"
        echo
    else
        "$@"
    fi
}

# Prints a progress message, except in dry-run mode where the commands are printed instead.
function say() {
    [[ "$DRY_RUN" == true ]] || echo "$@"
}

# Fills SRCS and DSTS with every link this repo manages on the current OS.
function collect() {
    local src rel
    for src in "$DOTFILES"/config/* "$DOTFILES"/home/.[!.]*; do
        rel="${src#"$DOTFILES"/}"
        [[ "${rel##*/}" == ".DS_Store" ]] && continue
        if [[ "$OS" != "Darwin" ]] && contains "$rel" "${DARWIN_ONLY[@]}"; then
            continue
        fi
        SRCS+=("$src")
        case "$rel" in
            config/*) DSTS+=("$HOME/.config/${rel#config/}") ;;
            home/*) DSTS+=("$HOME/${rel#home/}") ;;
        esac
    done
}

# Prints absolute path $1 with its deepest existing directory resolved physically.
function physical() {
    local dir="$1" rest=""
    while [[ -n "$dir" && ! -d "$dir" ]]; do
        rest="/${dir##*/}$rest"
        dir="${dir%/*}"
    done
    echo "$(cd -P "${dir:-/}" && pwd)$rest"
}

# Prints broken links in $HOME and ~/.config that point into this repo and are not managed paths.
function stale_links() {
    local dst target
    for dst in "$HOME"/.[!.]* "$HOME"/.config/*; do
        [[ -L "$dst" && ! -e "$dst" ]] || continue
        contains "$dst" "${DSTS[@]}" && continue
        target="$(readlink "$dst")"
        [[ "$target" == /* ]] || target="$(dirname "$dst")/$target"
        if [[ "$(physical "$target")" == "$DOTFILES"/* ]]; then
            echo "$dst"
        fi
    done
}

function remove_stale() {
    local dst
    while IFS= read -r dst; do
        run rm "$dst"
        say "Removed stale link $(pretty "$dst")"
    done < <(stale_links)
}

# Symlinks $2 to $1, replacing a broken link or backing up anything else at $2.
function link_one() {
    local src="$1" dst="$2" parent backup
    if [[ -L "$dst" && "$dst" -ef "$src" ]]; then
        return
    elif [[ -L "$dst" && ! -e "$dst" ]]; then
        run rm "$dst"
    elif [[ -e "$dst" || -L "$dst" ]]; then
        backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
        say "Backing up $(pretty "$dst") to $(pretty "$backup")"
        run mv "$dst" "$backup"
    fi
    parent="$(dirname "$dst")"
    if [[ ! -d "$parent" ]] && ! contains "$parent" "${MADE_DIRS[@]}"; then
        run mkdir -p "$parent"
        MADE_DIRS+=("$parent")
    fi
    run ln -s "$src" "$dst"
    say "Linked $(pretty "$dst")"
}

# Removes $2 if it is a symlink to $1.
function unlink_one() {
    local src="$1" dst="$2"
    if [[ -L "$dst" && "$dst" -ef "$src" ]]; then
        run rm "$dst"
        say "Unlinked $(pretty "$dst")"
    fi
}

# Prints the state of $2 and returns 1 unless it is linked to $1.
function status_one() {
    local src="$1" dst="$2" state
    if [[ -L "$dst" && "$dst" -ef "$src" ]]; then
        state="linked"
    elif [[ -L "$dst" && ! -e "$dst" ]]; then
        state="broken"
    elif [[ -e "$dst" || -L "$dst" ]]; then
        state="conflict"
    else
        state="missing"
    fi
    printf '%-9s %s\n' "$state" "$(pretty "$dst")"
    [[ "$state" == "linked" ]]
}

function status_all() {
    local i dst ok=true
    for i in "${!SRCS[@]}"; do
        status_one "${SRCS[$i]}" "${DSTS[$i]}" || ok=false
    done
    while IFS= read -r dst; do
        printf '%-9s %s\n' "stale" "$(pretty "$dst")"
        ok=false
    done < <(stale_links)
    if [[ "$ok" == false ]]; then
        echo "Run 'dots link' to fix."
        return 1
    fi
}

function usage() {
cat<<EOD
Usage: $(basename "$0") <command> [-n|--dry-run]

Commands:
    link   -- link all dotfiles
    unlink -- remove all dotfile symlinks
    status -- show the state of every link

Options:
    -n, --dry-run -- print the commands that would run without changing anything
EOD
  exit 1
}

[[ "$#" -gt 0 ]] || usage
command="$1"
shift
for arg in "$@"; do
    case "$arg" in
        -n|--dry-run) DRY_RUN=true ;;
        *) usage ;;
    esac
done

collect

case "$command" in
  link)
    for i in "${!SRCS[@]}"; do
        link_one "${SRCS[$i]}" "${DSTS[$i]}"
    done
    remove_stale
    ;;
  unlink)
    for i in "${!SRCS[@]}"; do
        unlink_one "${SRCS[$i]}" "${DSTS[$i]}"
    done
    remove_stale
    ;;
  status)
    status_all
    ;;
  *)
    usage
    ;;
esac

exit 0
