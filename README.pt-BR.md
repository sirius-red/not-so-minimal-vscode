# Not So Minimalist VS Code

> [!NOTE]
> Leia a [documentação do Custom CSS and JS Loader](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css) para dicas sobre como evitar problemas com as alterações não surtindo efeito.

## Instalação e Configuração

### 1. Instalar Extensões Necessárias do VS Code

Pressione `Ctrl + P` (Windows/Linux) ou `Cmd + P` (Mac), digite e execute os seguintes comandos:

| Nome                     | Comando                                              |
|--------------------------|------------------------------------------------------|
| Custom CSS and JS Loader | `ext install be5invis.vscode-custom-css`             |
| Fluent Icons             | `ext install miguelsolorio.fluent-icons`             |
| Catppuccin for VS Code   | `ext install Catppuccin.catppuccin-vsc`              |
| Catppuccin Noctis Icons  | `ext install alexdauenhauer.catppuccin-noctis-icons` |

### 2. Configurar as Definições do VS Code

1. Copie o conteúdo de `settings/settings.json` para o arquivo de configuração do VS Code. Remova opções duplicadas, se necessário.
2. Copie `settings/styles.css` e `settings/script.js` para um diretório de sua escolha. Locais recomendados:
   - **Linux/Mac:** `~/.config/not-so-minimalist-vscode/`
   - **Windows:** `C:\Users\seu-usuario\.config\not-so-minimalist-vscode\`

### 3. Atualizar o `settings.json`

Edite a propriedade `vscode_custom_css.imports` nas configurações do VS Code:

```jsonc
{
  // ... Resto do seu arquivo settings.json

  // ... Resto do settings/settings.json deste repositório

  "vscode_custom_css.imports": [
      "file:///${userHome}/.config/not-so-minimalist-vscode/styles.css",
      "file:///${userHome}/.config/not-so-minimalist-vscode/script.js",
      
      // Locais alternativos
      "file:///Users/seu-usuario/custom-vscode.css",
      "file:///Users/seu-usuario/custom-vscode-script.js",
      "file:///C:/caminho-do-custom-css/custom-vscode.css",
      "file:///C:/caminho-do-custom-css/custom-vscode-script.js"
  ]
}
```

### 4. Permissões no Linux e Mac

Se o Visual Studio Code não puder modificar a si mesmo, siga estas etapas:

#### Problemas Comuns:

- Arquivos do VS Code somente leitura.
- Executando o VS Code sem as permissões necessárias.

#### Solução:

Execute um dos seguintes comandos para reivindicar a propriedade do diretório de instalação:

```sh
sudo chown -R $(whoami) "$(which code)"
```

```sh
sudo chown -R $(whoami) /usr/share/code
```

> [!TIP]
> Substitua `/usr/share/code` pelo caminho correto para seu sistema:
> - **MacOS:** `/Applications/Visual Studio Code.app/Contents/MacOS/Electron`
> - **MacOS (Insiders):** `/Applications/Visual Studio Code - Insiders.app/Contents/MacOS/Electron`
> - **A maioria das distribuições Linux:** `/usr/share/code`
> - **Arch Linux:** `/usr/lib/code/` ou `/opt/visual-studio-code`

### 5. Ativar Custom CSS and JS Loader

Abra a **Paleta de Comandos** (`Ctrl + Shift + P`), digite e execute:

```
Enable Custom CSS and JS Loader
```

### 6. Personalizar e Recarregar

- Modifique `styles.css` ou `script.js` conforme suas preferências.
- Recarregue a extensão após fazer alterações:
  - Abra a **Paleta de Comandos** (`Ctrl + Shift + P`).
  - Digite e execute:
  
    ```
    Reload Custom CSS and JS
    ```

