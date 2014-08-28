function FindProxyForURL(url, host){
  var country = 'RU';
  var myip = myIpAddress();
  var ipbits = myip.split('.');
  var myseg = parseInt(ipbits[3]);
  var p = [3223469900, 3223469902, 3226589467, 628805681, 3231406921, 3334957773, 1806365296, 1790653165, 1481686931, 3039417072, 3039418672, 3039418673, 3039418796, 2991561975, 2991554669];
  for(var i in p){
    n = p[i];
    var d = n%256;
    for(var j = 3; j > 0; j--){
      n = Math.floor(n/256);
      d = n%256 + '.' + d;
    }
    p[i] = d;
  }
  var proxy_configs = [
    'PROXY '+p[0]+':80; PROXY '+p[1]+':80; DIRECT',
    'PROXY '+p[1]+':80; PROXY '+p[0]+':80; DIRECT'
  ];
  var netflix_proxy_configs = [
    'PROXY '+p[6]+':80; PROXY '+p[5]+':80; DIRECT',
    'PROXY '+p[5]+':80; PROXY '+p[6]+':80; DIRECT'
  ];
  var uk_configs = [
    'PROXY '+p[3]+':80; PROXY '+p[8]+':80; PROXY '+p[13]+':80; PROXY '+p[14]+':80; DIRECT',
    'PROXY '+p[8]+':80; PROXY '+p[13]+':80; PROXY '+p[14]+':80; PROXY '+p[8]+':80; DIRECT',
    'PROXY '+p[13]+':80; PROXY '+p[14]+':80; PROXY '+p[3]+':80; PROXY '+p[8]+':80; DIRECT',
    'PROXY '+p[14]+':80; PROXY '+p[3]+':80; PROXY '+p[8]+':80; PROXY '+p[13]+':80; DIRECT',
  ];
  var br_configs = [
    'PROXY '+p[9]+':80; PROXY '+p[10]+':80; PROXY '+p[11]+':80; PROXY '+p[12]+':80; DIRECT',
    'PROXY '+p[12]+':80; PROXY '+p[9]+':80; PROXY '+p[10]+':80; PROXY '+p[11]+':80; DIRECT',
    'PROXY '+p[11]+':80; PROXY '+p[12]+':80; PROXY '+p[9]+':80; PROXY '+p[10]+':80; DIRECT',
    'PROXY '+p[10]+':80; PROXY '+p[11]+':80; PROXY '+p[12]+':80; PROXY '+p[9]+':80; DIRECT'
  ];
  var netflix_proxies = netflix_proxy_configs[myseg % 2];
  var proxies = proxy_configs[myseg % 2];
  if(country === 'US'){
    proxies = 'DIRECT';
  }
  if((/atv-(ps|ext)\.amazon\.com/).test(host) && country !== "US"){
    return proxies;
  }
  if(country !== 'GB'){
    var ukproxies = uk_configs[myseg % 4];
    if(
      ((/bbc\.co\.uk\/iplayer\/tv/).test(url)&&(/watchlive/).test(url))
      ||(/^(www|news)\.bbc\.co\.uk$/).test(host)
      ||((/playlists\.bbc\.co\.uk/).test(host)&&(/\.sxml/).test(url))
      ||(/bbc\.co\.uk\/iplayer/).test(url)
      ||(/open\.live\.bbc\.co\.uk/).test(host)
      ||(/bbc\.co\.uk\.edgesuite\.net\/crossdomain\.xml/).test(url)
      ||(/bbcfmhds\.vo\.llnwd\.net\/crossdomain\.xml/).test(url)
      ||(/bbc\.co\.uk\.edgesuite\.net\/hds-live\/livepkgr/).test(url)
      ||(/bbc\.co\.uk\.edgesuite\.net\/hds-live\/streams\/livepkgr/).test(url)
      ||(/bbcfmhds\.vo\.llnwd\.net\/hds-live\/streams\/livepkgr\/streams/).test(url)
      ||((/bbcfmhds\.vo\.llnwd\.net\/hds-live\/livepkgr/).test(url) && (/f4m/).test(url))
      ||(/bbc\.co\.uk\/mediaselector/).test(url)
      ||(/ais\.channel4\.com/).test(host)
      ||(/bbc\.co\.uk\/mobile\/apps\/iplayer/).test(url)
      ||(/itv\.com\/ukonly/).test(url)
      ||(/^(ned|ted|mercury|tom)\.itv\.com$/).test(host)
      ||(/bbci\.co\.uk/).test(host)
      ||(/live\.bbc\.co\.uk/).test(host)
      ||(/bbcmedia\.fcod\.llnwd\.net/).test(host)
      ||(/\/idle\/[a-zA-Z0-9\-_]{16}\//).test(url)
      ||(/\/send\/[a-zA-Z0-9\-_]{16}\//).test(url)
      ||(/londonlive\.co\.uk$/).test(host)
      ||(/ssl\.bbc\.co\.uk$/).test(host)
    ){
      return ukproxies;
    }
  }
  if((host == 'localhost')||(shExpMatch(host, 'localhost.*'))||(shExpMatch(host, '*.local'))||(host == '127.0.0.1')){
    return 'DIRECT';
  }
  if(host == 'ihost.netflix.com'){
    return 'DIRECT';
  }
  if(isPlainHostName(host) ||
    shExpMatch(host, '*.local') ||
    isInNet(dnsResolve(host), '10.0.0.0', '255.0.0.0') ||
    isInNet(dnsResolve(host), '172.16.0.0',  '255.240.0.0') ||
    isInNet(dnsResolve(host), '192.168.0.0',  '255.255.0.0') ||
    isInNet(dnsResolve(host), '127.0.0.0', '255.255.255.0')){
    return 'DIRECT';
  }
  if(shExpMatch(host, '/^\d+\.\d+\.\d+\.\d+$/g')){
    if(isInNet(host, '10.0.0.0', '255.0.0.0')||isInNet(host, '192.168.0.0', '255.255.0.0')) {
      return 'DIRECT';
    }
  }
  if((/(^link\.theplatform\.com$)|(^urs\.pbs\.org$)/).test(host)){
    return 'PROXY '+p[2]+':80';
  }
  if((/(^videocgi\.drt\.cbsig\.net$)|(^media\.cwtv\.com$)/).test(host)){
    return proxies;
  }
  if((/^www\.slacker\.com$/).test(host)&&(/\/(xslte\/userContent)|(wsv1\/session)/).test(url)){
    return proxies;
  }
  if((/^video\.nbcuni\.com$/).test(host)&&(/geo\.xml/).test(url)){
    return proxies;
  }
  if((/songza\.com\/config\.js|geofilter|\/video\/geolocation|geoCountry\.xml|geo-check|\.ism\/manifest|\/services\/viewer\/(htmlFederated|federated_f9)|\/services\/messagebroker\/amf/).test(url)){
    return proxies;
  }
  if((/^api\.abc\.com$|^w88\.go\.com$/).test(host)){
    return proxies;
  }
  if((/^(www\.)?thewb\.com$/).test(host)){
    return proxies;
  }
  if((/^(www\.|ext\.)?last\.fm$/).test(host)){
    return 'PROXY '+p[2]+':80';
  }
  if(country !== 'GB' && ((/^media\.mtvnservices\.com$/).test(host) || (/^intl\.esperanto\.mtvi\.com$/).test(host)) && (/nick\.co\.uk/).test(url) && (/\.swf/).test(url) === false){
    return ukproxies;
  }
  if(
    (/^media\.mtvnservices\.com$/).test(host)
    ||(/www\.spike\.com\/feeds\/mediagen/).test(url)
    ||(/\/widgets\/geo\/geoload\.jhtml/).test(url)
    ||(/\/includes\/geo\.jhtml/).test(url)
    ||(/activity\.flux\.com\/geo\.html/).test(url)
    ||(/\/mediaGen\.jhtml/).test(url)
    ||(/geocheck\.turner\.tv\.edgesuite\.net/).test(host)
  ){
    return proxies;
  }
  if((/^music\.twitter\.com$/).test(host) && ['AU','GB','US','CA','NZ','IE'].indexOf(country) === -1){
    return proxies;
  }
  if((/^video\.query\.yahoo\.com$/).test(host) && (/yahoo\.media\.video\.streams/).test(url)){
    return proxies;
  }
  if((/netflix\.com\/FilePackageGetter/i).test(url)){
    return netflix_proxies;
  }
  if((/songza\.com\/(api|advertising)\/|hulu\.com\/mozart\/.*|\.(ico|jpg|png|gif|mp3|css|mp4|flv|swf|json)(\?.*)?$|^crackle\.com\/flash\/$/).test(url)||(/(^presentationtracking|blog|signup)\.netflix\.com$|^(r|p|t2|ll\.a|t|t-l3|ads|assets|urlcheck)\.hulu\.com$|^(stats|blog|audio.*|const.*|mediaserver.*|cont.*)\.pandora\.com$/).test(host)){
    return 'DIRECT';
  }
  if(country !== "BR"){
    var brproxies = br_configs[myseg % 4];
    if((/security\.video\.globo\.com$/).test(host)){
      return brproxies;
    }
  }
  if(((/epixhd\.com/).test(host) || (/epixhds\-f\.akamaihd\.net/).test(host)) && country !== "US"){
    return proxies;
  }
  if((/vevo\.com/).test(host)){
    return proxies;
  }
  if((/nextissue\.com/).test(host)){
    return proxies;
  }
  if((/account\.beatsmusic\.com$/).test(host) && country !== "US"){
    return proxies;
  }
  if((/^([\w\.-]+\.)?hulu\.com$/).test(host)){
    return netflix_proxies;
  }
  if((/^southpark\.cc\.com$/).test(host) && country !== "US"){
    return netflix_proxies;
  }
  if((/^([\w\.-]+\.)?hulu\.jp$/).test(host) && country !== "JP"){
    return 'PROXY '+ p[7] + ':80; DIRECT;';
  }
  if((/(^([\w\.-]+\.)?(songza|www\.iheart|www\.crackle|ulive|funimation)\.com$)/).test(host)){
    return proxies;
  }
  if((/netflix\.com\/(login|signout|logout|signin)/i).test(url) && ['US','GB','CA'].indexOf(country) >= 0){
    return 'DIRECT';
  }
  if((/(^([\w\.-]+\.)?netflix|pandora\.com$)/).test(host)){
    return netflix_proxies;
  }
  if(['AD','AU','AT','BE','DK','FO','FI','FR','DE','IE','IT','LI','LU','LV','MX','MC','NL','NZ','NO','PL','PT','ES','SE','CH','GB','US','HK','EE','LT','MY','SG','IS'].indexOf(country) === -1){
    if((/^([\w\.-]+\.)?spotify\.com/).test(host)){
      return 'PROXY '+p[2]+':80';
    }
  }

  return 'DIRECT';
}