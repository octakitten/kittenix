#!/bin/bash
sudo cp ./"$1"/configuration.nix /etc/nixos
sudo nixos-rebuild test
