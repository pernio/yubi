# Yubi

This is my second case study, this time about YubiKeys. I got inspired by [Jack Kerr](https://github.com/jwkerr), who initially introduced me to Yubico.

## What are YubiKeys?

All info related to what Yubikeys are and how you can use them, can be found in his blog post:\
https://blog.jackkerr.com/beginners-guide-to-yubikeys/

## What is this repository about?

I am not going to focus on explaining what YubiKeys are. I suggest reading the blog post attached above for that.

This repository focuses on making YubiKeys easier to use. The goal is to provide simple command-line helpers for working with GPG-backed Git commit signing using YubiKeys.

This is done via:

- a Bash script for Git Bash, Linux, macOS and WSL
- a PowerShell script for Windows PowerShell / PowerShell Core

## Why?

When I started using YubiKeys for GPG commit signing, it was a big learning gap to remember all commands. For sure when I wanted to switch between signing keys. You often need to remember commands like:

```bash
gpgconf --kill gpg-agent
gpg --card-edit
git config --global user.signingkey <key-id>
```

That's hard, right? Well, this repository wraps those commands into easier commands such as:

```bash
yubi switch terry
yubi status
yubi test
yubi enable
yubi disable
...
```

## Features

- Switch between multiple YubiKey signing keys using readable names
- Restart the GPG agent quickly
- View the inserted YubiKey status
- Test whether GPG signing works
- Enable or disable global Git commit signing
- Works in both Bash and PowerShell

## Configuration

Both scripts use a named list of YubiKeys.

### Bash

```bash
declare -A YUBI_KEYS=(
  ["terry"]="x"
  ["jerry"]="y"
)
```

### PowerShell

```powershell
$YubiKeys = @{
    "terry" = "x"
    "jerry" = "y"
}
```

The names can be anything you want, for example:

```text
work
home
backup
blue
black
```

## Bash setup

### 1. Create a local bin folder

```bash
mkdir -p ~/bin
```

### 2. Create the script

```bash
nano ~/bin/yubi
```

Paste the Bash script you can find [here](https://github.com/pernio/yubi/blob/main/yubi) into the file.

### 3. Make it executable

```bash
chmod +x ~/bin/yubi
```

### 4. Add `~/bin` to your PATH

Open your Bash config:

```bash
nano ~/.bashrc
```

Add this line:

```bash
export PATH="$HOME/bin:$PATH"
```

Reload Bash:

```bash
source ~/.bashrc
```

### 5. Test it

```bash
yubi help
yubi list
yubi status
```

### Use your keys

In the bash script you pasted, you will see that the key's values are `x` and `y`. Replace `x` and `y` with your key's ID. These are 16-char long random number/characters which resembles a unique identifier for your key.

```bash
declare -A YUBI_KEYS=(
  ["terry"]="x"
  ["jerry"]="y"
)
```

## PowerShell setup

### 1. Create the script

Create a file called:

```text
yubi.ps1
```

Paste the PowerShell script you can find in [here](https://github.com/pernio/yubi/blob/main/yubi.ps1) into the file. (Also do not forget to replace the `x` & `y` values with your own keys identifiers.)

### 2. Run the script

From the folder where the script is located:

```powershell
.\yubi.ps1 help
```

### 3. Example usage

```powershell
.\yubi.ps1 list
.\yubi.ps1 status
.\yubi.ps1 switch terry
.\yubi.ps1 current
.\yubi.ps1 test
.\yubi.ps1 enable
.\yubi.ps1 disable
```

### 4. Make the command globally available

Instead of running:

```powershell
.\yubi.ps1 status
```

every time, you can make `yubi` work globally from anywhere in PowerShell. Just like in Bash.

#### Create a scripts folder

```powershell
mkdir $HOME\Scripts
```

Move:

```text
yubi.ps1
```

into:

```text
C:\Users\<your-user>\Scripts\
```

Example:

```text
C:\Users\Pernio\Scripts\yubi.ps1
```

#### Add the folder to PATH

Run this in PowerShell:

```powershell
[Environment]::SetEnvironmentVariable(
  "Path",
  $env:Path + ";$HOME\Scripts",
  "User"
)
```

Restart PowerShell afterward.

#### Create a PowerShell wrapper function

Open your PowerShell profile:

```powershell
notepad $PROFILE
```

If that errors because the profile does not exist yet:

```powershell
New-Item -ItemType File -Path $PROFILE -Force
notepad $PROFILE
```

Add this function:

```powershell
function yubi {
    & "$HOME\Scripts\yubi.ps1" @args
}
```

Save the file.

Reload your PowerShell profile:

```powershell
. $PROFILE
```

#### Done

You can now run:

```powershell
yubi help
yubi status
yubi switch terry
yubi current
yubi enable
```

from anywhere in PowerShell without needing:

```powershell
.\yubi.ps1
```

## Conclusion

These scripts make GPG commit signing using YubiKeys easier to use from your CLI.

For any questions, problems or requesting addons -> [Make an issue](https://github.com/pernio/yubi/issues)\
For any changes you'd like to make on the Powershell/Bash scripts -> [Make a pull request](https://github.com/pernio/yubi/pulls)
