devcontainer_setup() {
    # Create directories
    mkdir -p docker/dev docker/prod .devcontainer
    print_success "Docker and devcontainer directories created"

    # Create devcontainer files
    touch -- .devcontainer/{devcontainer.json,compose.yaml}
    print_success "Devcontainers files created"

    # Create docker files
    touch docker/dev/{Dockerfile,compose.yaml} docker/prod/{Dockerfile,compose.yaml}
    print_success "Dockerfiles for production and development environments created"
                
    cp "$WIZARD_DIR/src/templates/.dockerignore" .dockerignore
    print_success ".dockerignore file created"
                
    print_success "Devcontainer support added to the repository"
                                
    return 0
}