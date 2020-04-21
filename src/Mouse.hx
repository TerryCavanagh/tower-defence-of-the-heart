import hashagon.*;
import hxd.Key;

class Mouse{
	public static var x(get, null):Float;
	public static function get_x(){
		return Gfx.core.s2d.mouseX;
	}
	
	public static var y(get, null):Float;
	public static function get_y(){
		return Gfx.core.s2d.mouseY;
	}

	public static function leftheld():Bool {
		if (Key.isDown(Key.MOUSE_LEFT)) {
			return true;
		}
		return false;
	}

	public static function leftclick():Bool {
		if (Key.isPressed(Key.MOUSE_LEFT)) {
			return true;
		}
		return false;
	}

	public static function leftreleased():Bool {
		if (Key.isReleased(Key.MOUSE_LEFT)) {
			return true;
		}
		return false;
	}
}