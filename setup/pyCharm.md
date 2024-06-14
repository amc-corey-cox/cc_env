# pyCharm - IDE for Python
pyCharm is and IDE environment for Python devlopment create by JetBrains. It is one of the more popular IDE's for development in Python. In addition, many in my team use it. I also use Visual Studio Code for Python but I tend to use pyCharm when unless many other tools are involved in the development.

## Installation
Previously, I had installed by downloading the tarbal and unpacking to /opt. However, I just noticed there is now a version available through App Center. I'm going to try installing that way this time and see how it goes.
I'll make notes here if I have any trouble.

### Install via App Center
The App Center has been updated by Ubuntu and many software packages are now updated or install more cleanly. So, I'll be using the App Center provided pyCharm for now. It is as simple as looking up the package in App Center and installing.

### Install via Tarball
This is the past information on installing via tarball. It looks like it should still work but I will be using the above method for now.

[pyCharm Installation Guide](https://www.jetbrains.com/help/pycharm/installation-guide.html)

Install by unpacking to /opt

```
sudo tar xzf pycharm-*.tar.gz -C /opt/pyCharm
```

add opt/pyCharm/bin to PATH in .profile

## pyCharm plugins
The pyCharm IDE has a lot of plugins to improving programming with different aspects of development. Here I'll try to capture the plugins I'm currenlty using and any configuration necessary for them.

### Plugins List
Here are the plugins I'm currently using. If the plugin is just listed below it didn't require any non-obvious setup to get working properly. Any plugins requiring more effort will have an additional entry below.

 * Docker - by JetBrains
 * GitHub CoPilot - by GitHub
