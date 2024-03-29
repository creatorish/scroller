﻿package com.creatorish.ui.scrollbar
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import net.lifebird.ui.scrollbar.ScrollerObject;
	//import org.libspark.ui.SWFWheel;
	
	/**
	 * スクロールバー設定仲介クラス
	 * @author yuu
	 * @link http://creatorish.com
	 * @version 1.0β
	 * @update 2009/12/1
	 * @required Tweener
	 */
	public class Scroller extends Sprite 
	{
		private var scroll:ScrollerObject;
		private var textField:TextField;
		private var target:*;
		public function Scroller(_height:int=300,scrollStrength:int=10, bgObject:Sprite=null, barObject:Sprite=null) 
		{
			scroll = new ScrollerObject(_height, bgObject, barObject);
			scroll.strength = scrollStrength;
			addEventListener(Event.ADDED, onAdded);
		}
		private function onAdded(e:Event):void {
			removeEventListener(Event.ADDED, onAdded);
			addChild(scroll);
			//SWFWheel.initialize(stage);
		}
		
		public function setTarget(_target:*):void {
			target = _target;
			trace(_target is DisplayObject);
			if (target is TextField) {
				setTextField(_target);
			} else if (_target is DisplayObject) {
				setDisplayObject(_target);
			} else {
				trace("Target Type Error");
			}
		}
		/**
		 * マスクをかけたDisplayObjectにスクロールバーを反映させます
		 * @param	sprite
		 */
		private function setDisplayObject(dis:DisplayObject):void {
			this.visible = true;
			if (scroll.vertical && dis.height > dis.mask.height) {
				scroll.max = dis.height - dis.mask.height;
				dis.addEventListener(MouseEvent.MOUSE_WHEEL, scroll.wheel);
				dis.addEventListener(Event.ENTER_FRAME, function():void {
					dis.y = - scroll.value;
				});
			} else if (!scroll.vertical && dis.width > dis.mask.width) {
				scroll.max = dis.width - dis.mask.width;
				dis.addEventListener(MouseEvent.MOUSE_WHEEL, scroll.wheel);
				dis.addEventListener(Event.ENTER_FRAME, function():void {
					dis.x = - scroll.value;
				});
			} else {
				this.visible = false;
			}
		}
		/**
		 * テキストフィールドにスクロールバーを反映させます
		 * @param	tf
		 */
		private function setTextField(tf:TextField):void {
			this.visible = true;
			if (scroll.vertical && tf.textHeight > tf.height) {
				scroll.max = tf.maxScrollV + tf.bottomScrollV;
				addTextFieldEvent(tf);
			} else if (!scroll.vertical && tf.textWidth > tf.width) {
				var leftScrollH:Number = tf.width;
				scroll.max = tf.maxScrollH + leftScrollH;
				addTextFieldEvent(tf);
			} else {
				this.visible = false;
			}
		}
		private function addTextFieldEvent(tf:TextField):void {
			tf.addEventListener(Event.ENTER_FRAME, onEnter);
			tf.addEventListener(MouseEvent.MOUSE_WHEEL, scroll.wheel);
			tf.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			tf.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		private function onEnter(e:Event):void {
			if (scroll.vertical) {
				e.currentTarget.scrollV = scroll.value;
			} else {
				e.currentTarget.scrollH = scroll.value;
			}
		}
		private function onDownEnter(e:Event):void {
			var scale:Number = 1;
			if (scroll.vertical) {
				scale = e.currentTarget.scrollV / e.currentTarget.maxScrollV;
			} else {
				scale = e.currentTarget.scrollH / e.currentTarget.maxScrollH;
			}
			scroll.value = e.currentTarget.scrollV;
		}
		private function mouseDownHandler(e:MouseEvent):void {
			e.currentTarget.removeEventListener(Event.ENTER_FRAME, onEnter);
			e.currentTarget.addEventListener(Event.ENTER_FRAME, onDownEnter);
		}
		private function mouseUpHandler(e:MouseEvent):void {
			target.addEventListener(Event.ENTER_FRAME, onEnter);
			target.removeEventListener(Event.ENTER_FRAME, onDownEnter);
		}
		public function initMotion(time:int=1):void {
			scroll.initMotion(time);
		}
		
		public function update():void {
			setTarget(target);
		}
		public function direction(_vertical:Boolean):void {
			scroll.vertical = _vertical;
			if (_vertical) {
				scroll.rotation = 0;
				scroll.y = 0;
			} else {
				scroll.rotation = -90;
				scroll.y = scroll.height;
			}
		}
	}
}		