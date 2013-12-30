package user
{
	import game.Room;
	
	import manager.DataHandler;
	import manager.Database;
	
	import ui.UImanager;
	
	public class UserAction
	{
		private static const a:String = "UserAction";
		
		public static const TABLE_user:String = "user_data";
		/**	表user_data 字段名  user_id  类型：int	 主键*/
		public static const FIELD_user_id:String = "user_id";
		/**	表 user_data 字段名  state  类型：int	 */
		public static const FIELD_user_state:String = "user_state";
		/**	表 user_data 字段名  nick  类型：String	 */
		public static const FIELD_user_nick:String = "user_nick";
		/**	表 user_data 字段名  charge  类型：int	 */
		public static const FIELD_user_charge:String = "user_charge";
		/**	表 user_data 字段名  coin  类型：int	 */
		public static const FIELD_user_coin:String = "user_coin";
		/**	表 user_data 字段名  room_id  类型：int	 */
		public static const FIELD_user_room_index:String = "user_room_index";
		/**	表 user_data 字段名  seat_id  类型：int	 */
		public static const FIELD_user_seat_index:String = "user_seat_index";
		
		
		public static const STATE_offline:int = 0;
		public static const STATE_online:int = 1;
		public static const STATE_waiting:int = 2;
		public static const STATE_ready:int = 3;
		
		
		public static var tempData:Array = [];
		
		public function UserAction()
		{
		}
//		
		public static function initTempData():void
		{
			tempData[FIELD_user_id] = 0;
			tempData[FIELD_user_nick] = "";
			tempData[FIELD_user_state] = STATE_offline;
			tempData[FIELD_user_charge] = 0;
			tempData[FIELD_user_coin] = 0;
			tempData[FIELD_user_room_index] = -1;
			tempData[FIELD_user_seat_index] = -1;
//			trace(a,52,tempData[FIELD_user_id]);
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_id] = 0;
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_nick] = "";
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_state] = STATE_offline;
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_charge] = 0;
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_coin] = 0;
		}
		
		public static function register(nick:String):void
		{
			if(!checkNick(nick))
			{
				Database.insertData(TABLE_user, [FIELD_user_nick, FIELD_user_state, FIELD_user_charge, FIELD_user_coin], [DataHandler.dbString(nick), STATE_online, 0, 0]);
//				tempData[FIELD_user_id] = checkNick(nick);
//				tempData[FIELD_user_nick] = nick;
//				tempData[FIELD_user_state] = STATE_online;
//				tempData[FIELD_user_charge] = 0;
//				tempData[FIELD_user_coin] = 0;
//				Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_id] = checkNick(nick);
//				Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_nick] = nick;
//				Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_state] = STATE_online;
//				Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_charge] = 0;
//				Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_coin] = 0;
			}
			login(nick);
		}
		
		public static function checkNick(nick:String):int
		{
			var chk_nick:Array = Database.getData(TABLE_user,[FIELD_user_id],FIELD_user_nick + " = "+ DataHandler.dbString(nick));
//			trace("action 18：	",chk_nick);
			if(chk_nick && chk_nick.length > 0)
			{
//				trace("action 18：	",chk_nick[0].nick);
				return chk_nick[0][FIELD_user_id];
			}
			return 0;
		}
		
		public static function login(nick:String):void
		{
			if(nick != "")
			{
				if(!chkCheckIn)
				{
					GuessClientUser.dataHandler.send2Server("CheckIn|"+nick);
				}
				else
				{
					trace(a,101,"您已登录！");
				}
//				initTempData();
			}
			else
			{
				trace(a,106,"昵称不能为空！");
			}
		}
		
		public static function get chkCheckIn():Boolean
		{
			trace(a,113,tempData[FIELD_user_room_index]);
			if (tempData[FIELD_user_room_index] >= 0 )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function loginHandler(user_id:int, field:Array, data:Array):void
		{
			
		}
		
		public static function checkInHandler(room_index:int, seat_index:int, field:Array, data:Array):void
		{
			setTempData(room_index, seat_index, field, data);
			
		}
		
		public static function logout():void
		{
			
		}
		
		/**
		 * 进入房间
		 * @return 座位ID
		 * 
		 */
		public static function checkIn(user_id:int, nick:String, room_id:int=0):void
		{
			if(room_id == 0)
			{
				room_id = Room.checkWaitingRoomID()
			}
			if(user_id > 0)
			{
				var room_index:int = Room.join(room_id);
//				var room_index:int = Room.getRoomIndex(room_id);
//				trace(a,86,user_id,room_id,room_index);
				var seat_index:int = Room.getSeatIndex(room_index);
//				trace(a,115, seat_index,tempData[FIELD_user_state]);
				if(seat_index >= 0)
				{
					Database.updateData(TABLE_user,[FIELD_user_state,FIELD_user_room_index,FIELD_user_seat_index],[STATE_online,room_index,seat_index],FIELD_user_id +　" = " + user_id);
//					if(Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_state] != STATE_online)
//					{
						var get_data:Array = Database.getData(TABLE_user,[FIELD_user_nick, FIELD_user_charge, FIELD_user_coin],FIELD_user_id +　" = " + user_id);
						trace(a,138, get_data[0][FIELD_user_nick]);
//						tempData[FIELD_user_id] = get_data[0][user_id];
//						tempData[FIELD_user_nick] = get_data[0][FIELD_user_nick];
//						tempData[FIELD_user_charge] = get_data[0][FIELD_user_charge];
//						tempData[FIELD_user_coin] = get_data[0][FIELD_user_coin];
//						tempData[FIELD_user_room_index] = get_data[0][FIELD_user_charge];
//						tempData[FIELD_user_seat_index] = get_data[0][FIELD_user_coin];
						tempData[FIELD_user_id] = user_id;
						tempData[FIELD_user_nick] = nick;
						tempData[FIELD_user_state] = STATE_online;
						tempData[FIELD_user_charge] = nick;
						tempData[FIELD_user_coin] = STATE_online;
						tempData[FIELD_user_room_index] = room_index;
						tempData[FIELD_user_seat_index] = seat_index;
						
						Room.setPlayerData(room_index,seat_index,FIELD_user_id, user_id);
						Room.setPlayerData(room_index,seat_index,FIELD_user_nick, nick);
						Room.setPlayerData(room_index,seat_index,FIELD_user_state, STATE_online);
						Room.setPlayerData(room_index,seat_index,FIELD_user_charge, get_data[0][FIELD_user_charge]);
						Room.setPlayerData(room_index,seat_index,FIELD_user_coin, get_data[0][FIELD_user_coin]);
						
						updatePlayerUI(room_index, seat_index);
//					}
						
//					Room.updatePlayerUI(seat_index,Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_nick],STATE_online,Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_charge],Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_coin]);
//					Room.updatePlayerData(room_index, seat_index, user_id, STATE_online);
//					Room.updatePlayerData(room_index,seat_index,user_id,STATE_online,tempData[FIELD_user_nick],tempData[FIELD_user_charge],tempData[FIELD_user_coin]);
					
				}
				else
				{
					//房间满员，重新找房
					trace(a,98,"房间满员");
				}
			}
		}
		
		public static function updatePlayerUI(room_index:int, seat_index:int):void
		{
			UImanager.players_UI[0][UImanager.UI_player_nick].text = Room.tempData[room_index][Room.FIELD_room_players][seat_index][FIELD_user_nick];
			UImanager.players_UI[0][UImanager.UI_player_state].text = Room.tempData[room_index][Room.FIELD_room_players][seat_index][FIELD_user_state];
			UImanager.players_UI[0][UImanager.UI_player_charge].text = Room.tempData[room_index][Room.FIELD_room_players][seat_index][FIELD_user_charge];
			UImanager.players_UI[0][UImanager.UI_player_coin].text = Room.tempData[room_index][Room.FIELD_room_players][seat_index][FIELD_user_coin];
		}
		
		
		/**
		 * 离开房间
		 * 
		 */
		private static function checkOut(room_id:uint,user_id:uint):void
		{
			
		}
		
		/**
		 * 准备
		 * 
		 */
		private static function getReady(user_id:uint):void
		{
			
		}
		
		/**
		 * 取消准备
		 * 
		 */
		private static function cancelReady(user_id:uint):void
		{
			
		}
		
		/**
		 * 获取用户数据
		 * 
		 */
		public static function setTempData(room_index:int, seat_index:int, field:Array, data:Array):void
		{
			tempData[FIELD_user_room_index] = room_index;
			tempData[FIELD_user_seat_index] = seat_index;
			var i :int;
			for(i = 0; i < field.length; i++)
			{
				Room.setPlayerData(room_index, seat_index, field[i], data[i]);
				tempData[field[i]] = data[i];
			}
			updatePlayerUI(room_index, seat_index);
			
		}
		

	}
}