class com.lifeztream.debug.FPS
{
   static var BITMAP;
   static var CONTAINER;
   static var TEXTFIELD;
   static var averageFPS;
   static var cTime;
   static var count;
   static var currentFPS;
   static var data;
   static var highestFPS;
   static var intervalID;
   static var log;
   static var lowestFPS;
   static var median;
   static var movieFPS;
   static var timeElapsed;
   static var VERSION = "1.2";
   static var ALIGN = "left";
   static var AUTHOR = "(c) 2006-2007 Copyright by Wissarut Pimanmassuriya | lifeztream.com | wissar_p@hotmail.com";
   static var _isExpand = false;
   static var intervaltimes = 4;
   static var isCreated = false;
   static var WIDTH = 100;
   static var HEIGHT = 60;
   static var BORDER = 2;
   static var saveTimer = 5;
   function FPS()
   {
   }
   static function start(setfps, align)
   {
      _root.trc("FPS start");
      var _loc2_;
      var _loc3_;
      if(!isCreated)
      {
         data = _root.traceSO.data.FPS = new Object();
         ALIGN = align != undefined ? align : "left";
         movieFPS = setfps;
         lowestFPS = highestFPS = averageFPS = setfps;
         reset();
         mx.transitions.OnEnterFrameBeacon.init();
         MovieClip.addListener(com.lifeztream.debug.FPS);
         CONTAINER = _level0.createEmptyMovieClip("FPSCONTAINER",_root.getNextHighestDepth());
         CONTAINER.onUnload = function()
         {
            stop();
         };
         _loc2_ = CONTAINER.createEmptyMovieClip("bitmap",2);
         _loc2_.onRelease = function()
         {
            isExpand = !isExpand;
            CONTAINER.swapDepths(_root.getNextHighestDepth());
         };
         _loc2_.useHandCursor = false;
         TEXTFIELD = CONTAINER.createTextField("FPSFIELD",25,0,0,10,10);
         TEXTFIELD.autoSize = true;
         _loc3_ = new TextFormat("Georgia",10,10395294);
         TEXTFIELD._x = BORDER;
         TEXTFIELD._y = BORDER;
         TEXTFIELD.setNewTextFormat(_loc3_);
         TEXTFIELD.selectable = false;
         intervalID = setInterval(update,1000 / intervaltimes);
         isCreated = true;
         isExpand = true;
      }
   }
   static function stop()
   {
      isCreated = false;
      MovieClip.removeListener(com.lifeztream.debug.FPS);
      CONTAINER.FPSFIELD.removeTextField();
      BITMAP.dispose();
      clearInterval(intervalID);
   }
   static function update()
   {
      currentFPS = count * intervaltimes;
      count = 0;
      calcValues();
      createLog();
      drawData();
      saveData();
   }
   static function get isExpand()
   {
      return _isExpand;
   }
   static function set isExpand(b)
   {
      _isExpand = b;
      if(b)
      {
         WIDTH = 200;
         HEIGHT = 120;
      }
      else
      {
         WIDTH = 100;
         HEIGHT = 60;
      }
   }
   static function tostring()
   {
      return "com.lifeztream.debug.FPS, version:" + VERSION;
   }
   static function reset()
   {
      count = 0;
      currentFPS = 0;
      median = movieFPS;
      log = new Array();
      timeElapsed = 0;
      cTime = 0;
      saveTimer = 5;
   }
   static function onEnterFrame()
   {
      timeElapsed = getTimer() - cTime;
      cTime = getTimer();
      count++;
   }
   static function drawData()
   {
      BITMAP.dispose();
      var _loc4_ = new flash.geom.Matrix();
      _loc4_.translate(BORDER,20);
      BITMAP = new flash.display.BitmapData(WIDTH,HEIGHT,false,4079166);
      BITMAP.draw(new flash.display.BitmapData(WIDTH - BORDER * 2,HEIGHT - BORDER - 20,false,1184274),_loc4_);
      BITMAP.setPixel(BORDER - 1,HEIGHT - BORDER - getPointerHeight(movieFPS),65535);
      var _loc3_ = 0;
      if(log.length > (WIDTH - BORDER * 2) / 2)
      {
         i = log.length - (WIDTH - BORDER * 2) / 2;
      }
      else
      {
         var i = 0;
      }
      i;
      var _loc2_;
      var _loc1_;
      while(i < log.length)
      {
         _loc2_ = BORDER + _loc3_ * 2;
         if(log[i] > movieFPS * 0.7)
         {
            _loc1_ = 32256;
         }
         else if(log[i] > movieFPS * 0.5)
         {
            _loc1_ = 16777088;
         }
         else
         {
            _loc1_ = 16711680;
         }
         BITMAP.setPixel(_loc2_,HEIGHT - BORDER - getPointerHeight(log[i]),_loc1_);
         _loc3_ = _loc3_ + 1;
         i++;
      }
      CONTAINER.bitmap.attachBitmap(BITMAP,10);
      TEXTFIELD.text = "FPS : " + currentFPS + ", TE : " + timeElapsed + " ms.,  A : " + averageFPS + ", L : " + lowestFPS + ", H : " + highestFPS;
      if(ALIGN == "left")
      {
         CONTAINER._x = 0;
      }
      else if(ALIGN == "right")
      {
         CONTAINER._x = 1010 - WIDTH;
      }
   }
   static function getPointerHeight(n)
   {
      var _loc1_ = HEIGHT - BORDER - 20;
      var _loc2_ = movieFPS + 10;
      return Math.round(_loc1_ * (n / _loc2_));
   }
   static function createLog()
   {
      if(log.length >= Math.floor(WIDTH - BORDER * 2))
      {
         log.shift();
         log.push(currentFPS);
      }
      else
      {
         log.push(currentFPS);
      }
   }
   static function calcValues()
   {
      if(lowestFPS > currentFPS)
      {
         lowestFPS = currentFPS;
      }
      if(highestFPS < currentFPS)
      {
         highestFPS = currentFPS;
      }
      var _loc2_ = log.length;
      var _loc3_ = 0;
      var _loc1_ = 0;
      while(_loc1_ < _loc2_)
      {
         _loc3_ += log[_loc1_];
         _loc1_ = _loc1_ + 1;
      }
      averageFPS = Math.floor(_loc3_ / _loc2_);
   }
   static function saveData()
   {
      saveTimer--;
      if(saveTimer < 0)
      {
         saveDataFunction();
         saveTimer = 5;
      }
   }
   static function saveDataFunction()
   {
      data.scene = _root.ClusterName + " " + _root.SceneName;
      data.averageFPS = averageFPS;
      data.lowestFPS = lowestFPS;
      data.highestFPS = highestFPS;
      _root.traceSO.flush();
   }
}
