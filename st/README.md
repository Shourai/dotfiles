# st - simple terminal

st is a simple terminal emulator for X which sucks less.

## Notes about this fork

This is a fork of ST, the original repo can be found here: [https://git.suckless.org/st/](https://git.suckless.org/st/)
The original ST webpage is here: [https://st.suckless.org/](https://st.suckless.org/)
Updated to version 0.8.1.

### Patches applied

* [Alpha](https://st.suckless.org/patches/alpha/) : This patch allows users to change the opacity of the background. Note that you need an X composite manager (e.g. compton, xcompmgr) to make this patch effective.
* [Scrollback](https://st.suckless.org/patches/scrollback/) : Scroll back through terminal output using Shift+{PageUp, PageDown} and Shift+MouseWheel.
* [Solarized](https://st.suckless.org/patches/solarized/) : Solarized is a color scheme by Ethan Schoonover which exists in a dark and a light variant.

##### Applying/Removing Patches
```
# Add custom patch
patch -Np1 -i patches/custom.diff

# Remove st-alpha-201806-16-0.81 patch
patch -R patches/st-alpha-20180616-0.8.1.diff
```

## Requirements

In order to build st you need the Xlib header files.

## Installation

Edit config.mk to match your local setup (st is installed into
the /usr/local namespace by default).

Afterwards enter the following command to build and install st (if
necessary as root):

```bash
make clean install
```

## Running st

If you did not install st with make clean install, you must compile
the st terminfo entry with the following command:

```bash
tic -sx st.info
```

See the man page for additional details.

#### Keyboard
Action      | Key Combination
---         | ---
Copy        | `ctrl` + `shift` + `c`
Paste       | `ctrl` + `shift` + `v`
Zoom In     | `ctrl` + `shift` + `PageUp`
Zoom Out    | `ctrl` + `shift` + `PageDown`
Reset Zoom  | `ctrl` + `shift` + `Home`

#### Mouse
Action | Modifier
---    | ---
Scroll | `shift` + `mouse wheel`


## Credits

* Forked from [https://st.suckless.org/](https://st.suckless.org/)
* Based on Aurélien APTEL aurelien.aptel@gmail.com bt source code.
