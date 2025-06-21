#!/bin/sh

# Package lists for Debian. Run this with no arguments for usage.

set -eu

DEBIAN=${DEBIAN:-$(cat /etc/debian_version || echo 13)}
DEBIAN=$(echo "$DEBIAN" | cut -d. -f1)

usage() {
    echo "USAGE: $0 [--info] ROLE..."
    echo
    echo "Print package lists for Debian. You can install these with:"
    echo "  apt install \$($0 ...)"
    echo "With --info, describe each package and warn of unknown packages."
    echo
    echo "Roles:"
    echo "  base:     generally useful"
    echo "  build:    C/C++ compilers, man pages"
    echo "  gui:      graphical"
    echo "  hardware: not a container or VM"
    echo "  print:    CUPS printer daemon"
    echo "  ssh:      SSH daemon"
    echo
    echo "Detected Debian $DEBIAN. Set \$DEBIAN to override."
}

info=false

base=false
build=false
gui=false
hardware=false
print=false
ssh=false

if [ $# -eq 0 ]; then
    usage
    exit 1
fi
while [ $# -ne 0 ]; do
    case "$1" in
        --info)     info=true ;;
        base)       base=true ;;
        build)      build=true ;;
        gui)        gui=true ;;
        hardware)   hardware=true ;;
        print)      print=true ;;
        ssh)        ssh=true ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
    shift
done

list() {

if $base; then
    echo apt-file       # search for packages providing files
    echo aspell         # spell checker
    echo aspell-en      # spell checker (English dictionary)
    echo bash-completion    # better tab completion for Bash
    echo bat            # print files with syntax highlighting (`batcat`)
    echo bind9-dnsutils # `dig` for DNS lookups
    echo bsdextrautils  # `column`, `hexdump`, `look`, etc
    echo curl           # command-line HTTP client (and other protocols)
    echo docker.io      # run Linux containers
    echo eatmydata      # ignore fsync
    echo elinks         # command-line web browser
    echo git            # version control system
    echo glibc-doc      # pthreads man pages
    echo gpg            # encryption tool
    echo htop           # [monitoring] process, CPU, and memory usage
    echo hwinfo         # show information about hardware
    echo iotop          # [monitoring] disk read/write throughput by process
    echo iperf3         # measure network throughput
    echo ipython3       # interactive Python shell
    echo iw             # configure wireless devices
    echo jq             # manipulate JSON files
    echo lshw           # show information about hardware
    echo lsof           # [monitoring] show open files by processes
    echo lz4            # fast compression tool
    echo nano           # basic command-line text editor
    echo ncal           # displays a calendar on the command-line (`cal`)
    echo net-tools      # [monitoring] check open network ports, etc (`netstat`)
    echo nethogs        # [monitoring] network throughput by process
    echo nmap           # port scanner
    echo oathtool       # command-line tool to generate 2FA/MFA codes
    echo pciutils       # display information about PCIe devices (`lspci`)
    echo pv             # add progress bars to pipelines
    echo pwgen          # command-line tool to generate random passwords
    echo python3        # scripting language
    echo python3-pip    # Python package manager
    echo python3-venv   # Python virtual environment manager
    echo python3-wheel  # Python support for wheel-formatted packages
    echo qalc           # command-line calculator supporting units
    echo ripgrep        # faster, modern grep
    echo rlwrap         # add readline support to unmodified programs
    echo runsc          # gVisor, for sandboxing containers
    echo rsync          # remote file copying tool
    echo s-tui          # [monitoring] CPU usage, temperature, etc
    echo sqlite3        # CLI tool to manage file-based SQL databases
    echo strace         # interpose on system calls
    echo tcpdump        # sniff network packets
    echo time           # measure command CPU time
    echo tree           # list a directory tree recursively
    echo usbutils       # display information about USB devices (`lsusb`)
    echo ufw            # easy-to-configure firewall
    echo unattended-upgrades    # automatic and periodic apt upgrade
    echo unzip          # de-compress .zip archives
    echo vim            # text editor
    echo wamerican      # American English dictionary for /usr/share/dict
    echo wget           # command-line HTTP client
    echo wireguard-tools    # UDP-based VPN with little configuration
    echo xxd            # hex dump (see also `hexdump` in bsdextrautils)
    echo zip            # create .zip archives
    echo zsh            # feature-rich shell
    echo zsh-autosuggestions    # suggested completions for Zsh prompt
    echo zsh-syntax-highlighting    # syntax highlighting for Zsh prompt
    echo zstd           # fast and/or strong compression tool

    if [ "$DEBIAN" -ge 13 ]; then
        echo docker-cli # run Linux containers (client)
        echo linux-sysctl-defaults  # default sysctl.conf entries, making ping work for normal users, etc
    fi
fi

if $build; then
    echo build-essential    # C/C++ compiler, tools
    echo libtool        # used in building C/C++ libraries
    echo libtool-bin    # used in building C/C++ libraries
    echo linux-perf     # CPU profiling tool
    echo llvm           # compiler, linker, interpreter
    echo manpages-dev   # development-related man pages
    echo manpages-posix-dev # POSIX standard man pages
fi

if $hardware; then
    echo cryptsetup     # LUKS/dm-crypt disk encryption
    echo dosfstools     # to create FAT32 partitions
    echo efibootmgr     # manage UEFI settings
    echo exfatprogs     # format exFAT partitions
    echo fbset          # configure the Linux framebuffer/console
    echo libvirt-clients    # virsh tool for managing virtual machines
    echo libvirt-daemon # daemon for running virtual machines (user session mode)
    echo nvme-cli       # manage NVMe disks (PCIe SSDs)
    echo ovmf           # UEFI for KVM/QEMU virtual machines
    echo parted         # command-line disk partitioning tool
    echo qemu-system-x86    # support for x86/x86-64 virtual machines
    echo qemu-utils     # contains `qemu-img` tools to manipulate VM disk images
    echo virtinst       # virt-install to create virtual machines
fi

if $gui; then
    echo at-spi2-core   # to quiet down D-Bus warnings (like when launching gvim)
    echo baobab         # graphical disk usage analyzer
    echo chromium       # open-source web browser
    echo diffpdf        # visually compare two PDF files
    echo evince         # PDF viewer
    echo feh            # very basic image viewer
    echo firefox-esr    # open-source web browser (older extended support release)
    echo flatpak        # manage sandboxed desktop applications
    echo fluxbox        # basic floating window manager
    echo font-manager   # graphical tool to view fonts
    echo fonts-recommended   # depends on a bunch of fonts
    echo fonts-roboto   # a Google font
    echo galternatives  # graphical tool to manage Debian alternatives system
    echo gimp           # raster image editor
    echo gir1.2-spiceclientgtk-3.0   # for virt-manager to display VM console
    echo gnome-icon-theme    # icons for GNOME
    echo gnumeric       # spreadsheet program
    echo graphviz       # tool to generate graph (node and edge) diagrams from text
    echo gvfs-backends  # access MTP devices (Android) in Thunar, etc
    echo gvfs-fuse      # access MTP devices (Android), etc on filesystem
    echo inkscape       # vector image editor
    echo kazam          # tool to record screencasts
    echo kdenlive       # video editor
    echo libimage-exiftool-perl  # CLI tool to read and write image metadata
    echo libnotify-bin  # CLI tool to show desktop notifications (`notify-send`)
    echo libreoffice    # office suite (document editor, spreadsheet program, etc)
    echo libglib2.0-bin # to modify GNOME settings (`gsettings`)
    echo lightdm        # graphical display manager
    echo lightdm-gtk-greeter-settings    # graphical tool to edit lightdm settings
    echo mesa-utils     # graphics info: glxinfo, glxgears
    echo mousepad       # simple graphical text editor
    echo mplayer        # video player
    echo notion         # tiling window manager
    echo pavucontrol    # GUI for sound mixing
    echo pipewire-audio # sound daemon and adapters
    echo qpdfview       # tabbed PDF viewer (Qt)
    echo qrencode       # create QR codes
    echo remmina        # VNC and rdesktop client
    echo remmina-plugin-rdp  # rdesktop support for remmina
    echo remmina-plugin-vnc  # VNC support for remmina
    echo ristretto      # image viewer
    echo rxvt-unicode   # basic graphical terminal emulator
    echo synaptic       # graphical front-end for APT
    echo task-xfce-desktop   # the Xfce desktop environment (lots of dependencies)
    echo thunar         # graphical file manager
    echo tumbler-plugins-extra   # thumbnails in thunar
    echo vim-gtk3       # graphical front-end for vim (`gvim`)
    echo vlc            # video player
    echo xclip          # command-line interface to X clipboard
    echo xdg-desktop-portal-gtk  # important component for flatpak
    echo xfce4-goodies  # optional components for the Xfce desktop environment
    echo xfce4-notifyd  # daemon for desktop notifications
    echo xinput         # list and configure X input devices (keyboards, etc)
    echo xscreensaver   # screen saver/lock screen
    echo xserver-xephyr # nested X server
    echo xss-lock       # configures screen to lock on events like closing laptop lid
    echo xterm          # basic graphical terminal emulator
    echo yt-dlp         # download videos from YouTube and other sites
    echo zbar-tools     # read QR codes (from image file or webcam)

    if $hardware; then
        echo blueman    # graphical Bluetooth manager
        echo cheese     # graphical tool to take pictures with or test webcam
        echo gparted    # graphical disk partitioning tool
        echo network-manager-gnome  # manage network devices and WiFi networks
        echo qemu-system-gui    # GUI to run virtual machines
        echo virt-manager   # graphical tool to manage virtual machines
        echo virt-viewer    # graphical keyboard/video/mouse for virtual machines
    fi

    if $print; then
        echo system-config-printer  # graphical front-end for CUPS
    fi
fi

if $print; then
    echo cups           # printing daemon
fi

if $ssh; then
    echo openssh-server # SSH server
fi

}

packages=$(list | sort)

if $info; then
    # Package names consist of lowercase letters (a-z), digits (0-9), plus (+)
    # and minus (-) signs, and periods (.), so we just need to escape plus and
    # periods.
    regex="^($(echo "$packages" | xargs | sed 's/\+/\\+/; s/\./\\./; s/ /|/g'))$"
    apt search --names-only "$regex"

    # Warn on missing packages.
    found=$(apt-cache search --names-only "$regex" | cut -d' ' -f1)
    echo "$packages" | while read -r package; do
        if ! echo "$found" | grep -q "^$(echo "$package" | sed 's/\+/\\+/; s/\./\\./')$"; then
            echo "WARNING: package $package not found"
        fi
    done
else
    echo "$packages"
fi
