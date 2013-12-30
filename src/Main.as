package
{
	import flash.display.Sprite;
	
	import game.CashResult;
	import game.Manager;
	
	import manager.Database;
	import user.UserAction;
	import game.Room;
	
	import naga.eff.GameStop;
	import naga.global.Css;
	import naga.global.Global;
	import naga.ui.Dialog;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	import ui.NpcDialog;

	public class Main extends starling.display.Sprite
	{
		public function Main()
		{
			if(stage)
			{
				
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, initStage);
			}
			
		}
		
		public function initStage():void
		{
			initGlobal();
			Dialog.init(T_pan, "000000",NpcDialog);
			GameStop.init(Manager.gameStop, Manager.gameContine);
			Css.init(12);
//			Dialog.add("测试");
			init();
			
		}
		
		public function init():void
		{
			var cash_result:CashResult = new CashResult();
			addChild(cash_result);
			//			Conn.insertSql("user_data","nick,charge,coin",["\"aaaaa\"",int(Math.random()*10000),int(Math.random()*100)]);
			var data:Array =Database.getData("user_data",["nick,charge,coin"]);
			UserAction.register("n,s,s,s");
			trace("main 50:	",Room.checkWaitingRoomID());
			
//			Room.updateData(1,[Room.FIELD_room_state],[int(Math.random()*10000)]);
			
		}
		
		public static function initGlobal():void
		{
			//			trace("Glo 65:	"+stage_w+"	"+stage_h);
			//				游戏层
			Global.g_floor = new flash.display.Sprite();
			Global.gameStage.addChild(Global.g_floor);
			//				eff层
			Global.eff_floor = new flash.display.Sprite();
			Global.eff_floor.mouseChildren = false;
			Global.eff_floor.mouseEnabled = false;
			Global.gameStage.addChild(Global.eff_floor);
			//				ui层
			Global.ui_floor = new flash.display.Sprite();
			Global.ui_floor.mouseEnabled = false;
			Global.gameStage.addChild(Global.ui_floor);
			//				tips层
			Global.tp_floor = new flash.display.Sprite();
			Global.tp_floor.mouseEnabled = false;
			Global.gameStage.addChild(Global.tp_floor);
		}
	}
}