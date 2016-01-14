/* 
FLV Playback Control class
Written by Adrian Bota, adrian@oxylus.ro
Copyright (c) 2008 OXYLUS Development
----------------------------------------
[v1.0] 
23.02.2008 - playback support for local flv files and via http
*/
class oxylus.flv.FLVPlayback {
	private var nc:NetConnection;
	private var vo:Video;
	private var so:Sound;
	private var smc:MovieClip;
	private var ns:NetStream;
	//
	private var _master:Object;
	//
	private var _autoPlay:Boolean;
	private var _autoRewind:Boolean;
	private var _buffering:Boolean;
	private var _bufferTime:Number;
	private var _bytesLoaded:Number;
	private var _bytesTotal:Number;
	private var _fileURL:String;
	private var _vidHeight:Number;
	private var _vidWidth:Number;
	private var _metadata:Object;
	private var _paused:Boolean;
	private var _playheadTime:Number;
	private var _playing:Boolean;
	private var _stopped:Boolean;
	private var _totalTime:Number;
	private var _volume:Number;
	//
	private var fullLoad:Boolean;
	private var IDLoad:Number;
	private var IDPhead:Number;
	//
	private var _eFlush:Boolean;
	private var _eStop:Boolean;
	private var _cInt:Number;
	private var _wait:Number;
	// EVENTS
	// buffering event receives true if is buffering, false otherwise
	public var onFLVBuffering:Function;
	// triggered when flv playback reaches the end
	public var onFLVComplete:Function;
	// called everytime the playhead is changed; receives current time and total time
	public var onFLVPlayheadUpdate:Function;
	// called on download; receives bytes loaded and bytes total
	public var onFLVDownload:Function;
	// called when flv is ready for playback after a load action
	public var onFLVReady:Function;
	// called once after a load actions; receives the metadata object
	public var onFLVInfo:Function;
	// called eveytime a state change occurs; receives strings like: "load", "pause", "play", "stop"
	public var onFLVState:Function;
	// called when the streaming file is not found; receives file url
	public var onFLVError:Function;
	//-------------------------------------------------------------------------------------------------
	// Constructor: ms - Master object that will be the equivalent for thisObject in the handler functions for the events (null for default)
	//				vid - Video object instance name
	//				mc - MovieClip for the Sound object instance
	public function FLVPlayback(ms:Object, vid:Video, mc:MovieClip) {
		_master = ms == null ? this : ms;
		nc = new NetConnection();
		vo = vid;
		vo._alpha = 0;
		smc = mc;
		so = new Sound(smc);
		this.init();
	}
	// METHODS
	// load flv file from http or local hard drive
	public function load(url:String) {
		onFLVState.call(_master, "load");
		_fileURL = url;
		nc.connect(null);
		ns.close();
		delete ns;
		ns = new NetStream(nc);
		var ref = this;
		ns.onMetaData = function(inf) {
			with (ref) {
				onMeta(inf);
			}
			delete this.onMetaData;
		};
		ns.onStatus = function(inf) {
			with (ref) {
				onStat(inf);
			}
		};
		ns.play(_fileURL);
		_buffering = true;
		onFLVBuffering.call(_master, true);
		if (!_autoPlay) {
			ns.pause();
			ns.seek(0);
		} else {
			onFLVState.call(_master, "play");
		}
		vo.attachVideo(ns);
		smc.attachAudio(ns);
		so.setVolume(_volume);
		this.reset();
		_buffering = true;
		onFLVBuffering.call(_master, true);
	}
	// pause playback
	public function pause() {
		if (!_paused) {
			ns.pause();
			_paused = true;
			_playing = false;
			onFLVState.call(_master, "pause");
		}
	}
	// start/resume playback
	public function play() {
		if (!_playing) {
			ns.pause();
			_paused = _stopped=false;
			_playing = true;
			onFLVState.call(_master, "play");
		}
	}
	// seek to a percent
	public function seekPercent(p:Number) {
		this.seek(_totalTime*p);
	}
	// seek to a number of seconds
	public function seek(t:Number) {
		this.pause();
		//trace("SEEK: "+t);
		ns.seek(t);
		onFLVState.call(_master, "seek");
	}
	// stop playback
	public function stop() {
		_stopped = false;
		this.pause();
		ns.seek(0);
		onFLVState.call(_master, "stop");
	}
	// close flv file
	public function close() {
		ns.close();
		this.reset();
		onFLVState.call(_master, "close");
	}
	// PROPERTIES
	// master object
	public function set master(o) {
		_master = o == null ? this : o;
	}
	public function get master() {
		return _master;
	}
	// autoPlay = true|false
	// set if the flv will start playing after a load command
	public function set autoPlay(b:Boolean) {
		_autoPlay = b;
	}
	public function get autoPlay():Boolean {
		return _autoPlay;
	}
	// autoRewind = true|false
	// set if the flv will start playing again after playback has complete
	public function set autoRewind(b:Boolean) {
		_autoRewind = b;
	}
	public function get autoRewind():Boolean {
		return _autoRewind;
	}
	// see if the flv is buffering
	public function get buffering():Boolean {
		return _buffering;
	}
	// set buffer time; default is 0.1s
	public function set bufferTime(b:Number) {
		ns.setBufferTime(b);
		_bufferTime = b;
	}
	public function get bufferTime():Number {
		return _bufferTime;
	}
	// get bytes loaded and bytes total
	public function get bytesLoaded():Number {
		return _bytesLoaded;
	}
	public function get bytesTotal():Number {
		return _bytesTotal;
	}
	// flv URL; setting this variable will trigger a load command
	public function set fileURL(url:String) {
		load(url);
	}
	public function get fileURL():String {
		return _fileURL;
	}
	// returns video original height
	public function get vidHeight():Number {
		return _vidHeight;
	}
	// returns video original width
	public function get vidWidth():Number {
		return _vidWidth;
	}
	// returns metadata object
	public function get metadata():Object {
		return _metadata;
	}
	// returns true if teh flv playback is paused
	public function get paused():Boolean {
		return _paused;
	}
	// playhead position in percents; it will trigger a seek action
	public function set playeadPercent(np:Number) {
		this.seekPercent(np);
	}
	public function get playheadPercent():Number {
		return _playheadTime/_totalTime;
	}
	// playhead time in seconds; triggers a seek action
	public function set playeadTime(nt:Number) {
		this.seek(nt);
	}
	public function get playheadTime():Number {
		return _playheadTime;
	}
	// returns true if teh flv playback is playing
	public function get playing():Boolean {
		return _playing;
	}
	// returns true if teh flv playback is stopped
	public function get stopped():Boolean {
		return _stopped;
	}
	// returns total playback time
	public function get totalTime():Number {
		return _totalTime;
	}
	// volume 
	public function set volume(nv:Number) {
		_volume = nv;
		so.setVolume(_volume);
	}
	public function get volume():Number {
		return _volume;
	}
	// mute 
	public function set mute(_b:Boolean) {
		if (_b) {
			so.setVolume(0);
		} else {
			so.setVolume(_volume);
		}
	}
	public function get mute():Boolean {
		return so.getVolume() == 0;
	}
	// Additional private functions
	private function timeDif(n:Number):Boolean {
		return Math.abs(_playheadTime-_totalTime)<n;
	}
	private function init() {
		_autoPlay = true;
		_autoRewind = true;
		_buffering = false;
		_bufferTime = 0.1;
		_bytesLoaded = 0;
		_bytesTotal = 0.1;
		_fileURL = "";
		_vidHeight = -1;
		_vidWidth = -1;
		_paused = true;
		_playheadTime = -1;
		_playing = false;
		_stopped = true;
		_totalTime = 0.1;
		_volume = 50;
		fullLoad = false;
		so.setVolume(_volume);
		_eFlush = false;
		_eStop = false;
		_cInt = 50;
		_wait = 0;
		onFLVDownload.call(_master, _bytesLoaded, _bytesTotal);
	}
	private function reset() {
		vo._alpha = 0;
		_buffering = false;
		_bufferTime = 0.1;
		_bytesLoaded = 0;
		_bytesTotal = 0.1;
		_vidHeight = -1;
		_vidWidth = -1;
		_paused = !_autoPlay;
		_playheadTime = -1;
		_playing = _autoPlay;
		_stopped = !_autoPlay;
		_totalTime = 0.1;
		fullLoad = false;
		_cInt = 50;
		_wait = 0;
		_metadata = undefined;
		_eFlush = false;
		_eStop = false;
		clearInterval(IDLoad);
		clearInterval(IDPhead);
		onFLVDownload.call(_master, _bytesLoaded, _bytesTotal);
	}
	//
	private function onMeta(o:Object) {
		_metadata = o;
		o.videocodecid != undefined ? vo.deblocking=o.videocodecid : vo.deblocking=0;
		o.width != undefined ? _vidWidth=o.width : null;
		o.height != undefined ? _vidHeight=o.height : null;
		_totalTime = o.duration != undefined ? o.duration : 0.1;
		if (o.framerate != undefined) {
			_cInt = 1000/o.framerate;
		}
		IDPhead = setInterval(checkPhead, _cInt, this);
		IDLoad = setInterval(checkDload, _cInt, this);
		if (_vidWidth>0 && _vidHeight>0) {
			vo._alpha = 100;
			onFLVInfo.call(_master, _vidWidth, _vidHeight);
		}
	}
	private function onStat(o:Object) {
		switch (o.code) {
		case "NetStream.Play.Start" :
			onFLVReady.call(_master);
			onFLVPlayheadUpdate.call(_master, 0, _totalTime);
			break;
		case "NetStream.Buffer.Flush" :
			if (this.timeDif(1)) {
				_eFlush = true;
			}
			break;
		case "NetStream.Play.Stop" :
			if (this.timeDif(1)) {
				_eStop = true;
			}
			break;
		case "NetStream.Seek.InvalidTime" :
			ns.seek(Number(o.details));
			break;
		case "NetStream.Play.StreamNotFound" :
			onFLVError.call(_master, _fileURL);
			break;
		}
	}
	private function checkDload(ref) {
		with (ref) {
			if (ns.bytesLoaded == "NaN") {
				return;
			}
			if (_bytesLoaded != ns.bytesLoaded) {
				_bytesLoaded = ns.bytesLoaded;
				if (_bytesTotal != ns.bytesTotal) {
					_bytesTotal = ns.bytesTotal;
				}
				onFLVDownload.call(_master, _bytesLoaded, _bytesTotal);
				if (_bytesLoaded == _bytesTotal) {
					fullLoad = true;
					clearInterval(IDLoad);
				}
			}
		}
	}
	private function checkPhead(ref) {
		with (ref) {
			if (_playheadTime != Math.round(ns.time)) {
				_playheadTime = Math.round(ns.time);
				if (_totalTime<_playheadTime) {
					_totalTime = _playheadTime;
				}
				onFLVPlayheadUpdate.call(_master, _playheadTime, _totalTime);
			}
			if (timeDif(0.5)) {
				if (_eFlush && _eStop && _playing) {
					_wait = 0;
					_eFlush = _eStop=false;
					onFLVComplete.call(_master);
					onFLVPlayheadUpdate.call(_master, _totalTime, _totalTime);
					stop();
					if (_autoRewind) {						
						play();
					}
				} else {
					_wait++;
					if (_wait*_cInt>1000) {
						_wait = 0;
						_eFlush = true;
						_eStop = true;
					}
				}
			}
			if (ns.bufferLength<ns.bufferTime && !fullLoad) {
				if (!_buffering) {
					_buffering = true;
					onFLVBuffering.call(_master, true);
				}
			} else {
				if (_buffering) {
					_buffering = false;
					onFLVBuffering.call(_master, false);
				}
			}
			if (_vidWidth<=0 || _vidHeight<=0) {
				if (vo.width>0 && vo.height>0) {
					_vidWidth = vo.width;
					_vidHeight = vo.height;
					vo._alpha = 100;
					onFLVInfo.call(_master, _vidWidth, _vidHeight);
				}
			}
		}
	}
}
