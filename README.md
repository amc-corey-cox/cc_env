The purpose of this repository is to capture changes I make to my environment to aid in setting up the environment in future setups.
The initial use-case for this is setting up my bash prompt with a smart attractive and easily configurable prompt and to manage my PATH variable more intelligently.


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

