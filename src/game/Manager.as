package game
{
	import naga.global.Global;

	public class Manager
	{
		public function Manager()
		{
		}
		
		public static function gameStop():void
		{
			MyHeart.doPause();
			Global.g_move_sp = 0;
		}
		
		public static function gameContine():void
		{
			if(Mode.game_state == Mode.STATE_PLAY)
			{
				MyHeart.doRun();
			}
//			trace("gameContine");
			Global.g_move_sp = Global.g_move_sp_bak;
		}
	}
}