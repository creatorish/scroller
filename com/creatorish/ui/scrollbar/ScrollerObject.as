package  com.creatorish.ui.scrollbar
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import caurina.transitions.Tweener;
	
	/**
	 * スクロールバー基本クラス
	 * @author yuu
	 * @link http://creatorish.com
	 * @version 1.0β
	 * @update 2009/12/1
	 * @required Tweener
	 */
	public class ScrollerObject extends Sprite
	{
		private var _min:int = 0;
		private var _max:int = 100;
		private var _value:int = 0;
		private var maxPoint:int = 0;
		public var vertical:Boolean = true;
		public var scrollHeight:int;
		public var strength:int = 10;
		public var bar:Sprite = new Sprite();
		public var bg:Sprite = new Sprite();
		
		/**
		 * スクロールの最大値を設定します
		 */
		public function set max(val:int):void {
			_max = val;
			var scale:Number = scrollHeight / _max;
			var n:int = Math.floor(scale);
			scale = scale - n;
			bar.height = scrollHeight*(scale);
			maxPoint = scrollHeight - bar.height - _min+1;
		}
		public function get max():int {
			return _max;
		}
		/**
		 * スクロールvalueを設定します（外部からのスクロールバー設定に使用）
		 */
		public function set value(val:int):void {
			_value = val;
			bar.y = Math.floor(((scrollHeight - bar.height - _min) / _max * val) + _min);
		}
		public function get value():int {
			return _value;
		}
		
		/**
		 * スクロールバーの実装
		 * @param	height バーの高さ
		 * @param	bgObject 背景に使用するSprite
		 * @param	barObject ドラッグバーに使用するSprite
		 */
		public function ScrollerObject(_height:int=300,bgObject:Sprite=null,barObject:Sprite=null) 
		{
			scrollHeight = _height;
			if (bgObject) {
				bg = bgObject;
			} else {
				defaultBar("bg");
			}
			if (barObject) {
				bar = barObject;
			} else {
				defaultBar("bar");
			}
			bar.buttonMode = true;
			addChild(bg);
			addChild(bar);
			
			bg.addEventListener(MouseEvent.CLICK, onClick);
			bar.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			bar.addEventListener(MouseEvent.MOUSE_UP, mouseDownHandler);
			
			addEventListener(Event.ADDED, onAdded);
		}
		private function onAdded(e:Event):void {
			removeEventListener(Event.ADDED, onAdded);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			addEventListener(MouseEvent.MOUSE_WHEEL, wheel);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			//SWFWheel.initialize(stage);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function onEnterFrame(e:Event):void
		{
			_value = Math.floor((bar.y - _min) / (scrollHeight - bar.height - _min) * _max);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function mouseDownHandler(e:MouseEvent):void
		{
			Tweener.pauseTweens(bar);
			var bounds:Rectangle = new Rectangle(0, _min,0, scrollHeight - bar.height - _min+1);
			bar.startDrag(false, bounds);
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function mouseUpHandler(e:MouseEvent):void
		{
			bar.stopDrag();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onMouseLeave(e:Event):void {
			bar.stopDrag();
		}
		/**
		 * 
		 * @param	e
		 */
		private function onClick(e:MouseEvent):void {
			var my:Number = e.currentTarget.mouseY+1 - bar.height / 2;
			if (my < 0) {
				my = 0;
			}
			if (my + bar.height > scrollHeight) {
				my = scrollHeight - bar.height;
			}
			Tweener.addTween(bar,
			{
				y: my,
				time: 1,
				transition: "easeOutExpo"
			});
		}
		/**
		 * 
		 * @param	e
		 */
		public function wheel(e:MouseEvent):void {
			var delta:Number = e.delta * strength;
			var ty:Number = 0;
			if (bar.y - delta <= 0) {
				ty = 0;
			} else if (bar.y - delta >= maxPoint) {
				ty = maxPoint;
			} else {
				ty = bar.y - delta;
			}
			Tweener.addTween(bar,
			{
				y: ty,
				time: 1,
				transition: "easeOutExpo"
			});
		}
		/**
		 * デフォルトバーの生成
		 * @param	type
		 */
		private function defaultBar(type:String):void {
			switch(type) {
				case "bg":
					bg.graphics.beginFill(0xCCCCCC);
					bg.graphics.drawRect(0, 0, 15, scrollHeight);
					bg.graphics.endFill();
					break;
				case "bar":
					bar.graphics.beginFill(0x333333);
					bar.graphics.drawRect(0, 0, 15, 50);
					bar.graphics.endFill();
					bar.addEventListener(MouseEvent.ROLL_OVER, onOver);
					bar.addEventListener(MouseEvent.ROLL_OUT, onOut);
					break;
				default:
					break;
			}
		}
		
		/**
		 * 初期化モーション
		 * @param	time
		 */
		public function initMotion(time:int=1):void {
			bar.y = maxPoint;
			Tweener.addTween(bar,
			{
				y: _min,
				time: time,
				transition: "easeOutExpo"
			});
		}
		
		private function onOver(e:MouseEvent):void {
			e.currentTarget.alpha = 0.7;
		}
		private function onOut(e:MouseEvent):void {
			e.currentTarget.alpha = 1;
		}
	}
}