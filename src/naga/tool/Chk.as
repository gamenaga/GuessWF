package naga.tool
{
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Chk
	{
		public function Chk()
		{
		}
		
		public static function touch(event:TouchEvent):Point
		{
			var obj:DisplayObject = event.currentTarget as DisplayObject;
			var touch:Touch = event.getTouch(obj);
			if (touch)
			{
				var pos:Point = touch.getLocation(obj);
				//				trace ( "cashResult 107:	",touch.phase ,pos.x,pos.y);
				if(touch.phase == TouchPhase.ENDED)
				{
					//					trace ( "cashResult 148:	",event.target,event.currentTarget,obj.x,touch.phase ,pos.x,pos.y,obj.hitTest(new Point(pos.x,pos.y),true));
					if(obj.hitTest(pos,true) == event.target)
					{
						return new Point(pos.x+obj.x,pos.y+obj.y);
						
					}
				}
			}
			return null;
		}
	}
}