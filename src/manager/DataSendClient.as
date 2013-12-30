package manager
{
	import flash.data.SQLResult;
	
	import naga.system.Conn;
		
	public class DataSendClient
	{
		private static const a:String = "Database";
		
		public function DataSendClient()
		{
		}
		
		/**
		 * 查询数据
		 * @return 查询结果
		 * 
		 */		
		public static function getData(table:String,field:Array,condition:String=""):void
		{
			
			GuessClientUser.dataHandler.send2Server("select|"+table+"|"+field+"|"+condition);
//			if(condition != "")
//			{
//				sql = sql + " WHERE " + condition;
//			}
//			var result:SQLResult;
//			GuessClientUser.send2Server("select|"+table+"|"+field+"|"+condition);
////			trace("database 26:	",field,result.data[0].room_state);
//			return result.data;
		}
		
		/**
		 * 插入数据
		 * 
		 */
		public static function insertData(table:String, field:Array, data:Array):void
		{
			GuessClientUser.dataHandler.send2Server("insert|"+table+"|"+field+"|"+data);
//			var sql:String = "INSERT INTO "+table+"("+field+")VALUES("+data+")";
//			Conn.insertSql(sql);
//			trace("database 37:	",field,data);
		}
		
		/**
		 * 更新数据
		 * 
		 */		
		public static function updateData(table:String,field:Array, data:Array,condition:String):void
		{
			GuessClientUser.dataHandler.send2Server("update|"+table+"|"+field+"|"+data+"|"+condition);
//			var sql:String = "UPDATE "+table+" SET ";
//			var i:int;
//			for(i=0; i<field.length; i++)
//			{
////				trace(a,69,data[i],data[i] is String || data[i] is Array ,data[i].toString().search(/[\+]/));
//				if((data[i] is String && data[i].toString().search(/[\+]/) <0) || data[i] is Array)
//				{
//					sql = sql + field[i] + " = " + Database.dbString(data[i]);
//				}
//				else
//				{
//					sql = sql + field[i] + " = " + data[i];
//				}
//				sql = sql + " , "
//			}
//			sql = sql.substring(0,sql.length-3);
//			if(condition != "")
//			{
//				sql = sql + " WHERE " + condition;
//			}
//			var result:SQLResult;
//			result = Conn.selectSql(sql);
////			trace(a, 72, sql,field,result.data,result.rowsAffected);
//			return result.rowsAffected;
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
			return str.split(",");
		}
		
		/**
		 * 修改数据 
		 * @param user_id
		 * @param data
		 * @return 反馈信息参数
		 * 
		 */		
		public static function changeData(user_id:uint,data:uint):uint
		{
			var result:uint;
			
			return result;
		}
		
		/**
		 * 累加数据 
		 * @param user_id
		 * @param data
		 * @return 反馈信息参数
		 * 
		 */		
		public static function addData(user_id:uint,data:uint):uint
		{
			var result:uint;
			
			return result;
		}
		
		public static function check(user_id:uint,data:uint):uint
		{
			var result:uint;
			
			return result;
		}
		
		
	}
}