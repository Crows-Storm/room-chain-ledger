#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/lib.sh"

log_info "Starting protobuf code generation..."

check_tool "protoc" "brew install protobuf (macOS) or apt-get install protobuf-compiler (Linux)" || exit 1
check_tool "protoc-gen-go" "go install google.golang.org/protobuf/cmd/protoc-gen-go@latest" || exit 1
check_tool "protoc-gen-go-grpc" "go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest" || exit 1

export PATH="$PATH:$(go env GOPATH)/bin"

API_GEN_DIR="$PROJECT_ROOT/api/gen"
mkdir -p "$API_GEN_DIR"

API_DIR="$PROJECT_ROOT/api"
if [ ! -f "$API_DIR/go.mod" ]; then
    log_info "Initializing Go module for api..."
    cd "$API_DIR"
    go mod init github.com/Crows-Storm/room-chain-ledger/api
    cd "$PROJECT_ROOT"
    
    if [ -f "$PROJECT_ROOT/go.work" ]; then
        if ! grep -q "./api" "$PROJECT_ROOT/go.work"; then
            log_info "Adding api module to workspace..."
            go work use ./api
            log_success "Added api to go.work"
        fi
    fi
fi

processed=0
failed=0

for service_dir in $(get_service_dirs); do
    service_name=$(basename "$service_dir")
    
    proto_file=$(find "$service_dir" -maxdepth 1 -name "*.proto" | head -n 1)
    
    if [ -z "$proto_file" ]; then
        log_warn "No proto file found in $service_name, skipping..."
        continue
    fi
    
    log_info "Processing $service_name..."
    
    output_dir="$API_GEN_DIR/$service_name"
    mkdir -p "$output_dir"
    
    if protoc \
        --proto_path="$service_dir" \
        --go_out="$output_dir" \
        --go_opt=paths=source_relative \
        --go-grpc_out="$output_dir" \
        --go-grpc_opt=paths=source_relative \
        "$proto_file"; then
        log_success "Generated protobuf code for $service_name"
        ((processed++))
    else
        log_error "Failed to generate protobuf code for $service_name"
        ((failed++))
    fi
done

echo ""
log_info "========================================="
log_info "Protobuf Generation Summary"
log_info "========================================="
log_success "Successfully processed: $processed services"
if [ $failed -gt 0 ]; then
    log_error "Failed: $failed services"
    exit 1
fi

log_success "All protobuf code generated successfully!"
log_info "Generated files are in: $API_GEN_DIR"

log_info "Running go mod tidy for api module..."
cd "$API_DIR"
if go mod tidy; then
    log_success "Go module dependencies updated"
else
    log_warn "Failed to run go mod tidy, you may need to run it manually"
fi
cd "$PROJECT_ROOT"
