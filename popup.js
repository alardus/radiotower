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
        mode: "pac_script",
        pacScript: {
          data: "function FindProxyForURL(url, host) {\n" +
                "  return 'DIRECT';\n" +
                "}"
        }
      };
      chrome.proxy.settings.set(
          {value: config, scope: 'regular'},
          function() {});
      
}


function main() {

}


document.addEventListener('DOMContentLoaded', function () {
  document.querySelector('#enable').addEventListener('click', enable);
  document.querySelector('#disable').addEventListener('click', disable);
  main();
});