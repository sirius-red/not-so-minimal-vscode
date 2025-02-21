document.addEventListener("DOMContentLoaded", function () {
    const checkCommandDialog = setInterval(() => {
        const commandDialog = document.querySelector(".quick-input-widget");
        if (!commandDialog) return console.log("Command dialog not found yet. Retrying...");

        // Apply the blur effect immediately if the command dialog is visible
        if (commandDialog.style.display !== "none") addBlur();

        // Create an DOM observer to 'listen' for changes in element's attribute.
        const observer = new MutationObserver(mutations => {
            mutations.forEach(mutation => {
                if (mutation.type !== "attributes" || mutation.attributeName !== "style") return;

                // If the .quick-input-widget element (command palette) is in the DOM
                // but no inline style display: none, show the backdrop blur.
                if (commandDialog.style.display === "none") removeBlur();
                else addBlur();
            });
        });

        observer.observe(commandDialog, { attributes: true });
        clearInterval(checkCommandDialog);
    }, 500);

    // Execute when command palette was launched.
    document.addEventListener("keydown", function (event) {
        if (((event.metaKey || event.ctrlKey) && event.key === "p") || event.key === "f1") {
            event.preventDefault();
            addBlur();
        } else if (event.key === "Escape" || event.key === "Esc") {
            event.preventDefault();
            removeBlur();
        }
    });

    // Ensure the escape key event listener is at the document level
    document.addEventListener(
        "keydown",
        function (event) {
            if (event.key === "Escape" || event.key === "Esc") removeBlur();
        },
        true
    );

    function addBlur() {
        // Remove existing element if it already exists
        const existingElement = document.getElementById("command-blur");
        if (existingElement) existingElement.remove();

        // Create and configure the new element
        const newElement = document.createElement("div");
        newElement.setAttribute("id", "command-blur");

        // Append the new element as a child of the targetDiv
        const targetDiv = document.querySelector(".monaco-workbench");
        targetDiv.appendChild(newElement);
    }

    // Remove the backdrop blur from the DOM when esc key is pressed.
    function removeBlur() {
        document.getElementById("command-blur")?.remove();
    }
});
