import caurina.transitions.Tweener;
import oxylus.TGallery.Utils;
class oxylus.TGallery.TextBox extends MovieClip {
	private var Bground:MovieClip;
	private var Shape:MovieClip;
	private var TitleMc:MovieClip;
	private var TitleTf:TextField;
	private var BodyMc:MovieClip;
	private var BodyTf:TextField;
	private var SHandle:MovieClip;
	private var SBar:MovieClip;
	private var Mask:MovieClip;
	private var SMask:MovieClip;
	private var FTop:MovieClip;
	private var FBtm:MovieClip;
	//
	private var space:Number;
	private var w:Number;
	private var h:Number;
	private var node:XMLNode;
	private var rad:Number;
	private var fh:Number;
	public function TextBox() {
		Bground = this["_a_"];
		TitleMc = this["_b_"];
		TitleTf = this["_b_"]["_a_"];
		BodyMc = this["_e_"];
		BodyTf = this["_e_"]["_a_"];
		FTop = this["_c_"];
		FBtm = this["_d_"];
		SBar = this["_f_"];
		SHandle = this["_f_"]["_a_"];
		//
		BodyTf.autoSize = true;
		BodyTf.html = true;
		BodyTf.multiline = true;
		BodyTf.mouseWheelEnabled = false;
		BodyTf.selectable = true;
		BodyTf.wordWrap = true;
		BodyTf.condenseWhite = true;
		BodyTf.gridFitType = "pixel";
		//
		TitleTf.autoSize = "none";
		TitleTf.selectable = true;
		TitleTf.html = true;
		TitleTf.condenseWhite = true;
		TitleTf.gridFitType = "pixel";
		//
		//SBar._alpha = 0;
		SBar._visible = false;
		SHandle.stop();
		SBar.onPress = SBar_onPress;
		SBar.onRelease = SBar_onRelease;
		SBar.onReleaseOutside = SBar_onReleaseOutside;
		SBar.onRollOver = SBar_onRollOver;
		SBar.onRollOut = SBar_onRollout;
		SMask = SBar.createEmptyMovieClip("_shm_", SBar.getNextHighestDepth());
		SBar.setMask(SMask);
		//
		Shape = this.createEmptyMovieClip("_shape_", this.getNextHighestDepth());
		Mask = this.createEmptyMovieClip("_mask_", this.getNextHighestDepth());
		//
		Bground.setMask(Shape);
		BodyMc.setMask(Mask);
		//
		space = 10;
		w = 500;
		h = 120;
		rad = 5;
		fh = FTop._height/2;
		//
		SBar._y = space;
		drawMask();
		drawShape(SMask, Math.round(SHandle._width/2), SHandle._width, SHandle._height);
		reset();
		resize();
	}
	private function resize() {
		SBar._x = w-Math.round(SBar._width/2);
		Bground._width = w;
		Bground._height = h;
		drawShape(Shape, rad, w, h);
		TitleMc._x = TitleMc._y=space;
		TitleTf._width = w-2*space;
		FTop._x = space;
		FTop._y = space+Math.floor(TitleTf.textHeight);
		FTop._width = w-2*space;
		FBtm._x = space;
		FBtm._y = h-space;
		FBtm._width = w-2*space;
		BodyMc._x = space;
		BodyMc._y = FTop._y+fh;
		BodyTf._width = w-2*space;
		Mask._x = space;
		Mask._y = FTop._y;
		Mask._width = w-2*space;
		Mask._height = FBtm._y-FTop._y;
		checkSlider();
	}
	private function drawMask() {
		Mask.beginFill(0x000000, 100);
		Mask.lineTo(0, 1);
		Mask.lineTo(1, 1);
		Mask.lineTo(1, 0);
		Mask.lineTo(0, 0);
		Mask.endFill();
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
	private function SBar_onPress() {
		with (this._parent) {
			var sh:Number = SHandle._height;
			var sx:Number = SBar._x;
			SBar.startDrag(false, sx, space, sx, h-space-sh);
		}
		var oldy:Number = BodyMc._y;
		this.onEnterFrame = function() {
			with (this._parent) {
				var toy:Number = Mask._y+fh+Math.round((Mask._height-BodyMc._height-2*fh)*(SBar._y-space)/(h-2*space-SBar._height));
				if (oldy != toy) {
					Tweener.addTween(BodyMc, {_y:toy, transition:"easeOutQuad", time:.6});
					oldy = toy;
				}
			}
		};
	}
	private function SBar_onRelease() {
		this.stopDrag();
		delete this.onEnterFrame;
	}
	private function SBar_onReleaseOutside() {
		with (this._parent) {
			Utils.mcPlay(SHandle, 1);
		}
		delete this.onEnterFrame;
		this.stopDrag();
	}
	private function SBar_onRollOver() {
		with (this._parent) {
			Utils.mcPlay(SHandle, 0);
		}
	}
	private function SBar_onRollout() {
		with (this._parent) {
			Utils.mcPlay(SHandle, 1);
		}
	}
	private function setData(n:XMLNode) {
		SBar._visible = false;
		SBar._alpha = 0;
		SBar._y = space;
		Tweener.removeTweens(TitleMc);
		Tweener.removeTweens(BodyMc);
		node = n;
		var wait:Number = .4;
		function gf() {
			with (this._parent) {
				TitleTf.htmlText = node.attributes.name;
				BodyTf.htmlText = node.firstChild.nodeValue;
				BodyMc._y = FTop._y+fh;
				checkSlider();
			}
		}
		if (TitleMc._alpha>0) {
			Tweener.addTween(TitleMc, {_alpha:0, transition:"easeOutSine", time:wait});
			Tweener.addTween(BodyMc, {_alpha:0, transition:"easeOutSine", time:wait, onComplete:gf});
		} else {
			TitleTf.htmlText = node.attributes.name;
			BodyTf.htmlText = node.firstChild.nodeValue;
			BodyMc._y = FTop._y+fh;
			checkSlider();
			wait = 0;
		}
		Tweener.addTween(TitleMc, {_alpha:100, transition:"easeInSine", time:.8, delay:wait});
		Tweener.addTween(BodyMc, {_alpha:100, transition:"easeInSine", time:.8, delay:wait});
	}
	public function set data(n:XMLNode) {
		setData(n);
	}
	public function get data():XMLNode {
		return node;
	}
	private function checkSlider() {
		if (BodyMc._height>Mask._height-2*fh) {
			SMask.clear();
			var sh:Number = Math.round((h-2*space)*(Mask._height-2*fh)/BodyMc._height);
			if (sh<20) {
				sh = 20;
			}
			SHandle._height = sh;
			drawShape(SMask, Math.round(SHandle._width/2), SHandle._width, SHandle._height);
			//var toy:Number = Mask._y+fh+Math.round((Mask._height-BodyMc._height-2*fh)*(SBar._y-space)/(h-2*space-SBar._height));
			//SBar._y = space+Math.round(((BodyMc._y-Mask._y+fh)*(h-2*space-SBar._height))/((Mask._height-BodyMc._height-2*fh)*(SBar._y-space)));
			if (SBar._y>h-2*space-SBar._height) {
				SBar._y = h-2*space-SBar._height;
			}
			SBar._visible = true;
			Tweener.addTween(SBar, {_alpha:100, transition:"easeInSine", time:.4});
		} else {
			SBar._visible = false;
			SBar._alpha = 0;
		}
	}
	public function set width(nw:Number) {
		w = Math.round(nw);
		resize();
	}
	public function set height(nh:Number) {
		h = Math.round(nh);
		resize();
	}
	public function get width():Number {
		return w;
	}
	public function get height():Number {
		return h;
	}
	public function reset() {
		TitleMc._alpha = BodyMc._alpha=0;
	}
	public function FV(b:Boolean) {
		FTop._visible = FBtm._visible=b;
	}
}
