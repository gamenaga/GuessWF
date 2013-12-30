package ui
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import naga.global.Css;
	import naga.global.Global;
	import naga.system.EventManager;
	import naga.ui.Button_s;

	public class UICreater
	{
		public function UICreater()
		{
		}
		
		public static function createTextField( x:int, y:int, label:String, defaultValue:String = '', width:int = 0, height:int = 0, editable:Boolean = true ):TextField
		{
			var input:TextField = new TextField();
			if(label != "")
			{
				var labelField:TextField = new TextField();
				labelField.text = label;
				labelField.type = TextFieldType.DYNAMIC;
				labelField.width = 80;
				labelField.x = x;
				labelField.y = y;
				input.x = x + labelField.width;
				Global.ui_floor.addChild( labelField );
			}
			else
			{
				input.x = x;
			}
			
			if(width == 0)
			{
				width = Global.stage_w - labelField.x*2 - labelField.width;
			}
			if(height == 0)
			{
				height = Css.SIZE*2;
			}
			input.text = defaultValue;
			input.type = TextFieldType.INPUT;
			input.border = editable;
			input.selectable = editable;
			input.width = width;
			input.height = height;
			input.y = y;
			
			Global.ui_floor.addChild( input );
			
			return input;
		}
		
		public static function createBtn( x:int, y:int, label:String, fn:Function, para:Array, width:uint=100, height:uint=30, inputable:Boolean=false):Button_s
		{
			var btn:Button_s
			btn = new Button_s(label, width, height, "111111", 1, "888888",0,0,inputable);
			if(fn)
			{
				EventManager.AddEventFn(btn,MouseEvent.CLICK,fn,para);
			}
			else
			{
				btn.mode = false;
			}
			btn.x = x;
			btn.y = y;
			
			Global.ui_floor.addChild( btn );
			
			return btn;
		}
		
		public static function removeBtn(btnObj:Button_s):void
		{
			EventManager.delAllEvent(btnObj);
			Global.ui_floor.removeChild( btnObj );
			btnObj = null;
		}
		
	}
	
}