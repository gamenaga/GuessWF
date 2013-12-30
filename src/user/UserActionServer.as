package user
{
	import flash.net.Socket;
	
	import game.Room;
	import game.RoomServer;
	
	import manager.DataHandler;
	import manager.Database;
	
	import ui.UImanager;
	
	public class UserActionServer
	{
		private static const a:String = "UserAction_Server";
		
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
		
		public function UserActionServer()
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
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_id] = 0;
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_nick] = "";
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_state] = STATE_offline;
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_charge] = 0;
//			Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_coin] = 0;
		}
		
		public static function register(socket:Socket, nick:String):void
		{
			if(!checkNick(nick))
			{
				Database.insertData(TABLE_user, [FIELD_user_nick, FIELD_user_state, FIELD_user_charge, FIELD_user_coin], [DataHandler.dbString(nick), STATE_online, 0, 0], login, socket, nick);
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
			return -1;
		}
		
		public static function login(socket:Socket, nick:String):void
		{
			if(nick != "")
			{
				var user_id:int = checkNick(nick);
				if(user_id >= 0)
				{
					checkIn(socket, user_id, nick);
				}
				else
				{
					register(socket, nick);
				}
			}
			else
			{
				trace(a,76,"昵称不能为空！");
			}
		}
		
		public static function logout():void
		{
			
		}
		
		/**
		 * 进入房间
		 * @return 座位ID
		 * 
		 */
		public static function checkIn(socket:Socket, user_id:int, nick:String, room_index:int = -1):void
		{
			if(user_id >= 0)
			{
				if(room_index == -1)
				{
					room_index = RoomServer.checkWaitingRoomIndex()
				}
				trace(a,130,user_id,room_index);
				var seat_index:int = RoomServer.getSeatIndex(room_index);
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
						RoomServer.setPlayerData(room_index,seat_index,FIELD_user_id, user_id);
						RoomServer.setPlayerData(room_index,seat_index,FIELD_user_nick, nick);
						RoomServer.setPlayerData(room_index,seat_index,FIELD_user_state, STATE_online);
						RoomServer.setPlayerData(room_index,seat_index,FIELD_user_charge, get_data[0][FIELD_user_charge]);
						RoomServer.setPlayerData(room_index,seat_index,FIELD_user_coin, get_data[0][FIELD_user_coin]);
						
						MainServer.send("CheckIn|"+[room_index, seat_index]+
							"|"+[FIELD_user_id, FIELD_user_nick, FIELD_user_state, FIELD_user_charge, FIELD_user_coin]+
							"|"+[user_id, nick, STATE_online, get_data[0][FIELD_user_charge], get_data[0][FIELD_user_coin]]
							, socket);
						
						MainServer.send("User|"+[room_index,seat_index]+
							"|"+[FIELD_user_id, FIELD_user_nick, FIELD_user_state, FIELD_user_charge, FIELD_user_coin]+
							"|"+[user_id, nick, STATE_online, get_data[0][FIELD_user_charge], get_data[0][FIELD_user_coin]]
							);
//					}
						
//					Room.updatePlayerUI(seat_index,Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_nick],STATE_online,Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_charge],Room.tempData[room_index][Room.FIELD_room_players][FIELD_user_coin]);
					RoomServer.updatePlayerData(room_index, seat_index, user_id, STATE_online);
//					Room.updatePlayerData(room_index,seat_index,user_id,STATE_online,tempData[FIELD_user_nick],tempData[FIELD_user_charge],tempData[FIELD_user_coin]);
					
				}
				else
				{
					//房间满员，重新找房
					trace(a,172,"房间满员");
				}
			}
		}
		
		public static function updatePlayerUI(room_index:int, seat_index:int):void
		{
			UImanager.players_UI[0][UImanager.UI_player_nick].text = Room.tempData[room_index][RoomServer.FIELD_room_players][seat_index][FIELD_user_nick];
			UImanager.players_UI[0][UImanager.UI_player_state].text = Room.tempData[room_index][RoomServer.FIELD_room_players][seat_index][FIELD_user_state];
			UImanager.players_UI[0][UImanager.UI_player_charge].text = Room.tempData[room_index][RoomServer.FIELD_room_players][seat_index][FIELD_user_charge];
			UImanager.players_UI[0][UImanager.UI_player_coin].text = Room.tempData[room_index][RoomServer.FIELD_room_players][seat_index][FIELD_user_coin];
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
		public static function setTempData(room_index, seat_index, user_id, user_id):void
		{
			RoomServer.setPlayerData(room_index,seat_index,FIELD_user_id, user_id);
		}
		

	}
}