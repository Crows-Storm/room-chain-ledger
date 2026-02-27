#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$SCRIPT_DIR/lib.sh"

log_info "Starting OpenAPI documentation generation..."

if ! command_exists "openapi-generator-cli"; then
    log_warn "openapi-generator-cli not found, checking for docker..."
    
    if command_exists "docker"; then
        log_info "Using docker to run openapi-generator-cli"
        USE_DOCKER=true
    else
        log_error "Neither openapi-generator-cli nor docker is available"
        log_info "Install openapi-generator-cli: npm install -g @openapitools/openapi-generator-cli"
        log_info "Or install docker: https://docs.docker.com/get-docker/"
        exit 1
    fi
else
    USE_DOCKER=false
fi

DOCS_DIR="$PROJECT_ROOT/docs/api"
mkdir -p "$DOCS_DIR"

processed=0
failed=0

generate_openapi_docs() {
    local yml_file=$1
    local service_name=$2
    local output_dir="$DOCS_DIR/$service_name"
    
    mkdir -p "$output_dir"
    
    if [ "$USE_DOCKER" = true ]; then
        local relative_yml="${yml_file#$PROJECT_ROOT/}"
        local relative_output="${output_dir#$PROJECT_ROOT/}"
        
        docker run --rm \
            -v "$PROJECT_ROOT:/local" \
            openapitools/openapi-generator-cli generate \
            -i "/local/$relative_yml" \
            -g html2 \
            -o "/local/$relative_output"
    else
        openapi-generator-cli generate \
            -i "$yml_file" \
            -g html2 \
            -o "$output_dir"
    fi
}

for service_dir in $(get_service_dirs); do
    service_name=$(basename "$service_dir")
    
    yml_file=$(find "$service_dir" -maxdepth 1 -name "*.yml" -o -name "*.yaml" | head -n 1)
    
    if [ -z "$yml_file" ]; then
        log_warn "No OpenAPI yml file found in $service_name, skipping..."
        continue
    fi
    
    log_info "Processing $service_name..."
    
    relative_yml="${yml_file#$PROJECT_ROOT/}"
    
    if [ "$USE_DOCKER" = true ]; then
        if docker run --rm \
            -v "$PROJECT_ROOT:/local" \
            openapitools/openapi-generator-cli validate \
            -i "/local/$relative_yml" >/dev/null 2>&1; then
            log_success "OpenAPI spec validated for $service_name"
        else
            log_error "Invalid OpenAPI spec for $service_name"
            ((failed++))
            continue
        fi
    else
        if openapi-generator-cli validate -i "$yml_file" >/dev/null 2>&1; then
            log_success "OpenAPI spec validated for $service_name"
        else
            log_error "Invalid OpenAPI spec for $service_name"
            ((failed++))
            continue
        fi
    fi
    
    if generate_openapi_docs "$yml_file" "$service_name"; then
        log_success "Generated OpenAPI documentation for $service_name"
        ((processed++))
    else
        log_error "Failed to generate OpenAPI documentation for $service_name"
        ((failed++))
    fi
done

echo ""
log_info "========================================="
log_info "OpenAPI Generation Summary"
log_info "========================================="
log_success "Successfully processed: $processed services"
if [ $failed -gt 0 ]; then
    log_error "Failed: $failed services"
    exit 1
fi

log_success "All OpenAPI documentation generated successfully!"
log_info "Generated documentation is in: $DOCS_DIR"
