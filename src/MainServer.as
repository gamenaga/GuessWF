package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.ByteArray;
	
	import game.Room;
	
	import manager.DataHandlerServer;
	import manager.Database;
	
	import naga.system.Conn;
	import naga.system.EventManager;
	
	import ui.UImanager;
	
	public class MainServer extends Sprite
	{
		private static const a:String = "MainServer";
		
		private var serverSocket:ServerSocket = new ServerSocket();
//		private var clientSocket:Socket;
		public static var dataHandler:DataHandlerServer = new DataHandlerServer();
		
		private var localIP:TextField;
		private var localPort:TextField;
		private static var logField:TextField;
		private static var message:TextField;
		private static var _clients:Array = [];
		
		public function MainServer()
		{
			//设置安全沙箱
//			Security.allowDomain("116.228.135.50");
//			Security.allowInsecureDomain("*")
//			Security.showSettings(SecurityPanel.LOCAL_STORAGE);
			
			Conn.openConn();
			setupUI();
		}
		
		//当客户端成功连接服务端
		private function onConnect( event:ServerSocketConnectEvent):void
		{
			Room.initTempData(1);
			var clientSocket:Socket = new Socket();
			clientSocket = event.socket;
//			EventManager.delEventFn(serverSocket, ServerSocketConnectEvent.CONNECT, onConnect);
			EventManager.AddEventFn(clientSocket,ProgressEvent.SOCKET_DATA, onClientSocketData, null, true);
			EventManager.AddOnceEventFn(clientSocket, Event.CLOSE, onDisConnect);
			_clients.push(clientSocket);
			trace( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
			log( "Connection from " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
		}
		
		//当有数据通信时
		private static function onClientSocketData( event:ProgressEvent ):void
		{
			var buffer:ByteArray = new ByteArray();
			event.target.readBytes( buffer, 0, event.target.bytesAvailable );
			var user:int = (event.target as Socket).remotePort;
//			Database.insertData("chat",["user_id,contants,time"],[user,Database.dbString(buffer.toString()),int(Math.random()*10000)]);
			progressSocketData(buffer.toString(),event.target as Socket);
			trace( "Received: " + event.target.remoteAddress + ":" + event.target.remotePort + " " + buffer.toString() );
			log( "Received: " + event.target.remoteAddress + ":" + event.target.remotePort + " " + buffer.toString() );
		}
		private static function progressSocketData(data:String, socket:Socket):void
		{
			//		var arr:Array = data.split(/\,/);
			//		trace(a,72, arr[0]);
			dataHandler.handleSocketData(data, socket);
			//		Conn.excuteSql(data);
			//		send(data, socket);
		}
		
		private function onDisConnect( event:Event = null ):void
		{
			log("有玩家 断开连接！");
		}
	
		//绑定服务器ip 开始监听端口
		private function bind( event:Event = null ):void
		{
			if( serverSocket.bound ) 
			{
				serverSocket.close();
				serverSocket = new ServerSocket();
				
			}
			serverSocket.bind( parseInt( localPort.text ), localIP.text );
			EventManager.AddEventFn(serverSocket, ServerSocketConnectEvent.CONNECT, onConnect, null, true);
			serverSocket.listen();
			log( "Bound to: " + serverSocket.localAddress + ":" + serverSocket.localPort );
		}
		
		//服务器端向所有客户端发送数据
		public static function send( text:String = "", socketID:Socket = null):void
		{
			try
			{
				if (_clients.length == 0)
				{
					log('没有连接');
					return;
				}
				if (text == "")
				{
					text = message.text;
				}
				var item:Socket
				for (var i:int = 0; i < _clients.length; i++) 
				{
					item = _clients[i] as Socket;
					if (!item.connected) 
					{
						log("Client Over " + (i+1) + "/" + _clients.length);
						EventManager.delEventFn(item,ProgressEvent.SOCKET_DATA, onClientSocketData);
						item = null;
						_clients.splice(i,1);
						i --;
						continue;
					}
					//如果   发送对象不是 消息来源的socket，才发送
					if(item == socketID || socketID == null)
					{
						log("Send to: Client " + (i+1) + "/" + _clients.length + " - " + message.text + " " + item.remoteAddress + " " + item.remotePort + " " + item.bytesAvailable + " " + item.bytesPending);
						item.writeUTFBytes(text);
						item.flush();
					}
				}
				
				/*
				if( clientSocket != null && clientSocket.connected )
				{
				clientSocket.writeUTFBytes( message.text );
				clientSocket.flush(); 
				log( "Sent message to " + clientSocket.remoteAddress + ":" + clientSocket.remotePort );
				}
				else log("No socket connection.");
				//*/
			}
			catch ( error:Error )
			{
				log( error.message );
			}
		}
		
		// 输出日志
		public static function log( text:String ):void
		{
			logField.appendText( text + "\n" );
			logField.scrollV = logField.maxScrollV;
			trace( text );
		}
		
		//设置皮肤
		private function setupUI():void
		{
//			localIP = createTextField( 10, 10, "Local IP", "116.228.135.50");
			localIP = createTextField( 10, 10, "Local IP", "192.168.1.116");
			localPort = createTextField( 10, 35, "Local port", "50485" );
			createTextButton( 170, 60, "Bind", bind );
			message = createTextField( 10, 85, "Message", "Lucy can't drink milk." );
			createTextButton( 170, 110, "Send", send );
			logField = createTextField( 10, 135, "Log", "", false, 200 )
			
			this.stage.nativeWindow.activate();
		}
		
		private function createTextField( x:int, y:int, label:String, defaultValue:String = '', editable:Boolean = true, height:int = 20 ):TextField
		{
			var labelField:TextField = new TextField();
			labelField.text = label;
			labelField.type = TextFieldType.DYNAMIC;
			labelField.width = 100;
			labelField.x = x;
			labelField.y = y;
			
			var input:TextField = new TextField();
			input.text = defaultValue;
			input.type = TextFieldType.INPUT;
			input.border = editable;
			input.selectable = editable;
			input.width = 280;
			input.height = height;
			input.x = x + labelField.width;
			input.y = y;
			
			this.addChild( labelField );
			this.addChild( input );
			
			return input;
		}
		
		private function createTextButton( x:int, y:int, label:String, clickHandler:Function ):TextField
		{
			var button:TextField = new TextField();
			button.htmlText = "<u><b>" + label + "</b></u>";
			button.type = TextFieldType.DYNAMIC;
			button.selectable = false;
			button.width = 180;
			button.x = x;
			button.y = y;
			EventManager.AddEventFn(button, MouseEvent.CLICK, clickHandler );
			
			this.addChild( button );
			return button;
		}        
	}
}