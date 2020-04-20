import h2d.Interactive;
import hashagon.displayobject.*;
import hashagon.*;

class SimpleButton extends h2d.Object{
  public function new(type:String, position:Int, _parent:h2d.Object){
    super();
    _parent.addChild(this);

    this.type = type;
    x = 3;
    y = 2 + (position * 20);

    pressed = false;

    buttonbacking = new h2d.Graphics(this);

    var tileset:Tileset = Gfx.gettileset("towers");
    icon = new h2d.Anim(tileset.tiles, 0, this);
    switch (type){
      case "Laser":
        icon.currentFrame = 12;
      case "Beam":
        icon.currentFrame = 18;
      case "Vortex":
        icon.currentFrame = 6;
      case "Shooty":
        icon.currentFrame = 0;
    }

    checkpressed();
    updatebutton();

    var interaction:h2d.Interactive = new h2d.Interactive(14, 14, this);

    interaction.onOver = function(event : hxd.Event) {
      icon.alpha = 0.7;
      buttonbacking.alpha = 0.7;
      Game.uipanel.mouseover = true;
    }

    interaction.onOut = function(event : hxd.Event) {
      icon.alpha = 1.0;
      buttonbacking.alpha = 1.0;
    }

    interaction.onClick = function(event : hxd.Event) {
      Game.changeselectedmode(type);
    }
  }

  public function checkpressed(){
    pressed = false;
    if(Game.cursormode == CursorMode.PLACETOWER_LASER && type == "Laser") pressed = true;
    if(Game.cursormode == CursorMode.PLACETOWER_BEAM && type == "Beam") pressed = true;
    if(Game.cursormode == CursorMode.PLACETOWER_VORTEX && type == "Vortex") pressed = true;
    if(Game.cursormode == CursorMode.PLACETOWER_SHOOTY && type == "Shooty") pressed = true;
  }

  public function updatebutton(){
    if(pressed){
      buttonbacking.clear();
      buttonbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.75));
      buttonbacking.drawRect(0, 14, 14, 2);
      buttonbacking.endFill();
      buttonbacking.beginFill(Col.multiplylightness(Col.GREEN, 1.2));
      buttonbacking.drawRect(0, 1, 14, 14);
      buttonbacking.endFill();

      icon.x = 2; icon.y = 3;
    }else{
      buttonbacking.clear();
      buttonbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.75));
      buttonbacking.drawRect(0, 14, 14, 2);
      buttonbacking.endFill();
      buttonbacking.beginFill(Col.GREEN);
      buttonbacking.drawRect(0, 0, 14, 14);
      buttonbacking.endFill();

      icon.x = 2; icon.y = 2;
    }
  }

  public var buttonbacking:h2d.Graphics;
  public var icon:h2d.Anim;
  public var type:String;

  public var pressed:Bool;
}