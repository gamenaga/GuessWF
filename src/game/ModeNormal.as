package game
{
	import audio.Sounds;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import naga.eff.InOut;
	import naga.eff.Shake;
	import naga.eff.Zoom;
	import naga.global.Global;
	import pop.SafeTime;
	import ui.UI;
	
	
	public class ModeNormal extends Mode
	{
		public var gameUI:UI;
		public static var overX:uint;
		public static var overY:uint;
		
		public function ModeNormal(type:Object)
		{
			g_mode = MODE_NORMAL;
			super(type,true);
		}// end function 
		
		override protected function game_init() : void
		{
			//			trace("modeNormal 39:	"+Global.g_move_sp_init+"	"+Global.g_move_sp);
			if(gameUI!=null){
				Global.ui_floor.removeChild(gameUI);
			}
			if (g_mode != null)
			{
				InOut.fadeIn(UI.ui_top);
				UI.ui_top.visible = true;
			}
			UI.gameInit(hp_init,HP_max_init);
			//			trace("modeNormal 51:	"+Global.g_move_sp_init+"	"+Global.g_move_sp);
			game_state = STATE_PLAY;
		}// end function
		
		override protected function game_play() : void
		{
			if (Global.g_score > DataObj.data[4])
			{
				DataObj.data[4] = Global.g_score;
			}
			//main.game_menu.scores.txt("连击挑战<font size=\'-8\'>模式</font><br><font size=\'+20\' color=\'#" + Color.YELLOW + "\'>" + main.game_combo + "</font>分<br><font size=\'-8\' color=\'#" + Color.YELL_D2 + "\'>（最高纪录：<font size=\'+1\' color=\'#" + Color.YELL_D + "\'>" + DataObj.data[5] + "</font>）</font>");
			if(hp_<=0){
				Sounds.play(Se_over);
				game_over();
				over_eff();
				setTimeout(game_end, 2500, g_mode , Global.g_score,"氧气",Score2Lv.go(Global.g_score, LvScore), DataObj.data[1], ach.h_score == 1);
				//					Sco2lv.go(MttScore.score, Lv_score), DataObj.data[4], ach.h_combo == 1);
			}
			//			if (main.game_combo < MttScore.score)
			//            {
			//				//连击中断
			//                Sounds.play(Se_over);
			//                game_over();
			//                this.over_eff();
			//                setTimeout(game_end, 2500, " 连 击 中 断 啦 ", "连击挑战<font size=\'-8\'>模式</font>", MttScore.score,"连击", Sco2lv.go(MttScore.score, Lv_combo), DataObj.data[5], ach.h_combo == 1);
			//            }
		}// end function
		
		override protected function over_eff() : void
		{
			var pos_x:int;
			var pos_y:int;
//			var b:DisplayObject = Global.eff_floor.getChildByName("bbScroe");
			SafeTime.isSafe = true;
			//			var temp:uint = 0;
			//			while (temp < Global.eff_floor.numChildren)
			//			{
			//				if (b.name == "bb1")
			//				{
			pos_x = overX;//b.x + b.width * 0.5;
			pos_y = overY;//b.y + b.height * 0.5;
			//					break;
			//				}
			//				temp = temp + 1;
			//			}
			var rec:Rectangle = new Rectangle(0, 0, Global.stage_w, Global.stage_h);
			Zoom.add([Global.bg_floor , Global.g_floor, Global.eff_floor], pos_x, pos_y, rec, rec, 2000, 10);
			Shake.add(Global.bg, 1000);
//			Vision.add("gameOver", E1Grow, 0, 0, null, 0.8,500,1,0,true,true,true);
		}// end function
		
		override protected function modeChkAch() : void
		{
			//			if (ach.h_lv == 0 && DataObj.data[8] <= LvUp.lv_ && DataObj.data[5] !=0)
			//			{
			//				Bubble.instance.show(3, Global.stage_w * 0.5, Global.stage_h*.3, "最高等级<br><font color=\'#" + Css.ORAN_D + "\' size=\'+5\'>纪录刷新</font>", 80, Css.SIZE);
			//				ach.h_lv = 1;
			//			}
		}// end function
	}
}
