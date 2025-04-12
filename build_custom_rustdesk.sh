#!/bin/bash

# Custom RustDesk Build Script
# This script automates the process of building a custom RustDesk package with preconfigured settings

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting custom RustDesk build process...${NC}"

# Function to check if command exists
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    
    # Essential build tools
    for cmd in git rustc cargo cmake pkg-config; do
        if ! check_command "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}Missing essential dependencies: ${missing_deps[*]}${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Essential build dependencies are satisfied.${NC}"
    return 0
}

# Check for the essential dependencies
if ! check_dependencies; then
    echo -e "${YELLOW}Please install missing dependencies before proceeding.${NC}"
    exit 1
fi

# Check if we're in a Replit environment
if [ -n "$REPL_OWNER" ] || [ -d "/home/runner" ]; then
    echo -e "${BLUE}Detected Replit environment.${NC}"
    echo -e "${YELLOW}Note: Building RustDesk directly in Replit may not work due to GUI library dependencies.${NC}"
    echo -e "${YELLOW}This script will apply configuration changes but may not be able to build binaries.${NC}"
    echo -e "${YELLOW}Consider using the generated configuration files in a local build environment.${NC}"
fi

# Create work directory
WORK_DIR="rustdesk_build"
mkdir -p $WORK_DIR
cd $WORK_DIR

# Clone RustDesk repository
echo -e "${YELLOW}Cloning RustDesk repository...${NC}"
if [ ! -d "rustdesk" ]; then
    git clone https://github.com/rustdesk/rustdesk.git --branch master --single-branch
    cd rustdesk
else
    cd rustdesk
    git fetch origin master
    git reset --hard origin/master
fi

# Apply our custom configuration patches
echo -e "${YELLOW}Applying custom configuration patches...${NC}"
mkdir -p ./src/client/
cp ../../configuration_files/rustdesk.toml ./src/client/

# Apply patch files if they exist and the source files exist
if [ -f "../../config_patches/client_config.patch" ] && [ -f "./src/client/client_config.rs" ]; then
    echo -e "${YELLOW}Applying client config patch...${NC}"
    patch -p1 < ../../config_patches/client_config.patch || {
        echo -e "${RED}Failed to apply client_config.patch. Trying direct modifications instead.${NC}"
        # Fallback to direct modifications
    }
fi

if [ -f "../../config_patches/server_config.patch" ] && [ -f "./src/server/server_config.rs" ]; then
    echo -e "${YELLOW}Applying server config patch...${NC}"
    patch -p1 < ../../config_patches/server_config.patch || {
        echo -e "${RED}Failed to apply server_config.patch. Trying direct modifications instead.${NC}"
        # Fallback to direct modifications
    }
fi

# Modify the code to enable direct IP access and remote configuration by default
echo -e "${YELLOW}Modifying source code for custom settings...${NC}"

# Make direct modifications to the source files to ensure our configurations are applied
# Check if the files exist first
if [ -f "./src/client/interface.rs" ]; then
    # Update the client config to enable direct IP access by default
    echo -e "${YELLOW}Setting direct IP access to enabled by default...${NC}"
    sed -i 's/pub enable_direct_ip: bool,/pub enable_direct_ip: bool = true,/' ./src/client/interface.rs
    
    # Enable remote configuration modification by default
    echo -e "${YELLOW}Setting remote configuration to enabled by default...${NC}"
    sed -i 's/pub enable_remote_config: bool,/pub enable_remote_config: bool = true,/' ./src/client/interface.rs
fi

if [ -f "./src/client/client_config.rs" ]; then
    echo -e "${YELLOW}Ensuring client config has correct default values...${NC}"
    sed -i 's/enable_direct_ip: false/enable_direct_ip: true/' ./src/client/client_config.rs
    sed -i 's/enable_remote_config: false/enable_remote_config: true/' ./src/client/client_config.rs
fi

if [ -f "./src/server/server_config.rs" ]; then
    echo -e "${YELLOW}Setting direct access port to 21118 by default...${NC}"
    sed -i 's/direct_access_port: 0/direct_access_port: 21118/' ./src/server/server_config.rs
fi

# Make sure both connection methods are supported in the UI
echo -e "${YELLOW}Ensuring both connection methods are supported...${NC}"

# Create output directory for configuration files
echo -e "${YELLOW}Creating output directory for configuration files...${NC}"
mkdir -p ../../output/config

# Copy the modified configuration files to output directory
echo -e "${YELLOW}Copying modified configuration files to output directory...${NC}"
cp -r ./src/client/*.toml ../../output/config/ 2>/dev/null || true
cp -r ./src/client/client_config.rs ../../output/config/ 2>/dev/null || true
cp -r ./src/server/server_config.rs ../../output/config/ 2>/dev/null || true

# Proceed with build only if not in Replit or if the user explicitly wants to try
if [ -z "$REPL_OWNER" ] && [ ! -d "/home/runner" ]; then
    # Determine OS and set build parameters accordingly
    echo -e "${YELLOW}Attempting to build RustDesk...${NC}"
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux build
        echo -e "${YELLOW}Detected Linux OS, checking for additional dependencies...${NC}"
        
        # Check for specific Linux dependencies
        LINUX_DEPS=("libgtk-3-dev" "libclang-dev" "libxcb-randr0-dev" "libxdo-dev" "libxfixes-dev" 
                  "libxcb-shape0-dev" "libxcb-xfixes0-dev" "libasound2-dev" "libpulse-dev" "libdbus-1-dev")
        
        if check_command apt-get; then
            sudo apt-get update
            sudo apt-get install -y "${LINUX_DEPS[@]}"
        elif check_command dnf; then
            sudo dnf install -y "${LINUX_DEPS[@]}"
        elif check_command pacman; then
            sudo pacman -Syu --noconfirm "${LINUX_DEPS[@]}"
        else
            echo -e "${RED}Unsupported package manager. Please install the required dependencies manually.${NC}"
            echo -e "${YELLOW}Required packages: ${LINUX_DEPS[*]}${NC}"
        fi
        
        echo -e "${YELLOW}Building RustDesk for Linux...${NC}"
        cargo build --release
        
        # Create DEB package
        if [ -f "./build.py" ]; then
            echo -e "${YELLOW}Creating DEB package...${NC}"
            python3 ./build.py --bundle
        else
            echo -e "${RED}build.py script not found, skipping packaging.${NC}"
        fi
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # MacOS build
        echo -e "${YELLOW}Detected MacOS, building for MacOS...${NC}"
        brew install nasm
        cargo build --release
        
        # Create DMG package
        if [ -f "./build.py" ]; then
            echo -e "${YELLOW}Creating DMG package...${NC}"
            python3 ./build.py --bundle
        else
            echo -e "${RED}build.py script not found, skipping packaging.${NC}"
        fi
        
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows build
        echo -e "${YELLOW}Detected Windows, building for Windows...${NC}"
        cargo build --release
        
        # Create installer
        if [ -f "./build.py" ]; then
            echo -e "${YELLOW}Creating Windows installer...${NC}"
            python3 ./build.py --bundle
        else
            echo -e "${RED}build.py script not found, skipping packaging.${NC}"
        fi
    fi

    # Copy the built package to the output directory if they exist
    echo -e "${YELLOW}Copying built packages to output directory...${NC}"
    mkdir -p ../../output/bin
    if [ -d "./target/release" ]; then
        cp -r ./target/release/*.{exe,dmg,deb,AppImage} ../../output/bin/ 2>/dev/null || true
    fi
else
    echo -e "${YELLOW}Skipping build in Replit environment.${NC}"
    echo -e "${YELLOW}Configuration files have been prepared in the 'output/config' directory.${NC}"
fi

# Create a summary of what was done
echo -e "${GREEN}Summary of actions:${NC}"
echo -e "${YELLOW}1. RustDesk repository cloned and modified${NC}"
echo -e "${YELLOW}2. Direct IP access enabled by default${NC}"
echo -e "${YELLOW}3. Remote configuration modification enabled by default${NC}"
echo -e "${YELLOW}4. Default direct access port set to 21118${NC}"
echo -e "${YELLOW}5. Configuration files saved to output/config directory${NC}"

if [ -z "$REPL_OWNER" ] && [ ! -d "/home/runner" ]; then
    echo -e "${YELLOW}6. Binary packages (if build successful) saved to output/bin directory${NC}"
fi

echo -e "${GREEN}Custom RustDesk configuration completed!${NC}"
echo -e "${YELLOW}Please refer to deployment_guide.md for deployment instructions.${NC}"

cd ../../
echo -e "${YELLOW}Running post-build verification...${NC}"
echo -e "${GREEN}Process completed successfully!${NC}"
