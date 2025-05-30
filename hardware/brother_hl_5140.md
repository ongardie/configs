# Brother HL-5140 printer

Single-sided, grayscale, USB laser printer.

```sh
sudo apt install printer-driver-brlaser
```

Configure CUPS with the HL-5030 driver.

## Two-sided printing

The printer doesn't support duplex printing. This method is a manual way to do
two-sided printing, but it's prone to misprints and paper jams.

To print a two-sided document using the automatic feed tray:

1. If needed, print-to-file and open a new PDF with just the pages you want to
   print. Split up longer documents into parts (of even numbers of pages) to
   reduce waste in case something goes wrong.

2. Print the even pages only
   (copy a prefix of: `2,4,6,8,10,12,14,16,18,20,22,24,26,28,30`).

3. Fan the output sheets out to reduce static electricity, which may help
   prevent the sheets from sticking together.

4. Put the sheets back into the tray, with the existing content side facing the
   ceiling and the bottom edge (footer) of the content feeding into the printer
   first.

5. Print the odd pages only
   (copy a prefix of: `1,3,5,7,9,11,13,15,17,19,21,23,25,27,29`).


## Manual feed

Put the sheet into the manual feed tray, with the blank/desired content side
facing the ceiling and the top edge (header) of the desired content feeding
into the printer first. In other words, the manual feed tray has the exact
opposite orientation as the automatic feed tray.

Note that the manual feed tray does not align sheets very well, so the content
may be slightly diagonal and inconsistently so.
