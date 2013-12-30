package game
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import audio.Bgm;
	
	import naga.global.Global;
	import naga.system.EventManager;
	
	public class Mode extends Sprite
	{
		public static var g_mode:String;
		public static var game_state:uint;
		public static var game_type:String;
		public static const STATE_INIT:uint = 20;
		public static const STATE_PLAY:uint = 30;
		public static const STATE_STOP:uint = 40;
		public static const STATE_END:uint = 50;
		public var ach:Object= {};
		protected var delay:uint;
		public static const MODE_GUIDE:String="Guide Mode";
		public static const TYPE_TEST:Object={name:"Test Type", pop_type:0, move_sp:2, move_sp_max:5, sp_max:488, sp_min:100, hp:3, silver:0};
		
		
		public function Mode(type:Object, show_score:Boolean = false)
		{
			//			trace("mode 91:	type"+mode_type);
			init(type);
			game_ready();
		}
		
		public function init(type:Object):void
		{
		}
		
		protected function game_loop() : void
		{
			switch(game_state)
			{
				case STATE_INIT:
				{
					game_init();
					break;
				}
				case STATE_PLAY:
				{
					game_play();
					break;
				}
				case STATE_STOP:
				{
					game_stop();
					break;
				}
				default:
				{
					break;
				}
			}
		}
		
		public function game_ready() : void
		{
			//泡泡弹力系数初始化
			Global.spring = .1;//加速度
			Global.vx = .014;
			Global.vy = -.015;
			Global.friction = .97;//摩擦力作用
			//初始化成就属性 
			if(DataObj.data[1] >0)
			{//如果最高分成就>0  表示不是第一次玩游戏
				ach = {h_score:0, h_time:0, h_t_score:0, h_combo:0, g_combo:0, bg_lv:0,g_pop_num:DataObj.data[11] + DataObj.data[12],h_lv:0};
			}
			else
			{//第一次玩，不检测成就。
				ach = {h_score:1, h_time:1, h_t_score:1, h_combo:1, g_combo:0, bg_lv:0,g_pop_num:DataObj.data[11] + DataObj.data[12],h_lv:0};
			}
			MyHeart.go();
			if (!hasEventListener(Event.ENTER_FRAME))
			{
				EventManager.AddEventFn(this,Event.ENTER_FRAME, game_loop);
			}
			game_state = STATE_INIT;
		}
		
		public function chkAch() : void
		{
			modeChkAch();
		}
		
		protected function modeChkAch() : void
		{
		}
		
		//各不同模式，有不同的初始化内容。
		protected function game_init() : void
		{
		}
		
		protected function game_play() : void
		{
		}
		
		public function scores() : void
		{
		}
		
		protected function modeScores():void{
			
		}
		
		protected function game_stop() : void
		{
		}
		
		//游戏结束
		public function game_over() : void
		{
			game_state = STATE_END;
		}
		
		//退回主菜单
		public function game_exit() : void
		{
//		main.bg.removeEventListener(MouseEvent.MOUSE_DOWN, panComboOver);
//		main.bg.removeEventListener(MouseEvent.MOUSE_DOWN, panMiss);
		game_over();
		}
		
		protected function over_eff() : void
		{
		}
		
		//单局游戏结算
		protected function game_end(mode:String, score:int, u:String,lv:String, hi:uint, is_new:Boolean) : void
		{
			Bgm.end();
//			Sounds.play(Se_ending);
			Global.g_time = Global.g_time + MyHeart.seconds;
			MyHeart.stop();
		}
		
		
		public function delLoop():void
		{
			if (hasEventListener(Event.ENTER_FRAME))
			{
				//				trace("mode 202:	add event");
				//				addEventListener(Event.ENTER_FRAME, game_loop);
				EventManager.delEventFn(this,Event.ENTER_FRAME, game_loop);
			}
		}
		
	}
}

