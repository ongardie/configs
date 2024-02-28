# Firefox web browser

These are instructions to configure Firefox (last updated in full for v122).

## Extensions

- [1Password](https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager/)
- [Facebook Container](https://addons.mozilla.org/en-US/firefox/addon/facebook-container/)
- [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/)
- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)

### 1Password Settings

General > Make 1Password the default password manager in this browser: yes

## Settings


### General

General > Startup > Open previous windows and tabs: yes

Files and Applications > Downloads > Save files to: `~/tmp`

Files and Applications > Applications > What should Firefox do with other files?: Ask whether to open or save files

Browsing > Use smooth scrolling: no

Browsing > Recommend extensions as you browse: no

Browsing > Recommend features as you browse: no

### Home

Firefox Home Content > Web Search: no

Firefox Home Content > Shortcuts: no

Firefox Home Content > Recommended by Pocket: no

### Search

Default Search Engine: DuckDuckGo

Search Suggestions > Show search suggestions ahead of browsing history in address bar results: no

### Privacy & Security

Browser Privacy > Enhanced Tracking Protection: Strict

Browser Privacy > Website Privacy Preferences > Tell websites not to sell or share my data: yes

Browser Privacy > Website Privacy Preferences > Send websites a "Do Not Track" request: yes

Browser Privacy > Passwords > Ask to save passwords: no

Browser Privacy > Autofill > Save and fill payment methods: no

Browser Privacy > Autofill > Save and fill payment methods: no

Browser Privacy > Address Bar -- Firefox Suggest > Suggestions from sponsors: no

Permissions > Location > Settings > Block new requests asking to access your location: yes

Firefox Data Collection and Use > Allow Firefox to send technical and interaction data to Mozilla: no

Firefox Data Collection and Use > Allow Firefox to install and run studies: no

Security > HTTPS-Only Mode: Enable HTTPS-Only Mode in all windows

DNS over HTTPS > Enable DNS over HTTPS using: Max Protection

### Sync

Take Your Web With You > Sign in to sync...: ok

Sync > Syncing: On > You are syncing these items across all your connected devices: Bookmarks, Open tabs

## `about:config`

Set `browser.tabs.inTitlebar` to `0` if you're using a tiling window manager.
This gets rid of the minimize/maximize/close buttons and removes the padding on
either side of the tabs.

Set `widget.non-native-theme.scrollbar.size.override` to about `25` to increase
the scrollbar width.
