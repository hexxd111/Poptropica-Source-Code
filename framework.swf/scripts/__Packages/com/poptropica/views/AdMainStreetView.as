class com.poptropica.views.AdMainStreetView extends com.poptropica.mvc.AbstractView
{
   var _ad_data;
   var _dispatcher;
   var _loader;
   var _loaderListener;
   var _target;
   function AdMainStreetView(m, c, target)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("AdMainStreetView::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._target = target;
      this._loader = new MovieClipLoader();
      this._loaderListener = new Object();
      this._loaderListener.onLoadInit = Delegate.create(this,this.loaded);
      this._loaderListener.onLoadError = Delegate.create(this,this.loadError);
      this._loader.addListener(this._loaderListener);
      this._dispatcher = new com.poptropica.controllers.commands.CommandDispatcher();
   }
   function update(o, pInfoObj)
   {
      var _loc0_;
      var _loc2_;
      var _loc3_;
      if((_loc0_ = pInfoObj._type) === com.poptropica.models.PopUpdateNotificationTypes.MAINSTREET_AD_RETRIEVED)
      {
         _loc2_ = com.poptropica.models.vo.AdvertisementVO(pInfoObj._data);
         _loc3_ = com.poptropica.models.PopModelConst.gameplayMC.camera.scene;
         com.poptropica.util.Debug.trace("AdMainStreetView info.campaign_name=" + _loc2_.campaign_name + " type : " + pInfoObj._type + " gameplay : " + com.poptropica.models.PopModelConst.gameplayMC + " scene :: " + _loc3_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         if(!utils.Utils.isNull(_loc2_.campaign_name) && _loc3_.adArea._visible)
         {
            com.poptropica.util.Debug.trace("AdMainStreetView::update() " + com.poptropica.models.PopModelConst.gameplayMC + " type : " + pInfoObj._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdMainStreetView info.click_through_URL=" + _loc2_.click_through_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdMainStreetView info.impression_URL=" + _loc2_.impression_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdMainStreetView info.campaign_file1=" + _loc2_.campaign_file1,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdMainStreetView info.campaign_file2=" + _loc2_.campaign_file2,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            this._loader.loadClip(_loc2_.campaign_file1,_loc3_.adArea);
            _loc3_.adPrep();
         }
         else
         {
            _loc3_.adArea._visible = false;
            this.loadError();
         }
         this._ad_data = _loc2_;
      }
   }
   function loaded(clip)
   {
      this._dispatcher.dispatchEvent({type:"Loaded"});
   }
   function loadError(clip)
   {
      this._dispatcher.dispatchEvent({type:"LoadError"});
   }
   function get dispatcher()
   {
      return this._dispatcher;
   }
}
