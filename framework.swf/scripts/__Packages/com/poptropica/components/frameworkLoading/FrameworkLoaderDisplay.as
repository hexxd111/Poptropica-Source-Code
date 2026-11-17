class com.poptropica.components.frameworkLoading.FrameworkLoaderDisplay extends MovieClip
{
   var bg_mc;
   var cntr;
   var num_vines;
   var pop_load_package_mc;
   var reset;
   var vines_mc;
   var max_num_vines = 40;
   function FrameworkLoaderDisplay()
   {
      super();
   }
   function setInitPosition()
   {
      this.bg_mc._width = Stage.width;
      this.bg_mc._height = Stage.height;
      this.pop_load_package_mc._x = Stage.width / 2;
      this.pop_load_package_mc._y = Stage.height / 2;
      this.vines_mc._x = Stage.width / 2;
      this.vines_mc._y = Stage.height / 2;
   }
   function onPress()
   {
   }
   function onLoad()
   {
      Stage.scaleMode = "noScale";
      Stage.align = "TL";
      fscommand("allowscale","false");
      this.setInitPosition();
      this.useHandCursor = false;
      this.stop();
      this.vines_mc.myColors = [1286141];
      this.vines_mc.cntr = 45;
      this.vines_mc.reset = 45;
      this.vines_mc.num_vines = 0;
      var me = this;
      this.vines_mc.onEnterFrame = function()
      {
         this.cntr = this.cntr + 1;
         if(this.cntr > this.reset && this.num_vines < me.max_num_vines)
         {
            this.cntr = 0;
            me.generateGrowth(Math.random() * Stage.height - Stage.height / 2,-20 - Stage.width / 2,90);
            me.generateGrowth(Math.random() * Stage.height - Stage.height / 2,20 + Stage.width / 2,-90);
         }
      };
   }
   function generateGrowth(pY, pX, pRot)
   {
      var _loc2_ = this.vines_mc.attachMovie("Growth","growth" + this.vines_mc.getNextHighestDepth(),this.vines_mc.getNextHighestDepth());
      _loc2_._y = pY;
      _loc2_._x = pX;
      _loc2_._rotation = pRot;
      this.vines_mc.num_vines++;
   }
   function reflection(obj, indent)
   {
      for(var _loc3_ in obj)
      {
         this.reflection(obj[_loc3_],"   ");
      }
   }
}
