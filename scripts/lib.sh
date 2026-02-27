#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

check_tool() {
    local tool=$1
    local install_hint=$2
    
    if ! command_exists "$tool"; then
        log_error "$tool is not installed"
        if [ -n "$install_hint" ]; then
            log_info "Install with: $install_hint"
        fi
        return 1
    fi
    return 0
}

get_service_dirs() {
    find services -maxdepth 1 -mindepth 1 -type d | sort
}

has_proto_file() {
    local dir=$1
    [ -f "$dir"/*.proto ] 2>/dev/null
}

has_yml_file() {
    local dir=$1
    [ -f "$dir"/*.yml ] 2>/dev/null
}
