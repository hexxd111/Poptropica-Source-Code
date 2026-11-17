class com.poptropica.views.AdAutoCardView extends com.poptropica.mvc.AbstractView
{
   var _ad_data;
   var _target;
   function AdAutoCardView(m, c, target)
   {
      super(m,c);
      com.poptropica.util.Debug.trace("AdAutoCardView::()",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      this._target = target;
   }
   function update(o, pInfoObj)
   {
      var _loc0_;
      var _loc2_;
      var _loc5_;
      var _loc4_;
      if((_loc0_ = pInfoObj._type) === com.poptropica.models.PopUpdateNotificationTypes.AUTOCARD_AD_RETRIEVED)
      {
         _loc2_ = com.poptropica.models.vo.AdvertisementVO(pInfoObj._data);
         com.poptropica.util.Debug.trace("AdMainStreetView info.campaign_name=" + _loc2_.campaign_name + " type : " + pInfoObj._type + " gameplay : " + com.poptropica.models.PopModelConst.gameplayMC,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         if(!utils.Utils.isNull(_loc2_.campaign_name))
         {
            com.poptropica.util.Debug.trace("AdAutoCardView::update() " + com.poptropica.models.PopModelConst.gameplayMC + " type : " + pInfoObj._type,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdAutoCardView info.click_through_URL=" + _loc2_.click_through_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdAutoCardView info.impression_URL=" + _loc2_.impression_URL,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdAutoCardView info.campaign_file1=" + _loc2_.campaign_file1,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            com.poptropica.util.Debug.trace("AdAutoCardView info.campaign_file2=" + _loc2_.campaign_file2,com.poptropica.util.Debug.VERBOSE_MESSAGE);
            _loc5_ = this.parseAdDataSequence(_loc2_.campaign_file1);
            _loc4_ = this.parseAdDataSequence(_loc2_.campaign_name);
            this.getItemData(_loc5_,_loc4_);
         }
         this._ad_data = _loc2_;
      }
   }
   function getAutoCard(cardNum, campaignName, islands)
   {
      trace("autocard :: giving item : " + cardNum + " campaignName : " + campaignName + " : " + islands + " popupClip : " + com.poptropica.models.PopModelConst.gameplayMC.popupClip);
      if(!com.poptropica.models.PopModelConst.gameplayMC.popupClip)
      {
         com.poptropica.models.PopModelConst.gameplayMC.pickedItem = cardNum;
         if(Number(cardNum) > 2999)
         {
            com.poptropica.models.PopModelConst.gameplayMC.avatar.getItem(cardNum,"Store");
         }
         else
         {
            com.poptropica.models.PopModelConst.gameplayMC.avatar.getItemForIslands(cardNum,islands);
         }
         com.poptropica.models.PopModelConst.gameplayMC.popup("getcard.swf");
         com.poptropica.controllers.PopController.getInstance().track(campaignName,"ObjectCollected","AutoCard",String(cardNum),true);
      }
   }
   function parseAdDataSequence(data, containsExtraVariable)
   {
      var _loc7_ = data.split("var").length - 1;
      var _loc6_ = new Array();
      if(_loc7_ == 0)
      {
         return [data];
      }
      var _loc2_ = 1;
      var _loc4_;
      var _loc1_;
      var _loc5_;
      while(_loc2_ <= _loc7_)
      {
         _loc4_ = "var" + _loc2_ + "=";
         _loc1_ = data.indexOf("&var" + String(Number(_loc2_ + 1)) + "=");
         if(_loc1_ == -1 && containsExtraVariable)
         {
            _loc1_ = _loc1_ != -1 ? _loc1_ : data.lastIndexOf("&");
         }
         else
         {
            _loc1_ = _loc1_ != -1 ? _loc1_ : data.length;
         }
         _loc5_ = data.substring(data.indexOf(_loc4_) + _loc4_.length,_loc1_);
         _loc6_.push(_loc5_);
         _loc2_ = _loc2_ + 1;
      }
      return _loc6_;
   }
   function getItemData(items, campaigns)
   {
      if(com.poptropica.models.PopModelConst.gameplayMC.avatar.isRegistred())
      {
         com.poptropica.models.PopModelConst.gameplayMC.avatar.updateIslandData("Store",Delegate.create(this,this.getItems,items,campaigns));
      }
      else
      {
         this.getItems(items,campaigns);
      }
   }
   function getItems(items, campaigns)
   {
      trace("autocard :: get items : " + items + " campaigns : " + campaigns);
      var _loc9_ = false;
      var _loc8_ = 3500;
      var _loc6_ = 1000;
      var _loc5_;
      var _loc3_ = 0;
      while(_loc3_ < items.length)
      {
         if(!utils.Utils.isNull(items[_loc3_]) && !utils.Utils.isNull(campaigns[_loc3_]))
         {
            _loc5_ = String(items[_loc3_]).indexOf("m");
            if(_loc5_ > -1 && com.poptropica.models.PopModelConst.gameplayMC.isActiveMember() || _loc5_ == -1)
            {
               if(_loc5_ > -1)
               {
                  items[_loc3_] = String(items[_loc3_]).substring(0,4);
               }
               if(!com.poptropica.models.PopModelConst.gameplayMC.avatar.checkItem(items[_loc3_]))
               {
                  _global.setTimeout(this.getAutoCard,_loc6_,items[_loc3_],campaigns[_loc3_]);
                  _loc6_ += _loc8_;
               }
            }
         }
         _loc3_ = _loc3_ + 1;
      }
   }
}
