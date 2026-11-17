class com.poptropica.models.vo.AdvertisementVO
{
   var _campaign_file1;
   var _campaign_file2;
   var _campaign_name;
   var _click_through_URL;
   var _impression_URL;
   function AdvertisementVO(pCam, pClickThru, pImpression, pCampFile1, pCampFile2)
   {
      this._campaign_name = pCam;
      this._click_through_URL = pClickThru;
      this._impression_URL = pImpression;
      this._campaign_file1 = pCampFile1;
      this._campaign_file2 = pCampFile2;
   }
   function get campaign_name()
   {
      return this._campaign_name;
   }
   function get click_through_URL()
   {
      return this._click_through_URL;
   }
   function get impression_URL()
   {
      return this._impression_URL;
   }
   function get campaign_file1()
   {
      return this._campaign_file1;
   }
   function get campaign_file2()
   {
      return this._campaign_file2;
   }
   function set campaign_name(p)
   {
      this._campaign_name = p;
   }
   function set click_through_URL(p)
   {
      this._click_through_URL = p;
   }
   function set impression_URL(p)
   {
      this._impression_URL = p;
   }
   function set campaign_file1(p)
   {
      this._campaign_file1 = p;
   }
   function set campaign_file2(p)
   {
      this._campaign_file2 = p;
   }
}
