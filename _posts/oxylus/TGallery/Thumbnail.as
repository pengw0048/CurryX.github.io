import caurina.transitions.Tweener;
import flash.display.BitmapData;
import oxylus.TGallery.Utils;
class oxylus.TGallery.Thumbnail extends MovieClip {
	private var Border:MovieClip;
	private var BMask:MovieClip;
	private var Bground:MovieClip;
	private var Icon:MovieClip;
	private var TextMC:MovieClip;
	private var TextTF:TextField;
	private var Ploader:MovieClip;
	private var Image:MovieClip;
	private var PlayBtn:MovieClip;
	//
	private var node:XMLNode;
	private var mcl:MovieClipLoader;
	private var idx:Number = 0;
	public static var onClick:Function;
	private var w:Number;
	private var h:Number;
	private var bw:Number;
	private var is:Number;
	private var tbh:Number;
	private var vs:Number;
	private var oiw:Number;
	private var oih:Number;
	public function Thumbnail() {
		initClips();
		initVars();
		resize();
	}
	private function initClips() {
		Border = eval(this._target+"/_a_");
		Border.stop();
		Bground = eval(this._target+"/_b_");
		Icon = eval(this._target+"/_c_");
		Icon.stop();
		TextMC = eval(this._target+"/_d_");
		TextTF = eval(this._target+"/_d_/_a_");
		PlayBtn = eval(this._target+"/_pb_");
		TextTF.autoSize = false;
		TextTF.multiline = true;
		TextTF.wordWrap = true;
		TextTF.gridFitType = "pixel";
		Ploader = this.attachMovie("IDPreloader", "_e_", this.getNextHighestDepth());
		BMask = this.createEmptyMovieClip("_bmask_", this.getNextHighestDepth());
		Border.setMask(BMask);
		this.hitArea = Bground;
		PlayBtn._visible = false;
	}
	private function drawBMask() {
		var _h:Number = h-tbh;
		BMask.clear();
		BMask.beginFill(0x000000, 100);
		BMask.moveTo(0, 0);
		BMask.lineTo(w, 0);
		BMask.lineTo(w, _h);
		BMask.lineTo(0, _h);
		BMask.lineTo(0, bw);
		BMask.lineTo(bw, bw);
		BMask.lineTo(bw, _h-bw);
		BMask.lineTo(w-bw, _h-bw);
		BMask.lineTo(w-bw, bw);
		BMask.lineTo(0, bw);
		BMask.lineTo(0, 0);
		BMask.endFill();
	}
	private function initVars() {
		mcl = new MovieClipLoader();
		node = null;
		Image = undefined;
		w = 140;
		h = 175;
		bw = 2;
		is = 10;
		tbh = 35;
		vs = 5;
	}
	private function resize() {
		Border._width = w;
		Border._height = h-tbh;
		Border._x = Border._y=0;
		Bground._width = w-2*bw;
		Bground._height = h-2*bw-tbh;
		Bground._x = Bground._y=bw;
		TextMC._y = Math.round(h-tbh)+vs;
		TextTF._width = Math.round(w-TextMC._x);
		TextTF._height = tbh-vs;
		Icon._y = TextMC._y+1;
		Ploader._x = Math.round(w/2);
		Ploader._y = Math.round(h/2-tbh/2);
		resizeImg();
		drawBMask();
		PlayBtn._x = Math.round(w/2);
		PlayBtn._y = Math.round(Border._height/2);
	}
	public function set width(nw:Number) {
		w = nw;
		resize();
	}
	public function get width():Number {
		return w;
	}
	public function set height(nh:Number) {
		h = nh;
		resize();
	}
	public function get height():Number {
		return h;
	}
	private function setData(n:XMLNode) {
		node = n;
		if (Utils.getExt(node.attributes.file) == "flv") {
			Icon.gotoAndStop(1);
		} else {
			Icon.gotoAndStop(2);
		}
		TextTF.text = node.attributes.name;
		mcl.addListener(this);
		resetImg();
		mcl.loadClip(n.attributes.thumb, Image);
		Ploader.pStart();
	}
	public function set data(n:XMLNode) {
		setData(n);
	}
	public function get data():XMLNode {
		return node;
	}
	private function resetImg() {
		if (Image != undefined) {
			Tweener.removeTweens(Image);
			Image.removeMovieClip();
		}
		Image = this.createEmptyMovieClip("_img_"+(idx++), this.getNextHighestDepth());
	}
	private function onLoadComplete() {
		Ploader.pStop();
	}
	private function onLoadInit() {
		mcl.removeListener(this);
		oiw = Image._width;
		oih = Image._height;
		var bd:BitmapData = new BitmapData(oiw, oih);
		bd.draw(Image);
		resetImg();
		Image.attachBitmap(bd, Image.getNextHighestDepth(), "never", true);
		resizeImg();
		Image._alpha = 0;
		if (Icon._currentframe == 1) {
			PlayBtn._visible = true;
			PlayBtn._alpha = 0;
			PlayBtn.swapDepths(this.getNextHighestDepth());
			Tweener.addTween(PlayBtn, {_alpha:60, time:.5, transition:"easeInQuad"});
		}
		Tweener.addTween(Image, {_alpha:100, time:.5, transition:"easeInQuad"});
	}
	private function onRelease() {
		onClick.call(_root, node);
	}
	private function onRollOver() {
		Utils.mcPlay(Border, 0);
		if (PlayBtn._visible) {
			Tweener.addTween(PlayBtn, {_alpha:90, time:.3, transition:"easeInQuad"});
		}
	}
	private function onRollOut() {
		Utils.mcPlay(Border, 1);
		if (PlayBtn._visible) {
			Tweener.addTween(PlayBtn, {_alpha:60, time:.3, transition:"easeOutQuad"});
		}
	}
	private function onReleaseOutside() {
		onRollOut();
	}
	private function resizeImg() {
		if (Image == undefined) {
			return;
		}
		var mw = w-2*bw-2*is;
		var mh = h-2*bw-2*is-tbh;
		if (oiw>mw || oih>mh) {
			Image._width = mw;
			Image._yscale = Image._xscale;
			if (Image._height>mh) {
				Image._height = mh;
				Image._xscale = Image._yscale;
			}
		}
		Image._x = Math.round(w/2-Image._width/2);
		Image._y = Math.round(h/2-tbh/2-Image._height/2);
	}
}
