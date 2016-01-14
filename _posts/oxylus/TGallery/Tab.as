import caurina.transitions.Tweener;
import flash.display.BitmapData;
import flash.filters.BlurFilter;
import flash.filters.GlowFilter;
import oxylus.tooltip.Tooltip;
class oxylus.TGallery.Tab extends MovieClip {
	private var Bground:MovieClip;
	private var Frame:MovieClip;
	private var UFrame:MovieClip;
	private var PicBg:MovieClip;
	private var Ploader:MovieClip;
	private var Mask:MovieClip;
	private var Image:MovieClip;
	private var Over:MovieClip;
	//
	private static var crt:MovieClip;
	private var node:XMLNode;
	private var mcl:MovieClipLoader;
	private var idx:Number = 0;
	private var pos:Object;
	private var w:Number;
	public static var onClick:Function;
	private var _enabled:Boolean;
	public function Tab() {
		initClips();
		initVars();
	}
	public static function reset() {
		crt = undefined;
	}
	private function initClips() {
		Bground = eval(this._target+"/_a_");
		w = Bground._width;
		Bground._alpha = 0;
		pos = new Object();
		UFrame = eval(this._target+"/_b_");
		UFrame._y += 4;
		pos["uframe"] = UFrame._y;
		Frame = eval(this._target+"/_c_");
		Frame._y += 4;
		pos["frame"] = Frame._y;
		PicBg = eval(this._target+"/_d_");
		PicBg._y += 4;
		pos["picbg"] = PicBg._y;
		Ploader = this.attachMovie("IDPreloader", "_e_", this.getNextHighestDepth());
		Ploader._x = PicBg._x+Math.round(PicBg._width/2);
		Ploader._y = PicBg._y+Math.round(PicBg._height/2);
		Mask = PicBg.duplicateMovieClip("_f_", this.getNextHighestDepth());
		Mask._x = PicBg._x;
		Mask._y = PicBg._y;
		Mask._alpha = 0;
		this.hitArea = Bground;
	}
	private function initVars() {
		mcl = new MovieClipLoader();
		node = null;
		Image = undefined;
		Over = undefined;
		_enabled = true;
	}
	private function setData(n:XMLNode) {
		node = n;
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
			Tweener.removeTweens(Over);
			Over.removeMovieClip();
		}
		Over = this.createEmptyMovieClip("_ovr_"+(idx++), this.getNextHighestDepth());
		Image = this.createEmptyMovieClip("_img_"+(idx++), this.getNextHighestDepth());
		Over.swapDepths(Ploader);
		Over.swapDepths(PicBg);
		Over.swapDepths(Frame);
	}
	private function onLoadComplete() {
		Ploader.pStop();
	}
	private function onLoadInit() {
		mcl.removeListener(this);
		Image._alpha = 0;
		Image._x = PicBg._x;
		Image._y = PicBg._y;
		var bd:BitmapData = new BitmapData(Mask._width, Mask._height);
		bd.draw(Image);
		Image.setMask(Mask);
		var gf:GlowFilter = new GlowFilter(0x000000, .2, 8, 8, 1, 3, true, false);
		Image.filters = [gf];
		Over.attachBitmap(bd, Over.getNextHighestDepth(), "never", false);
		Over._x = PicBg._x;
		Over._y = PicBg._y;
		Over._alpha = 0;
		var bf:BlurFilter = new BlurFilter(16, 8, 3);
		Over.filters = [bf];
		Tweener.addTween(Image, {_alpha:100, time:.5, transition:"easeInQuad"});
	}
	private function setCrt() {
		this._enabled = false;
		this.useHandCursor = false;
		function updt() {
			with (this._parent) {
				Ploader._y = PicBg._y+Math.round(PicBg._height/2);
				Image._y = PicBg._y;
				Over._y = PicBg._y;
				Mask._y = PicBg._y;
			}
		}
		if (Over != undefined) {
			Tweener.addTween(Over, {_alpha:0, time:.2, transition:"easeInQuad"});
		}
		function func() {
			onClick.call(_root, _parent.node);
		}
		Tweener.addTween(Bground, {_alpha:100, time:.3, transition:"easeInQuad", onComplete:func});
		Tweener.addTween(Frame, {_y:pos["frame"]-4, time:.15, transition:"easeInQuad"});
		Tweener.addTween(UFrame, {_y:pos["uframe"]-4, time:.15, transition:"easeInQuad"});
		Tweener.addTween(PicBg, {_y:pos["picbg"]-4, time:.15, transition:"easeInQuad", onUpdate:updt});
		if (crt != undefined) {
			crt.unSetCrt();
		}
		crt = this;
	}
	private function unSetCrt() {
		this._enabled = true;
		this.useHandCursor = true;
		function updt() {
			with (this._parent) {
				Ploader._y = PicBg._y+Math.round(PicBg._height/2);
				Image._y = PicBg._y;
				Over._y = PicBg._y;
				Mask._y = PicBg._y;
			}
		}
		Tweener.addTween(Bground, {_alpha:0, time:.3, transition:"easeOutQuad"});
		Tweener.addTween(Frame, {_y:pos["frame"], time:.15, transition:"easeOutQuad"});
		Tweener.addTween(UFrame, {_y:pos["uframe"], time:.15, transition:"easeOutQuad"});
		Tweener.addTween(PicBg, {_y:pos["picbg"], time:.15, transition:"easeOutQuad", onUpdate:updt});
	}
	private function onRelease() {
		if (!_enabled) {
			return;
		}
		setCrt();
	}
	private function onRollOver() {
		Tooltip.show({tip:node.attributes.name, delay:.6, stay:6, follow:true});
		if (!_enabled) {
			return;
		}
		if (Over != undefined) {
			Tweener.addTween(Over, {_alpha:100, time:.4, transition:"linear"});
		}
	}
	private function onRollOut() {
		Tooltip.hide();
		if (!_enabled) {
			return;
		}
		if (Over != undefined) {
			Tweener.addTween(Over, {_alpha:0, time:.3, transition:"linear"});
		}
	}
	private function onReleaseOutside() {
		onRollOut();
	}
	public function get width():Number {
		return Math.round(w);
	}
	public function setInitTab() {
		Bground._alpha = 100;
		this._enabled = false;
		this.useHandCursor = false;
		crt = this;
	}
}
