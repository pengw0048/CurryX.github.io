import flash.filters.BlurFilter;
import oxylus.TGallery.Tab;
import oxylus.TGallery.Overlay;
import caurina.transitions.Tweener;
import oxylus.TGallery.ThumbsGrid;
class oxylus.TGallery.TabSlider extends MovieClip {
	private var Bground:MovieClip;
	private var LEdge:MovieClip;
	private var REdge:MovieClip;
	private var Tabs:MovieClip;
	private var Mask:MovieClip;
	private var w:Number;
	private var margin:Number;
	private var node:XMLNode;
	private var idx:Number;
	private var allowSlide:Boolean;
	private var offset:Number;
	private var totalWidth:Number;
	private var tox:Number;
	public function TabSlider() {
		initVars();
		initClips();
		resize();
	}
	private function initClips() {
		Bground = eval(this._target+"/_a_");
		LEdge = eval(this._target+"/_b_");
		REdge = eval(this._target+"/_c_");
		LEdge._width = REdge._width=margin;
		LEdge._alpha = REdge._alpha=100;
		Mask = this.createEmptyMovieClip("_mask_mc_", this.getNextHighestDepth());
		Mask.beginFill(0, 0);
		Mask.lineTo(1, 0);
		Mask.lineTo(1, 1);
		Mask.lineTo(0, 1);
		Mask.lineTo(0, 0);
		Mask.endFill();
		this.setMask(Mask);
		this.hitArea = Bground;
		this._xscale = this._yscale=100;
		this.useHandCursor = false;
	}
	private function initVars() {
		w = 800;
		margin = tox=20;
		Tabs = undefined;
		idx = 0;
		allowSlide = false;
		offset = 0;
		totalWidth = 0;
	}
	private function resize() {
		this._xscale = this._yscale=100;
		Bground._x = Bground._y=0;
		Bground._width = w;
		LEdge._y = REdge._y=0;
		LEdge._height = REdge._height=this.height;
		LEdge._x = 0;
		REdge._x = w;
		Mask._width = w;
		Mask._height = Bground._height;
		if (Tabs != undefined) {
			delete Tabs.onEnterFrame;
			Tabs.filters = [];
			Tabs._x = tox;
			checkIfSlideNeeded();
			if (!allowSlide) {
				Tabs._x = margin;
				tox = margin;
			} else {
				if (Tabs._x<w-totalWidth-margin) {
					Tabs._x = w-totalWidth-margin;
				}
			}
		}
	}
	public function set width(nw:Number) {
		w = Math.round(nw);
		resize();
	}
	public function get width():Number {
		return w;
	}
	public function get height():Number {
		return Bground._height;
	}
	private function setData(n:XMLNode) {
		node = n;
		allowSlide = false;
		totalWidth = 0;
		generate();
	}
	private function generate() {
		if (Tabs != undefined) {
			Tab.reset();
			Tabs.removeMovieClip();
		}
		Tabs = this.createEmptyMovieClip("_tab_slider_"+(idx++), this.getNextHighestDepth());
		REdge.swapDepths(this.getNextHighestDepth());
		LEdge.swapDepths(this.getNextHighestDepth());
		Tabs._x = margin;
		//
		var p:XMLNode = node.firstChild;
		var i = 0;
		for (; p != null; p=p.nextSibling) {
			var tb:MovieClip = Tabs.attachMovie("IDTab", "tab"+i, Tabs.getNextHighestDepth());
			tb._x = i*tb.width;
			tb.data = p;
			if (i == 0) {
				tb.setInitTab();
			}
			if (offset == 0) {
				offset = tb.width;
			}
			i++;
		}
		totalWidth = i*offset;
		checkIfSlideNeeded();
	}
	public function set data(n:XMLNode) {
		setData(n);
	}
	public function get data():XMLNode {
		return node;
	}
	private function checkIfSlideNeeded() {
		allowSlide = false;
		if (totalWidth>w-2*margin) {
			allowSlide = true;
		}
	}
	private function onMouseMove() {
		if (Overlay.overlayOn) {
			return;
		}
		if (!this.enabled) {
			return;
		}
		if (!allowSlide) {
			return;
		}
		if (Tabs == undefined) {
			return;
		}
		if (!this.hitTest(_root._xmouse, _root._ymouse, true)) {
			return;
		}
		if (ThumbsGrid.draging) {
			return;
		}
		var minx:Number = margin+offset;
		var maxx:Number = w-margin-offset;
		var dist:Number = maxx-minx;
		var xm:Number = this._xmouse<minx ? 0 : (this._xmouse>maxx ? dist : this._xmouse-minx);
		tox = Math.round(margin+xm/dist*(w-totalWidth-2*margin));
		var tx:Number = Tabs._x;
		Tabs.onEnterFrame = function() {
			with (this._parent) {
				if (Math.abs(tx-tox)<1) {
					delete Tabs.onEnterFrame;
					Tabs._x = tox;
					Tabs.filters = [];
					return;
				}
				tx += (tox-tx)/7;
				Tabs._x = tx;//Math.round(tx);
				var bv:Number = 32*Math.abs((tox-tx)/(w-totalWidth-2*margin));
				motionBlur(bv);
				updateAfterEvent();
			}
		};
	}
	private function motionBlur(bv:Number) {
		if (bv>1) {
			Tabs.filters = [new BlurFilter(bv, 0, 2)];
		} else {
			if (Tabs.filters != []) {
				Tabs.filters = [];
			}
		}
	}
}
