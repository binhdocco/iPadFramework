package com.binhdocco.persistenceobjects.mailsender {
	import com.binhdocco.dispatcher.Dispatcher;
	import com.binhdocco.events.DataTransferEvent;
	import com.binhdocco.events.InternetConnectionEvent;
	import com.binhdocco.events.LogEvent;
	import com.binhdocco.events.MailEvent;
	import com.binhdocco.events.OutputEvent;
	import com.binhdocco.utils.DataTransfer;
	import com.binhdocco.utils.InternetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author binhdocco
	 */
	public final class MailSender {
		
		private var newMails:Array;
		private var sentMails:Array;
		private var dispatcher: Dispatcher = new Dispatcher();
		//private var internetConnection: InternetConnection;
		private var mailConnection: MailConnection;
		protected var dataTranfer: DataTransfer;
		
		private var appkey: String;
		
		private var soName: String;
		private var currentSession: String = "";
		
		public function MailSender(key: String = "", mailServiceUrl: String = "", internetUrlChecking: String = "http://www.google.com") {
			if (key != "") {
				this.appkey = key;
				SharedObject.defaultObjectEncoding = ObjectEncoding.AMF3;
					
				var so: SharedObject;
				soName = appkey + "_mail_so_v2";
				try {
					so = SharedObject.getLocal(soName, "/");
					// clear all db
					//so.clear();
					// create trackings for this app
					if (so.data["newmails"] == null) {
						so.data["newmails"] = new Array();					
					}	
					if (so.data["sentmails"] == null) {
						so.data["sentmails"] = new Array();					
					}	
					newMails = so.data["newmails"];
					sentMails = so.data["sentmails"];
					
					//trace("xxx newMails: " + newMails);
					
				} catch (e: Error) { };
				
				//data transfer
				//dataTranfer = new DataTransfer(mailServiceUrl);
				//dataTranfer.addEventListener(DataTransferEvent.SUCCESS, onServiceResult);
				//dataTranfer.addEventListener(DataTransferEvent.ERROR, onServiceError);
				
				// internet connection manager
				//internetConnection = new InternetConnection(internetUrlChecking);
				//internetConnection.addEventListener(InternetConnectionEvent.CONNECTED, onInternetConnected);
				//internetConnection.addEventListener(InternetConnectionEvent.DISCONNECTED, onInternetDisconnected);		
				mailConnection = new MailConnection("mailhost.bms.com");//smtp.mail.yahoo.com
				mailConnection.addEventListener(InternetConnectionEvent.CONNECTED, onInternetConnected);
				mailConnection.addEventListener(InternetConnectionEvent.DISCONNECTED, onInternetDisconnected);	
				mailConnection.addEventListener(DataTransferEvent.SUCCESS, onServiceResult);
				mailConnection.addEventListener(DataTransferEvent.ERROR, onServiceError);
				
				//listening for send mail event
				dispatcher.addEventListener(MailEvent.SEND_MAIL, onSendMail);
			}
		}
		
		private function onSendMail(e:MailEvent):void {
			if (currentSession ==  "") return;
			
			var mail: MailObject = new MailObject();
			mail.from = e.from;
			mail.to = e.to;
			mail.body = e.body;
			mail.title = e.title;
			//mail.params = e.params;
			
			var to: String = mail.to;
			while(to.indexOf(" ") == 0)
				to = to.replace(" ", "");
			while(to.indexOf(" ") == (to.length-1))
				to = to.substr(0, to.length-1);

			while(to.indexOf(";") > -1)
				to = to.replace(";", ",");

			while(to.indexOf(",") > -1)
				to = to.replace(",", " ");

			while(to.indexOf("  ") > -1)
				to = to.replace("  ", " ");
			
			if (to == "") return;
			
			newMails.push(mail);
			
			var so: SharedObject = SharedObject.getLocal(soName, "/");
			so.data["newmails"] = newMails;
			so.flush();
			
			//trace("xxx newMails: " + newMails);
			doSendEmails();
		}
		
		protected function onServiceError(e:DataTransferEvent):void {
			//checking the internet connection
			mailConnection.counterToStartChecking();
		}
		
		protected function onServiceResult(e:DataTransferEvent):void {
			//var sentTrackings: Array = e.dataTrackings;
			//var count: int = 1;// sentTrackings.length;
			dispatcher.dispatchEvent(new OutputEvent("[MailSender] [onServiceResult] mail sent. "));
			
						
			if (newMails.length > 0) {
				var mO: MailObject = new MailObject();
				mO.parse(newMails.shift());
				mO.status = MailObject.SENT_STATUS;
				sentMails.unshift(mO);
				//count --;				
			}
			
			var so: SharedObject = SharedObject.getLocal(soName, "/");
			so.data["newmails"] = newMails;
			so.data["sentmails"] = sentMails;
			so.flush();
			
			//trace("xxx sentMails: " + sentMails);			
			
			doSendEmails();
		}
		
		protected function onInternetDisconnected(e:InternetConnectionEvent):void {
			
		}
		
		protected function onInternetConnected(e:InternetConnectionEvent):void {
			// send email
			doSendEmails();
		}
		
		private function doSendEmails():void {
			if (!mailConnection.connected) return;
			if (mailConnection.isSendingData) return;
			
			dispatcher.dispatchEvent(new LogEvent("[SMTP] Tratando de enviar otros mails…"));
			dispatcher.dispatchEvent(new OutputEvent("[MailSender] [doSendEmails]" ));
			if (newMails.length > 0) { 
				var mailToBeSent: MailObject = new MailObject();					
				mailToBeSent.parse(newMails[0]);				
				mailConnection.sendEmail(mailToBeSent);
			} else {
				dispatcher.dispatchEvent(new OutputEvent("[MailSender] [no any mails to send]" ));
				dispatcher.dispatchEvent(new LogEvent("[SMTP] No hay mails por enviar."));
			}
		}
		
	}

}