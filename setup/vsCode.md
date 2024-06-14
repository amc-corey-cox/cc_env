# Visual Studio Code - IDE
Visual Studio Code is an IDE for multiple programming languages and environments. I tend to use VS Code in projects with multiple langagues or architectures and projects mosly written in Typescript. VS Code is developed by Microsoft and one of their few programs that I genuinely like. For pure Python programming, I tend to use pyCharm instead.

## Installation
VS Code is available to download at (Visual Studio Code)[https://code.visualstudio.com/download] and available either as a Debian package or a Snap. I'm moving toward using Snaps for application software for improved containment so I'll use the App Center to install VS Code.
I'll make notes here if I have any trouble.

### Install via App Center
The App Center has been updated by Ubuntu and many software packages are now updated or install more cleanly. So, I'll be using the App Center VS Code (listed as just 'Code') for now. It is as simple as looking up the package in App Center and installing.

#### Fix crash on launch
In the past, I had an issue where VS Code would crash at launch; this appears to have been due to an issue with multiply monitors and graphics acceleration. It appears the issue is fixed but in case it crops up again here is how it was resolved.
To fix the issue, I needed to change the option in the 'code_code.desktop` file. This file is available in Ω_desktop/, Ω is just a convenient character to assure sorting after all letters.
```
cp Ω_desktop/code_code.desktop ~/.local/share/applications/code_code.desktop
```
When the snap is updated, you'll want to check if the file is still needed.
I used these sources of information to figure out this issue:
(StackOverflow)[https://stackoverflow.com/questions/78584630/visual-studio-code-crashes-with-errorprocess-memory-range-cc75-read-out]
(VSCode GitHub Issue)[https://github.com/microsoft/vscode/issues/204159]

### Install via Tarball
This should work for installing via tarball but I haven't tested it recently.

Downlod the .deb at (Visual Studio Code)[https://code.visualstudio.com/download].

Install with apt

```
sudo apt install /path/to/code.deb
```

## VS Code extensions
The VS Code IDE has a lot of extensions to improve programming with different aspects of development. Here I'll try to capture the plugins I'm currenlty using and any configuration necessary for them.

### Extensions List
Here are the plugins I'm currently using. If the plugin is just listed below it didn't require any non-obvious setup to get working properly. Any plugins requiring more effort will have an additional entry below. Multiple plugins listed in one line all install together with the first plugin.

 * Python, Pylance, Python Debugger - by Microsoft
 * GitHub Copilot, GitHub Copliot Chat - by GitHub

