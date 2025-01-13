# Git
Git is fundamental to all of my development and much of my desktop usage, as evidenced by this repo. As such, it is probably one of the most important packages to install quickly. Also, by installing git I will be able to access and work on this repository from the system in question right away; hopefully, improving my workflow.

# Git Installation
To install git using apt run the command below.
```
sudo apt install git-all
```
Using git-all also installs related git utilities to make git more useable and functional. I'm not certain that I need these but odds are good I'll want to have them so I might as well install them now.

## Git Config
I like to keep all of my repositories in a single directory so they aren't mixed with the contents of my home or documents directories. I used to call this Repositories but I've come to think that is unwieldy. Now I prefer just 'Dev'.
```
mkdir -p ~/Code
cd ~/Code
```

Next we need to set up some local variables for basic Git setup. 
```
git config --global user.name "amc-corey-cox"
git config --global user.email "69321580+amc-corey-cox@users.noreply.github.com"
git config --global init.defaultBranch main
git config --global fetch.prune true
```
These set the username and email to my details and ensure the default branch is `main`. The `fetch.prune` setting makes it so `git fetch` will always prune branches on the remote that have been deleted.

## SSH and GPG keys
Finally, we need to setup the ssh key to access our repositories.
```
ssh-keygen -t ed25519 -C "Corey_XPS15_GitHub"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

We also want to try out using a gpg key for signing commits.
```
gpg --full-generate-key
```
GPG requires some user information and a passphrase. I have saved these to LastPass for now. Here is the User information I used:

Corey Cox
69321580+amc-corey-cox@users.noreply.github.com
Corey_XPS15_GitHub_sign

After the keys are generated and stored locally we need to add the public keys to GitHub. Log in to GitHub, go to settings > SSH & GPG keys. There are buttons there to add the SSH and GPG keys.

View the ssh public key with:
```
cat ~/.ssh/id_ed25519.pub
```

And view the GPG key with:
```
gpg --list-secret-keys --keyid-format=long
```
The key id will look like this:

sec   ed25519/848C535626624F37 2024-05-31 [SC]

With the key id as: 848C535626624F37

Display the GPG public key with:
```
gpg --armor --export 848C535626624F37
```
This is the value to paste into GitHub to have the signing key. 

It can also be convenient to save the gpg passphrase for longer. I set it to one month here.
```
echo "default-cache-ttl 2629800" > ~/.gnupg/gpg-agent.conf
```

## Git Use Signing Key
In order to use the signing key we either need to tell Git to sign with the key on each commit.
```
git commit -S 26624F37 -m "commit message"
```
Or we can tell configure git to use the key, and to always sign.
```
git config --global user.signingkey 26624F37
git config --global commit.gpgsign true
```
I have also saved the password in Ubuntu's keyring because I feel my system is reasonably safe and my signing risk is low.


## Install GitHub CLI tools
The GitHub CLI tools allow us to do some things on GitHub from the command line. Honestly, I don't use them all that often but it is nice to have them installed in case I need them at some point.

Installation requires adding the GPG key and repository then installation with apt.
```
wget -q -O - https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null 
echo -n "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y
```

