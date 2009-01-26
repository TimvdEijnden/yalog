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


package nl.acidcats.yalog.yala.ui.table {
	import nl.acidcats.yalog.common.MessageData;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	public class RowRenderer extends Sprite implements ITableRowRenderer {
		public static var COLORS : Array = [0x99CCFF, 0xFFBB33, 0xFF5555, 0xFFCC00, 0xFFFFFF, 0xFFFFFF];
		private var mMessageField : TextField;
		private var mTimeField : TextField;
		

		/**
		 * Constructor
		 */
		public function RowRenderer() {
			var tf : TextFormat = new TextFormat();
			tf.bold = true;
			tf.font = "_sans";
			tf.size = 10;
			tf.color = 0xFFFFFF;

			mTimeField = new TextField();
			mTimeField.width = 60;
			mTimeField.height = 18;
			mTimeField.defaultTextFormat = tf;
			mTimeField.text = "Dit is een test";
			addChild(mTimeField);

			mMessageField = new TextField();
			mMessageField.x = mTimeField.width;
			mMessageField.width = 185;
			mMessageField.height = 18;
			mMessageField.defaultTextFormat = tf;
			addChild(mMessageField);
		}
		
		/**
		 *	Render the input data. 
		 *	@param inObject: the data object to be rendered. Cast to MessageData.
		 *	Can be null to clear the row display
		 */
		public function render (inObject : Object) : void {
			if (inObject == null) {
				mMessageField.text = "";
				mTimeField.text = "";
			} else {
				renderData(inObject as MessageData);
			}
		}
		
		/**
		 *	Do the actual row rendering with the right object type.
		 */
		private function renderData (inData : MessageData) : void {
			mMessageField.textColor = COLORS[inData.level];
	
			var s : String = "";
	
			if (!isNaN(inData.time)) {
				mTimeField.text = "" + inData.time;
			} else {
				mTimeField.text = "--";
			}
			s = inData.text;
			if (inData.sender != null) s += "\t\t-- " + inData.sender;
			
			mMessageField.text = s;
		}
		
		/**
		 *	Make sure the row fits the table width.
		 *	@TODO: the width is too big now
		 */
		public function setWidth (inWidth : Number) : void {
			mMessageField.width = inWidth;
		}
		
		/**
		 *	Cleanup after yourself and go away
		 */
		public function die () : void {
			parent.removeChild(this);
		}

		override public function toString() : String {
			return ";com.lostboys.yala.table.RowRenderer";
		}		
	}
}
