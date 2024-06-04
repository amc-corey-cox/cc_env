# Google Chrome and Chromium
Chrome has been my favorite browser for a while now but I'm probably going to start moving to either Chromium or Firefox due to some unfortunate business decisions by Google.
I'll continue to use Chrome for accessing tools within the Google ecosystem because it is likely to have an improved experience.

# Chrome Installation from .deb
Google Chrome can't currently be installed by clicking the .deb downloaded from the website, this will likely change soon.
We can install the .deb from the command line.
```
sudo apt install ~/Downloads/google-chrome-stable_current_amd64.deb
```
Installing this way, I was unable to launch Google Chrome either from the command line or the launcher. Installing this way does install the key and apt source.list repository. I then removed the installation with apt.
```
sudo apt remove google-chrome-stable
```
Oddly, after doing this... I can then install using the added repository/key.
```
sudo apt update
sudo apt install google-chrome-stable
```
However, this still doesn't seem to work properly so we'll remove the source.list and apt-key.
```
sudo rm /etc/apt/sources.list.d/google-chrome.list
sudo apt-key list
sudo apt-key del D38B4796
```

# Install Chrome from Official Repository

In order to install Chrome, we'll need to first install Google's signed key and then add the Google Chrome apt source repository. Then we can update our apt sources and install Google Chrome.
```
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor > google-chrome-keyring.gpg
sudo mv google-chrome-keyring.gpg /usr/share/keyrings/google-chrome-keyring.gpg
sudo chmod 644 /usr/share/keyrings/google-chrome-keyring.gpg
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install google-chrome-stable
```
I had to restart Ubuntu after the install here or it would not launch. I'm not sure but this may work for the .deb install above, too.

## Chrome Config
I log in with my main Gmail account and setup sync for all items. So far, I haven't noticed any other configuration that needs to be done. I will try to add anything new here.
