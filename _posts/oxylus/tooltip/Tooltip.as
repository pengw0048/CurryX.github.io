/* 
Tooltip v.1.0
Copyright (c) 2008 OXYLUS Development
email: office@oxylus.ro
developed by Adrian Bota
support: adrian@oxylus.ro
*/
import caurina.transitions.Tweener;
import flash.filters.DropShadowFilter;
import flash.display.BitmapData;
import oxylus.TGallery.Utils;
class oxylus.tooltip.Tooltip extends MovieClip {
	private static var tipOb:MovieClip = undefined;
	private var Border:MovieClip;
	private var Bground:MovieClip;
	private var Text:TextField;
	private var Image:MovieClip;
	private var idx:Number;
	private var Mask1:MovieClip;
	private var Mask2:MovieClip;
	private var mcl:MovieClipLoader;
	// tooltip width
	private var w:Number;
	// tooltip height, not including the tip
	private var h:Number;
	// image width
	private var iw:Number;
	// image height
	private var ih:Number;
	// tip height
	private var tiph:Number;
	// tip width
	private var tipw:Number;
	// corner radius
	private var rad:Number;
	// alignment
	private var algn:Number;
	// horizontal space
	private var hs:Number;
	// vertical space
	private var vs:Number;
	// border width
	private var bw:Number;
	// tip distance from edge
	private var tdst:Number;
	// distance from the tip
	private var cdst:Number;
	// cursor height
	private var crsh:Number;
	////////////////////////
	private var twer:Number;
	private var ther:Number;
	private var cint:Number;
	private var sint:Number;
	private var ciw:Number;
	private var cih:Number;
	private var imr:Number;
	private var wait:Number;
	private var imgURL:String;
	public function Tooltip() {
		assignInst2Vars();
		initEls();
		initVars();
		addShadow();
		resize();
	}
	private function assignInst2Vars() {
		Border = eval(this._target+"/a");
		Bground = eval(this._target+"/b");
		Text = eval(this._target+"/c");
		Mask1 = this.createEmptyMovieClip("msk1___", this.getNextHighestDepth());
		Mask2 = this.createEmptyMovieClip("msk2___", this.getNextHighestDepth());
	}
	private function initVars() {
		idx = 0;
		w = 100;
		h = 30;
		iw = 96;
		ih = 96;
		tiph = 5;
		tipw = 10;
		rad = 5;
		algn = 0;
		hs = 7;
		vs = 7;
		bw = 1;
		tdst = 10;
		cdst = 30;
		crsh = 20;
		ciw = 0;
		cih = 0;
		imr = 5;
		wait = 1;
		imgURL = "";
		twer = Utils.TFwem(Text);
		ther = Utils.TFhem(Text);
		mcl = new MovieClipLoader();
		mcl.addListener(this);
		tipOb = undefined;
	}
	private function initEls() {
		Text.autoSize = true;
		//"left";
		Text.condenseWhite = true;
		Text.gridFitType = "pixel";
		Text.html = true;
		Text.htmlText = "&nbsp;";
		Text.mouseWheelEnabled = false;
		Text.multiline = true;
		Text.selectable = false;
		Text.type = "dynamic";
		Text.wordWrap = false;
		Border.setMask(Mask1);
		Bground.setMask(Mask2);
		this._alpha = 0;
	}
	private function drawMask(mc:MovieClip, inside:Boolean) {
		var msky:Number = 0;
		var txpos:Number = tdst;
		var typos:Number = h;
		var tdir:Number = 1;
		switch (algn) {
		case 1 :
			msky = tiph;
			txpos = tdst;
			typos = tiph;
			tdir = -1;
			break;
		case 2 :
			msky = 0;
			txpos = w-tipw-tdst;
			typos = h;
			tdir = 1;
			break;
		case 3 :
			msky = tiph;
			txpos = w-tipw-tdst;
			typos = tiph;
			tdir = -1;
			break;
		}
		var r:Number = rad;
		var id:Number = 0;
		var ih:Number = tiph;
		var i:Number = 0;
		if (inside) {
			r -= 1.2929*bw;
			id = bw*(Math.sqrt(tipw*tipw/4+tiph*tiph)-tipw/2)/tiph;
			ih = (tiph*(tipw/2-id))/(tipw/2);
			i = bw;
			typos -= tdir*bw;
		}
		mc.clear();
		mc.beginFill(0x000000, 100);
		mc.moveTo(i+r, msky+i);
		mc.lineTo(w-i-r, msky+i);
		mc.curveTo(w-i, msky+i, w-i, msky+i+r);
		mc.lineTo(w-i, msky+h-i-r);
		mc.curveTo(w-i, msky+h-i, w-r-i, msky+h-i);
		mc.lineTo(i+r, msky+h-i);
		mc.curveTo(i, msky+h-i, i, msky+h-r-i);
		mc.lineTo(i, msky+i+r);
		mc.curveTo(i, msky+i, i+r, msky+i);
		mc.moveTo(txpos+id, typos);
		mc.lineTo(txpos+tipw-id, typos);
		mc.lineTo(txpos+tipw/2, typos+tdir*ih);
		mc.lineTo(txpos+id, typos);
		mc.endFill();
	}
	private function updateShape() {
		drawMask(Mask1);
		drawMask(Mask2, true);
	}
	private function resize() {
		Text._x = ciw+(ciw>0 ? imr-twer : 0)+hs-twer+bw;
		Text._y = vs+bw;
		Image._x = bw+hs;
		Image._y = bw+vs;
		if (algn == 1 || algn == 3) {
			Text._y += tiph;
			Image._y += tiph;
		}
		w = Math.round(Text.textWidth)+2*hs+twer+2*bw+ciw+(ciw>0 ? imr-twer : 0);
		if (_tip.length == 0) {
			w = 2*hs+2*bw+ciw;
		}
		h = Math.round(Text.textHeight)+2*vs+ther+2*bw;
		h = Math.max(h, 2*vs+2*bw+cih);
		if (_tip.length == 0) {
			h = 2*vs+2*bw+cih;
		}
		if (w<2*tdst+tipw) {
			w = 2*tdst+tipw;
		}
		if (h<2*vs+2*bw) {
			h = 2*vs+2*bw;
		}
		Border._x = 0;
		Border._y = 0;
		Border._width = w;
		Border._height = h+tiph;
		Bground._x = 0;
		Bground._y = 0;
		Bground._width = w;
		Bground._height = h+tiph;
		updateShape();
	}
	private function addShadow() {
		var distance:Number = 2;
		var angleInDegrees:Number = 45;
		var color:Number = 0x000000;
		var alpha:Number = 1;
		var blurX:Number = 4;
		var blurY:Number = 4;
		var strength:Number = 1;
		var quality:Number = 3;
		var inner:Boolean = false;
		var knockout:Boolean = false;
		var hideObject:Boolean = false;
		var filter:DropShadowFilter = new DropShadowFilter(distance, angleInDegrees, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
		var fa:Array = new Array();
		fa.push(filter);
		this.filters = fa;
	}
	public function set _tip(str:String) {
		if (str != undefined) {
			Text.htmlText = str;
			resize();
		}
	}
	public function get _tip():String {
		return Text.htmlText;
	}
	public function _show(o:Object) {
		clearInterval(cint);
		clearInterval(sint);
		//
		if (imgURL != o.img) {
			imgURL = o.img;
			ciw = 0;
			cih = 0;
			Image.removeMovieClip();
			if (o.img != undefined) {
				ciw = o.imgWidth == undefined ? iw : o.imgWidth;
				cih = o.imgHeight == undefined ? ih : o.imgHeight;
				Image = this.createEmptyMovieClip("image_no_"+(idx++), this.getNextHighestDepth());
				mcl.loadClip(o.img, Image);
			}
		}
		//                             
		this._tip = o.tip;
		var dly:Number = o.delay == undefined ? 0 : o.delay;
		var sty:Number = o.stay == undefined ? -1 : o.stay;
		function aniStart() {
			updatePos();
		}
		Tweener.removeTweens(this);
		//if (this._alpha<100) {
		this._alpha = 0;
		//}
		Tweener.addTween(this, {_alpha:100, time:.3, transition:"linear", delay:dly, onStart:aniStart});
		if (sty>=0) {
			sint = setInterval(function (mc) {
				mc._hide();
			}, 1000*(dly+sty+.5), this);
		}
		this.swapDepths(_root.getNextHighestDepth());
		if (o.follow) {
			cint = setInterval(this, "updatePos", 20);
		}
		//updatePos();    
	}
	private function _hide(dly:Number) {
		if (dly == undefined) {
			dly = 0;
		}
		clearInterval(cint);
		clearInterval(sint);
		Tweener.removeTweens(this);
		if (this._alpha == 100) {
			Tweener.addTween(this, {_alpha:0, time:.15, transition:"linear", delay:dly});
		} else {
			Tweener.addTween(this, {_alpha:0, time:.15, transition:"linear"});
		}
		//this._alpha = 0;
	}
	private function updatePos() {
		var oldalgn:Number = algn;
		algn = 0;
		if (_root._xmouse+w-tdst-tipw/2>Stage.width) {
			if (_root._ymouse-h-tiph-cdst<0) {
				algn = 3;
			} else {
				algn = 2;
			}
		} else {
			if (_root._ymouse-h-tiph-cdst<0) {
				algn = 1;
			}
		}
		if (oldalgn != algn) {
			resize();
		}
		switch (algn) {
		case 1 :
			this._x = Math.round(_root._xmouse-tdst-tipw/2);
			this._y = _root._ymouse+crsh+cdst;
			break;
		case 2 :
			this._x = Math.round(_root._xmouse-w+tdst+tipw/2);
			this._y = _root._ymouse-h-tiph-cdst;
			break;
		case 3 :
			this._x = Math.round(_root._xmouse-w+tdst+tipw/2);
			this._y = _root._ymouse+crsh+cdst;
			break;
		case 0 :
			this._x = Math.round(_root._xmouse-tdst-tipw/2);
			this._y = _root._ymouse-h-tiph-cdst;
			break;
		}
		updateAfterEvent();
	}
	public static function attach() {
		if (String(tipOb).length == 0 || tipOb == undefined) {
			tipOb = _root.attachMovie("IDTooltip", "_ja232jk_23k3p23iyio_pxj8_", _root.getNextHighestDepth());
		}
	}
	public static function set tip(str:String) {
		tipOb._tip = str;
	}
	public static function get tip():String {
		return tipOb._tip;
	}
	public static function show(o:Object) {
		tipOb._show(o);
	}
	public static function hide(dly:Number) {
		tipOb._hide(dly);
	}
	public static function setVars(o:Object) {
		if (tipOb == undefined) {
			return;
		}
		with (tipOb) {
			for (var i in o) {
				switch (i) {
				case "imgWidth" :
					iw = o[i];
					break;
				case "imgHeight" :
					ih = o[i];
					break;
				case "imgMarginRight" :
					imr = o[i];
					break;
				case "tipWidth" :
					tipw = o[i];
					break;
				case "tipHeight" :
					tiph = o[i];
					break;
				case "radius" :
					rad = o[i];
					break;
				case "hspace" :
					hs = o[i];
					break;
				case "vspace" :
					vs = o[i];
					break;
				case "borderWidth" :
					bw = o[i];
					break;
				case "tipXOffset" :
					tdst = o[i];
					if (tdst<rad) {
						tdst = rad;
					}
					break;
				case "cursorDist" :
					cdst = o[i];
					break;
				case "cursorHeight" :
					crsh = o[i];
					break;
				}
			}
		}
		tipOb.resize();
	}
	private function onLoadInit() {
		var bd:BitmapData = new BitmapData(ciw, cih, false, 0x000000);
		bd.draw(Image);
		Image.removeMovieClip();
		Image = this.createEmptyMovieClip("image_no_"+(idx++), this.getNextHighestDepth());
		Image.attachBitmap(bd, Image.getNextHighestDepth(), "always", false);
		Image._x = bw+hs;
		Image._y = bw+vs;
		if (algn == 1 || algn == 3) {
			Image._y += tiph;
		}
	}
}
