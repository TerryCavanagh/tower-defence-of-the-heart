package hashagon.displayobject;

class Tileset{
  public function new(tilesetname:String, w:Int, h:Int){
    tiles = [];

    var tilesetdata:h2d.Tile = hxd.Res.load("graphics/" + tilesetname + ".png").toTile();
    tiles = tilesetdata.gridFlatten(w);
    
    name = tilesetname;
    width = w; height = h;
    numtiles = tiles.length;
  }

  public var name:String;
  public var width:Int;
  public var height:Int;
  public var numtiles:Int;

  public var tiles:Array<h2d.Tile>;
}