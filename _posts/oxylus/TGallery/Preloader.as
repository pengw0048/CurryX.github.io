import caurina.transitions.Tweener;
class oxylus.TGallery.Preloader extends MovieClip {
	public function Preloader() {
		this._alpha = 0;
		this._visible = false;
	}
	public function pStart() {
		this._visible = true;
		Tweener.addTween(this, {_alpha:100, time:.8, transition:"linear"});
		this.onEnterFrame = rotate;
	}
	public function pStop() {
		Tweener.removeTweens(this);
		delete this.onEnterFrame;
		this._alpha = 0;
		this._visible = false;
	}
	private function rotate() {
		this._rotation += 8;
	}
}
