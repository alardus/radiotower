function enable() {
    var config = {
        mode: "pac_script",
        pacScript: {
            url: "http://portaller.com/proxy.pac"
        }
    };

    chrome.proxy.settings.set(
        { value: config, scope: "regular"},
        function() {});
}

function disable() {
    var config = {
        mode: "system"
    };

    chrome.proxy.settings.set(
        { value: config, scope: "regular" },
        function() {});

}

function setStatus(mode) {
    var text = mode === "system"
             ? "Radio Tower turned off"
             : "Radio Tower on Air";
    document.getElementById("statusText").textContent = text;
}

function updateStatus() {
    chrome.proxy.settings.get(
        { "incognito": false },
        function(config) {
            setStatus(config.value.mode);
        });
}

chrome.proxy.settings.onChange.addListener(function() {
    updateStatus();
});

document.addEventListener("DOMContentLoaded", function() {
    document.getElementById("enable").addEventListener("click", enable);
    document.getElementById("disable").addEventListener("click", disable);
    updateStatus();
});
