package manager
{
	import flash.net.Socket;
	
	import game.Room;
	
	import user.UserActionServer;

	public class DataHandlerServer
	{
		private static const a:String = "DataHandler_Server";
		private static var clientSocket:Socket;
		
		public function DataHandlerServer()
		{
		}
		
		public function init(socket:Socket):void
		{
			clientSocket = socket;
		}
		
		//向服务器发送数据
		public static function send2Server(msg:String):void
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
		
		public function handleSocketData(data:String, socket:Socket):void
		{
			//		房间	R|roomIndex|a,b,c|1,"2","3,4,5"
			//		用户	U|roomIndex,seatIndex|a,b,c|1,"2","3,4,5"
			//		游戏	G|gameIndex|a,b,c|1,"2","3,4,5"
			//		登录	L|nick||
			var arr:Array = data.split(/\|/);
			trace(a, 46, "Sokect Data: ", arr);
			var i:int
			for (i = 0; i < arr.length/4; i++)
			{
				this["progressData"+arr[i*4]].call(null, socket, dbArray(arr[i*4+1]), dbArray(arr[i*4+2]), dbArray(arr[i*4+3]));
				
			}
		}
		
		private function progressDataCheckIn(socket:Socket, index:Array, field:Array, data:Array):void
		{
			trace(a, 60, "CheckIn ", index[0]);
				UserActionServer.login(socket, index[0]);
		}
		
		private function progressDataR(socket:Socket, index:Array, field:Array, data:Array):void
		{
			var i :int ;
			for(i = 0; i <field.length; i++)
			{
				Room.tempData[index[0]][field[i]] = data[i];
				trace(a,70,field[i],Room.tempData[index[0]][field[i]]);
			}
		}
		
		private function progressDataU(socket:Socket, index:Array, field:Array, data:Array):void
		{
			var i :int ;
			for(i = 0; i <field.length; i++)
			{
				Room.tempData[index[0]][Room.FIELD_room_players][index[1]][field[i]] = data[i];
				trace(a,80,field[i],Room.tempData[index[0]][Room.FIELD_room_players][index[1]][UserActionServer.FIELD_user_nick]);
			}
			Room.updatePlayerUI(index[0], index[1]);
		}
		
		private function progressDataG(socket:Socket, game_index:int, field:Array, data:Array):void
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
			if(str != null)
			{
				return str.split(/\,/);
			}
			else
			{
				return null;
			}
		}
		
		
	}
}