# Brother HL-L3280CDW printer

Duplex, color, USB/Ethernet/wifi laser printer. Purchased 2025.

- [Product page](https://www.brother-usa.com/products/hll3280cdw)
- [Support page](https://support.brother.com/g/b/manualtop.aspx?c=us&lang=en&prod=hll3280cdw_us_as)
  (manuals, etc)

According to the
[OpenPrinting database](https://openprinting.github.io/printers/) (as of
2025-06), it supports AirPrint but not IPP Everywhere.

Visit `http://$printer` to see the toner level. Visit `https://$printer` and
accept self-signed cert to log in. The default password is on a sticker on the
back of the printer. You can change it in this web interface. You can also view
a lot of settings and see toner levels and usage. It doesn't support uploading
a PDF to print.

Its IPP URL is `ipp://$printer:631/ipp`. Maybe adding
`?encryption=required&contimeout=30` helps, I don't know.

Under Debian 12, I tried:
- Generic IPP Everywhere Printer: This printed but didn't do duplex and didn't
  report toner levels.
- Generic PostScript Printer: Did not print.
- Generic PDF Printer: This printed with duplex. It zoomed the PDF out (shrunk
  it so it has increased margins), perhaps because it had an icon near the edge
  of the page. I changed "Page Handling" > "Page Scaling" to "None" in print
  job settings, which helped that. It didn't print ligatures in a technical
  PDF, so it's unusable (`efficiency` turned into `e   iciency`, for example).
- Setup using Avahi, but it didn't even have duplex options listed.
- The support page has a `.deb` which would install a PPD and some stuff,
  including Perl scripts and compiled LPD programs. I installed
  `hll3280cdwpdrv-3.5.1-1.i386.deb` (with SHA-256 of
  `d891bb0beb02e7b7fafab2935938f09e1bc7ad1a74aa8162950ffb28e0cd6ebe`), which
  created a printer named `HLL3280CDW`. This had a `dnssd://` URL and failed to
  connect. I may not have set up Avahi or my firewall correctly.
- I added a printer to the IPP URL but selected the Driver
  `Brother HLL3280CDW CUPS`, which the above `.deb` installed. This seems to
  work well.

For Android, I installed the Brother Print Service Plugin, though it's not
clear that I needed to. I found the print quality lacking compared to Linux,
but I have no settings I can change.

On Mac, the printer was discovered fine with no setup.

Printing pages 1 and 5 of
[this PDF](https://dl.acm.org/doi/pdf/10.1145/3626246.3653380) together
in duplex mode happens to make for a good test. Page 1 has the icon in the
margin, and page 5 contains `ff` ligatures.
