//site information : [regex-url, embed player]
//--add more sites as you want here
var site = {
    "https?:\/\/(www\.)?youtube\.com\/.*" : "#movie_player"
};

//youtube player state
var player_state = {
    unstarted : -1,
    ended : 0,
    playing : 1,
    paused : 2,
    buffer : 3,
    video_cued : 5
};

//add string.format to string prototype
if (!String.prototype.format) {
    String.prototype.format = function() {
        var args = arguments;
        return this.replace(/{(\d+)}/g, function(match, number) { 
            return typeof args[number] != 'undefined'
            ? args[number]
            : match
            ;
        });
    };
}

//limit plugin to specific sites
var urls = [];
for (var url in site)
    urls.push(url);
    urls = urls.join('|');    

    var cmd  = "nmap -urls={0} {1} :{2}";
    liberator.execute(cmd.format(urls, "p", "ytplay<CR>"));
    liberator.execute(cmd.format(urls, "mu", "ytmute<CR>"));
    liberator.execute(cmd.format(urls, "s", "ytseek "));
    liberator.execute(cmd.format(urls, "h", "ytseek -"));
    liberator.execute(cmd.format(urls, "l", "ytseek +"));

    //add commands to vimperator
    commands.add(["ytplay"], "Play/pause video", togglePlay,  { argCount : '0' });
    commands.add(["ytmute"], "Mute/unmute video", toggleMute, { argsCount : '0' });
    commands.add(["ytseek"], "Seek video to a specific time", seek, { argCount : '1' });
    commands.add(["ytrepeat"], "Repeat video", repeatVideo);
    commands.add(["ytstopp"], "Stop repeating video", stopRepeatingVideo, { argsCount : '0' });
    commands.add(["ytsetq"], "Set video quality", setQuality);

    /* Object Container, includes : player, repeating system and other systems */
    function Container(player) {
        var self = this;
        this.player = player;
        this.timer_id = undefined;
        this.repeat_count = undefined;
        this.repeatVideo = function() {
            if (self.player.getCurrentTime() == self.player.getDuration())
                if (self.repeat_count == undefined) 
                    self.player.playVideo();                
                else {            
                    self.repeat_count--;
                    if (self.repeat_count > 0)
                        self.player.playVideo();
                    else {
                        clearInterval(self.timer_id);
                        self.timer_id = undefined;                                        
                    }
                }
        };
    }

/* Return handle to container */
function getContainer() {
    //create new container            
    if (!content.document.ytContainer)
        for (var url in site) {
            var regex = new RegExp(url, "i");
            if (content.document.URL.search(regex) > -1) {
                var embed_player = content.document.querySelector(site[url]).wrappedJSObject;
                content.document.ytContainer = new Container(embed_player);
                break;
            } 
        }        
    return content.document.ytContainer;
}

/* Return handle to player */
function getPlayer() {
    return getContainer().player;
}

/* Play or pause */
function togglePlay() {
    var player = getPlayer();
    if (player.getPlayerState() == player_state.playing)
        player.pauseVideo();
    else
        player.playVideo();
}

/* Mute or unmute */
function toggleMute() {
    var player = getPlayer();
    if (player.isMuted())
        player.unMute();
    else
        player.mute();
}

/* Change playback quality */
function setQuality(quality) {
    if (quality.length == 0) quality = "medium";
    var player = getPlayer();
    var availableQualities = player.getAvailableQualityLevels();
    if (availableQualities.indexOf(quality) == -1) {
        player.setPlaybackQuality(availableQualities[0]);
        liberator.echomsg("Highest available quality : " + availableQualities[0]);
    }
    else {
        player.setPlaybackQuality(quality);
        liberator.echomsg("Changed quality to " + quality);
    }
}

/*  Convert "hh:mm:ss", "mm:ss" to number of seconds */
function format(time) {   
    if (time.indexOf(':') == -1)
        return parseInt(time);            
    var arr = time.split(":");
    var total = 0;
    for (var i=0; i < arr.length; i++)
        total = total * 60 + parseInt(arr[i]);
    return total;
}

/*  Seek video to a specific time
    Syntax: seek [t]
    Player will seek video to t-th second. If  '+' or '-' preceeds t, player will forward or backward t seconds.
    Alternatively, t can be inputted as "hh:mm:ss" or "mm:ss"
    */
function seek(args) {
    var player = getPlayer(); 
    var time = args[0];       
    if (time[0] == '+') 
        player.seekTo(player.getCurrentTime() + format(time.slice(1)), true);
    else if (time[0] == '-') 
        player.seekTo(player.getCurrentTime() - format(time.slice(1)), true);
    else
        player.seekTo(format(time), true);    
}

/*  Repeat playing video
    Syntax: repeatVideo [n]
    Player will repeat the video n times.
    If n is unspecifed, player will repeat video until tab is closed or stopRepeatVideo() is called.  
    */
function repeatVideo(args) {
    var container = getContainer(); 
    //reset timer_count
    if (args.length == 0)
        container.repeat_count = undefined;
    else
        container.repeat_count = parseInt(args[0]);    

    if (!container.timer_id) {
        container.timer_id = setInterval(container.repeatVideo, 2000);
        content.window.onunload = function() { clearInterval(container.timer_id) };
    }
}

/* Stop repeating video */
function stopRepeatingVideo() {
    var container = getContainer();
    if (container.timer_id) {
        clearInterval(container.timer_id); 
        container.timer_id = undefined;
    }
}
