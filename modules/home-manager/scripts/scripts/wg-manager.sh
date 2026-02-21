#!/usr/bin/env bash
set -euo pipefail

log_error() {
    # Print error messages in a consistent format to stderr
    echo "[wg-manager][ERROR] $*" >&2
}

print_help() {
    cat <<EOF
Usage: $(basename "$0") [status|toggle|down|up|help] [INTERFACE]

Commands:
  status [INTERFACE]   Show status of all or specified WireGuard interfaces
  services             Show available WireGuard services
  toggle INTERFACE     Toggle the specified WireGuard interface (on/off)
  down                 Bring all WireGuard interfaces down
  up INTERFACE         Bring the specified WireGuard interface up
  help                 Show this help message

Examples:
  $(basename "$0") status
  $(basename "$0") services
  $(basename "$0") status wg0
  $(basename "$0") toggle wg0
  $(basename "$0") up wg0
  $(basename "$0") down

EOF
}

list_services() {
    systemctl list-unit-files --type=service | grep wg-quick- | awk '{print $1}' | sed 's/.service//'
}

check_interface() {
    local iface="$1"
    local services="$2"
    if ! echo "$services" | grep -qw "$iface"; then
        log_error "Interface '$iface' not found among available WireGuard services."
        exit 1
    fi
}

stop_all_services() {
    local services="$1"
    for svc in $services; do
        sudo systemctl stop "$svc"
    done
}

up_action() {
    local iface="$1"
    local services="$2"
    local svc="wg-quick-$iface"
    # if svs running quit
    if systemctl is-active "$svc" >/dev/null; then
      return
    fi
    # Stop all other wg-quick services
    for s in $services; do
        if [ "$s" != "$svc" ]; then
            sudo systemctl stop "$s"
        fi
    done
    sudo systemctl start "$svc"
}

status_action() {
    local iface="$1"
    local services="$2"
    if [ -n "$iface" ]; then
        local svc="wg-quick-$iface"
        if systemctl is-active "$svc" >/dev/null; then
            echo "WG-$iface: ON"
        else
            echo "WG-$iface: OFF"
        fi
    else
        for svc in $services; do
            local name="${svc#wg-quick-}"
            if systemctl is-active "$svc" >/dev/null; then
                echo "WG-$name: ON"
            else
                echo "WG-$name: OFF"
            fi
        done
    fi
}

toggle_action() {
    local iface="$1"
    local services="$2"
    local svc="wg-quick-$iface"
    if systemctl is-active "$svc" >/dev/null; then
        sudo systemctl stop "$svc"
    else
        # Stop all other wg-quick services
        for s in $services; do
            if [ "$s" != "$svc" ]; then
                sudo systemctl stop "$s"
            fi
        done
        sudo systemctl start "$svc"
    fi
}

main() {
    local action="${1:-status}"
    local iface="${2:-}"

    if [[ "$action" == "help" || "$action" == "--help" || "$action" == "-h" ]]; then
        print_help
        exit 0
    fi

    local services
    services="$(list_services)"

    if [ -z "$services" ]; then
        log_error "No WireGuard services found. Exiting."
        exit 1
    fi

    if [ -n "$iface" ]; then
        check_interface "$iface" "$services"
    fi

    case "$action" in
        status)
            status_action "$iface" "$services"
            ;;
        services)
            echo "$services" | sed 's/^wg-quick-//'
            ;;
        toggle)
            if [ -z "$iface" ]; then
                log_error "No interface specified for toggle action."
                print_help
                exit 1
            fi
            toggle_action "$iface" "$services"
            status_action "$iface" "$services"
            ;;
        down)
            stop_all_services "$services"
            status_action "$iface" "$services"
            ;;
        up)
            if [ -z "$iface" ]; then
              log_error "No interface specified for up action."
              print_help
              exit 1
            fi
            up_action "$iface" "$services"
            status_action "$iface" "$services"
            ;;
        *)
            log_error "Unknown action: $action"
            print_help
            exit 1
            ;;
    esac
}

main "$@"
