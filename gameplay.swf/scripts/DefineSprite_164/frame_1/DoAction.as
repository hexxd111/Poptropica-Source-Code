function animateIn()
{
   i = 1;
   while(i <= 3)
   {
      btn = this["btn" + i];
      btn.startY = btn._y;
      btn._y += 40;
      btn._alpha = 0;
      btn._xscale = btn._yscale = 0;
      btn._rotation = Math.random() * 360 - 180;
      btn.onEnterFrame = function()
      {
         this._alpha += (100 - this._alpha) / 2;
         this._xscale = this._yscale += (100 - this._xscale) / 2;
         this._rotation += (- this._rotation) / 2;
         this._y += (this.startY - this._y) / 2;
      };
      i++;
   }
}
stop();
clipHeight = 10;
btn1.onPress = function()
{
   _root.showChat(_root.camera.scene.char);
   _root.loadChat();
   EventToTrack = "ChatClicked";
   loadVariablesNum("/brain/track.php?cluster=" + _root.ClusterName + "&scene=" + _root.SceneName + "&event=" + EventToTrack + "&grade=" + _root.CharacterGrade + "&gender=" + _root.CharacterGender + "&lang=" + _root.CharacterLanguage + "&brain=Poptropica&randomNumber=" + random(10000),0);
};
btn1.onRollOver = _root.useArrow;
btn2.onPress = function()
{
   _root.showGameMenu(_root.camera.scene.char.targetPlayer);
   EventToTrack = "BattleClicked";
   loadVariablesNum("/brain/track.php?cluster=" + _root.ClusterName + "&scene=" + _root.SceneName + "&event=" + EventToTrack + "&grade=" + _root.CharacterGrade + "&gender=" + _root.CharacterGender + "&lang=" + _root.CharacterLanguage + "&brain=Poptropica&randomNumber=" + random(10000),0);
};
btn2.onRollOver = _root.useArrow;
