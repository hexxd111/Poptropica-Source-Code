class com.poptropica.views.AdLogOutView extends com.poptropica.mvc.AbstractView
{
   var _ad_data;
   var _target;
   var DEFAULT_AD = "ads/AdLogout_Default.swf";
   function AdLogOutView(m, c, target)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("AdLogOutView::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._target = target;
   }
   function update(o, pInfoObj)
   {
      var _loc3_ = com.poptropica.models.PopModelConst.gameplayMC.popupClip2.adContainer;
      com.poptropica.util.Debug.trace("AdLogOutView::update()" + pInfoObj._type + " container : " + _loc3_ + " : " + com.poptropica.models.PopModelConst.gameplayMC.popupClip2,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc0_;
      var _loc2_;
      var _loc4_;
      var _loc5_;
      if((_loc0_ = pInfoObj._type) === com.poptropica.models.PopUpdateNotificationTypes.LOGOUT_AD_RETRIEVED)
      {
         _loc2_ = com.poptropica.models.vo.AdvertisementVO(pInfoObj._data);
         com.poptropica.util.Debug.trace("info.campaign_name=" + _loc2_.campaign_name,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.click_through_URL=" + _loc2_.click_through_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.impression_URL=" + _loc2_.impression_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.campaign_file1=" + _loc2_.campaign_file1,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.campaign_file2=" + _loc2_.campaign_file2,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         _loc4_ = new MovieClipLoader();
         _loc5_ = new Object();
         _loc5_.onLoadInit = Delegate.create(this,this.adLoaded);
         _loc4_.addListener(_loc5_);
         if(!utils.Utils.isNull(_loc2_.campaign_file1))
         {
            _loc4_.loadClip(_loc2_.campaign_file1,_loc3_);
         }
         else
         {
            _loc4_.loadClip(this.DEFAULT_AD,_loc3_);
         }
         this._ad_data = _loc2_;
      }
   }
   function adLoaded(target)
   {
      target._visible = false;
      target._x -= target._width * 0.5;
      target._y -= target._height * 0.5;
      target._visible = true;
      if(!utils.Utils.isNull(this._ad_data.click_through_URL))
      {
         target.onRelease = Delegate.create(this,this.adClicked);
      }
   }
   function adClicked()
   {
      getURL(this._ad_data.click_through_URL,"_blank");
   }
}
