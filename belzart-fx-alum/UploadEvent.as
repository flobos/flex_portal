package 
{
	import flash.events.Event;
	
	/**
	 * Class extends the Event class to create a custom 
	 * event for the ImageUpload.mxml component.
	 * 
	 * @see flash.events.Event
	 */
	public class UploadEvent extends Event
	{
		// Used for the event type.
		public static const UPLOAD_EVENT:String = "uploadevent";
		
		private var _serverResponse:String = "";
		private var _serverResponseRaw:String = "";
		
		/**
		 * Class constructor sets the default values for 
		 * the bubbles and cancelable parameters. 
		 */ 
		public function UploadEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Getter method for the _serverResponse member 
		 * variable.
		 */  
		public function get ServerResponse():String {
			return _serverResponse;
		}
		
		/**
		 * @private
		 */ 
		public function set ServerResponse(value:String):void {
			_serverResponse = value;
		}
		
		/**
		 * Getter method for the _serverResponseRaw member 
		 * variable.
		 */ 
		public function get ServerResponseRaw():String {
			return _serverResponseRaw;
		}
		
		/**
		 * @private
		 */ 
		public function set ServerResponseRaw(value:String):void {
			_serverResponseRaw = value;
		}
		
	}
}