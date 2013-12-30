package game
{
	import manager.DataHandlerServer;
	import manager.Database;
	
	import ui.UImanager;
	
	import user.UserAction;
	import user.UserActionServer;

	public class RoomServer
	{
		private static const a:String = "Room_Server";
		
		public static const STATE_CLOSE:uint = 0;
		public static const STATE_WAIT:uint = 2;
		public static const STATE_FULL:uint = 3;
		public static const STATE_GAME:uint = 4;
		
		public static const TABLE_room:String = "room_data";
		/**	表 room 字段名  room_id  类型：int	 	 主键*/
		public static const FIELD_room_id:String = "room_id";
		/**	表 room 字段名  room_state  类型：int	 */
		public static const FIELD_room_state:String = "room_state";
		/**	表 room 字段名  room_members  类型：int	 */
		public static const FIELD_room_members:String = "room_members";
		/**	表 room 字段名  room_members_max  类型：int	 */
		public static const FIELD_room_members_max:String = "room_members_max";
		/**	表 room 字段名  owner_id  类型：int	 */
		public static const FIELD_room_owner_id:String = "owner_id";
		/**	表 room 字段名  players  类型：Array	 */
		public static const FIELD_room_players:String = "players";
		
		public static var MEMBERS_MAX:uint = 8;
		public static var INIT_PLAYERS:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
		
		public function RoomServer()
		{
		}
		
		public static function create(room_id:int):void
		{
			Room.initTempData(room_id);
//			initPlayerUI(room_id)
			Database.insertData(TABLE_room,
				[FIELD_room_id, FIELD_room_state, FIELD_room_members, FIELD_room_members_max, FIELD_room_players, FIELD_room_owner_id],
				[room_id, STATE_CLOSE, 0, MEMBERS_MAX, INIT_PLAYERS, 0]);
		}
		
		public static function open(room_id:int):void
		{
			updateData(room_id,[FIELD_room_state],[STATE_WAIT]);
		}
		
		public static function join(room_id:int):int
		{
			var room_index:int = getRoomIndex(room_id);
			if(room_index < 0)
			{
				return Room.initTempData(room_id);
			}
			else
			{
				return room_index;
			}
		}
		
		public static function initData(room_id:int):void
		{
			Database.updateData(TABLE_room,
				[FIELD_room_state, FIELD_room_members, FIELD_room_members_max, FIELD_room_players, FIELD_room_owner_id],
				[STATE_WAIT, 0, MEMBERS_MAX, INIT_PLAYERS, 0],FIELD_room_id + " = " + room_id);
		}
		
		/**
		 * 找1个等待中的房间 ID
		 * @return 房间ID 
		 * 
		 */
		public static function checkWaitingRoomIndex():int
		{
			var room_index:int;
			for (room_index = 0 ; room_index < Room.tempData.length; room_index ++)
			{
				trace(a,84,Room.tempData[room_index][FIELD_room_state]);
				if(Room.tempData[room_index][FIELD_room_state] == Room.STATE_WAIT)
				{
					return room_index;
				}
			}		
			
			return -1;
		}
		
		public static function getRoomData(room_id:uint,field:Array):Object
		{
			var get_data:Array = Database.getData(TABLE_room,field,FIELD_room_id + " = "+room_id);
			trace("ROOM 96：	",get_data[0][FIELD_room_id]);
			if(get_data)
			{
				//				trace("action 18：	",chk_nick[0].nick);
				return get_data[0];
			}
			return null;
		}
		
		public static function getTempData(room_index:uint):Array
		{
			var get_data:Array = Room.tempData[room_index];
			trace(a,107,get_data[FIELD_room_id]);
			if(get_data)
			{
				//				trace("action 18：	",chk_nick[0].nick);
				return get_data;
			}
			return null;
		}
		
		/**
		 * 获得房间Index
		 * @return 房间Index
		 * 
		 */
		public static function getRoomIndex(room_id:int):int
		{
			var i:int
//			trace(a,115,Room.tempData[i][FIELD_room_id],room_id);
			for(i = 0; i < Room.tempData.length; i++)
			{
				if(Room.tempData[i][FIELD_room_id] == room_id)
				{
					return i;
				}
			}
			return -1;
			
		}
		
		/**
		 * 获得 Room.tempData中的座位Index 
		 * @return 座位Index 
		 * 
		 */
		public static function getSeatIndex(room_index:int):int
		{
			var i:int;
			for(i = 0; i < 8; i++)
			{
				trace(a,147,room_index,Room.tempData[room_index][FIELD_room_players][i][UserActionServer.FIELD_user_id]);
				if(Room.tempData[room_index][FIELD_room_players][i][UserActionServer.FIELD_user_id] == 0)
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function updateData(room_id:uint, field:Array, data:Array):void
		{
			var result:int = Database.updateData(TABLE_room,field,data,FIELD_room_id + " = " + room_id);
			if (result >0)
			{
				Room.initTempData(room_id);
			}
			else
			{
				create(room_id);
			}
			//			trace(a,93,room_id,field,data,result);
			//			updateTempData(room_id, field, data);
		}
		
		public static function getData(room_id:uint, field:Array):void
		{
			var result:Array = Database.getData(TABLE_room,field,FIELD_room_id + " = " + room_id);
			
			if (result != null)
			{
				Room.initTempData(room_id);
			}
			else
			{
				create(room_id);
			}
			//			trace(a,93,room_id,field,data,result);
			//			updateTempData(room_id, field, data);
		}
		
//		private static function getTempData(room_id:uint):Array
//		{
//			var i:int
//			for(i = 0; i < Room.tempData.length; i++)
//			{
//				if(Room.tempData[i][FIELD_room_id] == room_id)
//				{
//					var j:int
//					for(j = 0; j < field.length; j++)
//					{
//						Room.tempData[i][field[j]] = data[j];
//					}
//					trace(a,98,Room.tempData[i]);
//					break;
//				}
//			}
//			
//		}
//		
		private static function updateTempData(room_id:uint, field:Array, data:Array):void
		{
			var i:int
			for(i = 0; i < Room.tempData.length; i++)
			{
				if(Room.tempData[i][FIELD_room_id] == room_id)
				{
					var j:int
					for(j = 0; j < field.length; j++)
					{
						Room.tempData[i][field[j]] = data[j];
					}
					trace(a,202,Room.tempData[i]);
					break;
				}
			}
			
		}
		
//		public static function initUI(room_index:int):void
//		{
//					var seat_index:int
//					for(seat_index = 0; seat_index < 8; seat_index++)
//					{
////						trace(a,115,room_index,seat_index);
//						updateRoomPlayerUI(room_index,seat_index);
//					}
////			trace(a,120,room_index)
//			
//			
//		}
//		
//		private static function initPlayerUI(room_id:int):void
//		{
//			var room_index:int = getRoomIndex(room_id);
//			if (room_index >= 0)
//			{
//				var player_data:Array = DataHandlerServer.dbArray(Room.tempData[room_index][FIELD_room_players]);
////				trace(a,129,Room.tempData[room_index][FIELD_room_players],player_data);
//				var seat_index:int
//				for(seat_index = 0; seat_index < 8; seat_index++)
//				{
////					trace(a,133,Room.tempData[i][FIELD_players][j]);
////					Room.tempData[i][FIELD_players][j] = [int(player_data[j%2]),int(player_data[j%2+1])];
////					updatePlayerData(room_index, seat_index, int(player_data[seat_index%2]),int(player_data[seat_index%2+1]));
//					updateRoomPlayerUI(room_index, seat_index);
//				}
//				Room.tempData[room_index][FIELD_room_members] = 0;
//			}
//			
//			initData(room_id);
//			initUI(room_index);
//			
//		}
		
		public static function updatePlayerData(room_index:int, seat_index:int, user_id:int, user_state:int):void
		{
			updatePlayerTempData(room_index, seat_index, user_id, user_state);
			var members:int = Room.tempData[room_index][FIELD_room_members];
//			var member_max:int = Room.tempData[room_index][FIELD_room_members_max];
//			trace(a,238,members,member_max);
//			if(members < member_max)
//			{
//				Room.tempData[room_index][FIELD_room_members] += 1;
				Database.updateData(TABLE_room, [FIELD_room_members, FIELD_room_players], [Room.tempData[room_index][FIELD_room_members], getPlayersString(room_index)], [FIELD_room_id] +　" = " + Room.tempData[room_index][FIELD_room_id]);
//				updatePlayerUI(0, );
//			}
//			else
//			{
//			}
		}
//		
//		private static function updateRoomPlayerUI(room_index:int, seat_index:int):void
//		{
//						trace(a,252,room_index,seat_index);
//						if(seat_index == -1)
//						{
//							seat_index = 0;
//						}
//			var player_id:int = Room.tempData[room_index][FIELD_room_players][seat_index][0];
//			var nick:String;
//			var state:int;
//			var charge:int;
//			var coin:int;
//			
//			if(player_id == 0)
//			{
//				nick = UImanager.UI_player_default;
//				state = 0;
//				charge = 0;
//				coin = 0;
//			}
//			else
//			{
//				var player_data:Array = UserActionServer.getData(player_id);
//				nick = player_data[0][UserActionServer.FIELD_user_nick];
//				state = player_data[0][UserActionServer.FIELD_user_state];
//				charge = player_data[0][UserActionServer.FIELD_user_charge];
//				coin = player_data[0][UserActionServer.FIELD_user_coin];
////			trace(a,272,nick);
//			}
//			
//			updatePlayerUI(seat_index,nick,state,charge,coin);
//			
//		}

		public static function updatePlayerUI(seat_index:int, nick:String, state:int, charge:int, coin:int):void
		{
			UImanager.players_UI[seat_index][UImanager.UI_player_nick].text = nick;
			UImanager.players_UI[seat_index][UImanager.UI_player_state].text = state;
			UImanager.players_UI[seat_index][UImanager.UI_player_charge].text = charge;
			UImanager.players_UI[seat_index][UImanager.UI_player_coin].text = coin;
		}
		
		public static function updatePlayerTempData(room_index:int, seat_index:int, user_id:int, state:int):void
		{
			if(user_id > 0)
			{
				Room.tempData[room_index][FIELD_room_members] += 1;
			}
			else
			{
				Room.tempData[room_index][FIELD_room_members] -= 1;
			}
			Room.tempData[room_index][FIELD_room_players][seat_index][0] = user_id;
			Room.tempData[room_index][FIELD_room_players][seat_index][1] = state;
		}

		
		/**
		 * 广播房间信息
		 * @return 房间ID 
		 * 
		 */
		public static function sentRoomData(room_id:uint):Array
		{
			var get_data:Array = Database.getData(TABLE_room,["*"],FIELD_room_id + " = "+room_id);
			//			trace("action 18：	",chk_nick);
			if(get_data)
			{
//				trace("room sentRoomData!",get_data[0]);
				return get_data[0];
			}
			return null;
		}
		
		public static function setPlayerData(room_index:int, seat_index:int, field:String, data:*):void
		{
			Room.tempData[room_index][FIELD_room_players][seat_index][field] = data;
		}
		
		public static function getPlayersString(room_index:int):String
		{
			var players:String = "";
			var seat_index:int
			for(seat_index = 0 ; seat_index < 8; seat_index ++)
			{
				players = players + 
					Room.tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_id] + "," +
					Room.tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_nick] + "," +
					Room.tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_state] + "," +
					Room.tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_charge] + "," +
					Room.tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_coin] + ","
					;
			}
			players = players.substring(0,players.length-1);
			trace(a,374,players)
			return players;
		}

		
		
	}
}