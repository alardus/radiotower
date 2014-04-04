function enable() {
      var config = {
        mode: "pac_script",
        pacScript: {
          url: "http://portaller.com/proxy.pac"
        }
      };
      chrome.proxy.settings.set(
          {value: config, scope: 'regular'},
          function() {});
}
      

function disable() {
      var config = {
        mode: "system"
      };
      chrome.proxy.settings.set(
          {value: config, scope: 'regular'},
          function() {});
      
}


function main() {

}

function textToSpan(text) {
    var span = document.getElementById('statusText');
    if (!span) {
        span = document.createElement('span');
        span.setAttribute('id', 'statusText');
        document.body.appendChild(span);
    }
    span.textContent = text;

    // Если span сразу будет в вёрстке, то код создания можно убрать и писать так,
    // можно даже в функции status, если немного и удобнее.
    // document.getElementById('statusText').textContent = text;
}

function status() {
  chrome.proxy.settings.get(
            {'incognito': false},
            function(config) {
                var mode = config.value.mode;
                var text = (mode === "system")
                         ? "system!"
                         : "not system";
                textToSpan(text);
            });
}

document.addEventListener('DOMContentLoaded', function () {
  document.querySelector('#enable').addEventListener('click', enable);
  document.querySelector('#disable').addEventListener('click', disable);
  document.querySelector('#status').addEventListener('click', status);
  main();
});
