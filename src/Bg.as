package 
{
	import flash.events.Event;
	
	import naga.system.BitmapClip;
	import naga.system.EventManager;
	import naga.ui.Backgroud;
	
	public class Bg extends Backgroud
	{
		
		public static var bg_img:BitmapClip;
		private static var rush:BitmapClip;
//		private var rush:AlphaPan=new AlphaPan(1);
		private static var change_num:uint;
		
		public function Bg()
		{
			bg_img.stop();
			addChild(bg_img);
			//			trace("bg 21:	"+bg_img.currentFrame+"/"+bg_img.totalFrames);
			rush.stop();
			rush.alpha=0;
			addChild(rush);
//			rush.addEventListener(Event.ENTER_FRAME, open);
		}// end function
		
		public static function title() : void
		{
		}// end function
		public static function initGame() : void
		{
		}// end function
		public static function next() : void
		{
			if(bg_img.currentFrame<bg_img.totalFrames){
//				Sounds.play(Se_ending);
				change(bg_img.currentFrame+1);
//				trace("bg 32:	"+bg_img.currentFrame+"/"+bg_img.totalFrames);
			}
		}// end function
		public static function prev() : void
		{
			if(bg_img.currentFrame>2){
				change(bg_img.currentFrame-1);
			}
		}// end function
		
		private static function change(num:uint) : void
		{
			if(num<=bg_img.totalFrames){
				if (num == 0)
				{
					change_num = Math.random() * (bg_img.totalFrames - 1) + 1;
				}
				else{
					change_num = num;
				}
//				Vision.add("rush",rush,0,0,null,1,0,1,0,false,true);
				rush.gotoAndStop(bg_img.currentFrame);
				rush.alpha=1;
				bg_img.gotoAndStop(change_num);
//				rush.addEventListener(Event.ENTER_FRAME, open);
				EventManager.AddEventFn(rush,Event.ENTER_FRAME,open);
			}
		}// end function
		
		private static function close() : void
		{
			rush.alpha = rush.alpha + 0.1;
			if (rush.alpha >= .8)
			{
				bg_img.gotoAndStop(change_num);
//				rush.removeEventListener(Event.ENTER_FRAME, close);
//				rush.addEventListener(Event.ENTER_FRAME, open);
				EventManager.delEventFn(rush,Event.ENTER_FRAME,close);
				EventManager.AddEventFn(rush,Event.ENTER_FRAME,open);
			}
		}// end function
		
		private static function open() : void
		{
			rush.alpha = rush.alpha - 0.1;
			if (rush.alpha <= 0)
			{
//				rush.removeEventListener(Event.ENTER_FRAME, open);
				EventManager.delEventFn(rush,Event.ENTER_FRAME,open);
			}
		}// end function
		
	}
}
