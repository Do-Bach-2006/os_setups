#! /usr/bin/bash


add_chaotic_aur()
{
    pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key 3056513887B78AEB
    pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    echo "[chaotic-aur]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
}

install_needed_applications()
{
    # update the systems
    echo "system updates"
    sudo -S pacman -Syu

    # install needed package managers
    echo "install yay and paru"
    sudo -S pacman -S yay paru
    # install needed applications
    echo "install necessary apps"
    yay -S discord discordupdater chatgpt-desktop-bin microsoft-copilot-nativefier spotube-bin bleachbit etcher-bin brave-bin bitwarden gparted libreoffice-fresh wps-office rider fcitx5 fcitx5-configtool fcitx5-unikey git bat font-manager python-fonttools qbittorrent visual-studio-code-bin neovim python-pylspci python-pylsp-mypy python-pylsp-rope

}

install_dotfiles()
{
    # we have to move to the home directory for the gh0stzk to work
    cd $HOME
    echo "setup favorite dotfiles"
    curl https://raw.githubusercontent.com/gh0stzk/dotfiles/master/RiceInstaller -o $HOME/RiceInstaller
    chmod +x RiceInstaller
    ./RiceInstaller
}

setup_visual_studio_code()
{
    # install extensions
    # extensions=("ms-vscode.cpptools" "ms-python.python" "esbenp.prettier-vscode" "VisualStudioExptTeam.vscodeintellicode" "ms-vscode.cpptools-extension-pack" "formulahendry.code-runner" "VisualStudioExptTeam.intellicode-api-usage-examples" "VisualStudioExptTeam.vscodeintellicode-completions" "VisualStudioExptTeam.vscodeintellicode-insiders" "ms-python.debugpy" "rogalmic.bash-debug" "ritwickdey.LiveServer" "SonarSource.sonarlint-vscode" "PKief.material-icon-theme" "zhuangtongfa.Material-theme" "formulahendry.auto-complete-tag" "eamodio.gitlens")

    extensions=("formulahendry.code-runner" "VisualStudioExptTeam.vscodeintellicode" "VisualStudioExptTeam.intellicode-api-usage-examples" "VisualStudioExptTeam.vscodeintellicode-completions" "VisualStudioExptTeam.vscodeintellicode-insiders" "PKief.material-icon-theme" "zhuangtongfa.Material-theme" "itsjonq.owlet" "esbenp.prettier-vscode" "SonarSource.sonarlint-vscode" "wayou.vscode-todo-highlight" "streetsidesoftware.code-spell-checker" "christian-kohler.path-intellisense" "ms-vscode-remote.remote-ssh-edit" "ms-vscode.cpptools" "ms-vscode.cpptools-themes" "ms-vscode.cpptools-extension-pack" "ms-vscode.cmake-tools" "ms-python.python" "ms-python.debugpy" "ms-python.vscode-pylance" "ms-toolsai.jupyter" "ms-python.isort" "rogalmic.bash-debug" "shakram02.bash-beautify" "mads-hartmann.bash-ide-vscode" "xabikos.JavaScriptSnippets" "ms-vscode.js-debug-nightly" "formulahendry.auto-complete-tag" "ritwickdey.LiveServer" "ms-dotnettools.csharp" "ms-dotnettools.csdevkit" "ms-dotnettools.vscodeintellicode-csharp")

    # install the global extensions , which will visible in every profile
    for extension in "${extensions[@]}"
    do
        code --install-extension $extension
    done

}

# now , the vscode_profiles will be in the $HOME directory and we have to create a scropt to modify it


add_settings()
{
    echo "add bspwmrc settings"
    cat ./setting_files/bspwmrc_commands.txt >> $HOME/.config/bspwm/bspwmrc

    echo "add sxhkdrc settings"
    cat ./setting_files/sxhkdrc_commands.txt >> $HOME/.config/bspwm/sxhkdrc

    echo "add zshrc settings"
    cat ./setting_files/zshrc_commands.txt >>  $HOME/.zshrc

    echo "add vscode settings"
    cat ./setting_files/setting_content.json > $HOME/.config/Code/User/settings.json

}

main()
{
    add_chaotic_aur
    install_needed_applications

    # copy the settings content files to the home screen inorder to setup the settings and for the rice installer to work
    cp -r "./setting_files" $HOME
    cd $HOME

    mkdir programming

    setup_visual_studio_code

    install_dotfiles
    add_settings

    # clean up tempt files after setup
    # we are at the $HOME directory
    rm -rf ./setting_files
}

main