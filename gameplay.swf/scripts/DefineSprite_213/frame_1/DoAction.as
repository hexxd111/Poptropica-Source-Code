btnCelebrate.onPress = function()
{
   switch(Math.ceil(Math.random() * 2))
   {
      case 1:
         _parent._parent.emote("celebrate");
         break;
      case 2:
         _parent._parent.emote("laugh");
      default:
         return;
   }
};
btnAngry.onPress = function()
{
   switch(Math.ceil(Math.random() * 2))
   {
      case 1:
         _parent._parent.emote("angry");
         break;
      case 2:
         _parent._parent.emote("stomp");
      default:
         return;
   }
};
btnLaugh.onPress = function()
{
   switch(Math.ceil(Math.random() * 2))
   {
      case 1:
         _parent._parent.emote("score");
         break;
      case 2:
         _parent._parent.emote("proud");
      default:
         return;
   }
};
btnCry.onPress = function()
{
   switch(Math.ceil(Math.random() * 2))
   {
      case 1:
         _parent._parent.emote("grief");
         break;
      case 2:
         _parent._parent.emote("cry");
      default:
         return;
   }
};
btnWave.onPress = function()
{
   _parent._parent.emote("wave");
};
