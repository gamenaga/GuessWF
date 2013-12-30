package game
{
	import manager.DataSendClient;
	
	import ui.UImanager;
	
	import user.UserAction;

	public class Room
	{
		private static const a:String = "Room";
		
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
		public static var tempData:Array = [];
		
		public function Room()
		{
		}
		
		public static function initTempData(room_id:int,data:Array=null):int
		{
			tempData.push([]);//房间列表  创建新房间
			var room_index:int = tempData.length-1;
			tempData[room_index][FIELD_room_id] = room_id;
			tempData[room_index][FIELD_room_state] = STATE_WAIT;
			tempData[room_index][FIELD_room_members] = 0;
			tempData[room_index][FIELD_room_members_max] = MEMBERS_MAX;
			tempData[room_index][FIELD_room_owner_id] = 0;
			tempData[room_index][FIELD_room_players] = [];
			trace(a,50,room_index,tempData[room_index][FIELD_room_players]);
			initTempDataPlayers(room_index);
			return tempData.lenght-1;
			
		}
		
		public static function create(room_id:int):void
		{
			initTempData(room_id);
			initPlayerUI(room_id)
			DataSendClient.insertData(TABLE_room,
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
				return initTempData(room_id);
			}
			else
			{
				return room_index;
			}
		}
		
		public static function initData(room_id:int):void
		{
			DataSendClient.updateData(TABLE_room,
				[FIELD_room_state, FIELD_room_members, FIELD_room_members_max, FIELD_room_players, FIELD_room_owner_id],
				[STATE_WAIT, 0, MEMBERS_MAX, INIT_PLAYERS, 0],FIELD_room_id + " = " + room_id);
		}
		
		/**
		 * 找1个等待中的房间 ID
		 * @return 房间ID 
		 * 
		 */
		public static function checkWaitingRoomID():int
		{
//			var chk_room:Array = DataSendClient.getData(TABLE_room,[FIELD_room_id,FIELD_room_state],FIELD_room_state + " = "+STATE_WAIT+" LIMIT 1");
//			//			trace("action 18：	",chk_nick);
//			if(chk_room && chk_room[0][FIELD_room_state] > 0)
//			{
//				//				trace("action 18：	",chk_nick[0].nick);
//				return chk_room[0][FIELD_room_id];
//			}
//			return -1;
			return 1;
		}
		
		public static function checkWaitingRoomIndex():int
		{
			var room_index:int;
			for (room_index = 0 ; room_index < tempData.length; room_index ++)
			{
				if(tempData[room_index][FIELD_room_state] == STATE_WAIT)
				{
					return room_index;
				}
			}		
			
			return -1;
		}
		
		public static function getRoomData(room_id:uint,field:Array):Object
		{
//			var get_data:Array = DataSendClient.getData(TABLE_room,field,FIELD_room_id + " = "+room_id);
//			trace("ROOM 96：	",get_data[0][FIELD_room_id]);
//			if(get_data)
//			{
//				//				trace("action 18：	",chk_nick[0].nick);
//				return get_data[0];
//			}
//			return null;
			
			return tempData[0];
		}
		
		public static function getTempData(room_index:uint):Array
		{
			var get_data:Array = tempData[room_index];
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
//			trace(a,115,tempData[i][FIELD_room_id],room_id);
			for(i = 0; i < tempData.length; i++)
			{
				if(tempData[i][FIELD_room_id] == room_id)
				{
					return i;
				}
			}
			return -1;
			
		}
		
		/**
		 * 获得 tempData中的座位Index 
		 * @return 座位Index 
		 * 
		 */
		public static function getSeatIndex(room_index:int):int
		{
			var chk_seat:Array = tempData[room_index][FIELD_room_players];
			var i:int;
			for(i = 0; i < 8; i++)
			{
				trace(a,162,room_index,tempData[room_index][FIELD_room_players][i][UserAction.FIELD_user_id]);
				if(tempData[room_index][FIELD_room_players][i][UserAction.FIELD_user_id] == 0)
				{
					return i;
				}
			}
			return -1;
		}
		
		public static function updateData(room_id:uint, field:Array, data:Array):void
		{
//			DataSendClient.updateData(TABLE_room,field,data,FIELD_room_id + " = " + room_id);
				initTempData(room_id);
			//			trace(a,93,room_id,field,data,result);
			//			updateTempData(room_id, field, data);
		}
		
//		public static function getData(room_id:uint, field:Array):void
//		{
//			var result:Array = DataSendClient.getData(TABLE_room,field,FIELD_room_id + " = " + room_id);
//			
//			if (result != null)
//			{
//				initTempData(room_id);
//			}
//			else
//			{
//				create(room_id);
//			}
//			//			trace(a,93,room_id,field,data,result);
//			//			updateTempData(room_id, field, data);
//		}
		
//		private static function getTempData(room_id:uint):Array
//		{
//			var i:int
//			for(i = 0; i < tempData.length; i++)
//			{
//				if(tempData[i][FIELD_room_id] == room_id)
//				{
//					var j:int
//					for(j = 0; j < field.length; j++)
//					{
//						tempData[i][field[j]] = data[j];
//					}
//					trace(a,98,tempData[i]);
//					break;
//				}
//			}
//			
//		}
//		
		private static function updateTempData(room_id:uint, field:Array, data:Array):void
		{
			var i:int
			for(i = 0; i < tempData.length; i++)
			{
				if(tempData[i][FIELD_room_id] == room_id)
				{
					var j:int
					for(j = 0; j < field.length; j++)
					{
						tempData[i][field[j]] = data[j];
					}
					trace(a,202,tempData[i]);
					break;
				}
			}
			
		}
		
		public static function initUI(room_index:int):void
		{
					var seat_index:int
					for(seat_index = 0; seat_index < 8; seat_index++)
					{
//						trace(a,115,room_index,seat_index);
						updateRoomPlayerUI(room_index,seat_index);
					}
//			trace(a,120,room_index)
			
			
		}
		
		private static function initPlayerUI(room_id:int):void
		{
			var room_index:int = getRoomIndex(room_id);
			if (room_index >= 0)
			{
//				var player_data:Array = DataSendClient.dbArray(tempData[room_index][FIELD_room_players]);
//				trace(a,129,tempData[room_index][FIELD_room_players],player_data);
				var seat_index:int
				for(seat_index = 0; seat_index < 8; seat_index++)
				{
//					trace(a,133,tempData[i][FIELD_players][j]);
//					tempData[i][FIELD_players][j] = [int(player_data[j%2]),int(player_data[j%2+1])];
//					setPlayerData(room_index, seat_index, int(player_data[seat_index%2]),int(player_data[seat_index%2+1]));
					updateRoomPlayerUI(room_index, seat_index);
				}
				tempData[room_index][FIELD_room_members] = 0;
			}
			
			initData(room_id);
			initUI(room_index);
			
		}
		
		public static function initTempDataPlayers(room_index:int):void
		{
			var i:int;
			for (i = 0; i < 8; i++)
			{
				tempData[room_index][FIELD_room_players][i] = [];
				setPlayerData(room_index,i,UserAction.FIELD_user_id, 0);
				setPlayerData(room_index,i,UserAction.FIELD_user_nick, "");
				setPlayerData(room_index,i,UserAction.FIELD_user_state, UserAction.STATE_offline);
				setPlayerData(room_index,i,UserAction.FIELD_user_charge, 0);
				setPlayerData(room_index,i,UserAction.FIELD_user_coin, 0);
				
//				tempData[room_index][Room.FIELD_room_players][i][UserAction.FIELD_user_id] = 0;
//				tempData[room_index][Room.FIELD_room_players][i][UserAction.FIELD_user_nick] = "";
//				tempData[room_index][Room.FIELD_room_players][i][UserAction.FIELD_user_state] = UserAction.STATE_offline;
//				tempData[room_index][Room.FIELD_room_players][i][UserAction.FIELD_user_charge] = 0;
//				tempData[room_index][Room.FIELD_room_players][i][UserAction.FIELD_user_coin] = 0;
//				tempData[room_index][Room.FIELD_room_players][i][UserAction.FIELD_user_room_index] = -1;
//				tempData[room_index][Room.FIELD_room_players][i][UserAction.FIELD_user_seat_index] = -1;
			}
//			trace(a,282,tempData[room_index][FIELD_room_players][0],tempData[room_index][FIELD_room_players][1],tempData[room_index][FIELD_room_players][2],tempData[room_index][FIELD_room_players][3]);
			trace(a,307,tempData[room_index][FIELD_room_players][0][UserAction.FIELD_user_id]);
		}
		
		private static function updateRoomPlayerUI(room_index:int, seat_index:int = -1):void
		{
			trace(a,312,room_index,seat_index);
			if(seat_index == -1)
			{
				seat_index = 0;
			}
			
			updatePlayerUI(room_index, seat_index);
			
		}

		public static function updatePlayerUI(room_index:int, seat_index:int):void
		{
			if(UImanager.players_UI.length > 1)
			{
			UImanager.players_UI[seat_index][UImanager.UI_player_nick].text = tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_nick];
			UImanager.players_UI[seat_index][UImanager.UI_player_state].text = tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_state];
			UImanager.players_UI[seat_index][UImanager.UI_player_charge].text = tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_charge];
			UImanager.players_UI[seat_index][UImanager.UI_player_coin].text = tempData[room_index][FIELD_room_players][seat_index][UserAction.FIELD_user_coin];
			}
		}
		
		public static function setPlayerData(room_index:int, seat_index:int, field:String, data:*):void
		{
			tempData[room_index][FIELD_room_players][seat_index][field] = data;
		}
		
		public static function getPlayerData(room_index:int, seat_index:int, field:String):void
		{
			tempData[room_index][FIELD_room_players][seat_index][field];
		}

		
		
	}
}