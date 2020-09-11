# Kinesis Advantage Keyboard Programming Instructions

[Kinesis Advantage v1 manual](https://kinesis-ergo.com/wp-content/uploads/kb500-user_manual.pdf)

[Kinesis Advantage v2 manual](https://kinesis-ergo.com/wp-content/uploads/Adv2-Users-Manual-fw1.0.517-4-24-20.pdf)

## Factory reset instructions

1. Unplug keyboard
2. Hold F7
3. Plug in keyboard
4. Wait a few seconds
5. Let go of F7
6. Lights should flash

## Programming instructions

Disable audible tones and clicks:

```
Progrm -
Progrm \
```

Set to Windows mode (controls Meta, etc):

```
==============w
```

Set Ctrl_L + Space to act like Tab. This makes it possible to generate Tab
using just thumbs without taking up a dedicated key. (In the past, I used
Delete + Enter to mean Tab, but that led to unfortunate errors when I missed
the Delete key and hit Enter, which might, for example, run a command.)

```
Progrm F11
Ctrl_L Space
Tab
Progrm F11
```

Remap a bunch of stuff:
 - Swap the meaning of Shift_L and Delete, since the Delete function is
   needed less often but occupies a valuable thumb key by default.
 - Swap the meaning of Up and Down. I do this to mirror the behavior of J
   (down) and K (up) in Vim. I also physically exchange these keys so the
   labels are correct; Down ends up on the left and Up ends up on the right.
 - Make Ctrl_R act like Escape. This is a commonly used key in Vim, so it's
   worth a thumb key.

```
Progrm F12
Shift_L
Delete
Delete
Shift_L
Up
Down
Down
Up
Escape
Ctrl_R
Progrm F12
```

Disable the Tab key, for example. This can help retrain your mind. This
particular sequence is a strange one; it works because the Caps Lock key while
under Keypad mode is defined to have no effect.

```
Progrm F12
Keypad (on)
Caps_Lock
Keypad (off)
Tab
Progrm F12
```
