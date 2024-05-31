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
```

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

