class com.poptropica.models.vo.dailyPopVO.ComicVO
{
   var _id;
   var _thumbPath;
   var _title;
   function ComicVO(pId, pTitle, pThumbPath)
   {
      this._id = pId;
      this._title = pTitle;
      this._thumbPath = pThumbPath;
   }
   function get id()
   {
      return this._id;
   }
   function get title()
   {
      return this._title;
   }
   function get thumbPath()
   {
      return this._thumbPath;
   }
}
