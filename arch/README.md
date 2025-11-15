# Arch Linux

Install Arch linux using the `archinstall` script.

## After installation

### Disable authentication delay

<https://github.com/Shourai/til/blob/master/linux/authentication-delay.md>

### Increase login attemps

<https://github.com/Shourai/til/blob/master/linux/increase_login_attempts.md>

### Setup gnome-keyring

<https://github.com/Shourai/til/blob/master/linux/keyring.md>

### Change systemd-boot timeout

<https://github.com/Shourai/til/blob/master/linux/systemd-boot-timeout.md>

### Allow for hardware acceleration

<https://wiki.archlinux.org/title/Hardware_video_acceleration>
HD Graphics series starting from Broadwell (2014) and newer (e.g. Intel Arc) are supported by `intel-media-driver`.

### Modify LUKS iter time

<https://github.com/Shourai/til/blob/master/linux/modify-luks-iter-time.md>
The default `iter-time` is set to 10 seconds:

- <https://github.com/archlinux/archinstall/blob/master/archinstall/lib/luks.py#L100>
- <https://github.com/archlinux/archinstall/blob/master/archinstall/lib/models/device.py#L22>

### Makepkg compression

To speed up both packaging and installation, with the tradeoff of having larger package archives, change PKGEXT.

For example, the following skips compression of the package file, which will in turn have no need to be decompressed on install:

```
PKGEXT='.pkg.tar' makepkg
```

As another example, the following uses the LZ4 algorithm, which is focused on speed:

```
PKGEXT='.pkg.tar.lz4' makepkg
```

To make one of these settings permanent, set PKGEXT in /etc/makepkg.conf.
