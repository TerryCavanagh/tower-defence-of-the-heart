package engine;

import h2d.TileGroup;
import hashagon.displayobject.*;
import hashagon.*;

class World{
	public function new(){
		init();
	}
	
	public function init(){
		tileset = "";
		tilewidth = 0;
		tileheight = 0;
		outsidetile = 0;
		
		contents = null;
		width = 0;
		height = 0;
		tilegroup = null;
	}
	
	public function loadtiles(_tilesetname:String, _w:Int, _h:Int){
		tileset = _tilesetname;
		tilewidth = _w;
		tileheight = _h;
		Gfx.loadtiles(_tilesetname, _w, _h);
		
		collidable = [];
		for (i in 0 ... Gfx.numberoftiles(tileset)){
			collidable[i] = false;
		}
	}
	
	public function setcollidable(collidabletiles:Array<Int>){
		for (i in 0 ... Gfx.numberoftiles(tileset)){
			if(collidabletiles.indexOf(i) > -1){
				collidable[i] = true;
			}
		}
	}
	
	public function changesize(_w:Int, _h:Int){
		width = _w;
		height = _h;
		contents = Core.create2darray(width, height, 0);
	}
	
	public function randomcontents(_w:Int, _h:Int){
		changesize(_w, _h);
		
		var numtiles:Int = Gfx.numberoftiles(tileset);
		for (j in 0 ... _h){
			for (i in 0 ... _w){
				contents[i][j] = Random.int(0, numtiles - 1);
			}
		}
	}

	public function refreshmap(){
		var tileset:Tileset = Gfx.gettileset(tileset);
		tilegroup = new TileGroup(tileset.tilesetdata);
		for(j in 0 ... height){
			for(i in 0 ... width){
				tilegroup.add(i * tilewidth, j * tileheight, tileset.tiles[contents[i][j]]);
			}
		}
		Gfx.core.s2d.addChild(tilegroup);
	}
	
	public function render(camera:Camera){
		camera.update();
		tilegroup.x = -camera.x;
		tilegroup.y = -camera.y;
	}
	
	public function gridx(pixelx:Float):Int{
		return Std.int((pixelx - (Std.int(pixelx) % tilewidth)) / tilewidth);
	}
	
	public function gridy(pixely:Float):Int{
		return Std.int((pixely - (Std.int(pixely) % tileheight)) / tileheight);
	}
	
	public function gridxoffset(pixelx:Float):Float{
		return pixelx - (gridx(pixelx) * tilewidth);
	}
	
	public function gridyoffset(pixely:Float):Float{
		return pixely - (gridy(pixely) * tileheight);
	}
	
	public var contents:Array<Array<Int>>;
	public var tilegroup:h2d.TileGroup;
	public var width:Int;
	public var height:Int;
	
	public var collidable:Array<Bool>;
	
	public var tileset:String;
	public var tilewidth:Int;
	public var tileheight:Int;
	
	public var outsidetile:Int;
}