package hashagon.displayobject;

class Tile{
	public function new(){
		attached = false;
		tilesetattached = false;
		currenttileset = null;
		disposed = false;
	}

	public function drawtile(x:Float, y:Float, tilesetname:String, tilenum:Int){
		if(disposed) return;
		//No bounds checking for ludum dare!
		if(!tilesetattached){
			currenttileset = Gfx.tileindex.get(tilesetname);
			currentanim = new h2d.Anim(currenttileset.tiles, 0);
			tilesetattached = true;
		}

		currentanim.x = x;
		currentanim.y = y;
		currentanim.currentFrame = tilenum;

		if(!attached){
			Gfx.core.s2d.addChild(currentanim);
			attached = true;
		}
	}

	public function reattach(){
		if(!attached){
			Gfx.core.s2d.addChild(currentanim);
			attached = true;
		}else{
			Gfx.core.s2d.removeChild(currentanim);
			Gfx.core.s2d.addChild(currentanim);
		}
	}

	public function dispose(){
		disposed = true;
		Gfx.core.s2d.removeChild(currentanim);
		currentanim = null;
	}

	public var currentanim:h2d.Anim;
	public var currenttileset:Tileset;
	public var tilesetattached:Bool;
	public var attached:Bool;
	public var disposed:Bool;
}