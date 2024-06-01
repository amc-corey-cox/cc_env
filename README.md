# Corey's Development Environment
I initially started this repository to capture simple environment scripts and settings for transferring those to a new system. I have now grown this to try to capture my entire system setup. Each time I use this it is bound to be out-of-date but I expect much of it will remain useful especially as I document the choices I've made and how I make them.

The initial use-case for was setting up my bash prompt with a smart attractive and easily configurable prompt and to manage my PATH variable more intelligently. While that is still a core feature, I've learned there are many more pieces to setting up my development environent. Other key components are installing core apps and libraries along with their configuration. I also use specialized environments for both python and typescript/javascript which are helpful to manage right away.

This README.md will cover most of the basic initial setup and reference different .md files in the install-software directory for installation of other tools.

# Installing Ubuntu
I didn't manage to catch all the details of the install this time but the Ubuntu install is really straightforward. This time I used the defult selection rather than adding the office tools and utilities. I'll need to evaluate whether I think this was the right choice.
I also think the third party drivers and additional media formats are important to install right away as I'm sure to need them later.
The only specific detail that I think is important is to make sure to encrypt the drive and get the drive keys.

## Drive Encryption
On my work system I am using whole drive encription. It is a simple option when running through the disk setup.
To access disk encryption you need to select advance features. I'm currenlty going with LVM and encryption because I'm not especially familiar with the other option, using ZFS. I believe a new option will be available in upcoming version of Ubuntu and it will be worth evaluating at that time.
For my home system, I'm planning to do some things with Windows 11 so I have a more complicated installation. I will document these in install/Windows11pro.md.

Note: In the past, Ubuntu generated recovery keys that could be used to access the drive if the password was lost. This is no longer the case, so make sure to use a password you can remembet. I also recommend keeping it in a password manager.

## Enable Ubuntu Pro
Ubuntu Pro is a service provided for free from Ubuntu on up to 5 systems for better live patching and longer support. I prefer to enable it as it requires fewer reboots and is free for my usage.

## Install Updates
After the basic installation, install the updates from 'Software Updater' and 'App Center' so the system will be fully up-to-date.

### Snap Store
Updating Snap Store is kind of annoying because it cannot update itself while it is running. It appears Ubuntu still hasn't fixed this. To udate the Snap Store run the following command in the terminal.
```
sudo snap refresh
```
I believe this will refresh (update) all snaps but I haven't tested this, yet.

# Basic System Software
The primary basic system software for my day-to-day use is just the browsers Chrome and Firefox. With this system change I am planning to use Firefox more heavily for all of my needs except for services specifically in the Google ecosystem, i.e. GCloud and Google Suite. This is primarily due to unfortunate choices that Google has made in privacy and security; I also don't especially like where they appear to be headed with AI.
I would prefer to install both browsers as Snaps because they present the greatest security risk on my system (I think) and Snaps my provide some level of protection. Unfortunately, Chrome is only availabl as a .deb. Normally, I'd be happy with this but browsers are one of the few things I would prefer to be in Snaps.

## CLI Tools
Ubuntu may have some base command line tools that aren't strictly necessary for average users. A couple of examples are git and curl.
As I discover other basic command line tools I need I will try to add them here.

### Bash Setup
I'm a little picky about my bash setup. I have a directory, .bash.d, and .bashrc for managing my path and environment setup in a more structured way. To set this up run the following commands from the repo root.
```
cp -R .bash.d ~
mv ~/.bashrc ~/.bashrc.ubuntu
cp .bashrc ~
```
After this it is a good idead to compare the copied .bash.d/ and .bashrc files with the .bashrc from ubuntu and make sure we aren't missing anything new that is nice to have.

### Git
Intallation and setup instructions for Git are in the setup/git.md file. This is a somewhat complicated setup so I recommend going through the file for complete setup guide as opposed to just `apt install git-all`.


### Curl
Default Ubuntu doesn't come with curl which is often considered a basic CLI tool. Curl is often used for software installation, testing, and development. Install curl using apt with the following command.
```
sudo apt install curl
```

### Editors - VIM and NeoVIM
I tend to use several IDE's for development, see below, but I also like to use VIM to edit files quickly at the command line. For installation of VIM and NeoVIM, refer to the setup/vim.md.

## Browsers
Most of my work involves being online within multiple different websites usually through abrowser. These are the browsers I'm currently running.

### Firefox
Firefox is installed by default and so far there isn't anything necessary for installation except to install any updates, updates are located in 'App Center' and may have already been applied above.

### Firefox Sync
In the past, I haven't bothered with Firefox sync preferring Google Chrome and Lastpass to manage passwords and credentials. However, since I'm planning to make greater use of Firefox going forward I think I will give Firefox Sync a try. After ensuring Firefox is working and updated, log in to Firefox Sync using the credentials saved in the password manager.
Firefox Sync also appears to sync extensions and other information (configurable) so once configured it should have all of Firefox set up correctly.

### Grammerly
I currently have the Grammerly extension disabled because I'm not sure if I'm allowed to use it by UNC. I would like to add it back to my tools as soon as possible so may re-enable it soon; when I figure out an allowed way.

## Chrome
Chrome has been my default browser for a long time but, alas, due to recent business decisions I will be de-emphasizing my use of it. I will continue to use Chrome for anything sepcifically within the Google environment.
Instructions for installing chrome are in setup/chrome.md.



# Old Stuff below


Copy .desktop files and icons to appropriate locations
```
cp desktop/* ~/.local/share/applications/
cp icons/* ~/.local/share/icons
```

Copy sbin scripts to /usr/local/sbin
```
sudo chown root -R scripts/sbin
sudo cp scripts/sbin/* /usr/local/sbin
```

create symlink for python to python3
```
sudo ln -s /usr/bin/python3 /usr/bin/python
```

