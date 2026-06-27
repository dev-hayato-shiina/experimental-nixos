#!/usr/bin/env bash

# ディスク上のパーティション情報を完全に消去
wipefs -a /dev/sda

# ディスク領域を確認する
fdisk -l

# パーティションの作成
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart root ext4 512MB -8GB
parted /dev/sda -- mkpart swap linux-swap -8GB 100%
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 3 esp on

# 正しくパーティションが作成されているか、ディスク領域を再度確認する
fdisk -l

# フォーマットの作成
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3

# マウント
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
