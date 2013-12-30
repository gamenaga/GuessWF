package
{
	import naga.system.DataObjShare;
	
	public class DataObj extends DataObjShare
	{
		public static function init():void
		{
			init_("PopPooh");
//			trace(data[0]);
		}
		
		public static function loadData():void
		{
			loadData_();
		}
		
		public static function saveData():void
		{
			saveData_();
		}
		
		public static function delData():void
		{
			delData_();
		}
		
		public static function get data():Array
		{
			return so.data.userData;
		}
		
	}
	
}