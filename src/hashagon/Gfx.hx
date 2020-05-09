package hashagon;

import hashagon.displayobject.*;

class Gfx{
	public static function init(){
		graphicsmap = new Map<String, Quad>();
		imagemap = new Map<String, Image>();
		imageindex = new Map<String, h2d.Tile>();
		
		tilemap = new Map<String, Tile>();
		tileindex = new Map<String, Tileset>();

		clearbuffer = new Quad();
		linethickness = 1;
	}

	/** Loads an image into the game. */
	public static function loadimage(imagename:String):Bool {
		imagename = imagename.toLowerCase();
		if (imageindex.exists(imagename)) return true; //This is already loaded, so we're done!
		
		//We're just gonna assume this exists already
		var newtile:h2d.Tile = hxd.Res.load("graphics/" + imagename + ".png").toTile();
		imageindex.set(imagename, newtile);
		
		return true;
	}

	public static function loadtiles(imagename:String, width:Int, height:Int):Bool {
		imagename = imagename.toLowerCase();
		if (tileindex.exists(imagename)) return true; //This is already loaded, so we're done!
		
		//We're just gonna assume this exists already
		var newtileset:Tileset = new Tileset(imagename, width, height);
		tileindex.set(imagename, newtileset);
		
		return true;
	}

	public static function numberoftiles(tileset:String):Int {
		return gettileset(tileset).numtiles;
	}
	
	public static function gettileset(tileset:String):Tileset{
		return tileindex.get(tileset);
	}

	public static function getimage(imagename:String):h2d.Tile{
		return imageindex.get(imagename);
	}

	public static function drawtile(x:Float, y:Float, tilesetname:String, tilenum:Int, id:String = "", ?pos:haxe.PosInfos){
		if(id == "") id = pos.fileName + "_" + pos.lineNumber;

		var t:Tile;
		if (tilemap.exists(id)){
			t = tilemap.get(id);
		}else{
			t = new Tile();
			tilemap.set(id, t);
		}

		t.drawtile(x, y, tilesetname, tilenum);
	}

	public static function drawimage(x:Float, y:Float, imagename:String, id:String = "", ?pos:haxe.PosInfos){
		if(id == "") id = pos.fileName + "_" + pos.lineNumber;

		var img:Image;
		if (imagemap.exists(id)){
			img = imagemap.get(id);
			core.s2d.removeChild(img.bitmap);
		}else{
			img = new Image();
			imagemap.set(id, img);
		}

		img.drawimage(x, y, imagename);
	}

	public static function fillbox(x:Float, y:Float, width:Float, height:Float, col:Int, alpha:Float = 1.0, id:String = "", ?pos:haxe.PosInfos) {
		if(id == "") id = pos.fileName + "_" + pos.lineNumber;

		var box:Quad;
		if (graphicsmap.exists(id)){
			box = graphicsmap.get(id);
			core.s2d.removeChild(box.graphics);
		}else{
			box = new Quad();
			graphicsmap.set(id, box);
		}

		box.fillbox(x, y, width, height, col, alpha);
	}

	public static function drawbox(x:Float, y:Float, width:Float, height:Float, col:Int, alpha:Float = 1.0, id:String = "", ?pos:haxe.PosInfos) {
		if(id == "") id = pos.fileName + "_" + pos.lineNumber;

		var box:Quad;
		if (graphicsmap.exists(id)){
			box = graphicsmap.get(id);
			box.drawbox_update(x, y, width, height, col, alpha);
		}else{
			box = new Quad();
			graphicsmap.set(id, box);
			box.drawbox(x, y, width, height, col, alpha);
		}
	}

	public static function drawcircle(x:Float, y:Float, radius:Float, col:Int, alpha:Float = 1.0, id:String = "", ?pos:haxe.PosInfos) {
		if(id == "") id = pos.fileName + "_" + pos.lineNumber;

		var circle:Quad;
		if (graphicsmap.exists(id)){
			circle = graphicsmap.get(id);
			circle.drawcircle(x, y, radius, col, alpha);
		}else{
			circle = new Quad();
			graphicsmap.set(id, circle);
			circle.drawcircle(x, y, radius, col, alpha);
		}
	}

	public static function setpixel(x:Float, y:Float, col:Int, alpha:Float = 1.0, id:String = "", ?pos:haxe.PosInfos) {
		if(id == "") id = pos.fileName + "_" + pos.lineNumber;

		var box:Quad;
		if (graphicsmap.exists(id)){
			box = graphicsmap.get(id);
			core.s2d.removeChild(box.graphics);
		}else{
			box = new Quad();
			graphicsmap.set(id, box);
		}

		box.setpixel(x, y, col, alpha);
	}

	public static function clearscreen(color:Int = 0x000000) {
		if (color != Col.TRANSPARENT){
			clearbuffer.fillbox(0, 0, screenwidth, screenheight, color);
		}
	}

	public static function cleanup(){
		if(graphicsmap != null){
			for (k in graphicsmap.keys()){
				graphicsmap.get(k).dispose();
				graphicsmap.remove(k);
			}
		}
		
		if(tilemap != null){
			for (k in tilemap.keys()){
				tilemap.get(k).dispose();
				tilemap.remove(k);
			}
		}
		
		if(imagemap != null){
			for (k in imagemap.keys()){
				imagemap.get(k).dispose();
				imagemap.remove(k);
			}
		}
	}

	public static var linethickness(get,set):Float;
	private static var _linethickness:Float;

	static function get_linethickness():Float {
		return _linethickness;
	}

	static function set_linethickness(size:Float) {
		_linethickness = size;
		if (_linethickness < 1) _linethickness = 1;
		return _linethickness;
	}
	
	public static var imageindex:Map<String, h2d.Tile>;
	public static var tileindex:Map<String, Tileset>;

	public static var screenwidth(get, null):Int;
	@:noCompletion private static function get_screenwidth():Int{ return core.s2d.width; }
	public static var screenheight(get, null):Int;
	@:noCompletion private static function get_screenheight():Int{ return core.s2d.height; }
	public static var screenwidthmid(get, null):Int;
	@:noCompletion private static function get_screenwidthmid():Int{ return Std.int(core.s2d.width / 2); }
	public static var screenheightmid(get, null):Int;
	@:noCompletion private static function get_screenheightmid():Int{ return Std.int(core.s2d.height / 2); }
	
	public static var core:Core;
	private static var graphicsmap:Map<String, Quad>;
	private static var imagemap:Map<String, Image>;
	private static var tilemap:Map<String, Tile>;
	private static var clearbuffer:Quad;

	public static var clearcolor:Int = 0x000000;
}