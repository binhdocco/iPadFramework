package com.binhdocco.persistenceobjects.mailsender {
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.DataTransferEvent;
	import com.binhdocco.events.InternetConnectionEvent;
	import com.binhdocco.events.LogEvent;
	import com.binhdocco.events.OutputEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.bytearray.smtp.events.SMTPEvent;
	import org.bytearray.smtp.infos.SMTPInfos;
	import org.bytearray.smtp.mailer.SMTPMailer;
	
	/**
	 * ...
	 * @author binhdocco
	 */
	[Event(name="connected", type="com.binhdocco.events.InternetConnectionEvent")]
	[Event(name = "disconnected", type = "com.binhdocco.events.InternetConnectionEvent")]
	
	public class MailConnection extends EventDispatcher {
		
		public var serverSMTP: String = "";
		
		public var connected: Boolean = false;
		private var timer: Timer;
		private var dispatcher: Dispatcher = new Dispatcher();
		
		private var mailer: SMTPMailer;
		
		private var dataTranfers: Array;		
		public var isSendingData: Boolean = false;
		
		public function MailConnection(smtp: String, target:IEventDispatcher = null) {
			super(target);			
			this.serverSMTP = smtp;
			
			timer = new Timer(5 * 1000, 1); // 5s to check
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, startChecking);
			
			mailer = new SMTPMailer(this.serverSMTP, 25);
			mailer.addEventListener(SMTPEvent.MAIL_SENT, onMailResponse);
			// event dispatched when mail could not be sent
			mailer.addEventListener(SMTPEvent.MAIL_ERROR, onMailResponse);
			// event dispatched when SMTPMailer successfully connected to the SMTP server
			mailer.addEventListener(SMTPEvent.CONNECTED, onConnected);
			// event dispatched when SMTP server disconnected the client for different reasons
			mailer.addEventListener(SMTPEvent.DISCONNECTED, onDisconnected);
			// event dispatched when the client has authenticated successfully
			mailer.addEventListener(SMTPEvent.AUTHENTICATED, onAuthSuccess);
			// event dispatched when the client could not authenticate
			mailer.addEventListener(SMTPEvent.BAD_SEQUENCE, onAuthFailed);
			mailer.addEventListener("IOError", socketErrorHandler);
			mailer.addEventListener("showmessage", showMsgHandler);
			
			startChecking();
		}
		
		public function destroy():void {
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, startChecking);
		}
		
		public function counterToStartChecking():void {
			timer.stop();
			timer.reset();			
			timer.start();
		}
		
		private function onError(e:*):void {}
		
		private function startChecking(e:TimerEvent = null):void {
			//trace("startChecking");
			dispatcher.dispatchEvent(new OutputEvent("[MailConnection] startChecking smtp: " + serverSMTP));			
			mailer.connectToServer();
		}
		
		private function onAuthFailed ( pEvt:SMTPEvent ):void {			
			//status_txt.htmlText = "Authentication Error";			
			connected = false;
			//counterToStartChecking();
		}

		private function onAuthSuccess ( pEvt:SMTPEvent ):void {			
			//status_txt.htmlText = "Authentication OK !";			
			if (!connected) {
				dispatcher.dispatchEvent(new LogEvent("[SMTP] Server is AVAIABLE."));
				dispatcher.dispatchEvent(new OutputEvent("[MailConnection] Connected!"));
				connected = true;
				
				dispatchEvent(new InternetConnectionEvent(InternetConnectionEvent.CONNECTED));
			}
		}

		private function onConnected ( pEvt:SMTPEvent ):void {			
			dispatcher.dispatchEvent(new OutputEvent("[MailConnection] smtp onConnected: " + pEvt.result.message));	
			//login
			//mailer.authenticate("oblit99@yahoo.com", "drca2010");
			//return;
			
			if (!connected) {
				dispatcher.dispatchEvent(new LogEvent("[SMTP] Servidor DISPONIBLE."));
				dispatcher.dispatchEvent(new OutputEvent("[MailConnection] Server is AVAIABLE!"));
				connected = true;
				
				dispatchEvent(new InternetConnectionEvent(InternetConnectionEvent.CONNECTED));
			}
		}

		private function onMailResponse ( pEvt:SMTPEvent ):void {
			isSendingData = false;		
			//dispatcher.dispatchEvent(new OutputEvent("[MailConnection] smtp onMailResponse: " + pEvt.result.message + " [END]"));	
			var message: String = pEvt.result.message as String;
			if (message.indexOf("250 OK , completed") > -1) {
				dispatcher.dispatchEvent(new OutputEvent("[MailConnection] onMailResponse: Mail sent."));
				dispatcher.dispatchEvent(new LogEvent("[SMTP] Mail enviado."));
				dispatchEvent(new DataTransferEvent(DataTransferEvent.SUCCESS, dataTranfers));
			} else {
				if (connected) {
					if (message.indexOf("yahoo.com") < 0) {
						dispatcher.dispatchEvent(new OutputEvent("[MailConnection] onMailResponse: Mail can not be sent."));
						dispatcher.dispatchEvent(new LogEvent("[SMTP] Mail no puede ser enviado."));
						dispatchEvent(new DataTransferEvent(DataTransferEvent.ERROR, dataTranfers));
					}
				}
			}
		}

		private function onDisconnected ( pEvt:SMTPEvent ):void {			
			//status_txt.htmlText = "User disconnected :\n\n" + pEvt.result.message;
			//status_txt.htmlText += "Code : \n\n" + pEvt.result.code;			
			dispatcher.dispatchEvent(new OutputEvent("[MailConnection] smtp onDisconnected: " + pEvt.result.message));
			dispatcher.dispatchEvent(new LogEvent("[SMTP] Servidor DESCONECTADO. Tratando de conectar…"));
			connected = false;
			counterToStartChecking();
		}
		
		private function socketErrorHandler ( pEvt:Event ): void {
			// when data available, read it
			//status_txt.htmlText = "Connection error !";			
			dispatcher.dispatchEvent(new OutputEvent("[MailConnection] smtp socketErrorHandler: " + " Connection error !"));
			dispatcher.dispatchEvent(new LogEvent("[SMTP] Servidor NO DISPONIBLE. Tratando de reconectar…"));				
			if (connected) {
				dispatcher.dispatchEvent(new OutputEvent("[MailConnection] Disconnected."));
				connected = false;
				dispatchEvent(new InternetConnectionEvent(InternetConnectionEvent.DISCONNECTED));
			}
			
			// checking again
			counterToStartChecking();
		}

		private function showMsgHandler ( pEvt:SMTPEvent ):void	{	
			//status_txt.htmlText += pEvt.msg;
			dispatcher.dispatchEvent(new LogEvent("[SMTP] Error Message: " + pEvt.msg));
			dispatcher.dispatchEvent(new OutputEvent("[InternetConnection] Message: " + pEvt.msg));
			isSendingData = false;
			connected = false;
			counterToStartChecking();
		}
		
		public function sendEmail(mail: MailObject):void {
			dispatcher.dispatchEvent(new LogEvent("[SMTP] DE: " + mail.from + " => PARA: " + mail.to));		
			
			
			dataTranfers = [mail];
			isSendingData = true;			
			mailer.sendHTMLMail ( mail.from, mail.to, mail.title, mail.body);
		}
	}

}