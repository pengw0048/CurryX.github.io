import caurina.transitions.Tweener;
class oxylus.TGallery.ProgBar extends MovieClip {
	private var Brd:MovieClip;
	private var Bg:MovieClip;
	private var LInd:MovieClip;
	private var PInd:MovieClip;
	private var PHead:MovieClip;
	private var Mask:Array;
	private var h:Number = 10;
	private var w:Number = 100;
	private var bw:Number = 1;
	private var _drag:Boolean;
	private var _over:Boolean;
	private var _crtPer:Number;
	private var _loadPer:Number;
	private var _total:Number;
	private var _master:Object;
	private var oldxm:Number;
	public var onDrag:Function;
	public var onRoll:Function;
	public var onOut:Function;
	public var onOvr:Function;
	public var onRls:Function;
	public var onPrs:Function;
	private var t:Number = .3;
	private var _tip:String;
	public function ProgBar() {
		_total = w-2*bw;
		_loadPer = 1;
		_crtPer = 0;
		oldxm = -1;
		_drag = false;
		_over = false;
		_master = this;
		//
		Brd = eval(this._target+"/a");
		Bg = eval(this._target+"/b");
		LInd = eval(this._target+"/c");
		PInd = eval(this._target+"/d");
		PHead = eval(this._target+"/e");
		Mask = new Array();
		for (var i = 0; i<4; i++) {
			Mask[i] = this.createEmptyMovieClip("msk"+i, this.getNextHighestDepth());
		}
		Brd.setMask(Mask[0]);
		Bg.setMask(Mask[1]);
		LInd.setMask(Mask[2]);
		PInd.setMask(Mask[3]);
		this.hitArea = LInd;
		PHead._alpha = 0;
		resize();
		setInterval(checkEvents, 20, this);
	}
	private function resize() {
		_total = w-2*bw;
		//
		Brd._x = 0;
		Brd._y = 0;
		Brd._width = w;
		Brd._height = h;
		//
		Bg._x = bw;
		Bg._y = bw;
		Bg._width = w-2*bw;
		Bg._height = h-2*bw;
		//
		PInd._x = bw;
		PInd._y = bw;
		PInd._height = h-2*bw;
		PInd._width = Math.round(_crtPer*_total);
		//
		LInd._x = bw;
		LInd._y = bw;
		LInd._height = h-2*bw;
		LInd._width = Math.round(_loadPer*_total);
		//
		PHead._x = Math.round(PInd._width+bw);
		//
		drawMask(Brd, Mask[0]);
		drawMask(Bg, Mask[1]);
		drawMask(LInd, Mask[2]);
		drawMask(PInd, Mask[3]);
	}
	private function drawMask(mc:MovieClip, msk:MovieClip) {
		var mw:Number = mc._width;
		var mh:Number = mc._height;
		var px:Number = 3.5;
		with (msk) {
			clear();
			beginFill(0, 0);
			moveTo(px, 0);
			lineTo(mw-px, 0);
			curveTo(mw, 0, mw, px);
			lineTo(mw, mh-px);
			curveTo(mw, mh, mw-px, mh);
			lineTo(px, mh);
			curveTo(0, mh, 0, mh-px);
			lineTo(0, px);
			curveTo(0, 0, px, 0);
			endFill();
		}
		msk._x = mc._x;
		msk._y = mc._y;
	}
	private function checkEvents(ref) {
		with (ref) {
			if (_drag) {
				var tw:Number = _xmouse>LInd._width+bw ? LInd._width : (_xmouse<bw ? 0 : _xmouse-bw);
				if (oldxm != tw) {
					oldxm = tw;
					PInd._width = tw;
					PHead._x = bw+tw;
					drawMask(PInd, Mask[3]);
					_crtPer = tw/_total;
					onDrag.call(_master, _crtPer);
					updateAfterEvent();
				}
			}
			if (_over && !_drag) {
				var _tw:Number = _xmouse>LInd._width+bw ? LInd._width : (_xmouse<bw ? 0 : _xmouse-bw);
				if (oldxm != _tw) {
					oldxm = _tw;
					var p:Number = _tw/_total;
					onRoll.call(_master, p);
					updateAfterEvent();
				}
			}
		}
	}
	private function updateProgress() {
		PInd._width = Math.round(_crtPer*_total);
		drawMask(PInd, Mask[3]);
		PHead._x = bw+PInd._width;
	}
	private function updateLoading() {
		LInd._width = Math.round(_loadPer*_total);
		drawMask(LInd, Mask[2]);
	}
	private function onRollOver() {
		onOvr.call(_master);
		_over = true;
		Tweener.addTween(PHead, {_alpha:100, time:t, transition:"linear", rounded:true});
	}
	private function onRollOut() {
		_over = false;
		oldxm = -1;
		onOut.call(_master);
		Tweener.addTween(PHead, {_alpha:0, time:t, transition:"linear", rounded:true});
	}
	private function onReleaseOutside() {
		_drag = false;
		_over = false;
		oldxm = -1;
		onOut.call(_master);
		onRls.call(_master);
		Tweener.addTween(PHead, {_alpha:0, time:t, transition:"linear", rounded:true});
	}
	private function onRelease() {
		_drag = false;
		onRls.call(_master);
	}
	private function onPress() {
		onPrs.call(_master);
		_drag = true;
		oldxm = -1;
	}
	//
	public function set progPercent(np:Number) {
		if (_drag) {
			return;
		}
		_crtPer = np;
		updateProgress();
	}
	public function get progPercent():Number {
		return _crtPer;
	}
	//
	public function set loadPercent(nl:Number) {
		_loadPer = nl;
		updateLoading();
	}
	public function get loadPercent():Number {
		return _loadPer;
	}
	public function set master(o:Object) {
		_master = o;
	}
	public function set width(nw:Number) {
		w = nw;
		resize();
	}
	public function get width():Number {
		return w;
	}
	public function get height():Number {
		return h;
	}
	public function get drag():Boolean {
		return _drag;
	}
	public function get over():Boolean {
		return _over;
	}
	public function set tip(str:String) {
		_tip = str;
	}
	public function get tip():String {
		return _tip;
	}
}
