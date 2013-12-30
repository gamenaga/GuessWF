package ui
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import manager.DataSendClient;
	
	import naga.global.Css;
	import naga.global.Global;
	import naga.system.EventManager;
	import naga.ui.Button_s;
	import naga.ui.UIDisplay;
	
	import user.UserAction;
	import manager.DataHandler;
	import manager.DataSendClient;

	public class UImanagerUser
	{
		
		public function UImanagerUser()
		{
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
			for(i=0; i<1; i++)
			{
				var i_mod_4:int = i % 4;
				var i_division_4:int = int(i * .25);
				UImanager.players_UI[i] = [];
				UImanager.players_UI[i][UImanager.UI_player_nick] = UICreater.createTextField(space_w +　labal_w*i_mod_4, space_h +　labal_h*i_division_4, "", "", width, height);
				UImanager.players_UI[i][UImanager.UI_player_state] = UICreater.createBtn(space_w +　labal_w*i_mod_4, UImanager.players_UI[i][UImanager.UI_player_nick].y + height + space_mini, UImanager.UI_player_default, null, null, width, height);
				UImanager.players_UI[i][UImanager.UI_player_charge] = UICreater.createBtn(space_w +　labal_w*i_mod_4, UImanager.players_UI[i][UImanager.UI_player_state].y + height + space_mini, UImanager.UI_player_default, null, null, width, height);
				UImanager.players_UI[i][UImanager.UI_player_coin] = UICreater.createBtn(space_w +　labal_w*i_mod_4, UImanager.players_UI[i][UImanager.UI_player_charge].y + height + space_mini, UImanager.UI_player_default, null, null, width, height);
				UImanager.players_UI[i][UImanager.UI_player_charge_btn] = UICreater.createBtn(space_w +　labal_w*i_mod_4, UImanager.players_UI[i][UImanager.UI_player_coin].y + height + space_mini, "登录", login, null, width, height*2);
			}
		}
		
		private static function updataRoomData(room_id:int):void
		{
		}
		
		private static function login():void
		{
//			GuessClientUser.dataHandler.send2Server("INSERT INTO chat (user_id,contants,time)VALUES(1,222222222222,333)");
			UserAction.login(UImanager.players_UI[0][UImanager.UI_player_nick].text);
//			trace("mainClient 292:	charge for",user_id);
		}
		
	}
}