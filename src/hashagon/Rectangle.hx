package hashagon;

//Quick reimplementation/copy of Lime/OpenFL's rectangle class that could probably
//be improved a lot
class Rectangle{
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0){
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public function setTo(xa:Float, ya:Float, widtha:Float, heighta:Float){
		x = xa;
		y = ya;
		width = widtha;
		height = heighta;
	}

	public function intersects(toIntersect:Rectangle):Bool{
		var x0 = x < toIntersect.x ? toIntersect.x : x;
		var x1 = right > toIntersect.right ? toIntersect.right : right;

		if (x1 <= x0){
			return false;
		}

		var y0 = y < toIntersect.y ? toIntersect.y : y;
		var y1 = bottom > toIntersect.bottom ? toIntersect.bottom : bottom;

		return y1 > y0;
	}

	public function clone():Rectangle{
		return new Rectangle(x, y, width, height);
	}
	
	/**
		Returns whether this rectangle contains the specified (x, y) point
		@param	x	The x coordinate to test
		@param	y	The y coordinate to test
		@return	Whether the point is contained in the rectangle
	**/
	public function contains(x:Float, y:Float):Bool{
		return x >= this.x && y >= this.y && x < right && y < bottom;
	}

	public var left(get, set):Float;
	@:noCompletion private function get_left():Float{
		return x;
	}
	
	@:noCompletion private function set_left(l:Float):Float{
		width -= l - x;
		x = l;
		return l;
	}

	public var right(get, set):Float;
	@:noCompletion private function get_right():Float{
		return x + width;
	}

	@:noCompletion private function set_right(r:Float):Float{
		width = r - x;
		return r;
	}

	public var top(get, set):Float;
	@:noCompletion private function get_top():Float{
		return y;
	}

	@:noCompletion private function set_top(t:Float):Float{
		height -= t - y;
		y = t;
		return t;
	}

	public var bottom(get, set):Float;
	@:noCompletion private function get_bottom():Float{
		return y + height;
	}
	
	@:noCompletion private function set_bottom(b:Float):Float{
		height = b - y;
		return b;
	}

	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
}