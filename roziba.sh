#!/bin/bash
wget "https://github.com/sssgnu/roziba_installer/raw/master/files/image/bg.png"
gsettings set org.gnome.desktop.background picture-uri ~/Pictures/bg.png

if [[ $EUID -ne 0 ]]; then
   echo "roziba must be run as root"
   read -s -p "Enter your password: " pass
fi
distro=`lsb_release -is`
de=`echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/'`
echo "you have $distro $de"

if [[ "$distro" == "Ubuntu" ]]; then
  if [[ "$de" == "gnome" ]]; then
    # update system
    echo "$pass" | sudo -S apt -y update
    echo "$pass" | sudo -S apt -y upgrade
    echo "$pass" | sudo -S apt -y autoremove
    echo "$pass" | sudo -S apt -y autoclean

    # install arc theme
    echo "$pass" | sudo -S apt -y install autoconf automake pkg-config libgtk-3-dev git xdotool
    echo "$pass" | sudo -S rm -rf /usr/share/themes/{Arc-Flatabulous,Arc-Flatabulous-Darker,Arc-Flatabulous-Dark,Arc-Flatabulous-Solid,Arc-Flatabulous-Darker-Solid,Arc-Flatabulous-Dark-Solid}
    echo "$pass" | sudo -S rm -rf ~/.local/share/themes/{Arc-Flatabulous,Arc-Flatabulous-Darker,Arc-Flatabulous-Dark,Arc-Flatabulous-Solid,Arc-Flatabulous-Darker-Solid,Arc-Flatabulous-Dark-Solid}
    echo "$pass" | sudo -S rm -rf ~/.themes/{Arc-Flatabulous,Arc-Flatabulous-Darker,Arc-Flatabulous-Dark,Arc-Flatabulous-Solid,Arc-Flatabulous-Darker-Solid,Arc-Flatabulous-Dark-Solid}
    cd /tmp
    echo "$pass" | sudo -S git clone https://github.com/andreisergiu98/arc-flatabulous-theme
    cd arc-flatabulous-theme
    echo "$pass" | sudo -S ./autogen.sh --prefix=/usr
    echo "$pass" | sudo -S make install
    gsettings set org.gnome.desktop.interface gtk-theme "Arc-Flatabulous"

    # install Flat Remix icons
    cd /tmp && rm -rf Flat-Remix &&
    echo "$pass" | sudo -S git clone https://github.com/daniruiz/Flat-Remix &&
    echo "$pass" | sudo -S mkdir -p ~/.icons && cp -r Flat-Remix/Flat\ Remix* ~/.icons/ &&
    gsettings set org.gnome.desktop.interface icon-theme "Flat Remix"

    #Enable user themes
    gnome-shell-extension-tool -e "user-theme@gnome-shell-extensions.gcampax.github.com"
    #install Flat Remix theme
    echo "$pass" | sudo -S rm -rf /tmp/Flat-Remix-GNOME-theme/ && cd /tmp &&
    echo "$pass" | sudo -S git clone https://github.com/daniruiz/Flat-Remix-GNOME-theme &&
    echo "$pass" | sudo -S `mkdir -p ~/.themes && cp -r /tmp/Flat-Remix-GNOME-theme/Flat\ Remix* ~/.themes` &&
    gsettings set org.gnome.shell.extensions.user-theme name "Flat Remix";

    #install fonts
    # cd ~
    # mkdir ".fonts"
    # cd ".fonts"
    # wget "https://github.com/sssgnu/roziba_installer/blob/master/files/fonts/fonts.tar.gz"
    # tar -xvzf fonts.tar.gz

    # install conky manager an Gotham_Fa
    cd /tmp
    echo "$pass" | sudo -S git clone "https://github.com/sssgnu/persian_conky.git"
    echo "$pass" | sudo -S mkdir ~/.conky
    echo "$pass" | sudo -S cp -rf "persian_conky/Gotham_Fa" "~/.conky"
    x=`lsb_release -r -s`
    v=${x%.*}
    if [[ "$v" -le 16 ]]; then
      echo ">16"
      # apt-add-repository -y ppa:teejee2008/ppa
      # apt -y update
      # apt -y install conky-manager
    else
      bit = `uname -m`
      apt -y install gdebi
      if [[ "$bit" == "x86_64" ]]; then
        wget https://launchpad.net/~teejee2008/+archive/ubuntu/ppa/+files/conky-manager_2.4~136~ubuntu16.04.1_amd64.deb
      else
        wget https://launchpad.net/~teejee2008/+archive/ubuntu/ppa/+files/conky-manager_2.4~136~ubuntu16.04.1_i386.deb
      fi
      sudo gdebi conky-manager*.deb
    fi
      conky-manager&
      zenity --info --text="کانکی منیجر برای شما باز می‌شود، کانکی Gotham_Fa یک کانکی شمسی و فارسی شده است، شما میتوانید
      کانکی های مورد علاقه‌ی خود را فعال کنید و سپس کانکی منیجر و این پنجره را ببنید"

    echo "OK!!!!!"
    read -p "need reboot for update screen, restart? (y/n): " ans
    if [[ "$ans" == "y" ]]; then
      `reboot`
    else
      echo "finished!, please reboot for show new desktop!!"
    fi
  else
    echo "Roziba only runs on Gnome"
  fi
else
  echo "Roziba only runs on Ubuntu"
fi
