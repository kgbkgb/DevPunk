package demos.ogmolevel {
	
	import net.flashpunk.*;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
    import punk.ui.*;
    import punk.ui.skins.*;
	import punk.transition.*;
	import punk.transition.effects.*;
	
	import demos.*;
	import demos.Assets;
	import demos.bloomnblur.*;
	import demos.bloomnblur.bloom.*;
	import demos.bloomnblur.blur.*;
	import demos.gravityemit.*;
	import demos.lighting.*;
	import demos.ogmolevel.*;
	import demos.platformer.*;
	import demos.punkui.*;
	import demos.tinting.*;
	
	public class GameWorld extends World {
		public var txtA:*= new PunkTextArea("Coins Collected : " + Coin.getGameCoin(), 400, 400, 175, 50);
		
		public function GameWorld() {
			FP.log("Game World Started");
			Coin.setGameCoin();
		}
		
		override public function begin() : void {
			super.begin();
			PunkUI.skin = new Elite();
			add(txtA);
			
			add(new Level(Assets.LVL_SAMPLE));
			
		}
		override public function update() : void {
			this.txtA.text = "Coins Collected : " + Coin.getGameCoin();
			if (Coin.getGameCoin() >=8) {
				this.txtA.text = "You've Won!!!\nCoins Collected : " + Coin.getGameCoin();
			}
			
			// Check which Key has been pressed
			if(Input.released(Key.DIGIT_1))
			{
				Transition.to(Demo, 
					new StarIn({track:"player"}), 
					new StarOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_2))
			{
				Transition.to(BlankWorld, 
					new StarIn({color:0xFF06925f, duration:2}), 
					new StarOut({color:0xFF06925f, duration:4})
				);			
			}
			else if(Input.released(Key.DIGIT_3))
			{
				Transition.to(MainWorld, 
					new CircleIn({track:"player"}), 
					new CircleOut({track:"player"})
				);			
			}
			else if(Input.released(Key.DIGIT_4))
			{
				Transition.to(GameWorld, 
					new CircleIn({duration:1, color:0x99993333}), 
					new CircleOut({duration:0.5})
				);							
			}
			else if(Input.released(Key.DIGIT_5))
			{				
				Transition.to(BloomLevel, 
					new FadeIn({duration:4}), 
					new FadeOut({duration:6, color:0xFF334455})
				);			
			}
			else if(Input.released(Key.DIGIT_6))
			{
				Transition.to(BlurLevel, 
					new StripeFadeOut(), 
					new StripeFadeIn()
				);
			}
			else if(Input.released(Key.DIGIT_7))
			{
				Transition.to(BloomNBlur, 
					new BlurOut(), 
					new BlurIn(), 
					{onOutComplete:onBlurOutComplete, onInComplete:onBlurInComplete}
				);
			}			
			else if(Input.released(Key.DIGIT_8))
			{
				Transition.to(WorldOne, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			else if(Input.released(Key.DIGIT_9))
			{
				Transition.to(WorldOne, 
					new FlipOut(), 
					new FlipIn()
				);
			}
			else if(Input.released(Key.DIGIT_0))
			{
				Transition.to(TintWorld, 
					new RotoZoomOut(), 
					new RotoZoomIn()
				);
			}
			else if (Input.released(Key.Q)) 
			{
				Transition.to(LightGame, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			else if (Input.released(Key.W)) 
			{
				Transition.to(LightGame, 
					new PixelateOut(), 
					new PixelateIn()
				);
			}
			
			super.update();
			
			if (Input.mousePressed) {
				add(new GravityEmitter(Input.mouseX, Input.mouseY));
			}
			
		}
		
		private function onBlurOutComplete():void 
		{
			trace("Blur Out done!");
		}		
		
		private function onBlurInComplete():void 
		{
			trace("Blur In done!");
		}
		
	}
}