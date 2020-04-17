package hashagon.displayobject;

class Quad{
  public function new(){
    graphics = new h2d.Graphics();
    disposed = false;
    attached = false;
  }

  public function _draw(){
    if(!attached){
      Gfx.core.s2d.addChild(graphics);
      attached = true;
    }else{
      Gfx.core.s2d.removeChild(graphics);
      Gfx.core.s2d.addChild(graphics);
    }
  }

  public function setpixel(x:Float, y:Float, col:Int, alpha:Float = 1.0) {
    if(disposed) return;
    if (col == Col.TRANSPARENT) return;
    
    graphics.beginFill(col, alpha);
    graphics.drawRect(x, y, 1, 1);
    graphics.endFill();

    _draw();
  }

  public function fillbox(x:Float, y:Float, width:Float, height:Float, col:Int, alpha:Float = 1.0) {
    if(disposed) return;
    if (col == Col.TRANSPARENT) return;
    
    graphics.beginFill(col, alpha);
    graphics.drawRect(x, y, width, height);
    graphics.endFill();

    _draw();
  }

  public function drawbox_update(x:Float, y:Float, width:Float, height:Float, col:Int, alpha:Float = 1.0) {
    if(disposed) return;

    graphics.moveTo(x, y);
    graphics.beginFill(col, alpha);
    graphics.drawRect(x, y, width, Gfx.linethickness);
    graphics.drawRect(x, y + height - Gfx.linethickness, width, Gfx.linethickness);
    graphics.drawRect(x, y + Gfx.linethickness, Gfx.linethickness, height - (Gfx.linethickness * 2));
    graphics.drawRect(x + width - Gfx.linethickness, y + Gfx.linethickness, Gfx.linethickness, height - (Gfx.linethickness * 2));
    graphics.endFill();
  }

  public function drawbox(x:Float, y:Float, width:Float, height:Float, col:Int, alpha:Float = 1.0) {
    if(disposed) return;
    if (col == Col.TRANSPARENT) return;
    
    drawbox_update(x, y, width, height, col, alpha);
    
    _draw();
  }
  
  public function dispose(){
    disposed = true;
    Gfx.core.s2d.removeChild(graphics);
  }

  public var graphics:h2d.Graphics;
  public var attached:Bool;
  public var disposed:Bool;
}