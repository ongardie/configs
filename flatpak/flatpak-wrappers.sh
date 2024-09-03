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

    if [ "$name" =  onepassword ] && ! [ -f 1password ]; then
        ln -s onepassword 1password
        echo "Created $PWD/1password as alias for $PWD/onepassword"
    fi
done
