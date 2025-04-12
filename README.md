# Custom RustDesk Installation Package

This project provides a customized version of RustDesk with pre-configured settings to enable remote configuration modification and direct IP access by default. The custom build supports both connection methods:

1. Connecting using the unique RustDesk connection code
2. Connecting directly via IP address

## Features

- ✅ Remote configuration modification enabled by default
- ✅ Direct IP access enabled by default (port 21118)
- ✅ Support for both connection methods (ID-based and IP-based)
- ✅ Streamlined deployment for managed environments
- ✅ No manual post-installation configuration required

## Project Structure

```
.
├── build_custom_rustdesk.sh   # Main build script
├── config_patches/            # Patch files for source code modifications
├── configuration_files/       # Custom configuration templates
├── output/                    # Generated files and binaries
│   └── config/                # Generated configuration files
├── deployment_guide.md        # Comprehensive deployment instructions
├── test_procedure.md          # Testing procedures and verification steps
├── custom_icon.svg            # Custom icon for the project
└── download_configs.sh        # Script to package configs for download
```

## Security Notice

Enabling direct IP access increases the attack surface of your system. Please ensure:

- You use strong passwords for authentication
- Implement proper firewall rules to restrict access
- Consider using a VPN for additional security when connecting over the internet
- Use this configuration only in controlled environments where the security implications are understood

## Quick Start

### Option 1: Building Custom Packages

1. Clone this repository to a development system with required build dependencies:
   ```bash
   git clone https://github.com/yourusername/custom-rustdesk.git
   cd custom-rustdesk
   ```

2. Run the build script:
   ```bash
   chmod +x build_custom_rustdesk.sh
   ./build_custom_rustdesk.sh
   ```

3. The customized installation packages will be available in the `output/bin` directory
   (Note: Building in environments like Replit will generate configuration files only)

### Option 2: Using Pre-generated Configuration Files

If you're unable to build from source or prefer to use official builds:

1. Download the official RustDesk installers from the [RustDesk GitHub repository](https://github.com/rustdesk/rustdesk/releases)
2. Install RustDesk using the official installer
3. Replace the default configuration files with our custom ones from the `output/config` directory
4. Restart RustDesk to apply the new configuration

### Option 3: Download Configuration Files from Replit

If you're running this project in Replit:

1. Execute the download script to package all configuration files:
   ```bash
   chmod +x download_configs.sh
   ./download_configs.sh
   ```
2. Download the resulting `rustdesk_custom_config.zip` file from Replit
3. Extract the zip file on your local machine
4. Follow the instructions in the included README.md

### Deployment

See [deployment_guide.md](deployment_guide.md) for detailed instructions on deploying the custom RustDesk package in your environment, including:

- Network and firewall configuration
- Installation procedures for Windows, macOS, and Linux
- Mass deployment options for enterprise environments
- Troubleshooting common issues
- Security considerations

### Testing

See [test_procedure.md](test_procedure.md) for detailed testing procedures to verify that both connection methods work as expected.

## Requirements

- Git
- Rust and Cargo (install via https://rustup.rs/)
- Build dependencies specific to your OS:
  - **Linux**: Various development libraries (GTK3, XCB, etc.)
  - **Windows**: Visual Studio build tools, NASM
  - **macOS**: Xcode command line tools, NASM

The build script will check for required dependencies and inform you if anything is missing.

## Limitations in Replit Environment

Due to Replit environment constraints with building GUI applications:

- The script focuses on generating configuration files rather than building binaries
- Generated files can be downloaded and used in a local build environment
- Full builds should be performed on a development system with required dependencies

## Technical Details

The customization makes the following changes to RustDesk:

1. Modifies the source code to enable direct IP access by default
2. Sets remote configuration modification to enabled by default
3. Configures port 21118 as the default direct access port
4. Ensures both connection methods (ID and direct IP) are visible in the UI
5. Provides custom configuration files that can be used with official builds

## License

This project is distributed under the same license as RustDesk. RustDesk is licensed under the GNU Affero General Public License v3.0.

## Acknowledgments

- RustDesk team for creating an excellent open-source remote desktop application
- This custom package builds upon the official RustDesk codebase: https://github.com/rustdesk/rustdesk
