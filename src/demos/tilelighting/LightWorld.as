package demos.tilelighting
{
	import demos.Assets;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import punk.tilelighting.TileLighting;
	import punk.tilelighting.TileLight;

	/**
	 * ...
	 * @author Alex Larioza
	 */
	public class LightWorld extends World 
	{
		public static const TILE_SIZE:int = 16;
		
		private var _cursor:Cursor;
		public function get cursor():Cursor { return _cursor; }
		
		private var _lighting:TileLighting;
		public function get lighting():TileLighting { return _lighting; }
		
		private var _debug:Text;
		
		public function LightWorld()
		{
			addGraphic(new Backdrop(Assets.SPR_BG), 1000);
			
			add(_cursor = new Cursor());
			
			_lighting = new TileLighting(Assets.SPR_LIGHTING, FP.screen.width*4, FP.screen.height*4, TILE_SIZE, TILE_SIZE);
			_lighting.addLight(new TileLight(15, 15, 4, 4));
			add(_lighting);
			
			_debug = new Text("R: restart\nQ/E: size\nW/S: falloff\nA/D: brightness\n1/2: global light\nL/R/U/D: pan camera\nLeft Click: place block\nRight Click: remove block\nMiddle Click: add light\n\nLIGHTS: 2", 0, 24);
			_debug.scale = .5;
			addGraphic(_debug, -2000);
		}
		
		override public function begin():void
		{
			super.begin();
		}
		
		override public function update():void 
		{
			// Check which Key has been pressed
			if(Input.pressed(Key.X)) {
				Assets.updateWorld(true);
			} else if (Input.pressed(Key.Z)) {
				Assets.updateWorld(false);
			}
			super.update();
			
			// restart worlds
			if (Input.pressed(Key.R))
			{
				FP.world = new LightWorld();
			}
			
			// light size
			if (Input.pressed(Key.E))
			{
				_cursor.light.radius++;
				FP.log("RADIUS:", _cursor.light.radius);
			}
			if (Input.pressed(Key.Q))
			{
				if (_cursor.light.radius > 0)
				{
					_cursor.light.radius--;
					FP.log("RADIUS:", _cursor.light.radius);
				}
			}
			
			// light falloff
			if (Input.pressed(Key.W))
			{
				if (_cursor.light.falloff < 26)
				{
					_cursor.light.falloff++;
					FP.log("FALLOFF:", _cursor.light.falloff);
				}
			}
			if (Input.pressed(Key.S))
			{
				if (_cursor.light.falloff > 0)
				{
					_cursor.light.falloff--;
					FP.log("FALLOFF:", _cursor.light.falloff);
				}
			}
			
			// light brightness
			if (Input.pressed(Key.A))
			{
				if (_cursor.light.brightness > 0)
				{
					_cursor.light.brightness--;
					FP.log("LIGHT:", _cursor.light.brightness);
				}
			}
			if (Input.pressed(Key.D))
			{
				if (_cursor.light.brightness < 4)
				{
					_cursor.light.brightness++;
					FP.log("LIGHT:", _cursor.light.brightness);
				}
			}
			
			// global lighting
			if (Input.pressed(Key.DIGIT_2))
			{
				if (_lighting.ambientLevel < 4)
				{
					_lighting.ambientLevel++;
					FP.log("GLOBAL:", _lighting.ambientLevel);
				}
			}
			if (Input.pressed(Key.DIGIT_1))
			{
				if (_lighting.ambientLevel > 0)
				{
					_lighting.ambientLevel--;
					FP.log("GLOBAL:", _lighting.ambientLevel);
				}
			}
			
			// light creation
			if (Input.mouseReleasedMiddle)
			{
				_lighting.addLight(new TileLight(_cursor.tileX, _cursor.tileY, _cursor.light.radius, _cursor.light.brightness, _cursor.light.falloff));
				_debug.text = "R: restart\nQ/E: size\nW/S: falloff\nA/D: brightness\n1/2: global light\nL/R/U/D: pan camera\nLeft Click: place block\nRight Click: remove block\nMiddle Click: add light\n\nLIGHTS: " + _lighting.count;
				FP.log("ADDED LIGHT");
			}
			
			// block creation/destruction
			if (Input.mouseDown)
			{
				if (!_cursor.collide("block", _cursor.flooredX, _cursor.flooredY))
				{
					add(new Block(_cursor.flooredX, _cursor.flooredY));
				}
				FP.log("ADDED BLOCK");
			}
			if (Input.mouseDownRight)
			{
				var e:Entity = _cursor.collide("block", _cursor.flooredX, _cursor.flooredY);
				if (e)
				{
					remove(e);
				}
			}
			
			// camera pan
			if (Input.check(Key.RIGHT))
			{
				_debug.x = camera.x += 8;
			}
			if (Input.check(Key.LEFT))
			{
				_debug.x = camera.x -= 8;
			}
			if (Input.check(Key.UP))
			{
				_debug.y = camera.y -= 8;
				_debug.y += 24;
			}
			if (Input.check(Key.DOWN))
			{
				_debug.y = camera.y += 8;
				_debug.y += 24;
			}
			
		}
		
		override public function render():void 
		{
			super.render();
		}
	}
}