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


package  nl.acidcats.yalog.test {
	import nl.acidcats.yalog.Yalog;		import flash.display.MovieClip;	import flash.utils.getQualifiedClassName;	
	public class YalaTest extends MovieClip {
		public function YalaTest() {
			super();
			
			trace("Here");
			
			Yalog.debug("Yalog Debug: ", toString());
			Yalog.warn("Yalog Warn: ", toString());
			Yalog.info("Yalog Info: ", toString());
			Yalog.error("Yalog Error: ", toString());
			Yalog.fatal("Yalog Fatal", toString());
		}
		
		override public function toString():String {
			return getQualifiedClassName(this);
		}	}
}
