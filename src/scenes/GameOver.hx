package scenes;

import hashagon.*;
import engine.*;
import hxd.Key;

@:keep
class GameOver{
	public static function init(){
		gameoverscreen = new h2d.Anim([Gfx.getimage("gameoverscreen")], 0);
		Gfx.core.s2d.addChild(gameoverscreen);
		Sound.play("nextwave");
	}
	
	public static function update() {
	}

	public static function cleanup(){
	}

	public static var gameoverscreen:h2d.Anim;
}