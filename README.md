Cursors.as
======================
AS3でスクロールバーを実装するクラス

デモ
------
<a href="http://dev.creatorish.com/demo/bangojs/" target="_blank">http://dev.creatorish.com/demo/bangojs/</a>

使い方
------

### 初期化 ###
Scrollerをインポートします。

    import com.creatorish.ui.scroll.Scroller;

SWFWheelを使うとマウスのホイールイベントでスクロールさせられます。
SWFWheelを使用する場合はSWFWheelをインポートし、Scroller.asの**9行目**と**47行目**のコメントを外してください。

### TextFieldに適用する ###

    //テキストフィールドの設定例 
    textfiled.multiline = true; 
    textfield.height = 300; 
    textfield.width = 300;
    
    var scroll:Scroller = new Scroller(textfield.height);
    //適当な場所に配置
    scroll.x = textfield.width;
    addChild(scroll);
    //スクロールさせるTextField
    scroll.setTarget(textfield);

### DisplayObject(Sprite,MovieClip,Bitmap)に適用する ###

    //DisplayObjectにマスクをかけます
    sample.mask = maskObject;
    
    var scroll:Scroller = new Scroller(maskObject.height);
    scroll.x = maskObject.width;
    addChild(scroll);
    scroll.setTarget(sample)

### プラグイン ###

プラグインを使用することでアニメーション効果を付加します。  
またinitMotion関数が機能するようになります。

    //Tweenerプラグイン
    //別途Tweener(http://code.google.com/p/tweener/)が必要になります。
    import net.lifebird.ui.scroll.plugin.ScrollerTweener;

    //TweenLiteプラグイン
    //別途TweenLite(http://www.greensock.com/tweenlite/)が必要になります。
    import net.lifebird.ui.scroll.plugin.ScrollerTweenLite;

    var scroll:Scroller = new Scroller(300);
    scroll.plugin(ScrollerTweener);

### 関数 ###

    Scroller(_height:int=300,_strength:int=10,bgObject:Sprite=null,barObject:Sprite:null)
    
+    _height: スクロールバーの高さ  
+    _strength: マウスホイールの感度  
+    bgObject: スクロールバーの背景として使用するSpriteあるいはMovieClip  
+    barObject: スクロールバーのドラッグするところとして使用するSpriteあるいはMovieClip  
(bgObjectとbarObjectはnullだとサンプルと同じになります）

    setTarget(target:*):void

+    target: スクロールさせるターゲット。（TextFiledまたはマスクのかかったDisplayObject）  
※Bitmapにはマウスホイールイベントは発生しません

    direction(_vertical:Boolean):void
    
+    _vertical: スクロールバーを縦型で配置するかどうか。デフォルトはtrue。  
横スクロールバーとして使いたい場合はfalseを渡してください。

    update():void

+    スクロールバーを再描画します。setTargetで指定したターゲットの高さやテキスト量が変化したとき、  
resize関数でサイズを変更したとき等、Scrollerの設定を変更した後に使用します。

    resize(val:int):void

+    スクロールバーの高さをリサイズします。

    strength(val:int):void

+    マウスホイールの感度を再設定します。

    plugin(cls:Class):void

+    Scrollerプラグインを設定します。

    initMotion(time:int=1):void

+    pluginを設定したときのみ有効。初回表示をアニメーションして表示します。

ライセンス
--------
[MIT]: http://www.opensource.org/licenses/mit-license.php
Copyright &copy; 2012 creatorish.com
Distributed under the [MIT License][mit].

作者
--------
creatorish yuu  
Weblog: <http://creatorish.com>  
Facebook: <http://facebook.com/creatorish>  
Twitter: <http://twitter.jp/creatorish>