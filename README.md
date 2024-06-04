# Corey's Development Environment
I initially started this repository to capture simple environment scripts and settings for transferring those to a new system. I have now grown this to try to capture my entire system setup. Each time I use this it is bound to be out-of-date but I expect much of it will remain useful especially as I document the choices I've made and how I make them.

The initial use-case for was setting up my bash prompt with a smart attractive and easily configurable prompt and to manage my PATH variable more intelligently. While that is still a core feature, I've learned there are many more pieces to setting up my development environent. Other key components are installing core apps and libraries along with their configuration. I also use specialized environments for both python and typescript/javascript which are helpful to manage right away.

This README.md will cover most of the basic initial setup and reference different .md files in the install-software directory for installation of other tools.

# Dual Boot
For installation with Windows 11 dual boot with option to run in a VM under Ubuntu, see windows11.md.

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

## Install Essential Build Tools
Ubuntu comes without some of the basic build tools for development so let's install them.
```
sudo apt install build-essential
```
This installs things like gcc, make, and other important build tools.

## Snap Store
Updating Snap Store is kind of annoying because it cannot update itself while it is running. It appears Ubuntu still hasn't fixed this. To udate the Snap Store run the following command in the terminal.
```
sudo snap refresh
```
I believe this will refresh (update) all snaps but I haven't tested this, yet.

## Gnome Tweaks
There use some features of Gnome that aren't surfaced in the Ubuntu desktop. Installing Gnome Tweaks can let us at some additional settings.
```
sudo apt install gnome-tweaks
```
In particular, I like the focus follows mouse setting. I seem to only be able to enable it with Gnome Tweaks.


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

## Terminal Emulators
Ubuntu's default terminal is woefully insufficient. I need a full-featured terminal application.

### Terminology
Terminology remains my preferred and go-to Terminal Emulator. Terminology is part of the Enlightnement desktop environment and doesn't always play as nicely as I'd like with other desktop environments. 
The version of Termonology listed in the App Center is out of date. Installing Terminology using apt in CLI gets the newest version.
```
sudo apt update
sudo apt install terminology
```
I generally have to play around with this for a little bit to get things looking the way that I like but otherwise there is no specific configuration.
Unfortunately, I can't figure out how to get one aesthetic feature of past versions that I really liked working again. 

### Kitty
Kitty is a highly-recommended full-featured terminal emulator. I think I should give it a try.
Installing Kitty appears pretty simple.
```
sudo apt install kitty
```
I don't know yet what my preferences are for configuration in Kitty; when I do, I'll try to improve this entry or add an .md file.


## Browsers
Most of my work involves being online within multiple different websites usually through abrowser. These are the browsers I'm currently running.

### Firefox
Firefox is installed by default and so far there isn't anything necessary for installation except to install any updates, updates are located in 'App Center' and may have already been applied above.

#### Firefox Sync
In the past, I haven't bothered with Firefox sync preferring Google Chrome and Lastpass to manage passwords and credentials. However, since I'm planning to make greater use of Firefox going forward I think I will give Firefox Sync a try. After ensuring Firefox is working and updated, log in to Firefox Sync using the credentials saved in the password manager.
Firefox Sync also appears to sync extensions and other information (configurable) so once configured it should have all of Firefox set up correctly.

### Grammerly
I currently have the Grammerly extension disabled because I'm not sure if I'm allowed to use it by UNC. I would like to add it back to my tools as soon as possible so may re-enable it soon; when I figure out an allowed way.

### Chrome
Chrome has been my default browser for a long time but, alas, due to recent business decisions I will be de-emphasizing my use of it. I will continue to use Chrome for anything sepcifically within the Google environment.
Instructions for installing chrome are in setup/chrome.md.

### Chromium
The Chromium browser is an open source version of the Chrome browser with out the Google branding or extras. Given my concerns about Google/Chrome I'm going to try it out as an additional browser option. Installation simply requires searching for it in the App Center and installing.


# Programming Tools
My system is used primarily for software development so I need a number of programming environments and IDE's.

## Programming Environments
I have a number of programming environments I use in my development. Here I will quickly document how to install and set up each. If the setup is more detailed I will refer to a .md in the setup folder.

### Node and nvm
Ubuntu doesn't currenlty appear to ship with Node.js installed or use it for system management. However, the version in the apt repositories appears to be current so we can just install from there. I also use nvm for managing the Node environment to ensure I'm using the correct version for development of different repositories. Here we will install both.
```
sudo apt install nodejs
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```
The shell environment it already properly configured in the .bashrc that we installed earlier.

### Python, pyenv, venv, and poetry
Python is commonly used for many of our software projects so we need to install base python and system tools for managing versioning of Python, virtual environments, and installation of software for each repository. Python can be a bit tricky when working with multiple projects that aren't in sync so I have a method of trying to maintain isolation between environments.
Ubuntu ships with a fairly current version of Python which we'll leave alone for the system to manage. For development, we want to install pyenv. 
```
sudo apt install libbz2-dev libncurses-dev libffi-dev libreadline-dev libssl-dev libsqlite3-dev liblzma-dev tk-dev
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
cd ~/.pyenv && src/configure && make -C src
```
Previously, I used the automated installer script but now I think I'd like to try out using the basic git clone method for installation. Theoretically, it is safer this way and it also gives an opportunity to see how it all works...

### R
I don't use R all that much at the moment but it continues to be a programming language I like to have on my system.
```
gpg --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
gpg --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | sudo tee /usr/share/keyrings/r-cran-keyring.gpg > /dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/r-cran-keyring.gpg] https://cloud.r-project.org/bin/linux/ubuntu noble-cran40/ | sudo tee /etc/apt/sources.list.d/r-cran.sources
sudo apt install r-base r-base-core r-base-dev
```
This installs both the r-base and what we need to install R from source in case I have interest in hacking on R, too. I don't need it but it's nice to install just in case so I don't have to do it later.
The above installs the public CRAN signing key to our local keyring which we don't need. Let's remove it.
```
gpg --delete-key E298A3A825C0D65DFD57CBB651716619E084DAB9
```

### Perl
Perl is another legacy language that I just like to have around.
```
sudo apt install perl
```
As of yet, Perl doesn't need any special configuration.

## Programming IDEs
Here are the IDE's I typically install. In addition, I tend to use Vim for development as well.

### pyCharm by IntelliJ
The installation for pyCharm can now be handled by installation in the App Center which I plan to try for now. I have some other notes available in setup/pyCharm.md but I'm not using that for installation right now.
PyCharm has community and professional editions, both available through the App Center. For now, I'm using the community edition but I plan to switch over to the professional edition when I have licensing approved.

### VSCode
VSCode also appears to be available through the App Center with the current version. Again, I'll be using this installation unless I see a reason to install in a different way.

### RStudio
RStudio is the best IDE for running anything in R. It looks like there isn't currently support for Ubuntu 24.04 but it appears I should be able to install using the 2024.4.1 release for Ubuntu 22. Download the .deb and install it.
```
wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.04.1-748-amd64.deb
sudo apt install rstudio-2024.04.1-748-amd64.deb
sudo chmod 4755 /usr/lib/rstudio/chrome-sandbox
```
After changing the mode of rstudio/chrom-sandbox (which I don't really understand), I was able to get Rstudio running.


# Other Software
Other software that I generally like to have is all available without any issues from the App Center. They are:
 - Slack - latest/stable
 - Zoom - latest/edge
 - Teams - latest/edge - no longer available as .deb from Microsoft
 - Transmission - latest/stable
 - VLC - latest/stable
 - Gimp - latest/
 - InkScape - latest/


# Final Configuration
There are a few things I used to do in system configuration listed below. Only the Icons are something I still consider important.

## Icons
I use a few programs that I don't really care for the default icons on. These icons and the associated .desktop files make them a little prettier to my eye.
Copy .desktop files and icons to appropriate locations
```
cp desktop/* ~/.local/share/applications/
cp icons/* ~/.local/share/icons
```

## Scripts
I used to have some trouble with bluetooth dropping my devices and these scripts fixed it. This is no longer needed but I'm not ready to get rid of the scripts just yet.
Skip for now... Copy sbin scripts to /usr/local/sbin
```
sudo chown root -R scripts/sbin
sudo cp scripts/sbin/* /usr/local/sbin
```

## Symlinks
I used to create a symlink from `python` to `python3` because it was annoying to have to type `python3`. Since I manage `python` through pyenv this no longer matters most of the time. I'm keeping this here as a reminder.
create symlink for python to python3
```
sudo ln -s /usr/bin/python3 /usr/bin/python
```
I think instead of using a symlink it would probably be better to create a simple bash function because this would only be during interactive sessions and would guarantee scripts don't attempt to use the wrong python.
