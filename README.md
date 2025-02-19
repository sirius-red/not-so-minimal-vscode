# Not So Minimal - VS Code

> [!NOTE]
> Read the [Custom CSS and JS Loader documentation](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css) for tips on avoiding issues with changes not taking effect.

## Installation and Setup

### 1. Install Required VS Code Extensions

Press `Ctrl + P` (Windows/Linux) or `Cmd + P` (Mac), enter, and execute the following commands:

| Name                     | Command                                              |
|--------------------------|------------------------------------------------------|
| Custom CSS and JS Loader | `ext install be5invis.vscode-custom-css`             |
| Fluent Icons             | `ext install miguelsolorio.fluent-icons`             |
| Catppuccin for VS Code   | `ext install Catppuccin.catppuccin-vsc`              |
| Catppuccin Noctis Icons  | `ext install alexdauenhauer.catppuccin-noctis-icons` |

### 2. Configure VS Code Settings

1. Copy the contents of `settings/settings.json` into your VS Code configuration file. Remove duplicate options if necessary.
2. Copy `settings/styles.css` and `settings/script.js` to a directory of your choice. Recommended locations:
   - **Linux/Mac:** `~/.config/not-so-minimal-vscode/`
   - **Windows:** `C:\Users\your-user\.config\not-so-minimal-vscode\`

### 3. Update `settings.json`

Edit the `vscode_custom_css.imports` property in your VS Code settings:

```jsonc
{
  // ... Rest of your settings.json file

  // ... Rest of this repository settings/settings.json file

  "vscode_custom_css.imports": [
      "file:///${userHome}/.config/not-so-minimal-vscode/styles.css",
      "file:///${userHome}/.config/not-so-minimal-vscode/script.js",
      
      // Alternative locations
      "file:///Users/your-user-name/custom-vscode.css",
      "file:///Users/your-user-name/custom-vscode-script.js",
      "file:///C:/path-of-custom-css/custom-vscode.css",
      "file:///C:/path-of-custom-css/custom-vscode-script.js"
  ]
}
```

### 4. Linux and Mac Permissions

If Visual Studio Code cannot modify itself, follow these steps:

#### Common Issues:

- Read-only VS Code files.
- Running VS Code without necessary permissions.

#### Fix:

Run one of the following commands to claim ownership of the installation directory:

```sh
sudo chown -R $(whoami) "$(which code)"
```

```sh
sudo chown -R $(whoami) /usr/share/code
```

> [!TIP]
> Replace `/usr/share/code` with the correct path for your system:
> - **MacOS:** `/Applications/Visual Studio Code.app/Contents/MacOS/Electron`
> - **MacOS (Insiders):** `/Applications/Visual Studio Code - Insiders.app/Contents/MacOS/Electron`
> - **Most Linux distros:** `/usr/share/code`
> - **Arch Linux:** `/usr/lib/code/` or `/opt/visual-studio-code`

### 5. Enable Custom CSS and JS Loader

Open the **Command Palette** (`Ctrl + Shift + P`), enter, and execute:

```
Enable Custom CSS and JS Loader
```

### 6. Customize and Reload

- Modify `styles.css` or `script.js` to fit your preferences.
- Reload the extension after making changes:
  - Open the **Command Palette** (`Ctrl + Shift + P`).
  - Enter and execute:
  
    ```
    Reload Custom CSS and JS
    ```

