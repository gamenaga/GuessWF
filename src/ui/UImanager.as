package ui
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import naga.global.Css;
	import naga.global.Global;
	import naga.system.EventManager;
	import naga.ui.Button_s;
	import naga.ui.UIDisplay;
	
	import user.UserAction;

	public class UImanager
	{
		public static var localIP:TextField;
		public static var localPort:TextField;
		private static var logField:TextField;
		public static var message:TextField;
		private static var btn_bind:Button_s;
		private static var btn_send:Button_s;
		
		private static const CHARGE_TEXT:String = "充值100";
		public static var players_UI:Array = [];
		
		public static const UI_player_default:String = "???";
		public static const UI_player_nick:String = "player_nick";
		public static const UI_player_state:String = "player_state";
		public static const UI_player_charge:String = "player_charge";
		public static const UI_player_coin:String = "player_coin";
		public static const UI_player_charge_btn:String = "player_charge_btn";
		
		public function UImanager()
		{
		}
		
		public static function setupLoginUI(fnBind:Function,fnSend:Function):void
		{
			var space_w:int = 20;
			var space_h:int = 20;
			var height:int = Css.SIZE*2.5;
			localIP = UICreater.createTextField( space_w, space_h, "Local IP", MainClient.SERVER_IP, 280);
			localPort = UICreater.createTextField( space_w, localIP.y + height, "Local port", MainClient.SERVER_PORT, 280);
			btn_bind = UICreater.createBtn(localIP.x + localIP.width*1.1, localIP.y, "bind", fnBind, null, Global.stage_w * .2, Global.stage_w * .05);
			message = UICreater.createTextField( space_w, localPort.y + height, "Message", "Lucy can't drink milk.", 280);
			btn_send = UICreater.createBtn(btn_bind.x, message.y, "send", fnSend, null, Global.stage_w * .2, Global.stage_w * .05);
			logField = UICreater.createTextField( space_w, message.y + height, "Log", "", 0, 200, false)
			//			trace("mainCliet 211:	",localIP.text);
			//			this.stage.nativeWindow.activate();
		}
		
		public static function setupMainUI():void
		{
			UIDisplay.removeUI();
			var space_w:int = 20;
			var space_h:int = 20;
			var space_mini:int = 5;
			var width:int = Global.stage_w * .2;
			var height:int = width * .3;
			
			var labal_w:int = (Global.stage_w - space_w*2)*.25;
			var labal_h:int = height*6 + space_mini*4 + space_h;
			
			var i:int
			for(i=0; i<8; i++)
			{
				var i_mod_4:int = i % 4;
				var i_division_4:int = int(i * .25);
				players_UI[i] = [];
				players_UI[i][UI_player_nick] = UICreater.createBtn(space_w +　labal_w*i_mod_4, space_h +　labal_h*i_division_4, UI_player_default, null, null, width, height);
				players_UI[i][UI_player_state] = UICreater.createBtn(space_w +　labal_w*i_mod_4, players_UI[i][UI_player_nick].y + height + space_mini, UI_player_default, null, null, width, height);
				players_UI[i][UI_player_charge] = UICreater.createBtn(space_w +　labal_w*i_mod_4, players_UI[i][UI_player_state].y + height + space_mini, UI_player_default, null, null, width, height);
				players_UI[i][UI_player_coin] = UICreater.createBtn(space_w +　labal_w*i_mod_4, players_UI[i][UI_player_charge].y + height + space_mini, UI_player_default, null, null, width, height);
				players_UI[i][UI_player_charge_btn] = UICreater.createBtn(space_w +　labal_w*i_mod_4, players_UI[i][UI_player_coin].y + height + space_mini, CHARGE_TEXT, chargeForUser, [i], width, height*2);
			}
			updataRoomData(1);
		}
		
		private static function updataRoomData(room_id:int):void
		{
		}
		
		private static function chargeForUser(user_id:int):void
		{
			UserAction.checkIn(user_id, players_UI[user_id][UI_player_nick].text);
//			trace("mainClient 292:	charge for",user_id);
		}
		
		public static function log( text:String ):void
		{
			logField.appendText( text + "\n" );
			logField.scrollV = logField.maxScrollV;
//			trace("log",text );
		}
		
		
	}
}