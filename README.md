My dotfiles for configuring i3-gaps
===================================

# Usage

Basically, each files and folders in the repository is corresponding to the same item in your $HOME directory, except for .git of course. So create symlinks for each files and reload your environment if necessary.

You can use the installation script to automate the symbolic links:

    ./install.sh

This script does not install the files .zshrc and .gitconfig.

Please note that the file .gitconfig contains the configuration for my user, with my name and my email address. So don't use it without modifying it ;)

The script .screenlayout/hotplug.sh is initially called by the i3 configuration file and by a udev rule (you can find an example in the file 90-monitor-hotplug.example.rules) when monitors are un/plugged. Currently, the screen setup hard-coded in this script is corresponding to my laptop, so edit it before using it.
You can use it by copying the rule in the directory /etc/udev/rules.d/ (don't forget to edit the file according to your system).
Then you can force the reloading of the udev rules by running:

    # udevadm control --reload

There are references to my screens setup in the i3 config file. i3 should ignore them if the monitors does not exist.

See the [Archlinux wiki](https://wiki.archlinux.org/index.php/Udev#Execute_on_VGA_cable_plug_in) for more explanations.

You also need to add sudo rules to allow your user, or a group, to run the commands `reboot` and `poweroff`.

# Requirements

* [i3-gaps](https://github.com/Airblader/i3) (or i3 basic if you remove the parameters "gaps inner" and "gaps outer" at the end of the configuration file)
* Urxvt (patched version) [Here is an AUR package](https://aur.archlinux.org/packages/rxvt-unicode-patched/) but can be easily found for debian based distros
* [rofi](https://github.com/DaveDavenport/rofi)
* [Polybar](https://github.com/jaagr/polybar)
* [feh](https://feh.finalrewind.org/)
* [Font Awesome](http://fontawesome.io/)
* [Powerline fonts](https://github.com/powerline/fonts)
* vim: I recommand to use the [Awesome vimrc of amix](https://github.com/amix/vimrc)
* [ranger](http://ranger.nongnu.org/)
* [compton](https://github.com/chjj/compton)
* [pamixer](https://github.com/cdemoulins/pamixer)
* [udiskie](https://github.com/coldfix/udiskie)
* [nm-applet](git://git.gnome.org/network-manager-applet) ([see the NetworkManager website](https://wiki.gnome.org/Projects/NetworkManager/))
* [xrandr](https://www.x.org/wiki/)

# References 

* The wallpaper is a [picture](https://www.deviantart.com/art/REAPER-669345499) of [ERA-7](https://era-7.deviantart.com/)

