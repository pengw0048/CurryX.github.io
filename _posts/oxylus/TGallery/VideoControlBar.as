import caurina.transitions.Tweener;
import oxylus.flv.FLVPlayback;
import oxylus.TGallery.Utils;
class oxylus.TGallery.VideoControlBar extends MovieClip {
	private var w:Number;
	private var h:Number;
	private var _h:Number;
	private var ch:Number;
	private var hs:Number;
	private var volw:Number;
	private var ts:Number;
	//
	private var cbarOb:MovieClip;
	private var ppBtn:Object;
	private var repBtn:Object;
	private var mutIcn:Object;
	private var volBar:Object;
	private var prgBar:Object;
	private var timeOb:Object;
	private var FLVCtrl:Object;
	private var preloader:Object;
	private var prevPlay:Boolean;
	private var Mask:MovieClip;
	private static var thisObject:Object;
	public function VideoControlBar() {
		thisObject = this;
		this.initVars();
		this.createObjects();
		this.initObjects();
		this.resize();
	}
	private function initVars() {
		// control bar height
		ch = 30;
		// horizontal space
		hs = 5;
		// volume bar width
		volw = 60;
		// top space
		ts = 3;
		//
		w = 500;
		h = _h=30;
		this._xscale = 100;
		this._yscale = 100;
	}
	public function set control(nc) {
		FLVCtrl = nc;
		FLVCtrl.onFLVComplete = FLVCtrl_OnFLVComplete;
		FLVCtrl.onFLVPlayheadUpdate = FLVCtrl_OnFLVPlayheadUpdate;
		FLVCtrl.onFLVDownload = FLVCtrl_OnFLVDownload;
		FLVCtrl.onFLVState = FLVCtrl_OnFLVState;
		FLVCtrl.onFLVError = FLVCtrl_OnFLVError;
		volBar.progPercent = FLVCtrl.volume/100;
	}
	public function get control() {
		return FLVCtrl;
	}
	private function createObjects() {
		cbarOb = this.attachMovie("IDControlBarBg", "_b_", this.getNextHighestDepth());
		ppBtn = this.attachMovie("IDPlayPauseBtn", "_c_", this.getNextHighestDepth());
		repBtn = this.attachMovie("IDReplayBtn", "_d_", this.getNextHighestDepth());
		mutIcn = this.attachMovie("IDMuteIcon", "_e_", this.getNextHighestDepth());
		timeOb = this.attachMovie("IDTimeDisplay", "_f_", this.getNextHighestDepth());
		prgBar = this.attachMovie("IDProgressBar", "_g_", this.getNextHighestDepth());
		volBar = this.attachMovie("IDProgressBar", "_h_", this.getNextHighestDepth());
		Mask = this.createEmptyMovieClip("_i_", this.getNextHighestDepth());
		this.setMask(Mask);
		FLVCtrl.master = this;
	}
	private function initObjects() {
		ppBtn.master = repBtn.master=mutIcn.master=prgBar.master=volBar.master=this;
		ppBtn.tip = "Play/Pause";
		ppBtn.onClick = ppBtn_OnClick;
		repBtn.onClick = repBtn_OnClick;
		repBtn.tip = "Start from the begining";
		mutIcn.onClick = mutIcn_OnClick;
		mutIcn.tip = "Toggle Mute";
		prgBar.onDrag = prgBar_OnDrag;
		prgBar.onRoll = prgBar_OnRoll;
		prgBar.onOut = prgBar_OnOut;
		prgBar.onOvr = prgBar_OnOvr;
		prgBar.onRls = prgBar_OnRls;
		prgBar.onPrs = prgBar_OnPrs;
		volBar.onDrag = volBar_OnDrag;
		volBar.onOvr = volBar_OnOvr;
		volBar.onOut = volBar_OnOut;
	}
	private function resize() {
		cbarOb._width = w;
		cbarOb._height = ch;
		cbarOb._y = h-ch;
		//
		mutIcn._x = w-mutIcn._width-volw-2*hs;
		mutIcn._y = cbarOb._y+ts;
		//
		ppBtn._x = hs;
		ppBtn._y = cbarOb._y+ts;
		//
		timeOb._x = mutIcn._x-hs-timeOb._width;
		timeOb._y = cbarOb._y+Math.round(ch/2-timeOb._height/2);
		//
		repBtn._x = timeOb._x-hs-repBtn._width;
		repBtn._y = cbarOb._y+ts;
		//
		prgBar.width = repBtn._x-3*hs-ppBtn._width;
		prgBar._x = ppBtn._x+ppBtn._width+hs;
		prgBar._y = cbarOb._y+Math.round(ch/2-prgBar.height/2);
		//
		volBar.width = volw-hs;
		volBar._x = w-hs-volw;
		volBar._y = cbarOb._y+Math.round(ch/2-volBar.height/2);
		//
		preloader._x = Math.round(w/2);
		preloader._y = Math.round(h/2-ch/2);
		//
		drawShape(Mask, 5, w, _h);
	}
	private function ppBtn_OnClick(s:Number) {
		switch (s) {
		case 1 :
			FLVCtrl.pause();
			break;
		default :
			FLVCtrl.play();
			break;
		}
	}
	private function repBtn_OnClick() {
		FLVCtrl.stop();
		FLVCtrl.play();
	}
	private function mutIcn_OnClick(s:Number) {
		if (FLVCtrl.volume == 0) {
			mutIcn.state = 2;
			return;
		}
		switch (s) {
		case 2 :
			FLVCtrl.mute = true;
			volBar.progPercent = 0;
			break;
		default :
			FLVCtrl.mute = false;
			volBar.progPercent = FLVCtrl.volume/100;
			break;
		}
	}
	private function prgBar_OnDrag(per) {
		FLVCtrl.seekPercent(per);
	}
	private function prgBar_OnRoll(per) {
	}
	private function prgBar_OnOut() {
		//_global.TOOLTIP.hide();
	}
	private function prgBar_OnOvr() {
		//_global.TOOLTIP.show(prgBar.tip+" "+getTimeString(timeOb.elapsed));
	}
	private function prgBar_OnPrs() {
		prevPlay = FLVCtrl.playing;
	}
	private function prgBar_OnRls() {
		if (prevPlay) {
			FLVCtrl.play();
		}
	}
	private function volBar_OnDrag(p:Number) {
		FLVCtrl.volume = Math.round(100*p);
		if (FLVCtrl.mute) {
			mutIcn.state = 2;
		} else {
			mutIcn.state = 1;
		}
		//_global.TOOLTIP.tip = volBar.tip+" "+FLVCtrl.volume;
	}
	private function volBar_OnOvr() {
		if (FLVCtrl.mute) {
			//_global.TOOLTIP.show(volBar.tip+" 0");
		} else {
			//_global.TOOLTIP.show(volBar.tip+" "+FLVCtrl.volume);
		}
	}
	private function volBar_OnOut() {
		//_global.TOOLTIP.hide();
	}
	/*private function FLVCtrl_OnFLVBuffering(bf) {
	if (bf) {
	Tweener.addTween(preloader, {_alpha:100, time:1, transition:"linear", rounded:true});
	} else {
	Tweener.addTween(preloader, {_alpha:0, time:.4, transition:"linear", rounded:true});
	}
	}*/
	private function FLVCtrl_OnFLVComplete() {
	}
	private function FLVCtrl_OnFLVPlayheadUpdate(ct, tt) {
		with (thisObject) {
			prgBar.progPercent = ct/tt;
			timeOb.elapsed = ct;
			timeOb.total = tt;
			if (prgBar.drag || prgBar.over) {
				//_global.TOOLTIP.tip = "Time "+getTimeString(ct);
			}
		}
	}
	private function FLVCtrl_OnFLVDownload(lb, tb) {
		with (thisObject) {
			prgBar.loadPercent = lb/tb;
		}
	}
	private function FLVCtrl_OnFLVState(stat) {
		with (thisObject) {
			switch (stat) {
			case "play" :
				ppBtn.state = 2;
				break;
			case "pause" :
			case "load" :
			case "stop" :
				ppBtn.state = 1;
				break;
			}
		}
	}
	private function FLVCtrl_OnFLVError(file:String) {
		Utils.JSAlert("Could not open "+file);
	}
	//
	public function loadFLV(url:String) {
		FLVCtrl.load(url);
	}
	private function getTimeString(t:Number) {
		var tm = Math.floor(t/60);
		tm = tm<10 ? "0"+tm : tm;
		var ts = Math.ceil(t)%60;
		ts = ts<10 ? "0"+ts : ts;
		return String(tm+":"+ts);
	}
	public function set width(nw:Number) {
		w = Math.round(nw);
		resize();
	}
	public function set height(nh:Number) {
		_h = Math.round(nh);
		resize();
	}
	public function get width():Number {
		return w;
	}
	public function get height():Number {
		return _h;
	}
	private function drawShape(mc:MovieClip, r:Number, sw:Number, sh:Number) {
		mc.clear();
		mc.beginFill(0x000000, 100);
		mc.moveTo(r, 0);
		mc.lineTo(sw-r, 0);
		mc.curveTo(sw, 0, sw, r);
		mc.lineTo(sw, sh-r);
		mc.curveTo(sw, sh, sw-r, sh);
		mc.lineTo(r, sh);
		mc.curveTo(0, sh, 0, sh-r);
		mc.lineTo(0, r);
		mc.curveTo(0, 0, r, 0);
		mc.endFill();
	}
}
