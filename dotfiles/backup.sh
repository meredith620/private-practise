#! /bin/bash

ROOT="$(cd $(dirname $0) && pwd)"
ROOT=${ROOT%/}

is_dir() {
    local target="$1"
    file "$target" | grep directory > /dev/null
    ret=$?
    return ${ret}
}

dobackup() {
    local src="$1"
    target_parent=$(dirname ${ROOT}${src})
    mkdir -p ${target_parent}
    if [ ! -e "$src" ]; then
        echo "src: $src does not exists, skip"
        return 0
    fi
    is_dir "$src"
    ret=$?
    if [ $ret -eq 0 ]; then
        # is dir
        echo "cp -r ${src} ${target_parent}/"
        # cp -r ${src} ${target_parent}/
    else
        # is not dir
        echo "cp ${src} ${target_parent}/"
        # cp ${src} ${target_parent}/
    fi
}

BACKUP_LIST=(
    /etc/X11/xorg.conf.d
    /etc/acpi/actions
    /etc/acpi/events
    /etc/asound.conf
    /etc/bluetooth
    /etc/conf.d/net
    /etc/default/grub
    /etc/fstab
    #etc/grub.d/40_custom
    /etc/ipsec.conf
    /etc/ipsec.secrets
    #/etc/modprobe.d/nouveau.conf
    /etc/portage/make.conf
    /etc/portage/package.keywords
    /etc/portage/package.use
    /etc/portage/repos.conf
    /etc/portage/package.license
    /etc/portage/patches
    /etc/portage/savedconfig
    /etc/portage/package.accept_keywords
    /etc/portage/package.mask
    /etc/portage/repo.postsync.d
    /etc/profile.d/xdg_cache_home.sh
    /etc/ssh/ssh_config
    /etc/ssh/sshd_config
    /etc/sysctl.conf
    /etc/sysctl.d/10-net-forward.conf
    /etc/wpa_supplicant/wpa_supplicant.conf

    /usr/src/linux/.config
    ${HOME}/.Xresources
    ${HOME}/.bashrc
    ${HOME}/.emacs
    ${HOME}/.gitconfig
    # ${HOME}/.inputrc
    ${HOME}/.mplayer
    ${HOME}/.sawfish
    ${HOME}/.sawfishrc
    ${HOME}/.ssh
    ${HOME}/.tmux.conf
    ${HOME}/.toprc
    ${HOME}/.xbindkeysrc
    ${HOME}/.xinitrc
    ${HOME}/.xmodmap
    ${HOME}/.zshrc
    ${HOME}/makewallpaper.sh
    ${HOME}/set_brightness.sh
    ${HOME}/set_display.sh
    ${HOME}/wlanup.sh
)

backup_system_conf() {
    for x in ${BACKUP_LIST[@]}; do
        dobackup "$x"
    done
}

main() {
    backup_system_conf
}

# ===== main =====
if [[ "${BASH_SOURCE[0]}" == "$0" ]];then
    main $*
fi
