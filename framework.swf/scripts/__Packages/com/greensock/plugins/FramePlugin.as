class com.greensock.plugins.FramePlugin extends com.greensock.plugins.TweenPlugin
{
   var _target;
   var frame;
   var overwriteProps;
   var propName;
   var round;
   static var API = 1;
   function FramePlugin()
   {
      super();
      this.propName = "frame";
      this.overwriteProps = ["frame"];
      this.round = true;
   }
   function onInitTween(target, value, tween)
   {
      if(typeof target != "movieclip" || isNaN(value))
      {
         return false;
      }
      this._target = MovieClip(target);
      this.frame = this._target._currentframe;
      this.addTween(this,"frame",this.frame,value,"frame");
      return true;
   }
   function set changeFactor(n)
   {
      this.updateTweens(n);
      this._target.gotoAndStop(this.frame);
   }
}
