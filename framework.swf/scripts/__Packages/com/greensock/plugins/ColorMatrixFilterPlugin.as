class com.greensock.plugins.ColorMatrixFilterPlugin extends com.greensock.plugins.FilterPlugin
{
   var _filter;
   var _matrix;
   var _matrixTween;
   var _target;
   var _type;
   var initFilter;
   var overwriteProps;
   var propName;
   static var API = 1;
   static var _propNames = [];
   static var _idMatrix = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
   static var _lumR = 0.212671;
   static var _lumG = 0.71516;
   static var _lumB = 0.072169;
   function ColorMatrixFilterPlugin()
   {
      super();
      this.propName = "colorMatrixFilter";
      this.overwriteProps = ["colorMatrixFilter"];
   }
   function onInitTween(target, value, tween)
   {
      this._target = target;
      this._type = flash.filters.ColorMatrixFilter;
      var _loc3_ = value;
      this.initFilter({remove:value.remove,index:value.index,addFilter:value.addFilter},new flash.filters.ColorMatrixFilter(_idMatrix.slice()),_propNames);
      this._matrix = flash.filters.ColorMatrixFilter(this._filter).matrix;
      var _loc2_ = [];
      if(_loc3_.matrix != undefined && _loc3_.matrix instanceof Array)
      {
         _loc2_ = _loc3_.matrix;
      }
      else
      {
         if(_loc3_.relative == true)
         {
            _loc2_ = this._matrix.slice();
         }
         else
         {
            _loc2_ = _idMatrix.slice();
         }
         _loc2_ = setBrightness(_loc2_,_loc3_.brightness);
         _loc2_ = setContrast(_loc2_,_loc3_.contrast);
         _loc2_ = setHue(_loc2_,_loc3_.hue);
         _loc2_ = setSaturation(_loc2_,_loc3_.saturation);
         _loc2_ = setThreshold(_loc2_,_loc3_.threshold);
         if(!isNaN(_loc3_.colorize))
         {
            _loc2_ = colorize(_loc2_,_loc3_.colorize,_loc3_.amount);
         }
      }
      this._matrixTween = new com.greensock.plugins.EndArrayPlugin();
      this._matrixTween.init(this._matrix,_loc2_);
      return true;
   }
   function set changeFactor(n)
   {
      this._matrixTween.changeFactor = n;
      flash.filters.ColorMatrixFilter(this._filter).matrix = this._matrix;
      super.changeFactor = n;
   }
   static function colorize(m, color, amount)
   {
      if(isNaN(color))
      {
         return m;
      }
      if(isNaN(amount))
      {
         amount = 1;
      }
      var _loc3_ = (color >> 16 & 0xFF) / 255;
      var _loc5_ = (color >> 8 & 0xFF) / 255;
      var _loc2_ = (color & 0xFF) / 255;
      var _loc4_ = 1 - amount;
      var _loc7_ = [_loc4_ + amount * _loc3_ * _lumR,amount * _loc3_ * _lumG,amount * _loc3_ * _lumB,0,0,amount * _loc5_ * _lumR,_loc4_ + amount * _loc5_ * _lumG,amount * _loc5_ * _lumB,0,0,amount * _loc2_ * _lumR,amount * _loc2_ * _lumG,_loc4_ + amount * _loc2_ * _lumB,0,0,0,0,0,1,0];
      return applyMatrix(_loc7_,m);
   }
   static function setThreshold(m, n)
   {
      if(isNaN(n))
      {
         return m;
      }
      var _loc2_ = [_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * n,_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * n,_lumR * 256,_lumG * 256,_lumB * 256,0,-256 * n,0,0,0,1,0];
      return applyMatrix(_loc2_,m);
   }
   static function setHue(m, n)
   {
      if(isNaN(n))
      {
         return m;
      }
      n *= 0.017453292519943295;
      var _loc1_ = Math.cos(n);
      var _loc2_ = Math.sin(n);
      var _loc4_ = [_lumR + _loc1_ * (1 - _lumR) + _loc2_ * (- _lumR),_lumG + _loc1_ * (- _lumG) + _loc2_ * (- _lumG),_lumB + _loc1_ * (- _lumB) + _loc2_ * (1 - _lumB),0,0,_lumR + _loc1_ * (- _lumR) + _loc2_ * 0.143,_lumG + _loc1_ * (1 - _lumG) + _loc2_ * 0.14,_lumB + _loc1_ * (- _lumB) + _loc2_ * -0.283,0,0,_lumR + _loc1_ * (- _lumR) + _loc2_ * (- (1 - _lumR)),_lumG + _loc1_ * (- _lumG) + _loc2_ * _lumG,_lumB + _loc1_ * (1 - _lumB) + _loc2_ * _lumB,0,0,0,0,0,1,0,0,0,0,0,1];
      return applyMatrix(_loc4_,m);
   }
   static function setBrightness(m, n)
   {
      if(isNaN(n))
      {
         return m;
      }
      n = n * 100 - 100;
      return applyMatrix([1,0,0,0,n,0,1,0,0,n,0,0,1,0,n,0,0,0,1,0,0,0,0,0,1],m);
   }
   static function setSaturation(m, n)
   {
      if(isNaN(n))
      {
         return m;
      }
      var _loc4_ = 1 - n;
      var _loc2_ = _loc4_ * _lumR;
      var _loc5_ = _loc4_ * _lumG;
      var _loc1_ = _loc4_ * _lumB;
      var _loc6_ = [_loc2_ + n,_loc5_,_loc1_,0,0,_loc2_,_loc5_ + n,_loc1_,0,0,_loc2_,_loc5_,_loc1_ + n,0,0,0,0,0,1,0];
      return applyMatrix(_loc6_,m);
   }
   static function setContrast(m, n)
   {
      if(isNaN(n))
      {
         return m;
      }
      n += 0.01;
      var _loc2_ = [n,0,0,0,128 * (1 - n),0,n,0,0,128 * (1 - n),0,0,n,0,128 * (1 - n),0,0,0,1,0];
      return applyMatrix(_loc2_,m);
   }
   static function applyMatrix(m, m2)
   {
      if(!(m instanceof Array) || !(m2 instanceof Array))
      {
         return m2;
      }
      var _loc7_ = [];
      var _loc2_ = 0;
      var _loc5_ = 0;
      var _loc6_;
      var _loc1_;
      _loc6_ = 0;
      while(_loc6_ < 4)
      {
         _loc1_ = 0;
         while(_loc1_ < 5)
         {
            if(_loc1_ == 4)
            {
               _loc5_ = m[_loc2_ + 4];
            }
            else
            {
               _loc5_ = 0;
            }
            _loc7_[_loc2_ + _loc1_] = m[_loc2_] * m2[_loc1_] + m[_loc2_ + 1] * m2[_loc1_ + 5] + m[_loc2_ + 2] * m2[_loc1_ + 10] + m[_loc2_ + 3] * m2[_loc1_ + 15] + _loc5_;
            _loc1_ = _loc1_ + 1;
         }
         _loc2_ += 5;
         _loc6_ = _loc6_ + 1;
      }
      return _loc7_;
   }
}
