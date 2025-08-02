#!/usr/bin/env bash

# Stop script on any error
set -e

# --- Configuration ---
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUSTOM_DIR_NAME='not-so-minimal-vscode'
HTML_INJECT="<!-- NSMVSC --><link rel=\"stylesheet\" href=\"$CUSTOM_DIR_NAME/styles.css\" /><script src=\"$CUSTOM_DIR_NAME/script.js\"></script><!-- NSMVSC -->"

#
# Finds the VS Code workbench directory on Linux or macOS.
#
search_workbench_dir() {
    # Define an array of possible VS Code installation paths
    local possible_paths=(
        # macOS
        "/Applications/Visual Studio Code.app/Contents/Resources/app/out/vs/code/electron-browser/workbench"
        # Linux (system-wide package)
        "/usr/share/code/resources/app/out/vs/code/electron-browser/workbench"
        # Linux (user install/tarball)
        "$HOME/.vscode-server/bin"
        "/opt/visual-studio-code/resources/app/out/vs/code/electron-browser/workbench"
    )

    for path in "${possible_paths[@]}"; do
        if [[ -d "$path" ]]; then
            echo "$path"
            return 0
        fi
    done

    echo "ERROR: Could not find VS Code's installation directory automatically." >&2
    while true; do
        read -pr "Please enter the full path to VS Code's workbench directory and press Enter (or leave blank to cancel): " user_input
        if [[ -z "$user_input" ]]; then
            echo "Installation cancelled by user." >&2
            exit 1
        fi
        if [[ -d "$user_input" ]]; then
            echo "$user_input"
            return 0
        else
            echo "The provided path '$user_input' is not a valid directory. Please try again." >&2
        fi
    done

    return 1
}

#
# Copies the customization files.
#
copy_files() {
    local workbench_dir="$1"
    local target_dir="$workbench_dir/$CUSTOM_DIR_NAME"

    echo "Copying files to $target_dir..."

    if [[ -d "$target_dir" ]]; then
        echo "Removing existing configuration..."
        rm -rf "$target_dir"
    fi

    mkdir -p "$target_dir"

    cp "$SOURCE_DIR/styles.css" "$target_dir/styles.css"
    cp "$SOURCE_DIR/../script.js" "$target_dir/script.js"

    echo "Files copied successfully."
}

#
# Patches the workbench.html file to include the styles and scripts.
#
update_workbench_html() {
    local workbench_dir="$1"
    local workbench_html_path="$workbench_dir/workbench.html"

    echo "Patching $workbench_html_path..."

    if grep -q "NSMVSC" "$workbench_html_path"; then
        echo "WARNING: workbench.html already seems to be patched. Skipping." >&2
        return
    fi

    # Backup the original file
    local backup_path="${workbench_html_path}.bak"
    cp "$workbench_html_path" "$backup_path"
    echo "Backup created at: $backup_path"

    # Read, modify, and write the content back
    # Using a temporary file for sed compatibility on both Linux and macOS
    local temp_file
    temp_file=$(mktemp)
    sed "s|</html>|$HTML_INJECT\n</html>|" "$workbench_html_path" > "$temp_file"
    cat "$temp_file" > "$workbench_html_path"
    rm "$temp_file"

    echo "workbench.html patched successfully."
}

#
# Install the not So Minimal VSCode
#
invoke_install() {
    local workbench_dir="$1"

    echo -e "\033[0;32mStarting not-so-minimal-vscode installation...\033[0m"
    echo "VS Code directory found at: $workbench_dir"

    copy_files "$workbench_dir"
    update_workbench_html "$workbench_dir"

    echo ""
    echo -e "\033[0;32mInstallation complete!\033[0m"
    echo "Please restart VS Code for the changes to take effect."
    echo ""
    echo -e "\033[0;33mIMPORTANT: VS Code updates will overwrite these changes. If this happens, please run this script again.\033[0m"
}

#
# Uninstall the not So Minimal VSCode
#
invoke_uninstall() {
    local workbench_dir="$1"
    local workbench_file="$workbench_dir/workbench.html"
    local workbench_file_backup="${workbench_file}.bak"

    echo "Uninstalling Not So Minimal VSCode..."
    echo "VS Code directory found at: $workbench_dir"

    if [[ -f "$workbench_file_backup" ]]; then
        mv "$workbench_file_backup" "$workbench_file"
        echo "Restored workbench.html from backup."
    else
        echo "WARNING: No backup file found. You may need to reinstall VS Code to restore workbench.html." >&2
    fi

    if [[ -d "$workbench_dir/$CUSTOM_DIR_NAME" ]]; then
        rm -rf "${workbench_dir:?}/$CUSTOM_DIR_NAME"
        echo "Removed customization directory."
    fi

    echo ""
    echo -e "\033[0;32mUninstallation complete!\033[0m"
    echo "Please restart VS Code for the changes to take effect."
}

#
# Main script execution block
#
main() {
    local is_uninstall_cmd=false
    if [[ "$1" == "-u" || "$1" == "--uninstall" || "$1" == "r" || "$1" == "--remove" ]]; then
        is_uninstall_cmd=true
    fi

    # Check for root privileges
    if [[ "$(id -u)" -ne 0 ]]; then
        echo "ERROR: This script must be run with root privileges (e.g., using sudo)." >&2
        exit 1
    fi

    local workbench_dir
    workbench_dir=$(search_workbench_dir || exit 1)

    if [ "$is_uninstall_cmd" = true ]; then
        invoke_uninstall "$workbench_dir"
    else
        invoke_install "$workbench_dir"
    fi
}

# Run the main function with all script arguments
main "$@"
