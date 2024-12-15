# Lenovo Thinkpad X1 Carbon (gen 1) laptop

This laptop was manufactured in 2012. It's a model 3443CTO with the following
components:

| Type              | Model                                                   |
|-------------------|---------------------------------------------------------|
| CPU               | Intel Core i5-3427U                                     |
| disk              | Intel SSDSCMMW240A3L 240 GB M.2                         |
| GPU               | integrated Intel HD Graphics 4000 (i915)                |
| ports (left)      | 1 x USB-A 2.0 (always on if enabled in UEFI)            |
|                   | 20 V rectangle "Slim Tip" power                         |
| ports (rear)      | SIM tray                                                |
| ports (right)     | 1 x USB-A 3.0                                           |
|                   | Mini DisplayPort (see HDMI note below)                  |
|                   | SD/MMC card reader                                      |
|                   | 3.5 mm combined headphone and microphone jack           |
| RAM               | 8 GiB DDR3L                                             |
| screen            | 14", 1600x900                                           |
| wifi              | Intel Centrino Advanced-N 6205S AGN (iwlwifi)           |

See the
[Lenovo support site](https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-type-34xx/3443/3443cto/document-userguide/doc_userguide), including the
[user guide](https://download.lenovo.com/ibmdl/pub/pc/pccbbs/mobiles_pdf/x1carbon_ug_en.pdf)
and
[hardware maintenance manual](https://download.lenovo.com/pccbbs/mobiles_pdf/x1_carbon_hmm_en_0b48811_05.pdf).

## UEFI

Press `F1` to enter the UEFI settings at boot, or press `F12` for a boot menu.

The laptop is running UEFI version 2.85 (G6ETC5WW, released 2019) as of
December 2024. Diego updated it using the
[`geteltorito` method](https://www.thinkwiki.org/wiki/BIOS_Upgrade#Manually_creating_a_USB_Flash_drive_in_Linux)
to create a bootable USB drive.

## HDMI not working

Around 2012-2015, I used Mini DisplayPort to large DisplayPort daily, and I
used Mini DisplayPort to HDMI adapters to give presentations (frequently, at
different locations) with this laptop without issue.

In December 2024, I could easily get X to connect to an external DisplayPort
monitor, but I could not get X to detect the same monitor over HDMI. I tried 3
separate monitors/TVs. I tried 3 separate cables. I tried 4 Mini DisplayPort to
HDMI adapters (including one "active" adapter) and a Mini DisplayPort to HDMI
cable (with embedded adapter). I tried Debian 8, 9, 10, 11, and 12 Live
editions. On Debian 12 (non-Live), I tried both the Intel and modesetting X
drivers. Some of this was before the UEFI update (using firmware from 2012),
and some of it was after. Nothing I tried worked (but I did not try all
possible combinations).
