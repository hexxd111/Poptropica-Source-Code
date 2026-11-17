class com.greensock.plugins.AutoAlphaPlugin extends com.greensock.plugins.VisiblePlugin
{
   var _ignoreVisible;
   var _target;
   var addTween;
   var overwriteProps;
   var propName;
   var updateTweens;
   static var API = 1;
   function AutoAlphaPlugin()
   {
      super();
      this.propName = "autoAlpha";
      this.overwriteProps = ["_alpha","_visible"];
   }
   function onInitTween(target, value, tween)
   {
      this._target = target;
      this.addTween(target,"_alpha",target._alpha,value,"_alpha");
      return true;
   }
   function killProps(lookup)
   {
      super.killProps(lookup);
      this._ignoreVisible = Boolean(lookup._visible != undefined);
   }
   function set changeFactor(n)
   {
      this.updateTweens(n);
      if(!this._ignoreVisible)
      {
         this._target._visible = Boolean(this._target._alpha != 0);
      }
   }
}
