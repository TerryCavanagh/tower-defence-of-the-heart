package engine;

import hashagon.*;

enum CameraMode{
	FOLLOWENTITY;
	FREE;
}

class Camera{
	public function new(){
		x = 0;
		y = 0;
		mode = FREE;
		
		bounds = new Rectangle( -1, -1, -1, -1);
		centerx = false;
		centery = false;
	}	
	
	public function setbounds(w:World){
		setpointbounds(0, 0, 
		  (w.width * w.tilewidth) - Gfx.screenwidth, 
			(w.height * w.tileheight) - Gfx.screenheight);
	}
	
	public function setpointbounds(_x:Float, _y:Float, _width:Float, _height:Float){
		bounds.setTo(_x, _y, _width, _height);
	}
	
	public function update(){
		if (mode == FREE){
			//Just make sure the coordinates are in bounds.
			if (bounds.x != -1){
				if (x < bounds.x) x = bounds.x;
			}
			
			if (bounds.width != -1){
				if (x > bounds.width) x = bounds.width;
			}
			
			if (bounds.y != -1){
				if (y < bounds.y) y = bounds.y;
			}
			
			if (bounds.height != -1){
				if (y > bounds.height) y = bounds.height;
			}
		}
	}
	
	public var x:Float;
	public var y:Float;
	
	public var centerx:Bool;
	public var centery:Bool;
	
	public var bounds:Rectangle;
	public var mode:CameraMode;
}