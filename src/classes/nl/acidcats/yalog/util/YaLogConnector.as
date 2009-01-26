/*
Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


package nl.acidcats.yalog.util {
	import nl.acidcats.yalog.Yalog;
	import org.asaplibrary.util.debug.Log;
	import org.asaplibrary.util.debug.LogEvent;	


	public class YaLogConnector {
		private static var theInstance : YaLogConnector = new YaLogConnector();
		
		/**
		 * @return singleton instance of YaLogConnector
		 */
		public static function getInstance() : YaLogConnector {
			return theInstance;
		}
		
		public function YaLogConnector() {
			Log.addLogListener(handleLogEvent);
			Log.showTrace(false);
		}
			
		/**
		*	
		*/
		private function handleLogEvent (e:LogEvent) : void {
			trace("handleLogEvent ");
			
			switch (e.level) {
				case Log.LEVEL_DEBUG: Yalog.debug(e.text, e.sender); break;
				case Log.LEVEL_ERROR: Yalog.error(e.text, e.sender); break;
				case Log.LEVEL_FATAL: Yalog.fatal(e.text, e.sender); break;
				case Log.LEVEL_INFO: Yalog.info(e.text, e.sender); break;
				case Log.LEVEL_STATUS: Yalog.info(e.text, e.sender); break;
				case Log.LEVEL_WARN: Yalog.warn(e.text, e.sender); break;
			}
		}
		
		/**
		*	Connect to the Log
		*/
		public static function connect () : void {
			YaLogConnector.getInstance();
		}
	}
}