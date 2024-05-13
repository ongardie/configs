# Fractal desktop

Fractal is a desktop computer, first assembled in 2020, made up of the
following components:

| Type        | Model |
|-------------|-------|
| case        | [Fractal Design Core 1100 (mATX)](https://www.fractal-design.com/products/cases/core/core-1100/) |
| CPU         | [AMD Ryzen 7 3700X](https://www.amd.com/en/product/8446) |
| CPU cooler  | AMD Wraith Prism (bundled) |
| GPU         | [XFX AMD Radeon RX 570 RS 8GB XXX Edition](https://www.xfxforce.com/gpus/amd-radeon-tm-rx-570-rs-8gb-xxx-edition-2) |
| motherboard | [Gigabyte B550M DS3H](https://www.gigabyte.com/Motherboard/B550M-DS3H-rev-10-11-12-13) |
| RAM         | [Corsair Vengeance LPX 2 x 16GB DDR4](https://www.corsair.com/us/en/p/memory/cmk32gx4m2b3200c16/vengeancea-lpx-32gb-2-x-16gb-ddr4-dram-3200mhz-c16-memory-kit-black-cmk32gx4m2b3200c16#tab-techspecs) |
| serial      | [StarTech PLATE9M16](https://www.startech.com/en-us/cables/plate9m16) |
| SSD         | [Western Digital WD_BLACK SN770 NMVe 2TB](https://www.westerndigital.com/products/internal-drives/wd-black-sn770-nvme-ssd?sku=WDS200T3X0E) |
| wifi        | [TP-Link Archer TX50E (WiFi 6, Bluetooth 5.0)](https://www.tp-link.com/us/home-networking/pci-adapter/archer-tx50e/) |

The graphics card blocks the small PCIEx1 slot, so the wifi card had to go into
the bottom PCIEx4 slot.

## UEFI

Fractal is currently using UEFI version `F18d` (released Dec 25, 2023). The
"Q-BIOS" upgrade process is easy using a USB flash drive.

Enable SVM in the UEFI settings for virtualization support (KVM).

## Linux suspend issue

In 2020, I used to have issues with the computer not being able to come out of
suspend. I may have worked around that by adding `hpet=disable` to the kernel
command line. It was pretty reliable for a few years.

I used the serial console to get log messages while the problem was happening,
by adding this to the kernel command line:
```
console=tty0 console=ttyS0,115200 no_console_suspend
```

In 2024, after a clean install of Debian Bookworm, I did not disable the HPET
and encountered similar issues with entering suspend.

There's a workaround for similar Gigabyte motherboards of disabling wakeups
from GGP0 (something NVMe-related), as described on:
- <https://wiki.archlinux.org/title/Power_management/Wakeup_triggers#Instantaneous_wakeups_from_suspend> and
- <https://www.reddit.com/r/gigabyte/comments/p5ewjn/b550i_pro_ax_f13_bios_sleep_issue_on_linux/>.

This workaround helps, but it doesn't not entirely avoid the problem. To make
it permanent:

```sh
sudo tee /etc/tmpfiles.d/disable-gpp0-wake.conf <<'END'
#   Path                                               Mode UID  GID  Age Argument
w+  /sys/devices/pci0000:00/0000:00:01.1/power/wakeup  -    -    -    -   disabled
END
sudo systemd-tmpfiles --create
```

When fractal sleeps, it lets out an audible click (maybe when the CPU fan
stops). Sometimes the machine won't fully enter suspend, the power light will
remain on, and it won't click. The way to recover from this is to flip the
power switch off for about a second until hearing the click, then switch it
back on and wait to see if it fully wakes up. If it doesn't work the first
time, try again. I don't know how or why this works, but it almost always
recovers just fine without rebooting. Sometimes, especially during boot and
during that workaround, the fans switch to full (very noisy) for a few seconds.
