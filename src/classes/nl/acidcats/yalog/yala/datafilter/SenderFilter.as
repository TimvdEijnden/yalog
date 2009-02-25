package nl.acidcats.yalog.yala.datafilter {
	import nl.acidcats.yalog.common.MessageData;
	import nl.acidcats.yalog.yala.datafilter.IDataFilter;
	
	import flash.utils.getQualifiedClassName;	

	/**
	 * (c) Copyright LBi Lost Boys 2009
	 * @author Stephan Bezoen
	 */
	public class SenderFilter implements IDataFilter {
		private var mSender : String;
		
		/**
		 *	Set the sender text to look for; if this text is present, the data object is allowed
		 */
		public function set sender (inText : String) : void {
			mSender = inText;
		}
		
		public function allow (inObj : Object) : Boolean {
			var md : MessageData = inObj as MessageData;
			return (md.sender && (md.sender.indexOf(mSender) > -1));
		}
		
		public function toString():String {
			return getQualifiedClassName(this);
		}
	}
}
