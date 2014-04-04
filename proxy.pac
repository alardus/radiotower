function FindProxyForURL(url, host) {
    if (host=='pandora.com' || host=='www.pandora.com' || host=='tuner.pandora.com' || host=='mediaserver-sv5-rt-1.pandora.com' || host=='spotify.com' || host=='www.spotify.com' ){
        return 'PROXY 107.170.15.247; DIRECT';
    }
    // All other domains should connect directly without a proxy
    return "DIRECT";
}