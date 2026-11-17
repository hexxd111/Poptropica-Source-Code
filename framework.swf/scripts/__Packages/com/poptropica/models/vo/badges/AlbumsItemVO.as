class com.poptropica.models.vo.badges.AlbumsItemVO extends com.poptropica.models.vo.supportClasses.VOBase
{
   var _badgesEarned;
   var _id;
   var _name;
   function AlbumsItemVO(id, name, badgesEarned)
   {
      super();
      this._id = id;
      this._name = name;
      this._badgesEarned = badgesEarned;
   }
   function get id()
   {
      return this._id;
   }
   function get name()
   {
      return this._name;
   }
   function get badgesEarned()
   {
      return this._badgesEarned;
   }
}
