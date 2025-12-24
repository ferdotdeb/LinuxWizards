# Common functions across scripts

# Shell colors

BLUE='\033[0;34m'
ORANGE='\033[38;5;208m'   # naranja (256 colores)
RESET='\033[0m'


# Enable/disable colors (disable if output is not a TTY or NO_COLOR is set)
use_color=1
if [ -n "$NO_COLOR" ] || [ ! -t 1 ]; then
    use_color=0
fi

if [ "$use_color" -eq 1 ]; then
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
    if [ "$use_color" -eq 1 ]; then
        # %b for color escapes; %s for literal text (without interpreting backslashes)
        printf '%b%s%b\n' "$color" "$message" "$NC"
    else
        printf '%s\n' "$message"
    fi
}

print_success() { print_message "$GREEN" "✓ $*"; }
print_error()   { print_message "$RED"   "✗ ERROR: $*"; }
print_warning() { print_message "$YELLOW" "⚠ WARNING: $*"; }

# POSIX/portable (avoids &> which is bashism)
command_exists() {
    command -v -- "$1" >/dev/null 2>&1
}

# Uses DOTS_COUNT (default 3) and DOTS_DELAY (default 1s) as optional overrides.
dots() {
    msg=${1:-}
    count=${DOTS_COUNT:-3}
    delay=${DOTS_DELAY:-1}

    [ -n "$msg" ] && printf '%s' "$msg"

    i=0
    if [ ! -t 1 ]; then
        # No TTY (CI/logs), print without delays
        while [ "$i" -lt "$count" ]; do
            printf '.'
            i=$((i+1))
        done
        printf '\n'
        return 0
    fi

    while [ "$i" -lt "$count" ]; do
        printf '.'
        sleep "$delay"     # Integers for POSIX portability
        i=$((i+1))
    done
    printf '\n'
}