import h2d.Interactive;
import hashagon.displayobject.*;
import hashagon.*;

class SimpleButton extends h2d.Object{
  public function new(_type:ButtonType, position:Int, _parent:h2d.Object){
    super();
    _parent.addChild(this);

    type = _type;
    x = 3;
    y = 2 + (position * 20);

    pressed = false;

    buttonbacking = new h2d.Graphics(this);

    var tileset:Tileset = Gfx.gettileset("towers");
    icon = new h2d.Anim(tileset.tiles, 0, this);
    switch (type){
      case ButtonType.LASER:
        icon.currentFrame = 12;
      case ButtonType.BEAM:
        icon.currentFrame = 18;
      case ButtonType.VORTEX:
        icon.currentFrame = 6;
      case ButtonType.SHOOTY:
        icon.currentFrame = 0;
      case ButtonType.UPGRADE:
        icon.currentFrame = 42;
      case ButtonType.SELL:
        icon.currentFrame = 43;
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
    if(Game.cursormode == type) pressed = true;
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
  public var type:ButtonType;

  public var pressed:Bool;
}