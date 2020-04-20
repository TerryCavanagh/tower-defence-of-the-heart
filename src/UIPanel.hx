import hashagon.*;

class UIPanel extends h2d.Object{
  public function new(){
    super();

    x = Gfx.screenwidth - 20;

    //Panel backing
    panelbacking = new h2d.Graphics();
    panelbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.5));
    panelbacking.drawRect(0, 0, 20, Gfx.screenheight);
    panelbacking.endFill();
    addChild(panelbacking);
    
    var interaction:h2d.Interactive = new h2d.Interactive(20, Gfx.screenheight, this);

    //Buttons
    buttons = [];
    addbutton("Laser");
    addbutton("Beam");
    addbutton("Shooty");
    addbutton("Vortex");

    mouseover = false;
    interaction.onOver = function(event : hxd.Event) {
      mouseover = true;
    }

    interaction.onOut = function(event : hxd.Event) {
      mouseover = false;
    }
  }

  public function updateallbuttons(){
    for(b in buttons){
      b.checkpressed();
      b.updatebutton();
    }
  }

  public function addbutton(type:String){
    var newbutton:SimpleButton = new SimpleButton(type, buttons.length, this);
    buttons.push(newbutton);
  }

  public var panelbacking:h2d.Graphics;

  public var buttons:Array<SimpleButton>;

  public var mouseover:Bool;
}