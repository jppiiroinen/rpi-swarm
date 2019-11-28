# rpi-swarm

This repository contains source code for Ansible provisioning of a Docker Swarm for a cluster of first generation Raspberry Pi 1B (armv6) hardware. It makes the golang development and deployment easier and the overall first time installation of a RPI hardware faster.

The code has been released under MIT license, so that you can read and learn, and to also show you how you could do things at home with Ansible and a bunch of scripts. Please do note that there might be bugs and mistakes, no warranties included, please see the LICENSE for details.

## Requirements
- Operating System: macOS
- Apps/Libs: Python3
- Other: The IP addresses of your RPI hardware in inventories/rpi/hosts, inventories/swarm-master/hosts, inventories/swarm-worker/hosts

### How to install python3 on macOS?
Install homebrew: `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
then install python3: `brew install python@3`.

## Usage
### Format a new SD card for RPI
`make sd`

### Provision the rpi inventory
`make`

### Provision a specific node
`make LIMIT=swarm-worker-2`

### Change password to a specific node
`make LIMIT=swarm-worker-2 change_password`

### Configuration
See `group_vars/all` directory.

# Notes
Remember to store locally somewhere that vault_password file which will be generated for you at the first time. As that file will be used to unlock your ansible vault, which will contain the passwords to your RPI hardware.

# Author
Juhapekka Piiroinen

https://linkedin.com/in/jppiiroinen


# License
MIT

```
 (C) 2019 Juhapekka Piiroinen <juhapekka.piiroinen@1337.fi>
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom
 the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
