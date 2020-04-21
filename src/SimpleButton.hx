import h2d.Interactive;
import hashagon.displayobject.*;
import hashagon.*;

class SimpleButton extends h2d.Object{
	public function new(_type:ButtonType, position:Int, _parent:h2d.Object){
		super();
		_parent.addChild(this);

		type = _type;
		x = 3;
		y = 2 + (position * 17);

		pressed = false;
		buttoncol = Col.GREEN;

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

		inittooltips(_type);

		checkpressed();
		updatebutton();

		var interaction:h2d.Interactive = new h2d.Interactive(14, 14, this);

		interaction.onOver = function(event : hxd.Event) {
			icon.alpha = 0.7;
			buttonbacking.alpha = 0.7;
			showtooltips();
		}

		interaction.onOut = function(event : hxd.Event) {
			icon.alpha = 1.0;
			buttonbacking.alpha = 1.0;
			hidetooltips();
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
		canafford = true;
		buttoncol = Col.GREEN;

		switch (type){
			case ButtonType.LASER:
				if(Game.gold < GameData.towers.laser.cost) canafford = false;
			case ButtonType.BEAM:
				if(Game.gold < GameData.towers.beam.cost) canafford = false;
			case ButtonType.VORTEX:
				if(Game.gold < GameData.towers.vortex.cost) canafford = false;
			case ButtonType.SHOOTY:
				if(Game.gold < GameData.towers.shooty.cost) canafford = false;
			default:
		}

		if(!canafford){
			buttoncol = Col.GRAY;
		}

		if(pressed){
			buttonbacking.clear();
			buttonbacking.beginFill(Col.multiplylightness(buttoncol, 0.75));
			buttonbacking.drawRect(0, 12, 14, 3);
			buttonbacking.endFill();
			buttonbacking.beginFill(Col.multiplylightness(buttoncol, 1.2));
			buttonbacking.drawRect(0, 2, 14, 12);
			buttonbacking.endFill();

			icon.x = 2; icon.y = 3;
		}else{
			buttonbacking.clear();
			buttonbacking.beginFill(Col.multiplylightness(buttoncol, 0.75));
			buttonbacking.drawRect(0, 12, 14, 3);
			buttonbacking.endFill();
			buttonbacking.beginFill(buttoncol);
			buttonbacking.drawRect(0, 0, 14, 12);
			buttonbacking.endFill();

			icon.x = 2; icon.y = 1;
		}

		buttoncol = Col.GREEN;
	}

	public function inittooltips(_type:ButtonType){
		tooltipbacking = new h2d.Graphics(this);
		tooltipbacking.y = -1;

		tooltipname = new h2d.Text(Game.textfont, this);
		tooltipname.x = -4;
		tooltipname.y = 0;
		tooltipname.textAlign = Right;
		tooltipname.textColor = Col.WHITE;

		tooltipprice = new h2d.Text(Game.numberfont, this);
		tooltipprice.x = -4;
		tooltipprice.y = 9;
		tooltipprice.textAlign = Right;
		tooltipprice.textColor = Col.YELLOW;

		switch(_type){
			case ButtonType.LASER:
				tooltipname.text = "Laser";
				tooltipprice.text = "$" + GameData.towers.laser.cost;
				tooltipbacking.beginFill(Col.multiplylightness(buttoncol, 0.8));
				tooltipbacking.drawRect(-34 - 20, 0, 50, 18);
				tooltipbacking.endFill();
			case ButtonType.BEAM:
				tooltipname.text = "Beam";
				tooltipprice.text = "$" + GameData.towers.beam.cost;
				tooltipbacking.beginFill(Col.multiplylightness(buttoncol, 0.8));
				tooltipbacking.drawRect(-34- 10, 0, 40, 18);
				tooltipbacking.endFill();
			case ButtonType.VORTEX:
				tooltipname.text = "Vortex";
				tooltipprice.text = "$" + GameData.towers.vortex.cost;
				tooltipbacking.beginFill(Col.multiplylightness(buttoncol, 0.8));
				tooltipbacking.drawRect(-34 - 30, 0, 60, 18);
				tooltipbacking.endFill();
			case ButtonType.SHOOTY:
				tooltipname.text = "Mines";
				tooltipprice.text = "$" + GameData.towers.shooty.cost;
				tooltipbacking.beginFill(Col.multiplylightness(buttoncol, 0.8));
				tooltipbacking.drawRect(-34- 20, 0, 50, 18);
				tooltipbacking.endFill();
			case ButtonType.UPGRADE:
				tooltipname.text = "Upgrade";
				tooltipname.y += 5;
				tooltipprice.text = "";
				tooltipbacking.beginFill(Col.multiplylightness(buttoncol, 0.8));
				tooltipbacking.drawRect(-42- 30, 0, 68, 18);
				tooltipbacking.endFill();
			case ButtonType.SELL:
				tooltipname.text = "Sell";
				tooltipname.y += 5;
				tooltipprice.text = "";
				tooltipbacking.beginFill(Col.multiplylightness(buttoncol, 0.8));
				tooltipbacking.drawRect(-34- 10, 0, 40, 18);
				tooltipbacking.endFill();
		}    

		tooltipbacking.visible = false;
		tooltipname.visible = false;
		tooltipprice.visible = false;
	}

	public function showtooltips(){
		tooltipbacking.visible = true;
		tooltipname.visible = true;
		tooltipprice.visible = true;
	}

	public function hidetooltips(){
		tooltipbacking.visible = false;
		tooltipname.visible = false;
		tooltipprice.visible = false;
	}

	public var buttonbacking:h2d.Graphics;
	public var icon:h2d.Anim;
	public var type:ButtonType;

	public var buttoncol:Int;
	public var canafford:Bool;

	public var tooltipbacking:h2d.Graphics;
	public var tooltipname:h2d.Text;
	public var tooltipprice:h2d.Text;

	public var pressed:Bool;
}