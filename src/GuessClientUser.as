package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import game.Manager;
	import game.Room;
	import user.UserAction;
	
	import manager.DataHandler;
	
	import naga.eff.GameStop;
	import naga.global.Css;
	import naga.global.Global;
	import naga.system.EventManager;
	import naga.ui.Dialog;
	
	import ui.NpcDialog;
	import ui.UImanager;
	import ui.UImanagerUser;
	
	public class GuessClientUser extends Sprite
	{
		private const a:String = "MainClient_User";
//		private var serverSocket:ServerSocket = new ServerSocket();
		private var clientSocket:Socket;
		public static var dataHandler:DataHandler = new DataHandler();
		
		public const SERVER_IP:String = "192.168.1.116";
//		private const SERVER_IP:String = "58.250.69.2";
		public const SERVER_PORT:String = "50485";
		
		private var _clients:Array = [];
		
//		private var tempRoomData:Array = [];
//		private var tempUserData:Array = [];
//		private var tempGameData:Array = [];
		
		public function GuessClientUser()
		{
//						Security.allowDomain("116.228.135.50");
//						Security.allowInsecureDomain("*")
//						Security.showSettings(SecurityPanel.LOCAL_STORAGE);
			stage.align = StageAlign.TOP;
			if(stage)
			{
				initGlobal();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, initGlobal);
			}
		}
		
		private function initGlobal():void
		{
			Global.stage_h = stage.stageHeight;
			Global.stage_w = stage.stageWidth;
			//			trace(Global.stage_h);
			stage.addChild(Global.gameStage);
			stage.focus=Global.ui_floor;
			initStage();
		}
		
		
		public function initStage():void
		{
			Main.initGlobal();
			Dialog.init(T_pan, "000000",NpcDialog);
			GameStop.init(Manager.gameStop, Manager.gameContine);
			Css.init(12);
			//			Dialog.add("测试");
			UserAction.initTempData();
			UImanager.setupLoginUI(bind,send);
			
		}
		
		private function onConnect( event:flash.events.Event = null ):void
		{
			UImanager.log('成功连接服务器!');
			Room.initTempData(1);
			UImanagerUser.setupMainUI();
			//trace('成功连接服务器!!!!');
			EventManager.AddEventFn(clientSocket,ProgressEvent.SOCKET_DATA, onClientSocketData, null, true);
			EventManager.AddOnceEventFn(clientSocket, Event.CLOSE, onDisConnect );
//			UImanager.log( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
		}
		
		private function onDisConnect( event:Event = null ):void
		{
			UImanager.log('服务器 close!');
		}
		private function ioErrorHandler( event:Event = null ):void
		{
			UImanager.log('ioErrorHandler!');
		}
		private function securityErrorHandler( event:Event = null ):void
		{
			UImanager.log('securityErrorHandler!');
		}
		
		private function onClientSocketData( event:ProgressEvent):void
		{
			var buffer:ByteArray = new ByteArray();
			clientSocket.readBytes( buffer, 0, clientSocket.bytesAvailable );
			dataHandler.handleSocketData(buffer.toString());
			UImanager.log( "Received: " + buffer.toString() );
		}
		
		public function bind(host:String = "localhost", port:Number = 9080):void
		{
			UImanager.log('开始连接服务器!');
			if(clientSocket == null || !clientSocket.connected)
			{
				clientSocket = new Socket( UImanager.localIP.text, parseInt( UImanager.localPort.text ));
				dataHandler.init(clientSocket);
				EventManager.AddOnceEventFn(clientSocket, Event.CONNECT, onConnect);
				EventManager.AddOnceEventFn(clientSocket, IOErrorEvent.IO_ERROR, ioErrorHandler);
				EventManager.AddOnceEventFn(clientSocket, SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
			else
			{
				UImanager.log('已经是连接状态……');
			}
		}
		
		//向服务器发送数据
		public function send(event:Event = null):void
		{
			try
			{
				if( clientSocket != null && clientSocket.connected )
				{
					clientSocket.writeUTFBytes( UImanager.message.text );
					clientSocket.flush(); 
					UImanager.log( "Sent message to " + UImanager.message.text);
				}
				else UImanager.log("No socket connection.");
			}
			catch ( error:Error )
			{
				UImanager.log( error.message );
			}
		}
		
	}
}