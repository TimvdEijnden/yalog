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

/**
 *	A lean and mean table implementation.
 *	It's built for displaying changing data fast and low-CPU. 
 *	It supports:
 *		- scrolling
 *		- adding / removing data without rebuilding the table
 *		- resizing
 *	
 *	Rendering of rows is done by a ITableRowRenderer implementation.
 *	
 *	There is no mask, so it's left up to the row renderer or a higher level container to make sure it stays within bounds.
 *	Columns can be implemented in the row renderer. This class does currently not support a header. 
 */
 
package nl.acidcats.yalog.yala.ui.table {
	import fl.events.ScrollEvent;
	
	import nl.acidcats.yalog.yala.datafilter.IDataFilter;
	import nl.acidcats.yalog.yala.util.scroll.IScrollable;
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;	
	public class Table extends EventDispatcher implements IScrollable {
		private var mRowClass : Class;
		private var mContainer : Sprite;
		/** items of type ITableRowRenderer */
		private var mRows : Array;			
		/** items of type Object */
		private var mData : Array;
		/** items of type IDataFilter */
		public var mFilters : Array;
		/** items of type Object */
		private var mFilteredData : Array;
		private var mRowHeight : Number;
		private var mHeight : Number;
		private var mWidth : Number;	
		private var mScrollOffset : Number = 0;
		
		
		/**
		 *	Constructor
		 *	@param inContainer: Sprite in which the items will be created
		 *	@param inRowLinkageID: class that implements the ITableRowRenderer interface
		 *	@param inRowHeight: display mHeight of each row - this can differ from the actual row mHeight
		 *	@param inWidth: initial mWidth of the table
		 *	@param inHeight: initial mHeight of the table
		 */
		public function Table (inContainer : Sprite, inRowClass : Class, inRowHeight : Number, inWidth : Number, inHeight : Number) {
			super();
		
			mContainer = inContainer;
			mRowClass = inRowClass;
			mRowHeight = inRowHeight;
		
			mRows = new Array();
			mFilters = new Array();
			mData = new Array();
			mFilteredData = new Array();
		
			setSize(inWidth, inHeight);
		}
		
		/**
		 *	@return items of type Object
		 */
		public function get data () : Array {
			return mData;
		}
		
		/**
		 *	Add a single item to the end of the list
		 */
		public function addData (inObj : Object) : void {
			mData.push(inObj);
			if (isItemAllowed(inObj)) {
				mFilteredData.push(inObj);
			}
		}
		
		/**
		 *	resize the table
		 *	@param inW: new width
		 *	@param inH: new height
		 *	
		 *	This function creates or removes rows as necessary, and passes the width on to the row renderers
		 */
		public function setSize (inW : Number, inH : Number) : void {
			mWidth = inW;
			mHeight = inH;
			
			var rowCount : Number = Math.floor(inH / mRowHeight);
			updateRowList(rowCount);
		}
		
		/**
		 *	Update the row display if the data has changed
		 */
		public function update (inForceAll : Boolean = false) : void {
			if(inForceAll)
			{
				updateRowValues(true);
			} else {
				updateRowValues();
			}
		}
		
		/**
		 *	Clear the display
		 */
		public function clear () : void {
			mData = new Array();
			mFilteredData = new Array();
			
//			mScrollOffset = 0;
		
			updateRowValues(true);
		}
		
		/**
		 *	IScrollable impl.: return the total number of data items
		 */
		public function getMaxScrollPosition () : Number {
			return (mFilteredData.length < mRows.length) ? 0 : mFilteredData.length - mRows.length;
		}
		
		public function getMinScrollPosition () : Number {
			return 0;
		}

		/**
		 *	IScrollable impl.: return the current scroll position
		 */
		public function getCurrentScrollPosition () : Number {
			return mScrollOffset;
		}
		
		/**
		 *	IScrollable impl.: return the number of visible items
		 */
		public function getPageSize () : Number {
			return mRows.length;
		}
		
		/**
		 *	IScrollable impl.: event received when the scroll bar has changed
		 */
		public function scroll (e : ScrollEvent) : void {
			mScrollOffset = Math.round(e.position);

			update();
		}
		
		/**
		 *	Scroll to make the last data items visible in the display
		 */
		public function scrollToEnd () : void {
			mScrollOffset = mFilteredData.length - mRows.length;
			if (mScrollOffset < 0) mScrollOffset = 0;
			update();
		}
		
		/**
		 *	Add a data filter
		 */
		public function addFilter (inFilter:IDataFilter) : void {
			mFilters.push(inFilter);
			filterData();	
		}
		
		/**
		 *	Remove a previously added data filter
		 */
		public function removeFilter (inFilter : IDataFilter) : void {
			mFilters.splice(mFilters.indexOf(inFilter),1);
			filterData();
		}
		
		
		/**
		 *	Change the number of rows to the input number
		 *	@param inCount: new number of rows
		 *	
		 *	This function removes or adds rows as required, and sets the width of the rows
		 *	It doesn't update the display.
		 */
		private function updateRowList (inCount : Number) : void {
			var len : Number = mRows.length;

			if (inCount < len) {
				removeRows(inCount, len);
			} else if (inCount > len) {
				createRows(inCount - len);
			}
		
			len = mRows.length;
			for (var i : Number = 0;i < len; i++) {
				ITableRowRenderer(mRows[i]).setWidth(mWidth);
			}
		}
		
		/**
		 *	Remove the rows with the specified indexes
		 */
		private function removeRows (inStart : Number, inEnd : Number) : void {
			for (var i : Number = inStart;i < inEnd; ++i) {
//				if (ITableRowRenderer(mRows[i]) != null) 
				ITableRowRenderer(mRows[i]).die();
			}
			mRows.splice(inStart, inEnd - inStart);
		}
		
		/**
		 *	Add the requested number of rows at the end
		 *	New rows are cleared by calling the render function with parameter null
		 */
		private function createRows (inCount : Number) : void {
			for (var i : Number = 0;i < inCount; i++) {
				var index : Number = mRows.length;
	
				var s : Sprite = new mRowClass();
				mContainer.addChild(s);
				s.y = index * mRowHeight;
			
				ITableRowRenderer(s).render(null);
			
				mRows.push(s);
			}
		}
		
		/**
		 *	Update the display of rows
		 *	@param inForceAll: when true, all rows are rendered; otherwise, the lowest of the number of rows and the number of data items is rendered
		 */
		private function updateRowValues (inForceAll : Boolean = false) : void {
			var updateCount : Number;
			var rowCount : Number = mRows.length;
			if (inForceAll) {
				updateCount = rowCount ;
			} else {
				var dataCount : Number = mFilteredData.length;
				updateCount = Math.min(rowCount, dataCount);

			}

			for (var i : Number = 0;i < updateCount; i++) {
				ITableRowRenderer(mRows[i]).render(mFilteredData[mScrollOffset + i]);
			}
		}
		
		/**
		 *	Apply all added filters to the data
		 */
		private function filterData () : void {
			
			mFilteredData = new Array();
			
			var len : Number = mData.length;
			
			for (var i : Number = 0;i < len; i++) {
				var item : Object = mData[i];
				if (isItemAllowed(item)) {
					mFilteredData.push(item);
				}
				
			}
			
		}
		
		/**
		 *	Check if specified item is allowed by all filters
		 */
		private function isItemAllowed (inItem:Object) : Boolean
		{
			var len : Number = mFilters.length;
			for (var i : Number = 0;i < len; i++)
			{
				var filter : IDataFilter = mFilters[i] as IDataFilter;
				if (!filter.allow(inItem)) return false;
			}
			
			return true;
		}
		
		/**
		 *	
		 */

		override public function toString () : String {
			return ";com.lostboys.table.Table";
		}		
	}
}