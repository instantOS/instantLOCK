<div align="center">
    <h1>instantLOCK</h1>
    <p>Lock-screen for instantOS</p>
    <img width="300" height="300" src="https://raw.githubusercontent.com/instantOS/instantLOGO/master/png/lock.png">
</div>

--------

## Usage
lock the screen and show a random dad joke
```
ilock
```

Pull up a menu to enter a message to leave on the locked screen
```
ilock message
```

Script the shown text, put a null string for no text
```
ilock message customtext
```


## Installation
instantLOCK is the default lockscreen for [instantOS](https://instantos.github.io)  
The message menu depends on [instantMENU](https://github.com/instantos/instantmenu)  
To compile it locally, clone the repo and run build.sh

### instantOS is still in early beta, contributions always welcome

## Features

instantLOCK is a fork of [slock](https://tools.suckless.org/slock/) with some added features that make it more usable to a "normal" computer user
The added features include

- Dot indicators when typing the password
- A warning message if someone tried (and failed) to unlock the screen
- Option to unlock screen without a password
- ilock wrapper
- Dad jokes

Some features are also based on suckless patches and work pretty much the same

- Message
- Xresources
- Ctrl + U to clear
