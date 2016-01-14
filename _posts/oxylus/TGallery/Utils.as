class oxylus.TGallery.Utils {
	public static function TFem(tf:TextField) {
		return Math.round(tf._width/2-tf.textWidth/2);
	}
	public static function mcPlay(mc:MovieClip, f:Number) {
		if (f == 0) {
			f = mc._totalframes;
		}
		mc.onEnterFrame = function() {
			var cf:Number = this._currentframe;
			if (cf == f) {
				delete this.onEnterFrame;
			} else if (cf<f) {
				this.nextFrame();
			} else {
				this.prevFrame();
			}
		};
	}
	public static function JSAlert(str:String) {
		var alert:String = "javascript:alert('"+str+"');";
		getURL(alert);
	}
	public static function getExt(str:String):String {
		var pieces:Array = str.split(".");
		return pieces[pieces.length-1];
	}
	public static function get baseURL():String {
		var SWFPath:String = _root._url;
		var pieces:Array = SWFPath.split("/");
		var base:String = "";
		for (var i = 0; i<pieces.length-1; i++) {
			base += pieces[i]+"/";
		}
		return base;
	}
	public static function TFwem(tf:TextField) {
		return Math.ceil(tf._width/2-tf.textWidth/2);
	}
	public static function TFhem(tf:TextField) {
		return Math.round(tf._height/2-tf.textHeight/2);
	}
	
}
