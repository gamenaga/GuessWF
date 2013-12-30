package game
{
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import naga.global.Css;
	import naga.global.Global;
	import naga.system.BitmapClip;
	import naga.system.Bubble;
	import naga.ui.Dialog;
	import naga.tool.Chk;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	

	public class CashResult extends starling.display.Sprite
	{
		private var btn_add_cash_BC:BitmapClip =new BitmapClip(new btnThankOut(),"btn_add_cash_BC");
		public var btn_add_cash:Button = new Button(Texture.fromBitmapData(btn_add_cash_BC.bitmapData));
		private var btn_get_result_BC:BitmapClip =new BitmapClip(new btnAchOut(),"btn_get_result_BC");
		public var btn_get_result:Button = new Button(Texture.fromBitmapData(btn_get_result_BC.bitmapData,true,false,2));
		private var btn_reset_BC:BitmapClip =new BitmapClip(new btnReplayOut(),"btn_reset_BC");
		public var btn_reset:Button = new Button(Texture.fromBitmapData(btn_reset_BC.bitmapData,true,false,2));
		private var btn_subtract_cash_BC:BitmapClip =new BitmapClip(new btnHomeOut(),"btn_del_cash_BC");
		public var btn_subtract_cash:Button = new Button(Texture.fromBitmapData(btn_subtract_cash_BC.bitmapData,true,false,2));
		public var cash_total_title:TextField = new TextField(300,100,"奖金池","黑体",28,0x654321,true);
		public var cash_total:TextField = new TextField(300,100,"0","黑体",58,0x984321,true);
		public var cash_result:TextField = new TextField(300,240,"奖金分配：","黑体",18,0x654321,true);
		
		private const CHIPS_BEGIN:uint = 10;
		private const PRICE_LOSER:Number = .1;
		private const PRICE_1ST:Number = .3;
		private const PRICE_2ND:Number = .2;
		private const PRICE_3RD:Number = .1;
		
		public function CashResult()
		{
			if(stage)
			{
				
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			
		}
		
		public function init():void
		{
			cash_total_title.x = (Global.stage_w - cash_total_title.width)*.5;
			cash_total_title.vAlign = VAlign.TOP;
			addChild(cash_total_title);
			
			cash_total.x = (Global.stage_w - cash_total.width)*.5;
			cash_total.vAlign = VAlign.TOP;
			cash_total.y = 30;
			addChild(cash_total);
			
			btn_add_cash.x = (Global.stage_w - btn_add_cash.width)*.5;
			btn_add_cash.y = (Global.stage_h - btn_add_cash.height)*.3;
			addChild(btn_add_cash);
			btn_add_cash.addEventListener(starling.events.TouchEvent.TOUCH,addCash);
			
			btn_subtract_cash.x = btn_add_cash.x + btn_add_cash.width;
			btn_subtract_cash.y = btn_add_cash.y + btn_add_cash.height - btn_subtract_cash.height;
			addChild(btn_subtract_cash);
			btn_subtract_cash.addEventListener(starling.events.TouchEvent.TOUCH,subtractCash);
			
			cash_result.x = (Global.stage_w - cash_result.width)*.5;
			cash_result.y = 260;
			cash_result.hAlign = HAlign.LEFT;
			cash_result.vAlign = VAlign.TOP;
			cash_result.touchable = false;
			addChild(cash_result);
			
			btn_reset.x = Global.stage_w - btn_reset.width;
			btn_reset.y = Global.stage_h - btn_reset.height;
			addChild(btn_reset);
			btn_reset.addEventListener(starling.events.TouchEvent.TOUCH,reSet);
			
//			trace("cashResult 52:	",btn_get_result.width,btn_get_result.height,Global.stage_w-btn_get_result.width);
			btn_get_result.x = btn_reset.x - btn_get_result.width;
			btn_get_result.y = Global.stage_h - btn_get_result.height;
			addChild(btn_get_result);
			btn_get_result.addEventListener(starling.events.TouchEvent.TOUCH,getResult);
//			EventManager.AddEventFn(btn_add_cash as flash.events.EventDispatcher,flash.events.MouseEvent.CLICK,addCash,[1]);
			
			reSet();
		}
		
		private function addCash(event:TouchEvent,event2,num:uint=1):void
		{
			var pos:Point = Chk.touch(event);
			if(pos)
			{
				Bubble.instance.show("+1","cash",pos.x,pos.y,80,Css.SIZE*2);
				cash_total.text　= String(cash_total_num + num);
			}
			
		}
		
		private function subtractCash(event:TouchEvent,event2,num:uint=1):void
		{
			var pos:Point = Chk.touch(event);
			if(pos)
			{
				Bubble.instance.show("-1","cash",pos.x,pos.y,80,Css.SIZE*1.5,Css.BL_D);
				cash_total.text　= String(Math.max(0,cash_total_num - num));
			}
			
		}
		
		private function getResult(event:TouchEvent):void
		{
			var pos:Point = Chk.touch(event);
			if(pos)
			{
					removeBtnListener();
					Dialog.add("请选择胜利人数：",null,0,null,null,250,200,0,0,0,["<b>1</b>",showResult1,"2",showResult2,"3",showResult3,"0",showResult0]);
			}
			
		}
		private function showResult1():void
		{
			showResult(1);
		}
		private function showResult2():void
		{
			showResult(2);
		}
		private function showResult3():void
		{
			showResult(3);
		}
		private function showResult0():void
		{
			showResult(0);
		}
		private function showResult(num:uint):void
		{
			var result:String;
			var price1:String;
			var price2:String;
			var price3:String;
			var price0:String;
			var price_num1:uint;
			var price_num2:uint;
			var price_num3:uint;
			var price_num0:uint;
			if(num==0)
			{
				price_num1 = Math.floor(cash_total_num * PRICE_LOSER);
				price_num2 = price_num1;
				price_num3 = price_num1;
				price1 =	"Loser 1：		" + price_num1;
				price2 =	"Loser 2：		" + price_num2;
				price3 =	"Loser 3：		" + price_num3;
			}
			else if(num==1)
			{
				price_num1 = Math.floor((cash_total_num - CHIPS_BEGIN) * PRICE_1ST + CHIPS_BEGIN);
				price_num2 = Math.floor((cash_total_num - CHIPS_BEGIN) * PRICE_LOSER);
				price_num3 = Math.floor((cash_total_num - CHIPS_BEGIN) * PRICE_LOSER);
				price1 =	"Winner 1st：	" + price_num1 + " (" + (price_num1-CHIPS_BEGIN) + "+" + CHIPS_BEGIN + ") ";
				price2 =	"Loser 1：		" + price_num2;
				price3 =	"Loser 2：		" + price_num3;
			}
			else if(num==2)
			{
				price_num1 = Math.floor((cash_total_num - CHIPS_BEGIN*2) * PRICE_1ST + CHIPS_BEGIN);
				price_num2 = Math.floor((cash_total_num - CHIPS_BEGIN*2) * PRICE_2ND + CHIPS_BEGIN);
				price_num3 = Math.floor((cash_total_num - CHIPS_BEGIN*2) * PRICE_LOSER);
				price1 =	"Winner 1st：	" + price_num1 + " (" + (price_num2-CHIPS_BEGIN) + "+" + CHIPS_BEGIN + ") ";
				price2 =	"Winner 2nd：	" + price_num2 + " (" + (price_num2-CHIPS_BEGIN) + "+" + CHIPS_BEGIN + ") ";
				price3 =	"Loser  ：		" + price_num3;
			}
			else if(num==3)
			{
				price_num1 = Math.floor((cash_total_num - CHIPS_BEGIN*3) * PRICE_1ST + CHIPS_BEGIN);
				price_num2 = Math.floor((cash_total_num - CHIPS_BEGIN*3) * PRICE_2ND + CHIPS_BEGIN);
				price_num3 = Math.floor((cash_total_num - CHIPS_BEGIN*3) * PRICE_3RD + CHIPS_BEGIN);
				price1 =	"Winner 1st：	" + price_num1 + " (" + (price_num1-CHIPS_BEGIN) + "+" + CHIPS_BEGIN + ") ";
				price2 =	"Winner 2nd：	" + price_num2 + " (" + (price_num2-CHIPS_BEGIN) + "+" + CHIPS_BEGIN + ") ";
				price3 =	"Winner 3rd：	" + price_num3 + " (" + (price_num3-CHIPS_BEGIN) + "+" + CHIPS_BEGIN + ") ";
			}
			price_num0 = cash_total_num - price_num1 - price_num2 - price_num3;
			price0 = 		"庄家：			" + price_num0;
			cash_result.text　= String("奖金分配：\n\n  " + price0 + "\n  " + price1 + "\n  " + price2 + "\n  " + price3);
			setTimeout(addBtnListener,1000);
		}
		
		private function reSet(event:TouchEvent=null):void
		{
			if (event!=null)
			{
				var pos:Point = Chk.touch(event);
				if(pos)
				{
						cash_total.text　= "40";
						cash_result.text　= "游戏进行中……";
				}
				
			}
			else
			{
				cash_total.text　= "40";
				cash_result.text　= "游戏进行中……";
			}
		}
		
		/**
		 *设置所有按钮的侦听 
		 * 
		 */		
		public function addBtnListener():void
		{
//			btn_get_result.addEventListener(starling.events.TouchEvent.TOUCH,getResult);
//			btn_add_cash.addEventListener(starling.events.TouchEvent.TOUCH,addCash);
//			btn_subtract_cash.addEventListener(starling.events.TouchEvent.TOUCH,subtractCash);
//			btn_reset.addEventListener(starling.events.TouchEvent.TOUCH,reSet);
			btn_get_result.touchable = true;
			btn_add_cash.touchable = true;
			btn_subtract_cash.touchable = true;
			btn_reset.touchable = true;
		}
		
		/**
		 *移出所有按钮的侦听 
		 * 
		 */
		public function removeBtnListener():void
		{
//			btn_get_result.removeEventListener(starling.events.TouchEvent.TOUCH,getResult);
//			btn_add_cash.removeEventListener(starling.events.TouchEvent.TOUCH,addCash);
//			btn_subtract_cash.removeEventListener(starling.events.TouchEvent.TOUCH,subtractCash);
//			btn_reset.removeEventListener(starling.events.TouchEvent.TOUCH,reSet);
			btn_get_result.touchable = false;
			btn_add_cash.touchable = false;
			btn_subtract_cash.touchable = false;
			btn_reset.touchable = false;
		}
		
		private function get cash_total_num():uint
		{
			return Number(cash_total.text);
		}
		
		
		
		
	}
}