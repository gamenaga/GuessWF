package ui
{
	import naga.system.BitmapClip;
	import naga.system.IPoolable;
	import naga.ui.DialogNPC;
	
	public class NpcDialog extends DialogNPC implements IPoolable
	{
		private var _destroyed:Boolean;
		private var frame:uint;
		public function NpcDialog()
		{
			_destroyed = true;
			renew();
			
		}
		
		/* INTERFACE IPoolable */
		
		public function get destroyed():Boolean 
		{
			return _destroyed;
		}
		
		public function renew(...paramenters):void 
		{
			if (!_destroyed)
			{
				return;
			}
			
			_destroyed = false;
			
			/* 创建内容 */
			if(!BC)
			{
				mouseChildren=false;
				mouseEnabled=false;
				BC=new BitmapClip(new NPC001_(),"NPC001");
			}
			BC.gotoAndStop(frame);
			addChild(BC);
			
		}
		
		public function destroy():void 
		{
			if (_destroyed)
			{
				return;
			}
			
			_destroyed = true;
			
			/* 移出场景 */
			removeChild(BC);
		}
		public function dispose():void
		{
			
		}
	}
}