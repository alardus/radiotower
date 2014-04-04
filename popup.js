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

function status() {
  chrome.proxy.settings.get(
            {'incognito': false},
            function(config) {console.log(JSON.stringify(config));});
}

document.addEventListener('DOMContentLoaded', function () {
  document.querySelector('#enable').addEventListener('click', enable);
  document.querySelector('#disable').addEventListener('click', disable);
  document.querySelector('#status').addEventListener('click', status);
  main();
});