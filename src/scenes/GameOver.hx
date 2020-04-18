package scenes;

import hashagon.*;
import engine.*;
import hxd.Key;

@:keep
class GameOver{
	public static function init(){
	}
	
	public static function update() {		
    Gfx.fillbox(0, 0, Gfx.screenwidth, Gfx.screenheight, Col.BLACK);
    Text.align = Text.CENTER;
    Text.display(Gfx.screenwidthmid, Gfx.screenheightmid, "Game Over :(", Col.RED);
	}

	public static function cleanup(){
	}
}