My dotfiles for configuring i3-gaps
===================================

# Install

Basically, each file and folder in the repository is corresponding to the same item in your $HOME directory, except for .git of course.

First, clone the repository in your HOME directory:

    cd
    git clone https://github.com/MartialGeek/dotfiles .dotfiles

Then, create the configuration file for your monitors:

    cd .dotfiles/.screenlayout
    cp config.sh.dist config.sh

Run the xrandr command to display your monitors setup, then edit the file config.sh according to the output of xrandr. If you have only one monitor, simply set the monitor's name in the variable `PRIMARY`. Add the xrandr options of your monitor by editing the value of the key `PRIMARY` in the array `MONITORS`.
If you have more than one monitor, add them in the array.

Now you can use the installation script to automate the creation of the symbolic links:

    ~/.dotfiles/install.sh

This script does not install the file .zshrc and takes some options:
* `-h` or `--help`: displays the usage and exit
* `-n` or `--dry-run`: don't execute the commands, only log them
* `-f` or `--force`: force the recreation of the symbolic links, without asking questions

You can monitor the execution of the script with `journalctl -f` if it is installed on your system, otherwise the logs are displayed on the standard output.

The script .screenlayout/hotplug.sh is executed by the i3 configuration file and by a udev rule (you can find an example in the file 90-monitor-hotplug.example.rules) when monitors are un/plugged.
You can use it by copying the rule in the directory /etc/udev/rules.d/ (don't forget to edit the file according to your system).
Then you can force the reloading of the udev rules by running:

    # udevadm control --reload

See the [Archlinux wiki](https://wiki.archlinux.org/index.php/Udev#Execute_on_VGA_cable_plug_in) for more explanations.

There are references to my screens setup in the i3 config file. i3 should ignore them if the monitors does not exist.

You also need to add sudo rules to allow your user, or a group, to run the commands `reboot` and `poweroff` without password. For example:

    username ALL=(ALL) NOPASSWD: /usr/bin/poweroff, /usr/bin/reboot

Check the path of these executables on your system (`which poweroff && which reboot`).

I configured i3 to use the image `$HOME/.config/wallpaper/bg.jpg` (or .png) for the desktop background. So to change it, simply copy an image with this name in the directory, or create a symbolic link, and reload i3. You can also use the script `set-bg` installed in /usr/local/bin to change the wallpaper. Simply pass a valid jpg or png picture as first argument:

    set-bg Images/my-wallpaper.png

The screen locking is binded on Super+Shift+Return.

# Requirements

* [i3-gaps](https://github.com/Airblader/i3) (or i3 basic if you remove the parameters "gaps inner" and "gaps outer" at the end of the configuration file)
* Urxvt (patched version) [Here is an AUR package](https://aur.archlinux.org/packages/rxvt-unicode-patched/) but can be easily found for debian based distros
* [rofi](https://github.com/DaveDavenport/rofi)
* [Polybar](https://github.com/jaagr/polybar)
* [feh](https://feh.finalrewind.org/)
* [Font Awesome](http://fontawesome.io/)
* [Powerline fonts](https://github.com/powerline/fonts)
* vim: mininal version 8 
* [ranger](http://ranger.nongnu.org/)
* [compton](https://github.com/chjj/compton)
* [pamixer](https://github.com/cdemoulins/pamixer)
* [udiskie](https://github.com/coldfix/udiskie)
* [nm-applet](git://git.gnome.org/network-manager-applet) ([see the NetworkManager website](https://wiki.gnome.org/Projects/NetworkManager/))
* [xrandr](https://www.x.org/wiki/)
* [dunst](https://github.com/dunst-project/dunst), a great notification daemon
* [lightdm](https://www.freedesktop.org/wiki/Software/LightDM/)
* [light locker](https://github.com/the-cavalry/light-locker)
* (Optional) [blueman](https://github.com/blueman-project/blueman)

# References 

* The wallpaper is a [picture](https://www.deviantart.com/art/REAPER-669345499) of [ERA-7](https://era-7.deviantart.com/)

