/**
 *
 * Hungry Hero Game
 * http://www.hungryherogame.com
 * 
 * Copyright (c) 2012 Hemanth Sharma (www.hsharma.com). All rights reserved.
 * 
 * This ActionScript source code is free.
 * You can redistribute and/or modify it in accordance with the
 * terms of the accompanying Simplified BSD License Agreement.
 *  
 */

package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import naga.global.Global;
	import naga.system.EventManager;
	
	import starling.core.Starling;
	
	/**
	 * SWF meta data defined for iPad 1 & 2 in landscape mode. 
	 */	
	[SWF(frameRate="60", width="320", height="480", backgroundColor="0xdddddd")]
//			[SWF(frameRate=30,width=768,height=1280)]//BB10
//	[SWF(frameRate=60)]
	
	/**
	 * This is the main class of the project.v
	 * 
	 * @author hsharma
	 * 
	 */
	public class GuessWF extends Sprite
	{
		/** Starling object. */
		private var myStarling:Starling;
		
		public function GuessWF()
		{
			super();
			
//			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			EventManager.AddEventFn(this,Event.ADDED_TO_STAGE, onAddedToStage,null,true);
//			EventManager.AddEventFn(NativeApplication.nativeApplication,Event.ACTIVATE,onActivate);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
		}
		
		/**
		 * On added to stage. 
		 * @param event
		 * 
		 */
		protected function onAddedToStage(event:Event):void
		{
//			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			EventManager.delEventFn(this,Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.quality = StageQuality.LOW;
			

			MyHeart.init(stage.frameRate);
//			Global.stage_w=stage.stageWidth;
//			Global.stage_h=stage.stageHeight;
			
//			trace("PopO2 72: ",Global.gameStage.width);
			initGlobal();
			
			// Initialize Starling object.
			
			myStarling = new Starling(Main, stage);
			
			// Define basic anti aliasing.
			myStarling.antiAliasing = 1;
			
			// Position stats.
//			myStarling.showStatsAt("left", "bottom");
			
			// Start Starling Framework.
			myStarling.start();
			
//			trace("PopO2");
		}
		
		private function initGlobal():void
		{
			Global.stage_h = stage.stageHeight;
			Global.stage_w = stage.stageWidth;
//			trace(Global.stage_h);
			stage.addChild(Global.gameStage);
			stage.focus=Global.ui_floor;
		}
		
		//初始化缓存
		private function initCache():void
		{
//			ObjPool.instance.registerPool(PopWhite,3);
		}
		
		private function onActivate():void
		{
//									trace("main 111	:	onActivate");
			EventManager.delEventFn(NativeApplication.nativeApplication,Event.ACTIVATE,onActivate);
			EventManager.AddEventFn(NativeApplication.nativeApplication,Event.DEACTIVATE,onDeActivate);
			System.resume();
		}
		private function onDeActivate():void
		{
//									trace("main 117	:	onDeActivate");
			EventManager.delEventFn(NativeApplication.nativeApplication,Event.DEACTIVATE,onDeActivate);
			EventManager.AddEventFn(NativeApplication.nativeApplication,Event.ACTIVATE,onActivate);
			System.pause();
		}
		
	}
}