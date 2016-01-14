import oxylus.TGallery.Utils;
class oxylus.TGallery.XMLData extends XML {
	public var onXMLLoadSuccess:Function;
	public var onXMLLoadFailure:Function;
	public function XMLData(url:String) {
		this.ignoreWhite = true;
		this.load(url);
	}
	private function onLoad(s:Boolean) {
		if (!s) {
			Utils.JSAlert("Could not load XML file !");
			onXMLLoadFailure.call(this, status);
		} else {
			if (status<0) {
				Utils.JSAlert("Could not load/parse XML !");
				onXMLLoadFailure.call(this, status);
			} else {
				onXMLLoadSuccess.call(this, this.firstChild);
			}
		}
	}
	public function get root():XMLNode{
		return this.firstChild;
	}
}
