package hashagon.displayobject;

class Image{
	public function new(){
		bitmap = null;
		attached = false;
		disposed = false;
	}

	public function drawimage(x:Float, y:Float, imagename:String){
		if (!Gfx.imageindex.exists(imagename)) {
			Gfx.loadimage(imagename);
			//throw("Error: \"" + imagename + "\" is not loaded.");
		}
		
		if(bitmap == null){
			bitmap = new h2d.Bitmap(Gfx.imageindex.get(imagename));
		}

		bitmap.x = x;
		bitmap.y = y;

		if(!attached){
			Gfx.core.s2d.addChild(bitmap);
			attached = true;
		}else{
			Gfx.core.s2d.removeChild(bitmap);
			Gfx.core.s2d.addChild(bitmap);
		}
	}

	public function dispose(){
		disposed = true;
		Gfx.core.s2d.removeChild(bitmap);
		bitmap = null;
	}

	public var bitmap:h2d.Bitmap;
	public var attached:Bool;
	public var disposed:Bool;
}