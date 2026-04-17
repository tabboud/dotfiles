# Cross platform utility functions
#

# Function to check for help flag and display help message
# Usage: check_help "help message"
check_help() {
  local help_message="$1"

  for arg in "$@"; do
    if [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
      echo "$help_message"
      return 0
    fi
  done

  return 1
}

# Create a new directory and enter it
# Function to create a new directory and cd into it
function mkcd() {
  local help_message="Usage: mkcd <directory-name>

Options:
  -h, --help     Show this help message and exit

Description:
  Creates a new directory and changes the current directory to the newly created one."
  check_help "$help_message" "$@" && return

  if [[ -z $1 ]]; then
    echo "Error: Directory name required."
    echo "$help_message"
    return 1
  fi

  # Create the directory if it does not exist, and change into it
  mkdir -p "$1" && cd "$1"
}

function hist() {
    history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# find shorthand
function f() {
    find . -name "$1"
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

# Convert a .mov file to a .gif
function movToGif() {
    # Based on https://gist.github.com/SheldonWangRJT/8d3f44a35c8d1386a396b9b49b43c385
    output_file="$1.gif"
    ffmpeg -i $1 -pix_fmt rgb8 -r 10 $output_file && gifsicle -O3 $output_file -o $output_file
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

# listDeleted lists the local branches that
# are removed from the remote tracking repo.
function listDeleted() {
    git fetch -p && git branch -vv | awk '/: gone]/{print $1}'
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
