import hashagon.*;

class UIPanel extends h2d.Object{
  public function new(){
    super();

    x = Gfx.screenwidth - 20;

    //Panel backing
    panelbacking = new h2d.Graphics();
    panelbacking.beginFill(Col.BLACK);
    panelbacking.drawRect(-1, 0, 1, Gfx.screenheight);
    panelbacking.endFill();
    panelbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.5));
    panelbacking.drawRect(0, 0, 20, Gfx.screenheight);
    panelbacking.endFill();
    
    panelbacking.beginFill(Col.BLACK);
    panelbacking.drawRect(-21, Gfx.screenheight - 14, 41, 21);
    panelbacking.endFill();
    
    panelbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.5));
    panelbacking.drawRect(-20, Gfx.screenheight - 13, 40, 20);
    panelbacking.endFill();
    addChild(panelbacking);

    var interaction:h2d.Interactive = new h2d.Interactive(20, Gfx.screenheight, this);

    //Buttons
    buttons = [];
    addbutton(ButtonType.LASER);
    addbutton(ButtonType.BEAM);
    addbutton(ButtonType.SHOOTY);
    addbutton(ButtonType.VORTEX);
    addbutton(ButtonType.UPGRADE);
    addbutton(ButtonType.SELL);

    //Cash display
    
    cashdisplay = new h2d.Text(Game.numberfont, this);
    cashdisplay.x = 18;
    cashdisplay.y = Gfx.screenheight - 10;
    cashdisplay.textAlign = Right;
    cashdisplay.text = "$" + Game.gold;
    cashdisplay.textColor = Col.YELLOW;
    
    mouseover = false;
  }

  public function updatecashdisplay(){
    cashdisplay.text = "$" + Game.gold;
  }

  public function updateallbuttons(){
    for(b in buttons){
      b.checkpressed();
      b.updatebutton();
    }
  }

  public function addbutton(type:ButtonType){
    var newbutton:SimpleButton = new SimpleButton(type, buttons.length, this);
    buttons.push(newbutton);
  }

  public var panelbacking:h2d.Graphics;

  public var buttons:Array<SimpleButton>;
  
  public var cashdisplay:h2d.Text;

  public var mouseover:Bool;
}