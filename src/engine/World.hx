package engine;

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
		contents_tile = null;
		width = 0;
		height = 0;
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
		contents_tile = Core.create2darray(width, height, null);
		for(j in 0 ... height){
			for(i in 0 ... width){
				contents_tile[i][j] = new Tile();
			}
		}
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
	
	public function render(camera:Camera){
		camera.update();
		
		var xpos:Int = -Std.int(gridxoffset(camera.x));
		var ypos:Int = -Std.int(gridyoffset(camera.y));
		var i:Int = gridx(camera.x);
		var j:Int = gridy(camera.y);
		
		while (ypos < Gfx.screenheight + (tileheight * 2)){
			while (xpos < Gfx.screenwidth + (tilewidth * 2)){
				if (Geom.inbox(i, j, 0, 0, width, height)){
					contents_tile[i][j].drawtile(xpos, ypos, tileset, contents[i][j]);
					
					if (collidable[contents[i][j]]){
						//Gfx.drawbox(xpos, ypos, tilewidth, tileheight, Col.WHITE, "" + (id++));
					}
				}
				
				i++;
				xpos += tilewidth;
			}
			
			xpos = -Std.int(gridxoffset(camera.x)); i = gridx(camera.x);
			j++;
		  ypos += tileheight;	
		}
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
	public var contents_tile:Array<Array<Tile>>;
	public var width:Int;
	public var height:Int;
	
	public var collidable:Array<Bool>;
	
	public var tileset:String;
	public var tilewidth:Int;
	public var tileheight:Int;
	
	public var outsidetile:Int;
}