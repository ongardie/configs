# Dell U4919DW monitor

This is a 49", ultra-wide (32:9), 5120x1440, slightly curved monitor. It was
purchased in 2019. The monitor weighs about 25 lbs without the stand and about
38 lbs with the stand. It appears to embed two 27" (16:9) panels, and it can
drive the two seperately from two inputs in PBP (picture-by-picture) mode.

## Firmware

Firmware download site:
<https://www.dell.com/support/home/en-us/product-support/product/dell-u4919dw-monitor/drivers>

Firmware updates take about 25 minutes.

I was unable to update from M2B103 to M2B108 using a Debian live image with the
Ubuntu deb, from two different computers, including with a factory reset. The
monitor reverted back to its M2B101 firmware. The firmware update declared
success every time but the monitor remained at M2B101.

From Windows 11, the firmware update to M2B108 worked on the first attempt.

The M2B102 version was an important update to allow USB-C devices to charge
while the display is off (added as a setting).

After the update to M2B108, set `Personalize` > `Monitor Sleep` to `Off` to
allow the computer (fractal) to wake the monitor after suspend. The monitor
still seems to sleep and DPMS still seems to work.
