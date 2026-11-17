function Connect()
{
   var _loc2_ = camera.scene.char.avatar.loadLogin();
   var _loc5_ = camera.scene.char.avatar.getLook().toString();
   var _loc6_ = camera.scene.char.avatar.loadName();
   var _loc3_ = camera.scene.mmoRoomName;
   if(camera.scene.PartyRoom)
   {
      _loc3_ = _loc3_.substr(1,4);
   }
   trace("Connect Room: " + _loc3_ + " Login: " + _loc2_ + " Look: " + _loc5_ + " Char Name: " + _loc6_);
   var _loc4_ = getUserInfo();
   trace("USER INFO ranking: " + _loc4_.ranking + " points: " + _loc4_.points);
   server.connect("rtmp://" + _root.camera.scene.char.avatar.FunBrain_so.data.MMOprefix + "/game/",_loc3_,_loc2_,_loc5_,Math.round(camera.scene.startX),Math.round(camera.scene.startY),_loc6_,_loc4_);
   Users[_loc2_] = {char:camera.scene.char,login:_loc2_,look:_loc5_};
   Users[_loc2_].char.Loaded = true;
   Users[_loc2_].char.charName = _loc6_;
   Users[_loc2_].char.userInfo = _loc4_;
}
function getNextUserDepth()
{
   do
   {
      nextUserDepth++;
   }
   while(camera.scene.getInstanceAtDepth(nextUserDepth));
   return nextUserDepth;
}
function addUser(login, look, X, Y, stat, charName, userInfo)
{
   if(Users[login])
   {
      return undefined;
   }
   trace("Adding user Login: " + login + " Look: " + look + " X: " + X + " Y: " + Y + " STATUS: " + stat + " CHARNAME: " + charName);
   var _loc4_ = look.split("/")[0];
   var _loc3_ = camera.scene.attachMovie("_char","char" + ++nextUserNum,getNextUserDepth(),{_x:X,_y:2000});
   Users[login] = {char:_loc3_,login:login,look:_loc4_,loader:new MovieClipLoader()};
   camera.scene.createEmptyMovieClip("initMC" + nextUserNum,camera.scene.getNextHighestDepth());
   camera.scene["initMC" + nextUserNum].onEnterFrame = function()
   {
      if(Users[login].char.loadingFinished)
      {
         Users[login].char.createMultiPlayer(Users[login].look);
         Users[login].char.login = login;
         Users[login].char.charName = charName;
         Users[login].char.userInfo = userInfo;
         Users[login].char.avatar.gotoAndStop(2);
         Users[login].char.gotoAndStop("start");
         Users[login].char._x = X;
         Users[login].char._y = Y;
         Users[login].char.Loaded = true;
         Users[login].char.stat = stat;
         if(stat != "none")
         {
            if(stat != "busy")
            {
               if(stat == "sudoku" || stat == "hoopshot" || stat == "skydive" || stat == "paintwar" || stat == "quizgame" || stat == "dotgame" || stat == "balloongame" || stat == "boggle" || stat == "kidcatcher" || stat == "hex")
               {
                  if(firstPlayer != undefined)
                  {
                     if(Users[firstPlayer].char._x < X)
                     {
                        Users[firstPlayer].char._xscale *= -1;
                        Users[firstPlayer].char._x -= 30;
                     }
                     else
                     {
                        Users[login].char._xscale *= -1;
                        Users[login].char._x -= 30;
                     }
                     _root.hideSay(Users[login].char);
                     _root.hideSay(Users[firstPlayer].char);
                     _root.showBattle(Users[login].char,Users[firstPlayer].char,stat);
                     Users[login].char.stat = stat;
                     Users[firstPlayer].char.stat = stat;
                     firstPlayer = null;
                  }
                  else
                  {
                     firstPlayer = login;
                  }
               }
            }
         }
         removeMovieClip(this);
      }
   };
   Users[login].loader.loadClip("char.swf",Users[login].char);
}
function removeUser(login)
{
   _root.hideSay(Users[login].char);
   Users[login].char.removeMovieClip();
   delete Users[login];
   var _loc3_ = camera.scene.char.avatar.loadLogin();
   if(_loc3_ == login)
   {
      multiplayer.MultiUserObjectManager.reset();
   }
}
function createRoomName(login1, login2)
{
   if(login1 < login2)
   {
      return login1 + "vs" + login2;
   }
   return login2 + "vs" + login1;
}
function getUserInfo()
{
   totWins = 0;
   totLosses = 0;
   scores = 0;
   var _loc4_ = 0;
   var _loc2_;
   var _loc3_;
   while(_loc4_ < _root.MMOGames.length)
   {
      _loc2_ = _root.camera.scene.char.avatar.FunBrain_so.data[_root.MMOGames[_loc4_] + "Wins"];
      _loc3_ = _root.camera.scene.char.avatar.FunBrain_so.data[_root.MMOGames[_loc4_] + "Losses"];
      if(_loc2_ != undefined || _loc3_ != undefined)
      {
         _loc2_ = _loc2_ != undefined ? parseInt(_loc2_) : 0;
         _loc3_ = _loc3_ != undefined ? parseInt(_loc3_) : 0;
         switch(_root.MMOGames[_loc4_])
         {
            case "skydive":
               _loc2_ *= 1;
               _loc3_ *= 1;
               break;
            case "hoopshot":
               _loc2_ *= 2;
               _loc3_ *= 2;
               break;
            case "sudoku":
               _loc2_ *= 3;
               _loc3_ *= 3;
               break;
            case "paintwar":
               _loc2_ *= 2;
               _loc3_ *= 2;
               break;
            case "quizgame":
               _loc2_ *= 2;
               _loc3_ *= 2;
               break;
            case "dotgame":
               _loc2_ *= 2;
               _loc3_ *= 2;
               break;
            case "balloongame":
               _loc2_ *= 2;
               _loc3_ *= 2;
               break;
            case "boggle":
               _loc2_ *= 2;
               _loc3_ *= 2;
               break;
            case "kidcatcher":
               _loc2_ *= 1;
               _loc3_ *= 1;
               break;
            case "hex":
               _loc2_ *= 2;
               _loc3_ *= 2;
         }
         if(_root.MMOGames[_loc4_] == "sudoku")
         {
            scores += 100 * _loc2_;
         }
         else
         {
            scores += 10 * _loc2_;
         }
         totWins += _loc2_;
         totLosses += _loc3_;
      }
      _loc4_ = _loc4_ + 1;
   }
   var _loc5_ = totWins + totLosses;
   var _loc6_ = Math.ceil(100 * (totWins + 8 / (_loc5_ + 1)) / (_loc5_ + 40 / (_loc5_ + 1))) / 100;
   if(isNaN(_loc6_))
   {
      _loc6_ = 0;
   }
   var _loc7_ = new Object();
   _loc7_.ranking = Math.round(_loc6_ * 100);
   _loc7_.points = scores;
   return _loc7_;
}
Users = new Array();
nextUserNum = 1;
nextUserDepth = 100;
server = new NetConnection();
server.addUser = function(login, look, X, Y, stat, charName, userInfo)
{
   trace("ADD user with Login: " + login + " Look: " + look + " coords(" + X + ":" + Y + ")" + " STATE: " + stat + " CHARNAME: " + charName);
   if(!X)
   {
      X = camera.scene.startX;
   }
   if(!Y)
   {
      Y = camera.scene.startY;
   }
   addUser(login,look,X,Y,stat,charName,userInfo);
};
server.removeUser = function(login)
{
   trace("remove user " + login);
   _root.hideSay(Users[login].char);
   removeUser(login);
};
server.moveTo = function(login, X, Y)
{
   if(!Users[login].char.Loaded)
   {
      return undefined;
   }
   if(Users[login].char.invitePlayer != undefined)
   {
      _root.hideSay(Users[Users[login].char.invitePlayer].char);
   }
   if(login == camera.scene.char.avatar.loadLogin())
   {
      _root.hideMenu();
      _root.hideChat();
   }
   if(!Users[login].char.trackingClip)
   {
      Users[login].char.clickTarget(X,Y);
   }
};
server.emotion = function(login, emotion)
{
   var _loc5_ = emotion.slice(1,emotion.length - 1);
   var _loc3_ = _loc5_.split(", ");
   if(Users[login].char.invitePlayer != undefined)
   {
      _root.hideSay(Users[Users[login].char.invitePlayer].char);
   }
   var _loc6_;
   var _loc7_;
   if(Users[login].char.Loaded && Users[login].char.avatar.avatarReady)
   {
      if(emotion == "specialAction")
      {
         Users[login].char.avatar.item.action();
         Users[login].char.avatar.head.action();
         Users[login].char.avatar.pack.action();
         Users[login].char.avatar.body.action();
         Users[login].char.avatar.hair.action();
      }
      else if(_loc3_[0] == "multiUserObjectAction")
      {
         _loc6_ = _loc3_[1];
         _loc7_ = _loc3_.slice(2);
         multiplayer.MultiUserObjectManager[_loc6_].apply(null,_loc7_);
      }
      else
      {
         Users[login].char.action(emotion);
      }
   }
};
server.say = function(login, phrase, quest_id)
{
   trace("Say LOGIN: " + login + " PHRASE: " + phrase + " QUEST_ID: " + quest_id);
   Users[login].char.stat = "none";
   if(Users[login].char.invitePlayer != undefined)
   {
      _root.hideSay(Users[Users[login].char.invitePlayer].char);
   }
   _root.showSay(Users[login].char,phrase);
   if(quest_id > -1)
   {
      _root.showChat(_root.camera.scene.char);
      _root.loadAnswers(quest_id);
   }
   else if(quest_id == -2)
   {
   }
};
server.actUser = function(login, target, action)
{
   trace("actUser LOGIN: " + login + " TARGET: " + target + " ACTION: " + action);
   if(login == camera.scene.char.avatar.loadLogin())
   {
      Users[login].char.actionMMO = action;
   }
   if(Users[login].char.invitePlayer != undefined)
   {
      _root.hideSay(Users[Users[login].char.invitePlayer].char);
   }
   _root.hideSay(Users[login].char);
   Users[login].char.targetHor = true;
   Users[login].char.targetVer = true;
   Users[login].char.tracking = true;
   if(action == "comeup")
   {
      Users[login].char.stat = "none";
      Users[login].char.charState = "stand";
      Users[login].char.targetPlayer = Users[target].char;
      Users[login].char.targetPlayer.engaged = false;
   }
   else if(action == "npcact")
   {
      Users[login].char.targetPlayer = camera.scene[target];
   }
};
server.changeInfo = function(sender, userInfo)
{
   trace("changeInfo SENDER: " + sender);
   for(var _loc2_ in userInfo)
   {
      trace("    [" + _loc2_ + "]: " + userInfo[_loc2_]);
   }
   Users[sender].char.userInfo = userInfo;
};
server.request = function(sender, what)
{
};
server.changeLook = function(sender, look)
{
   trace("changeLook SENDER: " + sender + " LOOK: " + look);
   if(sender != camera.scene.char.avatar.loadLogin())
   {
      Users[sender].char.avatar.setLook(look.split(","));
      Users[sender].char.avatar.setParts();
      Users[sender].char.action("pop");
   }
};
server.sendData = function(sender, sentData)
{
   trace("sendData SENDER: " + sender + " SENTDATA: " + sentData);
};
server.battleInvite = function(login, target, game)
{
   trace("battleInvite LOGIN: " + login + " TARGET: " + target + " GAME: " + game);
   _root.showSay(Users[login].char,"Do you want to play\nhead-to-head " + _root.MMOGamesNames[game] + "?");
   Users[target].char.invitePlayer = login;
   trace("invite " + Users[target].char.invitePlayer);
   if(target == camera.scene.char.avatar.loadLogin())
   {
      camera.scene.char.targetPlayer = Users[login].char;
      _root.showChat(camera.scene.char);
      _root.invited(_root.MMOGames[game]);
   }
};
server.battleStart = function(login, target, game)
{
   trace("battlePlay LOGIN: " + login + " TARGET: " + target + " GAME: " + game);
   Users[login].char.avatar.gotoAndPlay("stand");
   Users[target].char.avatar.gotoAndPlay("stand");
   _root.hideSay(Users[login].char);
   _root.hideSay(Users[target].char);
   _root.showBattle(Users[login].char,Users[target].char,game);
   Users[login].char.stat = game;
   Users[target].char.stat = game;
   var _loc6_ = camera.scene.char.avatar.loadLogin();
   var _loc2_;
   if(login == _loc6_ || target == _loc6_)
   {
      _root.game = game + ".swf";
      _root.gameRoom = createRoomName(login,target);
      _root.popup("gameLoader.swf",true);
      _loc2_ = 0;
      while(_loc2_ < _root.MMOGames.length)
      {
         if(_root.MMOGames[_loc2_] == game)
         {
            gameNum = _loc2_;
         }
         _loc2_ = _loc2_ + 1;
      }
      GameName = _root.MMOGamesNames[gameNum] + " Battle";
      EventToTrack = "Loaded";
      loadVariablesNum("/brain/track.php?cluster=" + _root.ClusterName + "&scene=" + _root.SceneName + "&game=" + GameName + "&event=" + EventToTrack + "&grade=" + _root.CharacterGrade + "&gender=" + _root.CharacterGender + "&lang=" + _root.CharacterLanguage + "&brain=Poptropica&randomNumber=" + random(10000),0);
   }
};
server.battleStop = function(login, target)
{
   trace("battleStop LOGIN: " + login + " TARGET: " + target);
   Users[login].char.stat = "none";
   Users[target].char.stat = "none";
   _root.hideSay(Users[login].char);
   _root.hideSay(Users[target].char);
};
server.changeStatus = function(login, stat)
{
   trace("CHANGE STATUS LOGIN: " + login + " STATUS: " + stat);
   if(Users[login].char.stat == stat)
   {
      return undefined;
   }
   if(stat == "thinking")
   {
      Users[login].char.action("think");
   }
   Users[login].char.stat = stat;
};
server.onStatus = function(info)
{
   trace(info.code);
   if(info.code == "NetConnection.Connect.Success")
   {
      _root.play();
   }
};
nextFrame();
