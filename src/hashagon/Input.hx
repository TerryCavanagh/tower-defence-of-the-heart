package hashagon;

import hxd.Key;

class Input{
	public static function pressed(k:Int):Bool {
		if (Key.isDown(k)) {
			return true;
		}
		return false;
	}

	public static function justpressed(k:Int):Bool {
		if (Key.isPressed(k)) {
			return true;
		}
		return false;
	}

	public static function justreleased(k:Int):Bool {
		if (Key.isReleased(k)) {
			return true;
		}
		return false;
	}
}