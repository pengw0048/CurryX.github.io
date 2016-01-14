import caurina.transitions.Tweener;
class oxylus.TGallery.Overlay extends MovieClip {
	// hardlight
	private var bMode:Number = 14;
	private var op:Number = 90;
	private var w:Number;
	private var h:Number;
	private var node:XMLNode;
	public static var onDone:Function;
	public static var overlayOn:Boolean;
	public function Overlay() {
		//this.blendMode = bMode;
		this._alpha = 0;
		this._visible = false;
		//this.onPress = null;
		this.useHandCursor = false;
		w = 800;
		h = 600;
		resize();
		overlayOn = false;
	}
	private function resize() {
		this._x = this._y=0;
		this._width = w;
		this._height = h;
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
	public function show(n:XMLNode) {
		node = n;
		overlayOn = true;
		if (this._alpha>=op && this._visible) {
			return;
		}
		this._visible = true;
		function cb() {
			onDone.call(_root, node);
		}
		Tweener.addTween(this, {_alpha:op, time:.3, transition:"easeOutCirc", onComplete:cb});
	}
	public function hide() {
		if (this._alpha == 0 && !this._visible) {
			return;
		}
		function cb() {
			this._visible = false;
			overlayOn = false;
		}
		Tweener.addTween(this, {_alpha:0, time:.3, transition:"easeInCirc", onComplete:cb});
	}
	private function onPress() {
	}
}
