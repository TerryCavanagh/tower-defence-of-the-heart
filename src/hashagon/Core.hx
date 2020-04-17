package hashagon;

import haxe.Constraints.Function;
import haxe.Timer;

@:access(Scene)
class Core extends hxd.App {
  override function init() {
    //s2d.scaleMode = Stretch(1280, 720);
    hxd.Res.initEmbed();
    s2d.scaleMode = LetterBox(320, 180, false);
    Text.init(this);
    Gfx.init(this);
    Sound.init();
    Music.init();
    Random.seed = 0;

    deltatime = 0;
		Scene.init();
	}
	
	// on each frame
	override function update(dt:Float) {
    //if (Gfx.clearcolor != Col.TRANSPARENT) Gfx.clearscreen(Gfx.clearcolor);
    deltatime = dt;
    Scene.update();
  }
  
	public static function delaycall(f:Function, time:Float) {
	  Timer.delay(function() { f(); }, Std.int(time * 1000));	
  }
  
  public static function cleanup(){
		Text.cleanup();
		Gfx.cleanup();
  }

  public static var deltatime:Float;
}