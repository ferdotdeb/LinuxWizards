# ======================================================================
# PRINT MESSAGES FUNCTIONS
# ======================================================================

# Color codes for output messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print success messages
print_success() {
    print_message "$GREEN" "✓ $1"
}

# Function to print error messages
print_error() {
    print_message "$RED" "✗ ERROR: $1"
}

# Function to print warning messages
print_warning() {
    print_message "$YELLOW" "⚠ WARNING: $1"
}

command_exists() {
    command -v "$1" &> /dev/null
}