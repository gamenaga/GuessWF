package
{
	import flash.events.Event;
	
	import naga.global.Global;
	import naga.system.EventManager;
	import game.Mode;
	

    public class MyHeart
    {
        public static var running:Boolean = false;
		public static var second:uint = 0;
		private static var fps:uint;
		
		public static function init(FPS:uint) : void
		{
			fps = FPS;
		}// end function
		
        public static function go() : void
        {
//			trace("heart 24:	"+second+"	"+seconds+"	");
            second = 0;
			doRun();
        }// end function

        private static function run() : void
        {
//			trace("heart 31:	"+second+"	"+seconds+"	");
            second ++;
			//100秒模式  倒计时
//            if (second >= main.mode.time - 5 && second < main.mode.time)
//            {
//				Sounds.play(Se_dida);
//                Bubble.instance.show(Bubble.TYPE_OTHER, Global.stage_w*.5, Global.stage_h*.5, "<b>" + (main.mode.time - second) + "</b>", 200, Css.SIZE*4, Css.YELL_D);
//            }
//            if (second % (2*fps) == 0 && Mode.g_mode !=null)
//            {
//				//实时存档
//				DataObj.saveData();}
        }// end function

        public static function stop(): void
        {
			doPause();
			DataObj.data[6] = DataObj.data[6] + MyHeart.seconds;
			if (DataObj.data[3] < seconds)
			{
				DataObj.data[3] = seconds;
			}
            second = 0;
        }// end function
		
		public static function doPause(): void
		{
//			Global.gameStage.removeEventListener(Event.ENTER_FRAME, run);
			EventManager.delEventFn(Global.gameStage,Event.ENTER_FRAME,run);
			running	=	false;
		}// end function
		
		public static function doRun(): void
		{
			if(!running && Mode.g_mode != null)
			{
				running	=	true;
//				Global.gameStage.addEventListener(Event.ENTER_FRAME, run);
				EventManager.AddEventFn(Global.gameStage,Event.ENTER_FRAME,run);
			}
		}// end function

		public static function get seconds():uint
		{
			return second/fps;
		}
    }
}
