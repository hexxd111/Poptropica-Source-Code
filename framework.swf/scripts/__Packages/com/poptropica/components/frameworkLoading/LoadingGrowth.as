class com.poptropica.components.frameworkLoading.LoadingGrowth extends MovieClip
{
   var delx;
   var dely;
   var intID;
   var lineColor;
   var onEnterFrame;
   var tip;
   var tip2;
   var x1;
   var x2;
   var y1;
   var y2;
   var whichItems = ["Leaf1","Leaf2","Leaf3"];
   var randRot = 90;
   var unitAngle = 3;
   var vel = 8;
   var angleVel = 0;
   var angleAccel = 0.5;
   var angle = 0;
   var xPos = 0;
   var yPos = 0;
   var vel2 = 0;
   var i = 0;
   var lineWidth = 10;
   var lineStep = 0.2;
   var curDir = true;
   var dir = 0;
   function LoadingGrowth()
   {
      super();
   }
   function onLoad()
   {
      this.delx = this.tip._x - this.tip2._x;
      this.dely = this.tip._y - this.tip2._y;
      this.tip._visible = false;
      this.lineColor = this._parent.myColors[random(this._parent.myColors.length)];
      this.lineStyle(this.lineWidth,this.lineColor,100);
      this.moveTo(this.tip._x,this.tip._y);
      this.intID = setInterval(this,"changeDir",100);
      this.onEnterFrame = com.poptropica.util.EventDelegate.create(this,this.myOnEnterFrame);
   }
   function attachLeaf()
   {
      this.i = this.i + 1;
      var _loc4_ = this.whichItems[random(this.whichItems.length)];
      var _loc2_ = this.attachMovie(_loc4_,"leaf" + this.i,this.i);
      _loc2_._x = this.tip._x;
      _loc2_._y = this.tip._y;
      _loc2_._xscale = _loc2_._yscale = this.lineWidth * 5 + 20;
      _loc2_._rotation = this.tip._rotation - 90 + Math.random() * this.randRot - this.randRot / 2;
      var _loc5_ = new Color(_loc2_);
      var _loc3_ = this._parent.myColors[random(this._parent.myColors.length)];
      _loc5_.setRGB(_loc3_);
   }
   function changeDir()
   {
      if(this.lineWidth > 0)
      {
         this.dir = random(2);
      }
      else
      {
         this.angleAccel = 6;
      }
   }
   function myOnEnterFrame()
   {
      this.x1 = this.x2;
      this.y1 = this.y2;
      this.delx = this.tip._x - this.tip2._x;
      this.dely = this.tip._y - this.tip2._y;
      this.angle = this.tip._rotation * 3.141592653589793 / 180;
      this.xPos = this.vel * Math.cos(this.angle);
      this.yPos = this.vel * Math.sin(this.angle);
      this.tip._x -= this.xPos;
      this.tip._y -= this.yPos;
      this.x2 = this.tip._x;
      this.y2 = this.tip._y;
      var _loc2_ = (this.x1 + this.x2) / 2;
      var _loc3_ = (this.y1 + this.y2) / 2;
      this.curveTo(this.x1,this.y1,_loc2_,_loc3_);
      this.lineWidth -= this.lineStep;
      this.lineStyle(this.lineWidth,this.lineColor,100);
      if(this.dir == 0)
      {
         this.tip._rotation -= this.angleVel;
         if(this.curDir == true)
         {
            this.attachLeaf();
         }
         this.curDir = false;
      }
      else
      {
         this.tip._rotation += this.angleVel;
         if(this.curDir == false)
         {
            this.attachLeaf();
         }
         this.curDir = true;
      }
      this.angleVel += this.angleAccel;
      if(this.lineWidth < -2.5)
      {
         this.onEnterFrame = undefined;
         this.cacheAsBitmap = true;
         this._parent.generateGrowth(Math.random() * Stage.height - Stage.height / 2,this._x,this._rotation);
      }
   }
}
