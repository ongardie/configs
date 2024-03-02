# Dell XPS 13 9370 laptop

This laptop was manufactured in September 2018. It has the following
components:

| Type              | Model                                                   |
|-------------------|---------------------------------------------------------|
| battery           | 52 Wh, 4 cell, replaced in 2023                         |
| CPU               | Intel Core i7-8650U                                     |
| GPU               | Intel UHD Graphics 620                                  |
| RAM               | 16 GiB LPDDR3                                           |
| screen            | 13.3" 3840x2160 touchscreen (294mm x 165mm)             |
| SSD               | Crucial P1 1TB NVMe                                     |
| USB-C (left x 2)  | USB 3.1 Gen 2, DisplayPort 1.2, Thunderbolt 3, charging, 15 W |
| USB-C (right x 1) | USB 3.1 Gen 1, DisplayPort, charging, 7.5 W             |
| wifi              | Intel                                                   |

See the
[user manuals](https://www.dell.com/support/home/en-us/product-support/product/xps-13-9370-laptop/docs).

A button on the left side shows the battery status on 5 LEDs.

This is a [HiDPI](../hidpi.md) display.

## UEFI

Press `F2` (without `Fn`) to enter the UEFI settings at boot, or press `F12`
for a boot menu.

The laptop is running BIOS/UEFI version 1.15.0 (as of Feb 2024).

The firmware loves to do self-tests when anything changes. Sometimes when you
try to skip them, it will power off, and the next boot will just start them
again.

In the past, when the UEFI was set to RAID mode under "SATA Operation",
Linux was unable to see the NVMe drive.

The left and right-side USB ports seem to detect boot devices differently.

It seems picky about which USB devices it will boot Linux from (my T1 SSD
works). I got the following message when selecting a menu item from GRUB on
another drive in UEFI mode:

```sh
error: invalid magic number
error: you need to load the kernel first.

Press any key to continue...
```

That drive had a similar failure with no error when botting in legacy (BIOS)
mode.

After installing Linux, I had to manually add a UEFI "Boot Option" for
`\EFI\debian\grubx64.efi`.
