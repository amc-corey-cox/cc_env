This folder contains a .md file for each piece of software I regularly installl with instructions on installation and setup. Many software packages modify the PATH variable by inserting into .bashrc. Since part of the purpose of this envrinonment is to make my .bashrc more intelligible, I will often be modifying these changes.

Here is a list of all the software installed and basic information about them. Most of these require only a simple `sudo apt install`.


Curl
Git
Pip (python3-pip)
Gimp
Terminology


Install GitHub CLI tools
```
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
```

Install oh-my-bash
```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

Install zsh and oh-my-zsh
```
sudo apt install build-essential curl file git

```

Install FISH and 
