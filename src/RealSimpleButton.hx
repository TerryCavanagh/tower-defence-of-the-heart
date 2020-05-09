import h2d.Interactive;
import hashagon.displayobject.*;
import hashagon.*;
import haxe.Constraints.Function;

class RealSimpleButton extends h2d.Object{
	public function new(text:String, position:Int, onclick:Function, _parent:h2d.Object){
		super();
		_parent.addChild(this);
		x = Gfx.screenwidthmid - 40;
		y = position;

    buttonbacking = new h2d.Graphics(this);
    buttonbacking.moveTo(x, y);
    buttonbacking.clear();
    buttonbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.75));
    buttonbacking.drawRect(0, 2, 80, 11);
    buttonbacking.endFill();
    buttonbacking.beginFill(Col.GREEN);
    buttonbacking.drawRect(0, 0, 80, 11);
    buttonbacking.endFill();

    buttontext = new h2d.Text(Game.smallfont, this);
    buttontext.x = 40;
		buttontext.y = -2;
		buttontext.textAlign = Center;
    buttontext.text = text;
    buttontext.textColor = Col.WHITE;
    
		var interaction:h2d.Interactive = new h2d.Interactive(80, 14, this);

		interaction.onOver = function(event : hxd.Event) {
      //buttonbacking.alpha = 0.5;
      redraw_over();
		}

		interaction.onOut = function(event : hxd.Event) {
			//buttonbacking.alpha = 1.0;
      redraw_out();
		}

		interaction.onClick = function(event : hxd.Event) {
      onclick();
		}
	}

  public function redraw_out(){
    buttonbacking.clear();
    buttonbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.75));
    buttonbacking.drawRect(0, 2, 80, 11);
    buttonbacking.endFill();
    buttonbacking.beginFill(Col.GREEN);
    buttonbacking.drawRect(0, 0, 80, 11);
    buttonbacking.endFill();

    buttontext.y = -2;
  }

  public function redraw_over(){
    buttonbacking.clear();
    buttonbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.75));
    buttonbacking.drawRect(0, 2, 80, 11);
    buttonbacking.endFill();
    buttonbacking.beginFill(Col.multiplylightness(Col.GREEN, 1.25));
    buttonbacking.drawRect(0, 1, 80, 11);
    buttonbacking.endFill();

    buttontext.y = -1;
  }

  public var buttonbacking:h2d.Graphics;
  
  public var buttontext:h2d.Text;
}