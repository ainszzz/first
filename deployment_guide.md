# Deployment Guide for Custom RustDesk Package

This guide provides detailed instructions for deploying the customized RustDesk package in your managed environment.

## 1. Prerequisites

Before deployment, ensure you have:
- Administrator privileges on target machines
- Network connectivity between machines that need to connect
- Port 21118 accessible on machines that will act as hosts (for direct IP access)
- Port 21119 accessible for UDP (used for NAT traversal)

## 2. Building the Package

The custom RustDesk package can be built in two ways:

### Option 1: Building on a Development System

1. Clone this repository to a development system with all necessary build dependencies
2. Run the build script:
   ```
   chmod +x build_custom_rustdesk.sh
   ./build_custom_rustdesk.sh
   ```
3. The built installation packages will be available in the `output/bin` directory

### Option 2: Using Pre-configured Files with the Official RustDesk Build

If you cannot build from source or prefer to use official builds:

1. Download the official RustDesk installers from https://github.com/rustdesk/rustdesk/releases
2. After installation, replace the default configuration files with our custom ones from the `output/config` directory
3. The custom configuration files enable direct IP access and remote configuration by default

## 3. Network Configuration

### Firewall Settings

To allow direct IP connections, configure your firewall to allow:
- TCP on port 21118 (for direct connections)
- UDP on port 21119 (for NAT traversal)

#### Example for Windows Firewall:

```
netsh advfirewall firewall add rule name="RustDesk TCP" dir=in action=allow protocol=TCP localport=21118
netsh advfirewall firewall add rule name="RustDesk UDP" dir=in action=allow protocol=UDP localport=21119
```

#### Example for Linux (UFW):

```
sudo ufw allow 21118/tcp
sudo ufw allow 21119/udp
sudo ufw reload
```

#### Example for macOS:

If you're using the macOS built-in firewall, you'll need to allow incoming connections for the RustDesk application in System Preferences > Security & Privacy > Firewall > Firewall Options.

### Router Configuration

If your host machines are behind a router, you'll need to set up port forwarding:

1. Access your router's admin interface (typically http://192.168.1.1 or similar)
2. Navigate to the port forwarding section
3. Add port forwarding rules:
   - Forward TCP port 21118 to the internal IP of the host machine
   - Forward UDP port 21119 to the internal IP of the host machine
4. Save the settings and restart the router if required

## 4. Installation

### For Windows:

1. Double-click the custom RustDesk installer (.exe) file
2. Follow the on-screen instructions to install
3. During installation, ensure you select "Install for all users" if you want the custom settings to apply system-wide
4. After installation, RustDesk will start automatically with direct IP access and remote configuration already enabled

### For macOS:

1. Open the DMG file and drag the RustDesk application to the Applications folder
2. Open RustDesk from the Applications folder
3. If you get a security warning, go to System Preferences > Security & Privacy and click "Open Anyway"
4. The app will start with direct IP access and remote configuration already enabled

### For Linux:

#### Debian/Ubuntu:
```
sudo dpkg -i rustdesk_custom.deb
# If there are dependency issues
sudo apt-get install -f
```

#### Fedora/RHEL:
```
sudo rpm -i rustdesk_custom.rpm
```

#### AppImage:
```
chmod +x RustDesk-custom.AppImage
./RustDesk-custom.AppImage
```

## 5. Post-Installation Configuration

### Verify Settings:

1. Open RustDesk
2. Go to Settings
3. Verify that "Enable direct IP access" is checked/enabled
4. Verify that "Enable remote configuration" is checked/enabled

### Setting a Strong Password:

For security reasons, set a strong password for unattended access:

1. Open RustDesk
2. Go to Settings > Security
3. Set a permanent password for unattended access
4. Consider using a password manager to generate and store this password

### Optional: Configure ID-based Connection Settings

If you're using ID-based connections alongside direct IP:

1. Open RustDesk
2. Go to Settings > Network
3. If you have a self-hosted RustDesk server, enter the custom rendezvous server and relay server addresses
4. If using the public RustDesk network, leave these fields as default

## 6. Connection Methods

### Method 1: Connect via RustDesk ID

1. On the host machine, note the RustDesk ID displayed on the main screen
2. On the client machine, enter this ID in the "ID" field and click "Connect"
3. Enter the password when prompted

### Method 2: Connect via Direct IP

1. On the client machine, click on "IP/Domain" or similar option in the interface
2. Enter the IP address or hostname of the host machine (e.g., 192.168.1.100)
3. Enter the port number (default is 21118) if not automatically filled
4. Click "Connect" and enter the password when prompted

## 7. Mass Deployment

### Using Group Policy (Windows):

1. Create a GPO for RustDesk deployment
2. Use the customized MSI package for installation
3. Configure the following registry settings:
   ```
   [HKEY_LOCAL_MACHINE\SOFTWARE\RustDesk]
   "EnableDirectIP"=dword:00000001
   "EnableRemoteConfig"=dword:00000001
   ```

### Using MDM (macOS):

1. Create a deployment profile that includes the custom RustDesk package
2. Use the following preference domain: com.rustdesk.RustDesk
3. Set the appropriate values for EnableDirectIP and EnableRemoteConfig

### Using Ansible (Linux):

Sample playbook:
```yaml
- name: Install custom RustDesk
  hosts: all
  tasks:
    - name: Copy RustDesk package
      copy:
        src: ./rustdesk_custom.deb
        dest: /tmp/rustdesk_custom.deb
      when: ansible_os_family == "Debian"
      
    - name: Install RustDesk
      apt:
        deb: /tmp/rustdesk_custom.deb
      when: ansible_os_family == "Debian"
      
    # Add similar tasks for Red Hat based systems
```

## 8. Troubleshooting

### Direct IP Connection Issues:

1. Verify the firewall settings on both machines
2. Check that port 21118 (TCP) is open and not being used by another application
3. Try connecting with the IP address instead of hostname if DNS resolution might be an issue
4. Ensure the host machine is powered on and RustDesk is running

### ID-based Connection Issues:

1. Verify both machines have internet connectivity
2. Check if there are any firewall rules blocking outbound connections
3. Try restarting RustDesk on both machines
4. Verify the ID is entered correctly

### Security Warnings:

If you receive security warnings during installation or connection:

1. Verify you're using the official RustDesk package with our custom configurations
2. Check that you've implemented the recommended security measures (strong passwords, limited firewall rules)
3. On Windows, you may need to add exceptions to Windows Defender or other antivirus software

## 9. Performance Optimization

For the best remote desktop experience:

1. Set an appropriate quality level in the settings based on your network bandwidth
2. Consider disabling animations and visual effects on the host machine
3. For low-bandwidth connections, reduce the color depth and disable audio
4. Use direct IP connections when possible, as they often provide lower latency than ID-based connections

## 10. Security Considerations

Remember that enabling direct IP access increases your security exposure:

1. Never expose RustDesk ports directly to the internet without additional security (VPN, etc.)
2. Regularly update passwords and review connection logs
3. Consider implementing network segmentation if possible
4. Regularly update RustDesk to receive security patches
5. Monitor for unauthorized access attempts
