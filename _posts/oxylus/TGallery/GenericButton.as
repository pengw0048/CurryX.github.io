import caurina.transitions.Tweener;
class oxylus.TGallery.GenericButton extends MovieClip {
	private var op:Number = 60;
	private var t:Number = .3;
	private var states:Number;
	private var ref:MovieClip;
	public var onClick:Function;
	private var _master:Object;
	private var _tip:String;
	public function GenericButton() {
		_master = this;
		this.stop();
		this._alpha = op;
		ref = eval(this._target);
		states = this._totalframes>=2 ? 2 : 1;
	}
	private function onRollOver() {
		Tweener.addTween(ref, {_alpha:100, time:t, transition:"linear", rounded:true});
		if (_tip != undefined) {
			_global.TOOLTIP.show(_tip);
		}
	}
	private function onRollOut() {
		Tweener.addTween(ref, {_alpha:op, time:t, transition:"linear", rorunded:true});
		if (_tip != undefined) {
			_global.TOOLTIP.hide();
		}
	}
	private function onReleaseOutside() {
		onRollOut();
	}
	private function onRelease() {
		this.gotoAndStop(1+Math.abs(this._currentframe-states));
		onClick.call(_master, this._currentframe);
	}
	public function set state(n:Number) {
		this.gotoAndStop(n);
	}
	public function get state():Number {
		return this._currentframe;
	}
	public function set master(o:Object) {
		_master = o;
	}
	public function set tip(str:String) {
		_tip = str;
	}
	public function get tip():String {
		return _tip;
	}
}
