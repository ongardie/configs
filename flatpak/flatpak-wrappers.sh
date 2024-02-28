#!/bin/sh

set -eu

mkdir -p "$HOME/bin"
cd "$HOME/bin"

for app in $(flatpak list --app --columns application); do
    # in 'com.spotify.Client', strip off '.Client'
    name=${app%.Client}
    # in com.google.Chrome, strip off 'com.google.'
    name=${name##*.}
    name=$(echo "$name" | tr '[:upper:]' '[:lower:]')

    if ! [ -f "$name" ]; then
        cat > "$name" << END
#!/bin/sh
exec flatpak run "$app" -- "\$@"
END
        chmod +x "$name"
        echo "Created $PWD/$name to launch $app"
    fi
done
