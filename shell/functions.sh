# Cross platform utility functions
#

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

function suspended_jobs() {
    local sj
    sj=$(jobs 2>/dev/null | tail -n 1)
    if [[ $sj == "" ]]; then
        echo ""
    else
        echo "%{$FG[208]%}✱%f"
    fi
}

# Run either gradlew or godelw
function gd() {
    # check for gradlew
    if [ -f "gradlew" ]; then
        ./gradlew $@
    elif [ -f "godelw" ]; then
        ./godelw $@
    else
        echo "neither ./gradlew or ./godelw found!"
    fi
}

# git functions
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

# list out all directly imported packages
function getGoImports() {
    go list -f '{{ join .Imports "\n" }}' ./...
}

# List dependencies for go pkgs
# deps ./... | grep palantir | vim -
function deps() {
    go list -f '{{ join .Deps  "\n"}}' $1 | sort | uniq
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
