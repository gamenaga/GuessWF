package manager
{
	import flash.net.Socket;
	
	import game.Room;
	
	import user.UserAction;

	public class DataHandler
	{
		private static const a:String = "DataHandler";
		private static var clientSocket:Socket;
		
		public function DataHandler()
		{
		}
		
		public function init(socket:Socket):void
		{
			clientSocket = socket;
		}
		
		//向服务器发送数据
		public function send2Server(msg:String):void
		{
			try
			{
				if( clientSocket != null && clientSocket.connected )
				{
					clientSocket.writeUTFBytes( msg );
					clientSocket.flush(); 
					trace( "Sent message to " + msg);
				}
				else trace("No socket connection.");
			}
			catch ( error:Error )
			{
				trace( error.message );
			}
		}
		
		public function handleSocketData(data:String):void
		{
			//		房间	R|roomIndex|a,b,c|1,"2","3,4,5"
			//		用户	U|roomIndex,seatIndex|a,b,c|1,"2","3,4,5"
			//		游戏	G|gameIndex|a,b,c|1,"2","3,4,5"
			//		登录	L|userID|a,b,c|1,"2","3,4,5"
			var arr:Array = data.split(/\|/);
			trace(a, 46, "Sokect Data: ", arr);
			var i:int
			for (i = 0; i < arr.length/4; i++)
			{
				this["progressData"+arr[i*4]].call(null, dbArray(arr[i*4+1]), dbArray(arr[i*4+2]), dbArray(arr[i*4+3]));
			}
		}
		
		/**
		 * 登录成功后，服务器返回的信息
		 * @param user_id userID
		 * @param field 更新内存中的参数字段
		 * @param data 更新字段的内容
		 * 
		 */
		private function progressDataL(user_id:Array, field:Array, data:Array):void
		{
			var i :int ;
			for(i = 0; i <field.length; i++)
			{
				UserAction.loginHandler(user_id[0], field, data);
			}
		}
		
		/**
		 * 进入房间成功后，服务器返回的信息
		 * @param index 房间index 和 座位index
		 * @param field 更新内存中的参数字段
		 * @param data 更新字段的内容
		 * 
		 */
		private function progressDataCheckIn(index:Array, field:Array, data:Array):void
		{
			var i :int ;
			for(i = 0; i <field.length; i++)
			{
				UserAction.checkInHandler(index[0], index[1], field, data);
			}
		}
		
		private function progressDataR(index:Array, field:Array, data:Array):void
		{
			var i :int ;
			for(i = 0; i <field.length; i++)
			{
				Room.tempData[index[0]][field[i]] = data[i];
				trace(a,90,field[i],Room.tempData[index[0]][field[i]]);
			}
		}
		
		private function progressDataUser(index:Array, field:Array, data:Array):void
		{
			var i :int ;
			for(i = 0; i <field.length; i++)
			{
				Room.tempData[index[0]][Room.FIELD_room_players][index[1]][field[i]] = data[i];
				trace(a,105,field[i],Room.tempData[index[0]][Room.FIELD_room_players][index[1]][UserAction.FIELD_user_nick]);
			}
			Room.updatePlayerUI(index[0], index[1]);
		}
		
		private function progressDataG(game_index:int, field:Array, data:Array):void
		{
			
		}
		
		/**
		 * 过滤特殊资金，并给字符串加""
		 */
		public static function dbString(str:String, clear:Boolean = false):String
		{
			if(clear)
			{
				str = str.replace(/(\W)/g, "");//特殊字符转义
			}
			
			return "\""+str+"\"";
		}
		
		/**
		 * 库中String数据转Array
		 */
		public static function dbIncrease(field:String, num:Number):String
		{
			
			return field + " + " + num;
		}
		
		/**
		 * 库中String数据转Array
		 */
		public static function dbArray(str:String):Array
		{
			trace(a,100,str.split(/\,/)[0])
			return str.split(/\,/);
		}
		
		
	}
}