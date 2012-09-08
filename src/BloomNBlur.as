package  {
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class BloomNBlur extends World {
/* time between particle creation */
		public static const MIN_LAPSED_CREATE_TIME:Number = 0.05;
		public static const MAX_ADDITIONAL_CREATE_TIME:Number = 0.025;
		
		/* amount of bloom and quality of bloom desired */
		private static const BLOOM:Number = 10.0;
		private static const BLOOM_QUALITY:int = 2;
		
		/* amount of motion blur desired */
		private static const BLUR:Number = 0.8
		
		/* particle timing */
		private var _elapsed:Number = 0.0;
		private var _timeToNextParticle:Number = calcNextParticleTime();
		
		/* bloom effect */
		private var _bloom:BloomLighting = new BloomLighting(BLOOM, BLOOM_QUALITY);
		
		/* blur effect */
		private var _blur:BlurCanvas = new BlurCanvas(BLUR);
		
		/* data */
		private var _wrappedGraphic:BloomWrapper;
		
		override public function begin() : void {
			FP.console.enable();
			
			//set the layer and color of the bloom, and add it to the world
			_bloom.layer = -1;
			_bloom.color = 0xafffff;
			add(_bloom);
			
			//set the layer of the blur and add it to the world
			_blur.layer = 1;
			add(_blur);
			
			//create, add, and register an initial particle
			_bloom.register(create(BloomParticle).graphic as BloomWrapper);
			(create(BlurParticle) as BlurParticle).blur(_blur);
			
			//create, add, and register some text
			var txt:Entity = new Entity();
			var img:Text;
			Text.size = 48;
			img = new Text("BloomNBlurPunk");
			txt.graphic = _wrappedGraphic = new BloomWrapper(img);
			txt.x = FP.width / 2 - img.width / 2;
			txt.y = FP.height / 2 - img.height / 2;
			_bloom.register(add(txt).graphic as BloomWrapper);
		}
		
		override public function update() : void {
			super.update();
			
			/* spawn new particles if enough time has passed */
			if (_elapsed >= _timeToNextParticle) {
				_elapsed -= _timeToNextParticle;
				_timeToNextParticle = calcNextParticleTime();
				_bloom.register(create(BloomParticle).graphic as BloomWrapper);
				(create(BlurParticle) as BlurParticle).blur(_blur);
			}
			else
				_elapsed += FP.elapsed;
				
			/*toggle the text blooming*/
			if (Input.pressed(Key.ENTER)) {
				if (_wrappedGraphic.bloomCanvas)
					_bloom.unregister(_wrappedGraphic);
				else
					_bloom.register(_wrappedGraphic);
			}
		}
		
		/* returns a random amount of time to wait before spawning a new particle */
		private function calcNextParticleTime() : Number {
			return MIN_LAPSED_CREATE_TIME + (FP.random * MAX_ADDITIONAL_CREATE_TIME);
		}
	}
}