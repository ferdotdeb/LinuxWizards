#!/bin/bash

# These are common functions across scripts

# Ensure terminal settings are sane for input
if [[ -t 0 ]]; then
    stty erase ^? kill ^U 2>/dev/null
fi

# Shell colors

BLUE='\033[0;34m'
ORANGE='\033[38;5;208m'
RESET='\033[0m'
RB_RED=$(printf '\033[38;5;196m')
RB_ORANGE=$(printf '\033[38;5;202m')
RB_YELLOW=$(printf '\033[38;5;226m')
RB_GREEN=$(printf '\033[38;5;082m')
RB_VIOLET=$(printf '\033[38;5;163m')

# Enable/disable colors (disable if output is not a TTY or NO_COLOR is set)

use_color=1
if [[ -n "$NO_COLOR" ]] || [[ ! -t 1 ]]; then
    use_color=0
fi

if (( use_color == 1 )); then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color
else
  RED=''; GREEN=''; YELLOW=''; NC=''
fi

# Print colored message. Accepts arbitrary text after the color param.

print_message() {
    local color="$1"; shift
    local message="$*"
    if (( use_color == 1 )); then
        # %b for color escapes; %s for literal text (without interpreting backslashes)
        printf '%b%s%b\n' "$color" "$message" "$NC"
    else
        printf '%s\n' "$message"
    fi
}

print_success() { print_message "$GREEN" "✓ $*"; }
print_error()   { print_message "$RED"   "✗ ERROR: $*"; }
print_warning() { print_message "$YELLOW" "⚠ WARNING: $*"; }

# Check if command exists (bash version)
command_exists() {
    command -v "$1" &>/dev/null
}

# Uses DOTS_COUNT (default 3) and DOTS_DELAY (default 1s) as optional overrides.

dots() {
    local msg=${1:-}
    local count=${DOTS_COUNT:-3}
    local delay=${DOTS_DELAY:-1}

    [[ -n "$msg" ]] && printf '%s' "$msg"

    local i=0
    if [[ ! -t 1 ]]; then
        # No TTY (CI/logs), print without delays
        while (( i < count )); do
            printf '.'
            (( i++ ))
        done
        printf '\n'
        return 0
    fi

    while (( i < count )); do
        printf '.'
        sleep "$delay"
        (( i++ ))
    done
    printf '\n'
}