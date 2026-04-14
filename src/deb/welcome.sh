welcome() {
    printf "${BLUE}                                                                                              ${RESET}\n";
    printf "${BLUE}██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗    ██╗    ██╗██╗███████╗ █████╗ ██████╗ ██████╗ ${RESET}\n";
    printf "${BLUE}██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║    ██║    ██║██║╚══███╔╝██╔══██╗██╔══██╗██╔══██╗${RESET}\n";
    printf "${BLUE}██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║    ██║ █╗ ██║██║  ███╔╝ ███████║██████╔╝██║  ██║${RESET}\n";
    printf "${BLUE}██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║    ██║███╗██║██║ ███╔╝  ██╔══██║██╔══██╗██║  ██║${RESET}\n";
    printf "${BLUE}██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║    ╚███╔███╔╝██║███████╗██║  ██║██║  ██║██████╔╝${RESET}\n";
    printf "${BLUE}╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝     ╚══╝╚══╝ ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ${RESET}\n";
    printf "${BLUE}                                                                                              ${RESET}\n";

    printf '%s\n' "This script will perform basic fixes and configurations that must be executed strictly in the terminal"
    print_warning "These configurations are recommended for Debian 13"

    sleep 5

    return 0
}