# Testing Procedure for Custom RustDesk Package

This document outlines the testing procedures to verify that the custom RustDesk installation functions correctly with both connection methods enabled.

## Prerequisites

Before testing:
1. Install the custom RustDesk package on at least two machines:
   - One machine will act as the host (the machine to be controlled)
   - One machine will act as the client (the machine that will control the host)
2. Ensure both machines have internet connectivity
3. If testing direct IP connection, ensure that the machines can reach each other via IP and that the required ports are open

## Test Cases

### 1. Verify Default Configuration

**Objective**: Confirm that the custom settings are correctly applied by default.

**Procedure**:
1. Install the custom RustDesk package on a test machine
2. Open RustDesk
3. Go to Settings or Preferences
4. Check the configuration options

**Expected Result**:
- Direct IP access should be enabled by default
- Remote configuration modification should be enabled by default

**Status**: [ ] Pass / [ ] Fail

### 2. Connection via RustDesk ID

**Objective**: Verify that connections using the RustDesk ID work correctly.

**Procedure**:
1. On the host machine:
   - Open RustDesk
   - Note the displayed ID and password
2. On the client machine:
   - Open RustDesk
   - Enter the host's ID in the ID field
   - Click "Connect"
   - Enter the password when prompted

**Expected Result**:
- Connection should be established successfully
- Client should be able to view and control the host machine

**Status**: [ ] Pass / [ ] Fail

### 3. Connection via Direct IP

**Objective**: Verify that direct IP connections work without additional configuration.

**Procedure**:
1. On the host machine:
   - Open RustDesk
   - Set a password for unattended access if needed
2. On the client machine:
   - Open RustDesk
   - Click on "Direct IP" or similar option
   - Enter the host machine's IP address and port (default is 21118)
   - Click "Connect"
   - Enter the password when prompted

**Expected Result**:
- Connection should be established successfully
- Client should be able to view and control the host machine

**Status**: [ ] Pass / [ ] Fail

### 4. Remote Configuration Modification

**Objective**: Verify that remote configuration can be modified.

**Procedure**:
1. Establish a connection from client to host using either method
2. On the client machine:
   - While connected, access the remote machine's settings
   - Make a change to a configuration setting
   - Save the changes
3. Disconnect and reconnect to the host

**Expected Result**:
- Configuration changes should be applied successfully
- Changes should persist after reconnection

**Status**: [ ] Pass / [ ] Fail

### 5. Connection Behind NAT/Firewall

**Objective**: Verify that connections work when machines are behind NAT/firewalls.

**Procedure**:
1. Set up the host machine behind a NAT/firewall
2. Try connecting using both the RustDesk ID and direct IP methods

**Expected Result**:
- ID-based connection should work through NAT
- Direct IP may require port forwarding to be set up on the router/firewall

**Status**: [ ] Pass / [ ] Fail

### 6. Performance Testing

**Objective**: Verify that the custom build maintains performance comparable to the standard build.

**Procedure**:
1. Establish a connection using the custom build
2. Perform various actions:
   - Move the mouse rapidly
   - Type text
   - Transfer files (if applicable)
   - Stream audio/video (if applicable)
3. Note the responsiveness and quality

**Expected Result**:
- Performance should be comparable to the standard RustDesk build
- No noticeable lag or quality issues related to the custom modifications

**Status**: [ ] Pass / [ ] Fail

### 7. Security Testing

**Objective**: Verify that security features are functioning correctly.

**Procedure**:
1. Attempt to connect without providing the correct password
2. Check if encryption is working (verify in logs or connection details)
3. Verify that authentication prompts appear appropriately

**Expected Result**:
- Connection attempts with incorrect passwords should be rejected
- Connections should be encrypted
- Appropriate authentication prompts should be displayed

**Status**: [ ] Pass / [ ] Fail

## Test Results Summary

| Test Case | Status | Notes |
|-----------|--------|-------|
| 1. Default Configuration | | |
| 2. RustDesk ID Connection | | |
| 3. Direct IP Connection | | |
| 4. Remote Configuration | | |
| 5. NAT/Firewall Testing | | |
| 6. Performance Testing | | |
| 7. Security Testing | | |
| 8. Multi-Monitor Support | | |
| 9. Mass Deployment Testing | | |
| 10. Upgrade Testing | | |

### 8. Multi-Monitor Support

**Objective**: Verify that the custom build correctly handles multi-monitor setups.

**Procedure**:
1. Set up the host machine with multiple monitors
2. Establish a connection from a client machine
3. Test switching between monitors
4. Test viewing all monitors simultaneously (if supported)

**Expected Result**:
- All monitors should be accessible from the client
- Monitor switching/selection should work correctly
- Visual quality should be maintained across all monitors

**Status**: [ ] Pass / [ ] Fail

### 9. Mass Deployment Testing

**Objective**: Verify that the custom build can be deployed across multiple machines with consistent behavior.

**Procedure**:
1. Deploy the custom RustDesk package to multiple machines (>5 if possible) using mass deployment methods
2. Verify default configuration on all machines
3. Test connections between various combinations of machines

**Expected Result**:
- All machines should have the same default configuration
- Connections should work consistently between all machines
- No machine-specific issues should be observed

**Status**: [ ] Pass / [ ] Fail

### 10. Upgrade Testing

**Objective**: Verify that custom configurations persist through RustDesk upgrades.

**Procedure**:
1. Install the custom RustDesk package
2. Verify that custom configurations are active
3. Upgrade to a newer version of RustDesk (if available)
4. Check if the custom configurations are retained

**Expected Result**:
- Custom configurations should persist through the upgrade process
- Both connection methods should continue to work after upgrade

**Status**: [ ] Pass / [ ] Fail

## Issues and Observations

Document any issues or unexpected behaviors encountered during testing:

1. 
2. 
3. 

## Recommendations

Based on the test results, provide any recommendations for improvements or fixes:

1. 
2. 
3. 

## Tester Information

- Tester Name:
- Test Date:
- Test Environment:
  - Host OS:
  - Client OS:
  - Network Configuration:
  - Additional Software/Firewalls:
