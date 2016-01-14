class oxylus.TGallery.TimeDisplay extends MovieClip {
	private var TFTotal:TextField;
	private var TFElapsed:TextField;
	private var tot:Number = 0;
	private var elp:Number = 0;
	public function TimeDisplay() {
		TFTotal = eval(this._target+"/b");
		TFElapsed = eval(this._target+"/a");
		TFTotal.autoSize = "left";
		TFElapsed.autoSize = "right";
		reset();
	}
	private function updateTotal() {
		var min:Number = getMin(tot);
		var sec:Number = getSec(tot);
		TFTotal.text = format(min)+":"+format(sec);
	}
	private function updateElapsed() {
		var min:Number = getMin(elp);
		var sec:Number = getSec(elp);
		TFElapsed.text = format(min)+":"+format(sec);
	}
	private function format(val:Number):String {
		if (val>=10) {
			return String(val);
		}
		return String("0"+val);
	}
	private function getMin(val:Number):Number {
		return Math.floor(val/60);
	}
	private function getSec(val:Number):Number {
		return Math.round(val)%60;
	}
	public function set total(ntot:Number) {
		tot = ntot;
		updateTotal();
	}
	public function get total():Number {
		return tot;
	}
	public function set elapsed(nelp:Number) {
		elp = nelp;
		updateElapsed();
	}
	public function get elapsed():Number {
		return elp;
	}
	public function reset() {
		total = elapsed=0;
	}
}
