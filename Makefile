#############################################################################
# Author(s):
#     Juhapekka Piiroinen <juhapekka.piiroinen@1337.fi>
#
# License: MIT
#
# (C) 2019 Juhapekka Piiroinen <juhapekka.piiroinen@1337.fi>
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom
# the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#############################################################################
VENV:=source venv/bin/activate &&
ifeq ($(LIMIT),)
ANSIBLE_PLAYBOOK:=$(VENV) ansible-playbook
else
ANSIBLE_PLAYBOOK:=$(VENV) ansible-playbook --limit=$(LIMIT)
endif

ifeq ($(DEBUG),1)
ANSIBLE_PLAYBOOK:=$(ANSIBLE_PLAYBOOK) -vvv
endif

PATH:=$(PWD)/bin:$(PATH)
export PATH

LC_ALL:=C
export LC_ALL

all: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories playbook.yml

vault_password:
	@cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1 > vault_password
	@echo
	@echo "Your vault password has been set for this project."
	@echo "You should safe keep the file vault_password in this directory."
	@echo "Or you should copy the password in that file to a safe location."
	@echo
	@echo "Press <enter> when you have safely stored the file."
	@read

local: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/rpi local.playbook.yml

rpi: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/rpi rpi.playbook.yml

common: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/rpi common.playbook.yml

change_password: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/rpi change_password.playbook.yml

configuration: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/rpi configuration.playbook.yml

swarm: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/swarm-worker -i inventories/swarm-master swarm.playbook.yml

services: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/swarm-master services.playbook.yml

apps: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/swarm-master apps.playbook.yml

clean:
	rm -rf venv
	rm *.img
	rm raspbian_lite_latest

shutdown: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/rpi shutdown.playbook.yml

reboot: venv vault_password
	$(ANSIBLE_PLAYBOOK) -i inventories/rpi reboot.playbook.yml

raspbian_lite_latest:
	curl -OL https://downloads.raspberrypi.org/raspbian_lite_latest
	unzip raspbian_lite_latest
	rm raspbian_lite_latest
	ln -s `ls *.img` raspbian_lite_latest

sd: raspbian_lite_latest
	sudo rpi-image-to-sd raspbian_lite_latest `$(PWD)/bin/rpi-detect-sd`

venv:
	python3 -m venv venv
	
	$(VENV) pip install -U pip
	$(VENV) pip install -r requirements.txt	
