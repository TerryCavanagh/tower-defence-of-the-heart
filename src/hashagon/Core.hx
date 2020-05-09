package hashagon;

import haxe.Constraints.Function;
import haxe.Timer;

@:access(Scene)
class Core extends hxd.App {
  override function init() {
		super.init();
		Gfx.core = this;
		Text.core = this;
		assetsloaded = false;

		#if manifestfs
		var loader:cherry.res.ManifestLoader = cherry.fs.ManifestBuilder.initManifest("data");
		cherry.res.ManifestLoader.concurrentFiles = 4;
		var preloader = new TerryManifestProgress(loader, Col.BLACK, completeinit, s2d);
		preloader.start();
		#else
		hxd.Res.initEmbed();
    completeinit();
		#end
	}

	function completeinit(){
		//s2d.scaleMode = Stretch(1280, 720);
		hxd.Res.initEmbed();
		//s2d.scaleMode = LetterBox(320, 180, false);
		//s2d.scaleMode = LetterBox(240, 135, false);
		s2d.scaleMode = LetterBox(200, 120, false);
		
		Text.init();
		Gfx.init();
		Sound.init();
		Music.init();
		Random.seed = 0;

		deltatime = 0;
		Scene.init();
		assetsloaded = true;
	}
	
	// on each frame
	override function update(dt:Float) {
		//if (Gfx.clearcolor != Col.TRANSPARENT) Gfx.clearscreen(Gfx.clearcolor);
		deltatime = dt;
		if(assetsloaded) Scene.update();
	}
	
	public static function delaycall(f:Function, time:Float) {
		Timer.delay(function() { f(); }, Std.int(time * 1000));	
	}
	
	public static function cleanup(){
		Text.cleanup();
		Gfx.cleanup();
	}
	
	@:generic
	public static function create2darray<T>(width:Int, height:Int, value:T):Array<Array<T>> {
		return [for (x in 0 ... width) [for (y in 0 ... height) value]];
	}
	
	public static var deltatime:Float;
	public static var assetsloaded:Bool;
}