﻿/*Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nlLicensed under the Apache License, Version 2.0 (the "License");you may not use this file except in compliance with the License.You may obtain a copy of the License at   	http://www.apache.org/licenses/LICENSE-2.0Unless required by applicable law or agreed to in writing, softwaredistributed under the License is distributed on an "AS IS" BASIS,WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.See the License for the specific language governing permissions andlimitations under the License.*/package nl.acidcats.yalog.yala.util.scroll {	import fl.controls.ScrollBar;	import fl.events.ScrollEvent;		public class Scroller {		private var mScrollable : IScrollable;		private var mScrollBar : ScrollBar;		private var mScrollToEnd : Boolean;						public function Scroller (inScrollable : IScrollable, inScrollBar : ScrollBar) {			mScrollable = inScrollable;			mScrollBar = inScrollBar;						initCoupling();			update();		}				public function update () : void {			// store scroll position before update			var prevScrollPosition:Number = mScrollBar.scrollPosition;						mScrollBar.setScrollProperties(mScrollable.getPageSize(), mScrollable.getMinScrollPosition(), mScrollable.getMaxScrollPosition());						// check if scroll position after update is lower than previous scroll position			// the scroll bar doesn't send a ScrollEvent in this case, so we're doing it here instead			var newScrollPosition:Number = mScrollBar.scrollPosition;			if (newScrollPosition < prevScrollPosition) {				var e : ScrollEvent = new ScrollEvent(null, newScrollPosition - prevScrollPosition, newScrollPosition);				mScrollable.scroll(e);			}			if (mScrollToEnd) scrollToEnd();		}				/**		*			*/		public function setScrollToEnd (inScrollToEnd:Boolean) : void {			mScrollToEnd = inScrollToEnd;						if (mScrollToEnd) scrollToEnd();		}				private function scrollToEnd () : void {			mScrollBar.scrollPosition = mScrollable.getMaxScrollPosition();		}				private function initCoupling () : void {			mScrollBar.addEventListener(ScrollEvent.SCROLL, handleScrollEvent);		}				private function handleScrollEvent (e : ScrollEvent) : void {			mScrollable.scroll(e);		}				public function toString() : String {			return ";com.lostboys.yala.scroll.Scroller";		}	}}