# Not So Minimal - VS Code (for SynthWave '84)

These files should be used with the [SynthWave '84](https://marketplace.visualstudio.com/items?itemName=RobbOwen.synthwave-vscode) VS Code theme.

## Installation

> [!NOTE]
> Before proceeding with the installation, see [Requirements](/README.md).

### 1. Install SynthWave '84 Theme

See the official instructions: [SynthWave '84](https://marketplace.visualstudio.com/items?itemName=RobbOwen.synthwave-vscode)

### 2. Clone the Repository

#### 2.1 Linux and Mac

```shell
git clone https://github.com/sirius-red/not-so-minimal-vscode.git /tmp/not-so-minimal-vscode
cp -rf /tmp/not-so-minimal-vscode/settings/synthwave84 ~/.config/not-so-minimal-vscode
rm -rf /tmp/not-so-minimal-vscode
```

#### 2.2 Windows

```powershell
git clone https://github.com/sirius-red/not-so-minimal-vscode.git $env:TEMP\not-so-minimal-vscode
Copy-Item -Path $env:TEMP\not-so-minimal-vscode\settings\synthwave84 -Destination $env:USERPROFILE\.config\not-so-minimal-vscode -Recurse -Force
Remove-Item -Path $env:TEMP\not-so-minimal-vscode -Recurse -Force
```

### 2. Apply the VS Code Settings

Copy the contents of `~/.config/not-so-minimal-vscode/settings.json` into your VS Code configuration file. Remove duplicate options if necessary.

### 3. Enable Custom CSS and JS

```shell
cd ~/.config/not-so-minimal-vscode/synthwave84
```

#### 3.1 Linux and Mac

```shell
./install.sh
```

#### 3.2 Windows

```powershell
./install.ps1
```
