package hashagon.displayobject;

class TextField{
  public function new(){
    //var font : h2d.Font = hxd.res.DefaultFont.get();
    var font:h2d.Font = hxd.Res.special.toFont();
    tf = new h2d.Text(font);
    disposed = false;
  }

  public function update(x:Float, y:Float, text:Dynamic, color:Int = 0xFFFFFF, alpha:Float = 1.0){
    if(disposed) return;

    if (Std.is(text, Array)){
			text = text.toString();
		}else if (!Std.is(text, String)){
			text = Std.string(text);
    }
    
    tf.x = x;
    tf.y = y;
    tf.text = text;
    tf.textColor = color;
    tf.alpha = alpha;
    tf.setScale(Text.size);
    if(Text.align == Text.LEFT) tf.textAlign = Left;
    if(Text.align == Text.CENTER) tf.textAlign = Center;
    if(Text.align == Text.RIGHT) tf.textAlign = Right;
  }

  public function display(){
    if(disposed) return;
    Text.core.s2d.addChild(tf);
  }

  public function dispose(){
    disposed = true;
    Text.core.s2d.removeChild(tf);
    tf = null;
  }

  public var tf:h2d.Text;
  public var disposed:Bool;
}