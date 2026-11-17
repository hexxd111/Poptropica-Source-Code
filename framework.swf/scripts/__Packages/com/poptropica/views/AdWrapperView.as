class com.poptropica.views.AdWrapperView extends com.poptropica.mvc.AbstractView
{
   var _ad_data;
   var _ad_left;
   var _ad_right;
   var _content_mc;
   var _controller;
   var _target;
   var _ad_loaded_cntr = 0;
   function AdWrapperView(m, c, target, depth, x, y)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("AdWrapperView::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._target = target;
      this._content_mc = this._target.createEmptyMovieClip("ads_mc",depth);
      this._content_mc.tabChildren = false;
      this._ad_left = new com.poptropica.components.Advertisement(this._content_mc,1,0,100);
      this._ad_right = new com.poptropica.components.Advertisement(this._content_mc,2,845,100);
   }
   function onAdOver()
   {
      com.poptropica.util.Debug.trace("onAdOver::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("click");
   }
   function onAdOut()
   {
      com.poptropica.util.Debug.trace("onAdOut::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      com.poptropica.controllers.PopController(this._controller).setPointerDisplay("arrow");
   }
   function onAdClick(pAdEvent)
   {
      com.poptropica.util.Debug.trace("onAdClick::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc2_;
      if(pAdEvent.target == this._ad_left)
      {
         _loc2_ = "Left";
      }
      else
      {
         _loc2_ = "Right";
      }
      com.poptropica.controllers.PopController(this._controller).track(this._ad_data.campaign_name,"ClickToSponsor","Wrapper",_loc2_,true);
      var _loc3_;
      if(this._ad_data.click_through_URL.indexOf("&var") == -1)
      {
         com.poptropica.controllers.PopController(this._controller).link(this._ad_data.click_through_URL);
      }
      else
      {
         _loc3_ = this.parseClickUrls(this._ad_data.click_through_URL,2);
         if(pAdEvent.target == this._ad_left)
         {
            com.poptropica.controllers.PopController(this._controller).link(_loc3_[0]);
         }
         else
         {
            com.poptropica.controllers.PopController(this._controller).link(_loc3_[1]);
         }
      }
   }
   function parseClickUrls(pBaseUrl, countOfVars)
   {
      com.poptropica.util.Debug.trace("AdWrapperView::parseClickUrls()  pBaseUrl=" + pBaseUrl,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc6_ = new Array();
      var _loc1_ = 1;
      var _loc4_;
      var _loc2_;
      var _loc5_;
      while(_loc1_ <= countOfVars)
      {
         _loc4_ = "var" + _loc1_ + "=";
         _loc2_ = pBaseUrl.indexOf("&var" + String(Number(_loc1_ + 1)) + "=");
         if(_loc2_ == -1)
         {
            _loc2_ = pBaseUrl.length;
         }
         else
         {
            _loc2_ = pBaseUrl.lastIndexOf("&");
         }
         _loc5_ = pBaseUrl.substring(pBaseUrl.indexOf(_loc4_) + _loc4_.length,_loc2_);
         _loc6_.push(_loc5_);
         _loc1_ = _loc1_ + 1;
      }
      return _loc6_;
   }
   function onAdLoaded(e)
   {
      com.poptropica.util.Debug.trace("onAdLoaded::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._ad_loaded_cntr = this._ad_loaded_cntr + 1;
      if(this._ad_loaded_cntr == 2)
      {
         com.poptropica.controllers.PopController(this._controller).track(this._ad_data.campaign_name,"Impression","Wrapper",undefined,true);
         if(!utils.Utils.isNull(this._ad_data.impression_URL))
         {
            com.poptropica.util.Debug.trace("AdWrapperView:: Sending tracking pixel : " + this._ad_data.impression_URL,com.poptropica.util.Debug.WARNING);
            com.poptropica.controllers.PopController(this._controller).loadTrackingPixel(this._ad_data.impression_URL);
         }
      }
   }
   function get content_mc()
   {
      return this._content_mc;
   }
   function update(o, pInfoObj)
   {
      com.poptropica.util.Debug.trace("AdWrapperView::update() : " + pInfoObj._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
      var _loc0_;
      var _loc2_;
      if((_loc0_ = pInfoObj._type) === com.poptropica.models.PopUpdateNotificationTypes.WRAPPER_AD_RETRIEVED)
      {
         _loc2_ = com.poptropica.models.vo.AdvertisementVO(pInfoObj._data);
         com.poptropica.util.Debug.trace("info.campaign_name=" + _loc2_.campaign_name,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.click_through_URL=" + _loc2_.click_through_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.impression_URL=" + _loc2_.impression_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.campaign_file1=" + _loc2_.campaign_file1,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         com.poptropica.util.Debug.trace("info.campaign_file2=" + _loc2_.campaign_file2,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         if(!utils.Utils.isNull(_loc2_.campaign_name))
         {
            this._ad_left.loadAd(_loc2_.campaign_file1);
            this._ad_left.addEventListener(com.poptropica.components.Advertisement.AD_CLICK,com.poptropica.util.EventDelegate.create(this,this.onAdClick));
            this._ad_left.addEventListener(com.poptropica.components.Advertisement.AD_OVER,com.poptropica.util.EventDelegate.create(this,this.onAdOver));
            this._ad_left.addEventListener(com.poptropica.components.Advertisement.AD_OUT,com.poptropica.util.EventDelegate.create(this,this.onAdOut));
            this._ad_left.addEventListener(com.poptropica.components.Advertisement.AD_LOADED,com.poptropica.util.EventDelegate.create(this,this.onAdLoaded));
            this._ad_right.loadAd(_loc2_.campaign_file2,this.onAdClick);
            this._ad_right.addEventListener(com.poptropica.components.Advertisement.AD_CLICK,com.poptropica.util.EventDelegate.create(this,this.onAdClick));
            this._ad_right.addEventListener(com.poptropica.components.Advertisement.AD_OVER,com.poptropica.util.EventDelegate.create(this,this.onAdOver));
            this._ad_right.addEventListener(com.poptropica.components.Advertisement.AD_OUT,com.poptropica.util.EventDelegate.create(this,this.onAdOut));
            this._ad_right.addEventListener(com.poptropica.components.Advertisement.AD_LOADED,com.poptropica.util.EventDelegate.create(this,this.onAdLoaded));
         }
         this._ad_data = _loc2_;
      }
   }
}
