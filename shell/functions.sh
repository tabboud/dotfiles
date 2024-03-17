# Cross platform utility functions
#

# Append a path to $PATH IFF it doesn't exist.
#
# Ex: pathappend path1 -> $PATH:path1
function pathappend() {
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
}

# Prepend a path to $PATH IFF it doesn't exist.
#
# Ex: pathprepend path1 -> path1:$PATH
function pathprepend() {
    ARG=$1
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
}

# print available colors and their numbers
function colours() {
    for i in {0..255}; do
        printf "\x1b[38;5;${i}m colour${i}"
        if (( $i % 5 == 0 )); then
            printf "\n"
        else
            printf "\t"
        fi
    done
}

# Create a new directory and enter it
function md() {
    echo "mkdir -p \"$@\" && cd \"$@\""
    mkdir -p "$@" && cd "$@"
}

function hist() {
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# find shorthand
function f() {
    find . -name "$1"
}

# find piped to grep
function findinfiles() {
    if [[ "$#" -ne 2 ]]; then
        echo "USAGE: findinfiles <file_pattern> <grep_pattern>"
        return
    fi
    find . -type f -iname "$1" -print0 | xargs -0 ag "$2"
}

# get gzipped size
function gz() {
    echo "orig size    (bytes): "
    cat "$1" | wc -c
    echo "gzipped size (bytes): "
    gzip -c "$1" | wc -c
}

# Extract archives - use: extract <file>
# Credits to http://dotfiles.org/~pseup/.bashrc
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz) tar xzf $1 ;;
            *.bz2) bunzip2 $1 ;;
            *.rar) rar x $1 ;;
            *.gz) gunzip $1 ;;
            *.tar) tar xf $1 ;;
            *.tbz2) tar xjf $1 ;;
            *.tgz) tar xzf $1 ;;
            *.zip) unzip $1 ;;
            *.Z) uncompress $1 ;;
            *.7z) 7z x $1 ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Run either gradlew or godelw
# function gd() {
#     # check for gradlew
#     if [ -f "godelw" ]; then
#         ./godelw $@
#     elif [ -f "gradlew" ]; then
#         ./gradlew $@
#     else
#         echo "neither ./gradlew or ./godelw found!"
#     fi
# }
# Run gradlew
function gra() {
    ./gradlew $@
}
# Run godlew
function god() {
    ./godelw $@
}

#=========================================
# Git functions
#=========================================
function git_current_branch() {
  git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
}

function gpull() {
    git pull origin $(git_current_branch)
}

function gpush() {
    git push origin $(git_current_branch)
}

function gpushf() {
    git push -f origin $(git_current_branch)
}

# gdefault prints the default branch for a git repo.
# The remote name can be provided, but otherwise defaults to origin.
function gdefault() {
    # local remoteName=${1:-"origin"}
    # git remote show $remoteName | grep 'HEAD branch' | cut -d' ' -f5

    # Switch to this. Much faster but assumes "origin"
    git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
}

# gupdate will checkout the provided branch
# run a git pull
# and checkout the existing branch
function gupdate() {
    local current=$(git_current_branch)

    # always checkout the current branch even if a failure occured
    # trap git checkout current RETURN
    git checkout $1 && \
    gpull && \
    git checkout $current
}

# list all changed files. Use in combination with vim,
# to edit all files that have changed
function changedFiles() {
    git status --porcelain | sed -ne 's/^ M //p'
}

#=========================================
# Go functions
#=========================================
# list out directly imported packages for an entire project
function getGoImportsForAll() {
    getGoImportsForPkg ./...
}

# list directly imported packages for a given pkg.
function getGoImportsForPkg() {
    if [[ "$#" -ne 1 ]]; then
        echo "USAGE: getGoImportsForPkg <pkg> (Ex: getGoImportsForPkg ./internal/server)"
        return
    fi

    go list -f '{{ join .Imports "\n" }}' $1
}

# List dependencies for go pkgs
# deps ./... | grep palantir | vim -
function deps() {
    go list -f '{{ join .Deps  "\n"}}' $1 | sort | uniq
}

# List dependencies for go pkgs by the pkg name
# deps ./... | grep palantir | vim -
function depsByPkg() {
    go list -f '{{.ImportPath}}:{{"\n\t"}}{{ join .Deps  "\n\t"}}' $1
}

goImportsByPkg() {
    local helpText=$( printf "USAGE: %s <pkgs>

        Lists directly imported packages, by import path, for the provided packages.
        Example: goImportsByPkg ./...\n" "$0")
    if hasHelpFlag "$@"; then
        echo $helpText
        return 1
    fi
    if [[ $# -ne 1 ]]; then
        echo "Not enough arguments"
        echo $helpText
        return 1
    fi
    go list -f '{{.ImportPath}}:{{"\n\t"}}{{join .Imports "\n\t"}}' "$1"
}

# listDeleted lists the local branches that
# are removed from the remote tracking repo.
function listDeleted() {
    git fetch -p && git branch -vv | awk '/: gone]/{print $1}'
}

# mkdirDate creates a new director with the current date
# ex: 2019-11-01
function mkdirDate() {
    mkdir $(date +%Y-%m-%d)
}

# etmp creates a new temp file and opens it using the $EDITOR.
# The filename will be printed out before opening.
function etmp() {
    tempFile=$(mktemp)
    echo "Tempfile: $tempFile"
    $EDITOR $tempFile
}


# gheclone will run git clone from anywhere on the system
# from the configured $GHE_ORG and place the repo in the following locatioins:
#   - "$ROOT_CODE_DIR/$GHE_ORG/repo"
#   - "$GOPATH/src/$GHE_ORG/repo" (if $ROOT_CODE_DIR is not set)
#
# The env GHE_ORG must be set to use ghe clone.
# If cloning from public github.com, use `ghclone` instead
#
# Alternatively:
# gheclone <ghe-org>/repo
# ghclone tabboud/dotfiles
# TODO(tabboud): Update this to use different input arguments (full url, git url, org/repo, etc)
#                Can alternatively proxy these through the 'gh' command
function gheclone() {
    if [[ "$#" -ne 1 ]]; then
        echo "USAGE: gheclone <org>/<repo>"
        return
    fi

    _internalClone "${GHE_ORG}" "$1"
}

function ghclone() {
    if [[ "$#" -ne 1 ]]; then
        echo "USAGE: ghclone <org>/<repo>"
        return
    fi

    _internalClone "github.com" "$1"
}

function _internalClone() {
    local account=$1
    local repo=$2
    local codeDir="${ROOT_CODE_DIR:-$GOPATH/src}/$account"
    local dest="$codeDir/$repo"

    # Ensure the repo is not already cloned
    if [ -e "$dest" ]; then
        echo "$dest: already exists"
        return
    fi

    # Ensure the root code dir exists before cloning
    if [ ! -d "$codeDir" ]; then
        local colorYellow='\033[1;33m'
        local colorNone='\033[0m'
        echo -e "${colorYellow}Creating $codeDir since it does not exist${colorNone}"
        mkdir -p "$codeDir"
    fi

    git clone git@"$account":"$repo" "$dest" && cd "$dest"
}

# Returns 0 if the provided arguments contains
# a help flag (-h) and 1 otherwise.
hasHelpFlag() {
    while getopts h option; do
       case $option in
          h)
             return 0;;
          *)
             return 1;;
       esac
    done
    return 1
}
