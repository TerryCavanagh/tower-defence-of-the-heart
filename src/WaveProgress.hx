import motion.easing.Back;
import hashagon.*;
import hashagon.displayobject.*;
import motion.Actuate;

class WaveProgress extends h2d.Object{
  public function new(){
    super();

    y = -30;
    panelbacking = new h2d.Graphics();
    panelbacking.beginFill(Col.BLACK);
    panelbacking.drawRect(0, 0, Gfx.screenwidth - 21, 20);
    panelbacking.endFill();
    panelbacking.beginFill(Col.multiplylightness(Col.GREEN, 0.5));
    panelbacking.drawRect(0, 1, Gfx.screenwidth - 21, 18);
    panelbacking.endFill();
    addChild(panelbacking);

    nextwavedisplay = new h2d.Text(Game.textfont, this);
    nextwavedisplay.x = (Gfx.screenwidth - 20) / 2;
    nextwavedisplay.y = 7;
    nextwavedisplay.textAlign = Center;
    nextwavedisplay.text = "Wave 1 of 20";
    nextwavedisplay.textColor = Col.WHITE;
  }

  public function position(ypos:Float){
    y = ypos;
  }

  public function show(wavenum:Int){
    y = -30;
    nextwavedisplay.text = "Wave " + wavenum + " of 20";
    Actuate.update(position, 1, [-30], [Gfx.screenheightmid - 10])
      .ease(Back.easeOut)
      .onComplete(function(){
        Actuate.update(position, 1, [Gfx.screenheightmid - 10], [Gfx.screenheight + 10])
          
          .delay(0.5)
          .ease(Back.easeIn)
          .onComplete(function(){
            position(-30);
          });
      });
    /*
    Actuate.tween(this, 0.5, {y: Gfx.screenheightmid - 10})
      .ease(Back.easeIn)
      .onComplete(function(){
        Actuate.tween(this, 0.5, {y: Gfx.screenheight + 10})
        .ease(Back.easeOut)
        .delay(0.5)
        .onComplete(function(){
          y = -30;
        });
      });*/
  }

  public function hide(){
    y = -30;
  }
  
  public var nextwavedisplay:h2d.Text;
  public var panelbacking:h2d.Graphics;
}