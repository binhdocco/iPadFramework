package com.binhdocco.persistenceobjects.mailsender {
	import com.binhdocco.utils.TronTime;
	/**
	 * ...
	 * @author binhdocco
	 */
	public class MailObject {
		
		public static const PENDING_STATUS: String = "Pendiente";
		public static const SENT_STATUS: String = "Enviat";
		//public static const SENDING_STATUS: String = "Sending";
		
		public var datetime: String;
		public var from: String;
		public var to: String;
		public var body: String;
		public var title: String;
		public var status: String;
		public var params: Object;		
		
		public function MailObject() {
			this.status = PENDING_STATUS;
			var now: Date = new Date();
			this.params = new Object();
			this.datetime = TronTime.convertASDateToMySQLTimestamp(now); //return YYYY-MM-DD h:m:s
		}
		
		public function parse(obj: Object): void {
			this.status = obj.status;
			this.datetime = obj.datetime;
			this.from = obj.from;
			this.to = obj.to;
			this.title = obj.title;
			//this.params = obj.params;
			this.body = obj.body;
		}
		
		public function toString(): String {
			return "[" + datetime + "] [title: " + title + " ] [from: " + from + "] [to: " + to + "] [body: " + body + "] [status: " + status + "] [params: " + params + "]";
		}
		
	}

}