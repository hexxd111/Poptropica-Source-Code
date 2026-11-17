function getPrefix()
{
   if(_root.Settings.data.Prefix == undefined)
   {
      loadPrefix();
      return "";
   }
   return _root.Settings.data.Prefix;
}
function loadPrefix()
{
   var _loc4_ = new LoadVars();
   var _loc3_ = new LoadVars();
   _loc3_.onLoad = function()
   {
      if(this.prefix != undefined)
      {
         _root.Settings.data.lastPrefixUpdate = new Date();
         _root.Settings.data.Prefix = this.prefix;
      }
      else
      {
         _root.Settings.data.Prefix = "";
      }
      setTimeout(loadPrefix,1800000);
   };
   _loc4_.sendAndLoad("/getPrefix.php",_loc3_,"POST");
}
function checkPrefixUpdate()
{
   var _loc2_;
   if(_root.Settings.data.Prefix)
   {
      _loc2_ = new Date() - _root.Settings.data.lastPrefixUpdate;
      if(isNaN(_loc2_) || _loc2_ > 1800000)
      {
         loadPrefix();
      }
      else
      {
         setTimeout(loadPrefix,1800000 - _loc2_);
      }
   }
   else
   {
      loadPrefix();
   }
}
function loadMMOPrefix()
{
   var _loc4_ = new LoadVars();
   var _loc3_ = new LoadVars();
   _loc3_.onLoad = function()
   {
      if(this.prefix != undefined)
      {
         MMOprefix = this.prefix;
      }
      _root.nextFrame();
   };
   _loc4_.sendAndLoad("/getMMOPrefix.php",_loc3_,"POST");
}
function getMMOPrefix()
{
   return MMOprefix;
}
function bitOR(a, b)
{
   var _loc1_ = a & 1 | b & 1;
   var _loc2_ = a >>> 1 | b >>> 1;
   return _loc2_ << 1 | _loc1_;
}
function bitXOR(a, b)
{
   var _loc1_ = a & 1 ^ b & 1;
   var _loc2_ = a >>> 1 ^ b >>> 1;
   return _loc2_ << 1 | _loc1_;
}
function bitAND(a, b)
{
   var _loc1_ = a & 1 & (b & 1);
   var _loc2_ = a >>> 1 & b >>> 1;
   return _loc2_ << 1 | _loc1_;
}
function addme(x, y)
{
   var _loc1_ = (x & 0xFFFF) + (y & 0xFFFF);
   var _loc2_ = (x >> 16) + (y >> 16) + (_loc1_ >> 16);
   return _loc2_ << 16 | _loc1_ & 0xFFFF;
}
function rhex(num)
{
   str = "";
   j = 0;
   while(j <= 3)
   {
      str += hex_chr.charAt(num >> j * 8 + 4 & 0x0F) + hex_chr.charAt(num >> j * 8 & 0x0F);
      j++;
   }
   return str;
}
function str2blks_MD5(str)
{
   nblk = (str.length + 8 >> 6) + 1;
   blks = new Array(nblk * 16);
   i = 0;
   while(i < nblk * 16)
   {
      blks[i] = 0;
      i++;
   }
   i = 0;
   while(i < str.length)
   {
      blks[i >> 2] |= str.charCodeAt(i) << (str.length * 8 + i) % 4 * 8;
      i++;
   }
   blks[i >> 2] |= 128 << (str.length * 8 + i) % 4 * 8;
   var _loc2_ = str.length * 8;
   blks[nblk * 16 - 2] = _loc2_ & 0xFF;
   blks[nblk * 16 - 2] |= (_loc2_ >>> 8 & 0xFF) << 8;
   blks[nblk * 16 - 2] |= (_loc2_ >>> 16 & 0xFF) << 16;
   blks[nblk * 16 - 2] |= (_loc2_ >>> 24 & 0xFF) << 24;
   return blks;
}
function rol(num, cnt)
{
   return num << cnt | num >>> 32 - cnt;
}
function cmn(q, a, b, x, s, t)
{
   return addme(rol(addme(addme(a,q),addme(x,t)),s),b);
}
function ff(a, b, c, d, x, s, t)
{
   return cmn(bitOR(bitAND(b,c),bitAND(~b,d)),a,b,x,s,t);
}
function gg(a, b, c, d, x, s, t)
{
   return cmn(bitOR(bitAND(b,d),bitAND(c,~d)),a,b,x,s,t);
}
function hh(a, b, c, d, x, s, t)
{
   return cmn(bitXOR(bitXOR(b,c),d),a,b,x,s,t);
}
function ii(a, b, c, d, x, s, t)
{
   return cmn(bitXOR(c,bitOR(b,~d)),a,b,x,s,t);
}
function calcMD5(str)
{
   x = str2blks_MD5(str);
   a = 1732584193;
   b = -271733879;
   c = -1732584194;
   d = 271733878;
   var _loc1_;
   i = 0;
   while(i < x.length)
   {
      olda = a;
      oldb = b;
      oldc = c;
      oldd = d;
      _loc1_ = 0;
      a = ff(a,b,c,d,x[i + 0],7,-680876936);
      d = ff(d,a,b,c,x[i + 1],12,-389564586);
      c = ff(c,d,a,b,x[i + 2],17,606105819);
      b = ff(b,c,d,a,x[i + 3],22,-1044525330);
      a = ff(a,b,c,d,x[i + 4],7,-176418897);
      d = ff(d,a,b,c,x[i + 5],12,1200080426);
      c = ff(c,d,a,b,x[i + 6],17,-1473231341);
      b = ff(b,c,d,a,x[i + 7],22,-45705983);
      a = ff(a,b,c,d,x[i + 8],7,1770035416);
      d = ff(d,a,b,c,x[i + 9],12,-1958414417);
      c = ff(c,d,a,b,x[i + 10],17,-42063);
      b = ff(b,c,d,a,x[i + 11],22,-1990404162);
      a = ff(a,b,c,d,x[i + 12],7,1804603682);
      d = ff(d,a,b,c,x[i + 13],12,-40341101);
      c = ff(c,d,a,b,x[i + 14],17,-1502002290);
      b = ff(b,c,d,a,x[i + 15],22,1236535329);
      a = gg(a,b,c,d,x[i + 1],5,-165796510);
      d = gg(d,a,b,c,x[i + 6],9,-1069501632);
      c = gg(c,d,a,b,x[i + 11],14,643717713);
      b = gg(b,c,d,a,x[i + 0],20,-373897302);
      a = gg(a,b,c,d,x[i + 5],5,-701558691);
      d = gg(d,a,b,c,x[i + 10],9,38016083);
      c = gg(c,d,a,b,x[i + 15],14,-660478335);
      b = gg(b,c,d,a,x[i + 4],20,-405537848);
      a = gg(a,b,c,d,x[i + 9],5,568446438);
      d = gg(d,a,b,c,x[i + 14],9,-1019803690);
      c = gg(c,d,a,b,x[i + 3],14,-187363961);
      b = gg(b,c,d,a,x[i + 8],20,1163531501);
      a = gg(a,b,c,d,x[i + 13],5,-1444681467);
      d = gg(d,a,b,c,x[i + 2],9,-51403784);
      c = gg(c,d,a,b,x[i + 7],14,1735328473);
      b = gg(b,c,d,a,x[i + 12],20,-1926607734);
      a = hh(a,b,c,d,x[i + 5],4,-378558);
      d = hh(d,a,b,c,x[i + 8],11,-2022574463);
      c = hh(c,d,a,b,x[i + 11],16,1839030562);
      b = hh(b,c,d,a,x[i + 14],23,-35309556);
      a = hh(a,b,c,d,x[i + 1],4,-1530992060);
      d = hh(d,a,b,c,x[i + 4],11,1272893353);
      c = hh(c,d,a,b,x[i + 7],16,-155497632);
      b = hh(b,c,d,a,x[i + 10],23,-1094730640);
      a = hh(a,b,c,d,x[i + 13],4,681279174);
      d = hh(d,a,b,c,x[i + 0],11,-358537222);
      c = hh(c,d,a,b,x[i + 3],16,-722521979);
      b = hh(b,c,d,a,x[i + 6],23,76029189);
      a = hh(a,b,c,d,x[i + 9],4,-640364487);
      d = hh(d,a,b,c,x[i + 12],11,-421815835);
      c = hh(c,d,a,b,x[i + 15],16,530742520);
      b = hh(b,c,d,a,x[i + 2],23,-995338651);
      a = ii(a,b,c,d,x[i + 0],6,-198630844);
      d = ii(d,a,b,c,x[i + 7],10,1126891415);
      c = ii(c,d,a,b,x[i + 14],15,-1416354905);
      b = ii(b,c,d,a,x[i + 5],21,-57434055);
      a = ii(a,b,c,d,x[i + 12],6,1700485571);
      d = ii(d,a,b,c,x[i + 3],10,-1894986606);
      c = ii(c,d,a,b,x[i + 10],15,-1051523);
      b = ii(b,c,d,a,x[i + 1],21,-2054922799);
      a = ii(a,b,c,d,x[i + 8],6,1873313359);
      d = ii(d,a,b,c,x[i + 15],10,-30611744);
      c = ii(c,d,a,b,x[i + 6],15,-1560198380);
      b = ii(b,c,d,a,x[i + 13],21,1309151649);
      a = ii(a,b,c,d,x[i + 4],6,-145523070);
      d = ii(d,a,b,c,x[i + 11],10,-1120210379);
      c = ii(c,d,a,b,x[i + 2],15,718787259);
      b = ii(b,c,d,a,x[i + 9],21,-343485551);
      a = addme(a,olda);
      b = addme(b,oldb);
      c = addme(c,oldc);
      d = addme(d,oldd);
      i += 16;
   }
   return rhex(a) + rhex(b) + rhex(c) + rhex(d);
}
function hex_md5(s)
{
   return binl2hex(core_md5(str2binl(s),s.length * chrsz));
}
function b64_md5(s)
{
   return binl2b64(core_md5(str2binl(s),s.length * chrsz));
}
function str_md5(s)
{
   return binl2str(core_md5(str2binl(s),s.length * chrsz));
}
function hex_hmac_md5(key, data)
{
   return binl2hex(core_hmac_md5(key,data));
}
function b64_hmac_md5(key, data)
{
   return binl2b64(core_hmac_md5(key,data));
}
function str_hmac_md5(key, data)
{
   return binl2str(core_hmac_md5(key,data));
}
function md5_vm_test()
{
   return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
}
function core_md5(x, len)
{
   x[len >> 5] |= 128 << len % 32;
   x[(len + 64 >>> 9 << 4) + 14] = len;
   var _loc4_ = 1732584193;
   var _loc3_ = -271733879;
   var _loc2_ = -1732584194;
   var _loc1_ = 271733878;
   var _loc5_ = 0;
   var _loc10_;
   var _loc9_;
   var _loc8_;
   var _loc7_;
   while(_loc5_ < x.length)
   {
      _loc10_ = _loc4_;
      _loc9_ = _loc3_;
      _loc8_ = _loc2_;
      _loc7_ = _loc1_;
      _loc4_ = md5_ff(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 0],7,-680876936);
      _loc1_ = md5_ff(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 1],12,-389564586);
      _loc2_ = md5_ff(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 2],17,606105819);
      _loc3_ = md5_ff(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 3],22,-1044525330);
      _loc4_ = md5_ff(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 4],7,-176418897);
      _loc1_ = md5_ff(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 5],12,1200080426);
      _loc2_ = md5_ff(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 6],17,-1473231341);
      _loc3_ = md5_ff(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 7],22,-45705983);
      _loc4_ = md5_ff(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 8],7,1770035416);
      _loc1_ = md5_ff(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 9],12,-1958414417);
      _loc2_ = md5_ff(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 10],17,-42063);
      _loc3_ = md5_ff(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 11],22,-1990404162);
      _loc4_ = md5_ff(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 12],7,1804603682);
      _loc1_ = md5_ff(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 13],12,-40341101);
      _loc2_ = md5_ff(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 14],17,-1502002290);
      _loc3_ = md5_ff(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 15],22,1236535329);
      _loc4_ = md5_gg(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 1],5,-165796510);
      _loc1_ = md5_gg(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 6],9,-1069501632);
      _loc2_ = md5_gg(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 11],14,643717713);
      _loc3_ = md5_gg(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 0],20,-373897302);
      _loc4_ = md5_gg(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 5],5,-701558691);
      _loc1_ = md5_gg(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 10],9,38016083);
      _loc2_ = md5_gg(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 15],14,-660478335);
      _loc3_ = md5_gg(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 4],20,-405537848);
      _loc4_ = md5_gg(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 9],5,568446438);
      _loc1_ = md5_gg(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 14],9,-1019803690);
      _loc2_ = md5_gg(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 3],14,-187363961);
      _loc3_ = md5_gg(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 8],20,1163531501);
      _loc4_ = md5_gg(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 13],5,-1444681467);
      _loc1_ = md5_gg(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 2],9,-51403784);
      _loc2_ = md5_gg(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 7],14,1735328473);
      _loc3_ = md5_gg(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 12],20,-1926607734);
      _loc4_ = md5_hh(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 5],4,-378558);
      _loc1_ = md5_hh(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 8],11,-2022574463);
      _loc2_ = md5_hh(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 11],16,1839030562);
      _loc3_ = md5_hh(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 14],23,-35309556);
      _loc4_ = md5_hh(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 1],4,-1530992060);
      _loc1_ = md5_hh(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 4],11,1272893353);
      _loc2_ = md5_hh(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 7],16,-155497632);
      _loc3_ = md5_hh(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 10],23,-1094730640);
      _loc4_ = md5_hh(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 13],4,681279174);
      _loc1_ = md5_hh(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 0],11,-358537222);
      _loc2_ = md5_hh(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 3],16,-722521979);
      _loc3_ = md5_hh(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 6],23,76029189);
      _loc4_ = md5_hh(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 9],4,-640364487);
      _loc1_ = md5_hh(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 12],11,-421815835);
      _loc2_ = md5_hh(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 15],16,530742520);
      _loc3_ = md5_hh(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 2],23,-995338651);
      _loc4_ = md5_ii(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 0],6,-198630844);
      _loc1_ = md5_ii(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 7],10,1126891415);
      _loc2_ = md5_ii(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 14],15,-1416354905);
      _loc3_ = md5_ii(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 5],21,-57434055);
      _loc4_ = md5_ii(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 12],6,1700485571);
      _loc1_ = md5_ii(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 3],10,-1894986606);
      _loc2_ = md5_ii(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 10],15,-1051523);
      _loc3_ = md5_ii(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 1],21,-2054922799);
      _loc4_ = md5_ii(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 8],6,1873313359);
      _loc1_ = md5_ii(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 15],10,-30611744);
      _loc2_ = md5_ii(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 6],15,-1560198380);
      _loc3_ = md5_ii(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 13],21,1309151649);
      _loc4_ = md5_ii(_loc4_,_loc3_,_loc2_,_loc1_,x[_loc5_ + 4],6,-145523070);
      _loc1_ = md5_ii(_loc1_,_loc4_,_loc3_,_loc2_,x[_loc5_ + 11],10,-1120210379);
      _loc2_ = md5_ii(_loc2_,_loc1_,_loc4_,_loc3_,x[_loc5_ + 2],15,718787259);
      _loc3_ = md5_ii(_loc3_,_loc2_,_loc1_,_loc4_,x[_loc5_ + 9],21,-343485551);
      _loc4_ = safe_add(_loc4_,_loc10_);
      _loc3_ = safe_add(_loc3_,_loc9_);
      _loc2_ = safe_add(_loc2_,_loc8_);
      _loc1_ = safe_add(_loc1_,_loc7_);
      _loc5_ += 16;
   }
   return Array(_loc4_,_loc3_,_loc2_,_loc1_);
}
function md5_cmn(q, a, b, x, s, t)
{
   return safe_add(bit_rol(safe_add(safe_add(a,q),safe_add(x,t)),s),b);
}
function md5_ff(a, b, c, d, x, s, t)
{
   return md5_cmn(b & c | (~b) & d,a,b,x,s,t);
}
function md5_gg(a, b, c, d, x, s, t)
{
   return md5_cmn(b & d | c & (~d),a,b,x,s,t);
}
function md5_hh(a, b, c, d, x, s, t)
{
   return md5_cmn(b ^ c ^ d,a,b,x,s,t);
}
function md5_ii(a, b, c, d, x, s, t)
{
   return md5_cmn(c ^ (b | ~d),a,b,x,s,t);
}
function core_hmac_md5(key, data)
{
   var _loc2_ = str2binl(key);
   if(_loc2_.length > 16)
   {
      _loc2_ = core_md5(_loc2_,key.length * chrsz);
   }
   var _loc3_ = Array(16);
   var _loc4_ = Array(16);
   var _loc1_ = 0;
   while(_loc1_ < 16)
   {
      _loc3_[_loc1_] = _loc2_[_loc1_] ^ 0x36363636;
      _loc4_[_loc1_] = _loc2_[_loc1_] ^ 0x5C5C5C5C;
      _loc1_ = _loc1_ + 1;
   }
   var _loc5_ = core_md5(_loc3_.concat(str2binl(data)),512 + data.length * chrsz);
   return core_md5(_loc4_.concat(_loc5_),640);
}
function safe_add(x, y)
{
   var _loc1_ = (x & 0xFFFF) + (y & 0xFFFF);
   var _loc2_ = (x >> 16) + (y >> 16) + (_loc1_ >> 16);
   return _loc2_ << 16 | _loc1_ & 0xFFFF;
}
function bit_rol(num, cnt)
{
   return num << cnt | num >>> 32 - cnt;
}
function str2binl(str)
{
   var _loc3_ = Array();
   var _loc4_ = (1 << chrsz) - 1;
   var _loc1_ = 0;
   while(_loc1_ < str.length * chrsz)
   {
      _loc3_[_loc1_ >> 5] |= (str.charCodeAt(_loc1_ / chrsz) & _loc4_) << _loc1_ % 32;
      _loc1_ += chrsz;
   }
   return _loc3_;
}
function binl2str(bin)
{
   var _loc3_ = "";
   var _loc4_ = (1 << chrsz) - 1;
   var _loc1_ = 0;
   while(_loc1_ < bin.length * 32)
   {
      _loc3_ += String.fromCharCode(bin[_loc1_ >> 5] >>> _loc1_ % 32 & _loc4_);
      _loc1_ += chrsz;
   }
   return _loc3_;
}
function binl2hex(binarray)
{
   var _loc3_ = !hexcase ? "0123456789abcdef" : "0123456789ABCDEF";
   var _loc4_ = "";
   var _loc1_ = 0;
   while(_loc1_ < binarray.length * 4)
   {
      _loc4_ += _loc3_.charAt(binarray[_loc1_ >> 2] >> _loc1_ % 4 * 8 + 4 & 0x0F) + _loc3_.charAt(binarray[_loc1_ >> 2] >> _loc1_ % 4 * 8 & 0x0F);
      _loc1_ = _loc1_ + 1;
   }
   return _loc4_;
}
function binl2b64(binarray)
{
   var _loc6_ = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
   var _loc4_ = "";
   var _loc2_ = 0;
   var _loc5_;
   var _loc1_;
   while(_loc2_ < binarray.length * 4)
   {
      _loc5_ = (binarray[_loc2_ >> 2] >> 8 * (_loc2_ % 4) & 0xFF) << 16 | (binarray[_loc2_ + 1 >> 2] >> 8 * ((_loc2_ + 1) % 4) & 0xFF) << 8 | binarray[_loc2_ + 2 >> 2] >> 8 * ((_loc2_ + 2) % 4) & 0xFF;
      _loc1_ = 0;
      while(_loc1_ < 4)
      {
         if(_loc2_ * 8 + _loc1_ * 6 > binarray.length * 32)
         {
            _loc4_ += b64pad;
         }
         else
         {
            _loc4_ += _loc6_.charAt(_loc5_ >> 6 * (3 - _loc1_) & 0x3F);
         }
         _loc1_ = _loc1_ + 1;
      }
      _loc2_ += 3;
   }
   return _loc4_;
}
function initTraceSO(grantAccess)
{
   _root.traceSO = SharedObject.getLocal("trace","/");
   if(_root.traceSO.data.debugAccess == true || grantAccess)
   {
      _root.traceSO.data.debugAccess = true;
      _root.debugAccess = true;
      if(_root.traceSO.data.commandHistory == undefined)
      {
         _root.traceSO.data.commandHistory = new Array();
         _root.traceSO.data.historyIndex = 0;
         _root.traceSO.data.trcVisible = false;
         _root.traceSO.data.devVisible = false;
         _root.traceSO.data.trcLoading = false;
      }
   }
   _root.traceSO.flush();
}
function trc(msg)
{
   var _loc3_;
   if(!_root.trace_txt)
   {
      _loc3_ = new TextFormat();
      _loc3_.color = 65280;
      _root.trace_txt = this.createTextField("trace_txt",10000000,1,1,400,200);
      _root.trace_txt.border = true;
      _root.trace_txt.background = true;
      _root.trace_txt.backgroundColor = 16777215;
      _root.trace_txt.setTextFormat(_loc3_);
      _root.trace_txt._visible = _root.traceSO.data.trcVisible != undefined ? _root.traceSO.data.trcVisible : false;
   }
   else
   {
      _root.trace_txt.text += msg + "\n";
      _root.trace_txt.scroll = _root.trace_txt.maxscroll;
      _proxy.proxySend("traceMethod",substr,String(msg));
   }
}
function mkConsole()
{
   var _loc3_ = this.createTextField("dev_console",9999999,125,stageHeight - 30,400,20);
   _loc3_.type = "input";
   _loc3_.border = true;
   _loc3_.background = true;
   _loc3_.multiline = true;
   Selection.setFocus(_loc3_);
   _loc3_._visible = _root.traceSO.data.devVisible != undefined ? _root.traceSO.data.devVisible : false;
   var me = this;
   _loc3_.oldText = "";
   _loc3_.onChanged = function(tf)
   {
      if(this.text.indexOf("\r") != -1)
      {
         me.parseCmd(this.oldText);
         this.text = "";
      }
      this.oldText = this.text;
   };
}
function parseCmd(cmd)
{
   _root.traceSO.data.commandHistory.push(cmd);
   _root.traceSO.flush();
   _root.traceSO.data.historyIndex = _root.traceSO.data.commandHistory.length;
   var a = cmd.split(" ");
   for(i in a)
   {
      switch(a[i])
      {
         case "true":
            a[i] = true;
            break;
         case "false":
            a[i] = false;
      }
   }
   var cmd1 = a.shift();
   if(hex_md5(cmd1) == "aae3be1ef0e0e77f173405eb84ef8570")
   {
      _root.debugAccess = true;
      initTraceSO(true);
   }
   if(_root.debugAccess)
   {
      switch(cmd1)
      {
         case "soar":
            if(!_root.camera.scene.char.soaring)
            {
               _root.camera.scene.char.soaring = true;
            }
            else
            {
               _root.camera.scene.char.soaring = false;
            }
            return;
         case "loadScene":
            var scene = a.shift();
            var island = a.shift();
            if(scene)
            {
               if(island)
               {
                  _root.camera.scene.char.loadScene(scene,100,400,island);
               }
               else
               {
                  _root.camera.scene.char.loadScene(scene,100,400);
               }
            }
            return;
         case "getItem":
            var item = a.shift();
            var itemNum = Number(item);
            if(item > 0)
            {
               _root.camera.scene.char.avatar.getItem(itemNum);
            }
            return;
         case "deleteItem":
            var item = a.shift();
            var itemNum = Number(item);
            _root.camera.scene.char.avatar.deleteItem(itemNum);
            return;
         case "checkEvent":
            var event = a.shift();
            var eventName = String(event);
            _root.trc(!_root.camera.scene.char.avatar.checkEvent(eventName) ? eventName + "false\n" : eventName + " true\n");
            return;
         case "deleteEvent":
            var event = a.shift();
            var eventName = String(event);
            _root.camera.scene.char.avatar.deleteEvent(eventName);
            return;
         case "completeEvent":
            var event = a.shift();
            var eventName = String(event);
            if(event)
            {
               _root.camera.scene.char.avatar.completeEvent(eventName);
            }
            return;
         case "createNewPlayer":
            _root.camera.scene.char.createNewPlayer();
            return;
         case "trace":
            var path = a.shift().split(".");
            var trcObj = _root;
            var i = 0;
            while(i < path.length)
            {
               trcObj = trcObj[path[i]];
               i++;
            }
            _root.trc(trcObj);
            return;
         case "clear":
            _root.trace_txt.text = "";
            return;
         case "clearHistory":
            delete _root.traceSO.data.commandHistory;
            _root.traceSO.data.commandHistory = new Array();
            _root.traceSO.data.historyIndex = 0;
            _root.traceSO.flush();
            return;
         case "traceHistory":
            for(var i in _root.traceSO.data.commandHistory)
            {
               _root.trc(i + " => " + _root.traceSO.data.commandHistory[i]);
            }
            return;
         case "traceReturn":
            for(var i in _root.consoleReturnVal)
            {
               _root.trc(i + " => " + _root.consoleReturnVal[i]);
            }
            return;
         case "traceLoading":
            _root.traceSO.data.trcLoading = !_root.traceSO.data.trcLoading;
            return;
         case "loadFPS":
            com.lifeztream.debug.FPS.start(31,"right");
            return;
         case "closeFPS":
            com.lifeztream.debug.FPS.stop();
            return;
         case "login":
            var username = a.shift();
            var passhash = a.shift();
            tryLogin(username,passhash);
            return;
         default:
            var obj = eval(cmd1);
            if(obj == null)
            {
               return undefined;
            }
            var varStr = String(a.shift());
            if(obj[varStr] instanceof Function)
            {
               delete _root.consoleReturnVal;
               _root.consoleReturnVal = new Object();
               var func = obj[varStr];
               _root.consoleReturnVal[varStr] = func.apply(obj,a);
               return;
            }
            var v = a.shift();
            if(isNaN(v) != true)
            {
               obj[varStr] = Number(v);
               return;
            }
            obj[varStr] = v;
            return;
      }
   }
}
function tryLogin(username, hash)
{
   var _loc3_ = new LoadVars();
   var _loc4_ = new LoadVars();
   _root.takeClick._visible = true;
   _loc4_.onLoad = function()
   {
      if(this.answer == "ok")
      {
         doLogin(this,hash);
      }
      else
      {
         _root.takeClick._visible = false;
         getURL("javascript:alert(\'Bad username/password hash combination!\')");
      }
   };
   _loc3_.login = username;
   _loc3_.pass_hash = hash;
   _loc3_.sendAndLoad(_root.getPrefix() + "/login.php",_loc4_,"POST");
}
function doLogin(receiver, hash)
{
   var _loc3_ = SharedObject.getLocal("Char","/");
   var _loc5_;
   if(receiver.json)
   {
      _loc5_ = jsonLib.parse(receiver.json);
   }
   var _loc7_ = _loc5_.look.split(",");
   _root.camera.scene.char.avatar.gotoAndStop(1);
   _root.camera.scene.char.avatar.saveLook(_loc7_);
   _root.camera.scene.char.avatar.nextFrame();
   _root.camera.scene.char.avatar.saveLogin(_loc5_.login);
   _loc3_.data.password = hash;
   lastIsland = _loc5_.island;
   lastRoom = _loc5_.last_room;
   if(lastRoom == undefined || lastRoom == "")
   {
      lastIsland = "Early";
      lastRoom = "City2";
   }
   else
   {
      _loc3_.data[lastRoom + "xPos"] = _loc5_.lastx;
      _loc3_.data[lastRoom + "yPos"] = _loc5_.lasty;
   }
   _root.camera.scene.char.avatar.saveVisited(_loc5_.map);
   _root.camera.scene.char.avatar.saveGames(_loc5_.games);
   _loc3_.data.firstName = _loc5_.firstname;
   _loc3_.data.lastName = _loc5_.lastname;
   _loc3_.data.age = _loc5_.age;
   var _loc6_ = _loc5_.scores.split("*");
   var _loc4_ = 0;
   var _loc2_;
   while(_loc4_ < _loc6_.length)
   {
      _loc2_ = _loc6_[_loc4_].split(";");
      _loc3_.data[_loc2_[0] + "Score"] = _loc2_[1];
      _loc3_.data[_loc2_[0] + "Wins"] = _loc2_[2];
      _loc3_.data[_loc2_[0] + "Losses"] = _loc2_[3];
      _loc4_ = _loc4_ + 1;
   }
   _loc3_.data.mem_status = _loc5_.memstatus;
   _loc3_.data.mem_date = _loc5_.memdate;
   _loc3_.data.mem_timestamp = new Date().getTime();
   if(_loc5_.userData)
   {
      _loc3_.data.userData = jsonLib.parse(unescape(_loc5_.userData));
   }
   _loc3_.data.pickedItems = _loc5_.pickedItems;
   if(_loc3_.data.pickedItems == undefined)
   {
      _loc3_.data.pickedItems = "";
   }
   _loc3_.data.Registred = true;
   _loc3_.data.dbid = _loc5_.dbid;
   _root.camera.scene.char.avatar.saveCredits(_loc5_.credits);
   _root.camera.scene.char.avatar.saveCreditChange(_loc5_.credit_change);
   _root.camera.scene.char.avatar.saveRecent(_loc5_.recent);
   _root.createEmptyMovieClip("exit",1);
   _root.exit.room = lastRoom;
   _root.exit.island = lastIsland;
   _root.exit.startup_path = "home";
   EventToTrack = "LoginCompleted";
   CharacterGrade = _loc5_.age - 5;
   if(_loc3_.data.gender == 0)
   {
      CharacterGender = "F";
   }
   else
   {
      CharacterGender = "M";
   }
   _loc3_.data.parentEmail = _loc5_.parent_email;
   _loc3_.data.parentEmailStatus = _loc5_.has_parent_email;
   _loc3_.data.dbid = _loc5_.dbid;
   _loc3_.data.flush();
   loadBase();
}
function loadBase()
{
   if(utils.Utils.isNull(_root.exit.island))
   {
      trace("perf : island is null!  Setting default island of early...");
      _root.exit.island = "Early";
   }
   trace("perf : loadBase : " + _root.exit.island);
   _root.camera.scene.char.avatar.updateIslandData(_root.exit.island,Delegate.create(this,loadBaseInternal));
}
function loadBaseInternal()
{
   _root.exit.getURL("base.php","_self","POST");
}
function getFlashPrefix()
{
   var _loc3_;
   var _loc2_;
   if(_root.flashPrefix == undefined)
   {
      _loc3_ = new LocalConnection();
      _loc2_ = _loc3_.domain();
      if(_loc2_ == "localhost" || _loc2_ == "feta.fen.com")
      {
         _root.flashPrefix = "";
      }
      else
      {
         _root.flashPrefix = "http://" + _loc2_ + "/";
      }
      if(showTraces)
      {
         trc("Prefix: " + _root.flashPrefix);
      }
   }
   return _root.flashPrefix;
}
function wrapLoadClip()
{
   var baseLoadClip = MovieClipLoader.prototype.loadClip;
   var prefix = _root.getFlashPrefix();
   MovieClipLoader.prototype.loadClip = function(uri, tgt)
   {
      if(uri.indexOf("http://") != 0 && uri.indexOf("https://") != 0)
      {
         uri = prefix + uri;
      }
      if(showTraces)
      {
         trc("loadClip(\"" + uri + "\")");
      }
      return baseLoadClip.call(this,uri,tgt);
   };
}
function wrapLoadMovie()
{
   var prefix = _root.getFlashPrefix();
   MovieClip.prototype.loadMovie = function(uri)
   {
      if(uri.indexOf("http://") != 0 && uri.indexOf("https://") != 0)
      {
         uri = prefix + uri;
      }
      if(showTraces)
      {
         trc(typeof this + ".loadMovie(\"" + arguments.toString() + "\")");
      }
      try
      {
         if(arguments.length == 1)
         {
            loadMovie(uri,this);
         }
         else if(showTraces)
         {
            trc("loadMovie called with " + arguments.length + " arguments, ignored");
         }
      }
      catch(e:Error)
      {
         if(showTraces)
         {
            trc("loadMovie raised exception: " + e.message);
         }
      }
      if(showTraces)
      {
         trc("loadMovie returned");
      }
   };
}
function convertToBitmap(vectorArt, useSmoothing)
{
   if(useSmoothing == undefined)
   {
      useSmoothing = false;
   }
   var _loc6_ = vectorArt._name;
   var _loc8_ = vectorArt._rotation;
   var _loc10_ = vectorArt._xscale;
   var _loc9_ = vectorArt._yscale;
   var _loc3_ = 2;
   vectorArt._rotation = 0;
   vectorArt._xscale = vectorArt._yscale = 100;
   vectorArt._name += "VectorArt";
   var _loc5_ = new flash.geom.Matrix();
   _loc5_.translate(_loc3_,_loc3_);
   var _loc4_ = new flash.display.BitmapData(vectorArt._width + _loc3_ * 2,vectorArt._height + _loc3_ * 2,true,16777215);
   var _loc2_ = vectorArt._parent.createEmptyMovieClip(_loc6_,vectorArt._parent.getNextHighestDepth());
   _loc2_.createEmptyMovieClip("bitmapClip",_loc2_.getNextHighestDepth());
   _loc2_.bitmapClip.attachBitmap(_loc4_,1,"auto",useSmoothing);
   _loc2_.bitmapClip._x = - _loc3_;
   _loc2_.bitmapClip._y = - _loc3_;
   _loc4_.draw(vectorArt,_loc5_);
   _loc2_._x = vectorArt._x;
   _loc2_._y = vectorArt._y;
   _loc2_._rotation = _loc8_;
   _loc2_._xscale = _loc10_;
   _loc2_._yscale = _loc9_;
   _loc2_.swapDepths(vectorArt);
   vectorArt._visible = false;
   vectorArt.removeMovieClip();
}
function makeForeground(source_mc, base, bg, rightLim, downLim)
{
   if(!base)
   {
      base = camera.scene;
   }
   if(!source_mc)
   {
      source_mc = base.fgVector;
   }
   if(!fg)
   {
      fg = base.fg;
   }
   if(!rightLim)
   {
      rightLim = base.rightLimit;
   }
   if(!downLim)
   {
      downLim = base.downLimit;
   }
   makeBitmap(source_mc,base,fg,rightLim,downLim,true,1286142);
}
function makeBackground(source_mc, base, bg, rightLim, downLim)
{
   if(!base)
   {
      base = camera.scene;
   }
   if(!source_mc)
   {
      source_mc = base.bgVector;
   }
   if(!bg)
   {
      bg = base.bg;
   }
   if(!rightLim)
   {
      rightLim = base.rightLimit;
   }
   if(!downLim)
   {
      downLim = base.downLimit;
   }
   makeBitmap(source_mc,base,bg,rightLim,downLim,true,1286142);
}
function makeBackdrop(source_mc, base, bd, rightLim, downLim)
{
   if(!base)
   {
      base = camera.scene;
   }
   if(!source_mc)
   {
      source_mc = base.bdVector;
   }
   if(!bd)
   {
      bd = base.bd;
   }
   if(!rightLim)
   {
      rightLim = base.rightLimit;
   }
   if(!downLim)
   {
      downLim = base.downLimit;
   }
   makeBitmap(source_mc,base,bd,rightLim,downLim,false,4279476222,_root.bdScale);
}
function makeBitmap(source_mc, base, cont, mc_width, mc_height, transparent, fill, scale)
{
   if(!scale)
   {
      scale = 1;
   }
   var _loc9_ = Math.ceil(mc_width / 2800);
   var _loc10_ = Math.ceil(mc_height / 2800);
   var _loc5_ = Math.ceil(mc_width / _loc9_);
   var _loc6_ = Math.ceil(mc_height / _loc10_);
   var _loc4_ = new flash.geom.Matrix();
   _loc4_.scale(scale,scale);
   var _loc7_;
   var _loc3_;
   var _loc2_ = 0;
   var _loc1_;
   var _loc0_;
   while(_loc2_ < _loc9_)
   {
      _loc1_ = 0;
      while(_loc1_ < _loc10_)
      {
         _loc7_ = base["bm" + _loc2_ + "_" + _loc1_] = new flash.display.BitmapData(_loc5_,_loc6_,transparent,fill);
         _loc3_ = cont.createEmptyMovieClip("mc" + _loc2_ + "_" + _loc1_,_loc2_ + _loc1_ * _loc9_);
         _loc3_.attachBitmap(_loc7_,1,"auto",base.useSmoothing);
         _loc4_.tx = (- _loc2_) * _loc5_;
         _loc4_.ty = (- _loc1_) * _loc6_;
         _loc7_.draw(source_mc,_loc4_);
         _loc3_._x = _loc2_ * _loc5_ - _loc2_;
         _loc3_._y = _loc1_ * _loc6_ - _loc1_;
         _loc1_ = _loc1_ + 1;
      }
      _loc2_ = _loc2_ + 1;
   }
   source_mc._visible = false;
}
function useArrow()
{
   com.poptropica.util.Debug.trace("  gameplay::frame1::useArrow ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   _popController.setPointerDisplay("click");
}
function saveGame()
{
   com.poptropica.util.Debug.trace("  gameplay::frame1::saveGame ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   if(camera.scene.red5)
   {
      if(server)
      {
         server.call("changeStatus",null,"busy");
      }
   }
   if(navBar.btnSave.saved)
   {
      trackEvent("LogoutClicked");
      createEmptyMovieClip("popupClip2",popup2Depth);
      popupClip2.loadMovie("popups/logout.swf");
   }
   else
   {
      createEmptyMovieClip("popupClip2",popup2Depth);
      popupClip2.loadMovie("popups/register.swf");
   }
}
function doActiveCardAction()
{
   com.poptropica.util.Debug.trace("  gameplay::frame1::doActiveCardAction ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   trace("  gameplay::frame1::doActiveCardAction");
   trace("  _popModel.rt_mc=" + _popModel.rt_mc);
   trace("  _popModel.rt_mc.section=" + _popModel.rt_mc.section);
   trace("  _popModel.rt_mc.section.doActiveCardAction=" + _popModel.rt_mc.section.doActiveCardAction);
   if(_popModel.rt_mc.section && _popModel.rt_mc.section.doActiveCardAction)
   {
      _popModel.rt_mc.section.doActiveCardAction();
   }
}
function updateLatestGameplayBitmap()
{
   com.poptropica.util.Debug.trace("  gameplay::frame1::updateLatestGameplayBitmap ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   if(_root.camera.scene.getReturnToGameBitmap)
   {
      _popModel.latest_gameplay_bm = _root.camera.scene.getReturnToGameBitmap();
      return undefined;
   }
   var _loc3_ = 370;
   var _loc4_ = 210;
   var _loc7_ = 60;
   var _loc10_ = camera.scene.char._x;
   var _loc11_ = camera.scene.char._y;
   var _loc5_ = - _loc10_ + _loc3_ / 2;
   var _loc6_ = - _loc11_ + _loc4_ / 2 + _loc7_;
   var _loc2_;
   if(camera.scene.scaleFactor)
   {
      _loc2_ = 1 / camera.scene.scaleFactor;
   }
   else
   {
      _loc2_ = 1;
   }
   if(_root.camera.scene.char._x - _loc3_ / 2 < _root.camera.scene.leftLimit * _loc2_)
   {
      _loc5_ = _loc5_ - _loc3_ / 2 + (_root.camera.scene.char._x - _root.camera.scene.leftLimit * _loc2_);
   }
   if(_root.camera.scene.char._x + _loc3_ / 2 > _root.camera.scene.rightLimit * _loc2_)
   {
      _loc5_ -= _root.camera.scene.rightLimit * _loc2_ - (_root.camera.scene.char._x + _loc3_ / 2);
   }
   if(_root.camera.scene.char._y - _loc4_ / 2 - _loc7_ < _root.camera.scene.upLimit * _loc2_)
   {
      _loc6_ = _loc6_ - _loc4_ / 2 - _loc7_ + (_root.camera.scene.char._y - _root.camera.scene.upLimit * _loc2_);
   }
   if(_root.camera.scene.char._y + _loc4_ / 2 - _loc7_ > _root.camera.scene.downLimit * _loc2_)
   {
      _loc6_ -= _root.camera.scene.downLimit * _loc2_ - (_root.camera.scene.char._y + _loc4_ / 2 - _loc7_);
   }
   var _loc8_ = new flash.geom.Matrix();
   _loc8_.translate(_loc5_,_loc6_);
   var _loc9_ = new flash.display.BitmapData(_loc3_,_loc4_,false,4294967295);
   _loc9_.draw(camera.scene,_loc8_);
   _popModel.latest_gameplay_bm = _loc9_.clone();
}
function loadStoreItems(usr, msg)
{
   var so = _root.camera.scene.char.avatar.FunBrain_so;
   if(so.data.costumeInfo != null)
   {
      msg.call(usr,so.data.costumeInfo,so.data.cardInfo);
      return undefined;
   }
   var _loc5_ = new LoadVars();
   _loc5_.onLoad = function()
   {
      var _loc3_ = new asLib.JSON();
      var _loc2_ = _loc3_.parse(this.items_info);
      so.data.cardInfo = _loc2_["2001"];
      so.data.costumeInfo = _loc2_["2002"];
      msg.call(usr,so.data.costumeInfo,so.data.cardInfo);
   };
   var _loc3_ = new LoadVars();
   _loc3_.cats = "2001|2002";
   _loc3_.v = "2";
   _loc3_.gender = _root.camera.scene.char.avatar.FunBrain_so.data.gender != 1 ? "F" : "M";
   _loc3_.sendAndLoad(_root.getPrefix() + "/list_redeemable_items.php",_loc5_,"POST");
}
function loadSceneChars(char_cnt)
{
   var numChars = char_cnt + 1;
   var Chars = new Array();
   Chars.push(camera.scene.char);
   var _loc4_ = new MovieClipLoader();
   _loc4_.loadClip("char.swf",camera.scene.char);
   var _loc3_;
   var _loc2_ = 1;
   while(_loc2_ < numChars)
   {
      _loc3_ = camera.scene["char" + _loc2_];
      Chars.push(_loc3_);
      if(_loc3_.isCreature)
      {
         _loc4_.loadClip("creature.swf",_loc3_);
      }
      else
      {
         _loc4_.loadClip("char.swf",_loc3_);
      }
      _loc2_ = _loc2_ + 1;
   }
   this.createEmptyMovieClip("loadCheck",getNextHighestDepth());
   loadCheck.onEnterFrame = function()
   {
      var _loc2_ = 0;
      while(_loc2_ < Chars.length)
      {
         if(Chars[_loc2_].loadingFinished)
         {
            Chars[_loc2_] = null;
            numChars--;
         }
         _loc2_ = _loc2_ + 1;
      }
      if(numChars == 0)
      {
         delete this.onEnterFrame;
         camera.scene.initChars();
         this.removeMovieClip();
      }
   };
}
function stopAllEnterFrameEvents(container, init, eventArray)
{
   var _loc2_;
   var _loc1_;
   if(container)
   {
      if(init)
      {
         gEnterFrameEvents[container] = new Array();
         eventArray = gEnterFrameEvents[container];
      }
      for(var _loc5_ in container)
      {
         _loc1_ = container[_loc5_];
         if(typeof _loc1_ == "movieclip" && _loc1_._parent == container)
         {
            if(_loc1_.onEnterFrame)
            {
               _loc2_ = new Object();
               _loc2_.clip = _loc1_;
               _loc2_.event = _loc1_.onEnterFrame;
               eventArray.push(_loc2_);
               if(_loc1_._name.indexOf("__tweener_controller__") > -1)
               {
                  com.poptropica.util.Debug.trace("GamePlay :: Pausing Tweener : " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
                  caurina.transitions.Tweener.pauseAllTweens();
               }
               else
               {
                  com.poptropica.util.Debug.trace("GamePlay :: stopping onEnterFrame : " + _loc1_,com.poptropica.util.Debug.VERBOSE_MESSAGE);
                  _loc1_.onEnterFrame = placeHolderFunction;
               }
            }
            stopAllEnterFrameEvents(_loc1_,false,eventArray);
         }
      }
   }
}
function startAllEnterFrameEvents(container)
{
   var _loc2_ = gEnterFrameEvents[container];
   var _loc1_ = 0;
   while(_loc1_ < _loc2_.length)
   {
      if(_loc2_[_loc1_].clip && _loc2_[_loc1_].clip.onEnterFrame == placeHolderFunction)
      {
         com.poptropica.util.Debug.trace("GamePlay :: starting onEnterFrame : " + _loc2_[_loc1_].clip + " : " + _loc2_[_loc1_].clip.onEnterFrame,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         _loc2_[_loc1_].clip.onEnterFrame = _loc2_[_loc1_].event;
      }
      else if(_loc2_[_loc1_].clip._name.indexOf("__tweener_controller__") > -1)
      {
         com.poptropica.util.Debug.trace("GamePlay :: Resuming Tweener : " + _loc2_[_loc1_].clip,com.poptropica.util.Debug.VERBOSE_MESSAGE);
         caurina.transitions.Tweener.resumeAllTweens();
      }
      _loc1_ = _loc1_ + 1;
   }
   delete gEnterFrameEvents[container];
}
function placeHolderFunction()
{
}
function pauseGame(fromFramework)
{
   var _loc1_;
   if(!fromFramework || fromFramework && !camera.scene.pausedGame)
   {
      com.poptropica.util.Debug.trace("  gameplay::frame1 pauseGame() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
      _loc1_ = new flash.geom.Matrix();
      _loc1_.translate(camera._x,camera._y);
      cameraPaused._visible = true;
      cameraBitmap.draw(camera,_loc1_);
      camera._visible = false;
      camera.scene.pausedGame = true;
      delete camera.onEnterFrame;
      false;
      if(camera.scene.pauseGame)
      {
         camera.scene.pauseGame();
      }
      else if(!camera.scene.red5)
      {
         stopAllEnterFrameEvents(com.poptropica.models.PopModelConst.gameplayMC,true);
      }
   }
   else if(fromFramework && popupClip && !popupClip.pausedGame && !camera.scene.red5)
   {
      popupClip.pausedGame = true;
      stopAllEnterFrameEvents(popupClip,true);
   }
}
function unPauseGame(fromFramework)
{
   com.poptropica.util.Debug.trace("  gameplay::frame1 unPauseGame() ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   clickToUnPause._visible = false;
   btnPause.gotoAndStop(1);
   if(fromFramework && popupClip && !camera.scene.red5)
   {
      popupClip.pausedGame = false;
      startAllEnterFrameEvents(popupClip);
   }
   else
   {
      camera._visible = true;
      cameraPaused._visible = false;
      camera.scene.pausedGame = false;
      if(camera.scene.useScalePan != true)
      {
         camera.onEnterFrame = pan;
      }
      else
      {
         camera.onEnterFrame = scalePan;
      }
      if(camera.scene.unPauseGame)
      {
         camera.scene.unPauseGame();
      }
      else if(camera.scene.resumeGame)
      {
         camera.scene.resumeGame();
      }
      else if(!camera.scene.red5)
      {
         startAllEnterFrameEvents(com.poptropica.models.PopModelConst.gameplayMC);
      }
   }
   pointer._visible = true;
}
function springTo(clip, target, offsetX, offsetY, velX, velY, k, damp)
{
   clip.vx = velX;
   clip.vy = velY;
   clip.onEnterFrame = function()
   {
      clip.ax = (target.coordinates.x + offsetX - clip._x) * k;
      clip.ay = (target.coordinates.y + offsetY - clip._y) * k;
      clip.vx += clip.ax;
      clip.vy += clip.ay;
      clip.vx *= damp;
      clip.vy *= damp;
      clip._x += clip.vx;
      clip._y += clip.vy;
   };
}
function setPosition(clip)
{
   clip._x = Math.round(com.poptropica.models.PopModelConst.gameplayWidth / 2 - clip.scene.char._x);
   clip._y = Math.round(com.poptropica.models.PopModelConst.gameplayHeight / 2 - (clip.scene.char._y - 90));
   if(clip._x > clip.scene.leftLimit)
   {
      clip._x = clip.scene.leftLimit;
   }
   else if(clip._x < com.poptropica.models.PopModelConst.gameplayWidth - clip.scene.rightLimit)
   {
      clip._x = com.poptropica.models.PopModelConst.gameplayWidth - clip.scene.rightLimit;
   }
   if(clip._y > clip.scene.upLimit)
   {
      clip._y = clip.scene.upLimit;
   }
   else if(clip._y < com.poptropica.models.PopModelConst.gameplayHeight - clip.scene.downLimit)
   {
      clip._y = com.poptropica.models.PopModelConst.gameplayHeight - clip.scene.downLimit;
   }
}
function scalePan()
{
   delX = Math.round((com.poptropica.models.PopModelConst.gameplayWidth / 2 - this.scene.panChar._x * this.scene.scaleFactor - this._x) / 4);
   delY = Math.round((com.poptropica.models.PopModelConst.gameplayHeight / 2 - (this.scene.panChar._y - 90) * this.scene.scaleFactor - this._y) / 4);
   r = Math.sqrt(delX * delX + delY * delY);
   if(r > panMax)
   {
      delX = panMax * (delX / r);
      delY = panMax * (delY / r);
   }
   if(delX > 0)
   {
      if(this._x + delX < this.scene.leftLimit)
      {
         this._x += delX;
      }
      else
      {
         this._x = this.scene.leftLimit;
      }
   }
   else if(delX < 0)
   {
      if(this._x + delX > com.poptropica.models.PopModelConst.gameplayWidth - this.scene.rightLimit)
      {
         this._x += delX;
      }
      else
      {
         this._x = com.poptropica.models.PopModelConst.gameplayWidth - this.scene.rightLimit;
      }
   }
   if(delY > 0)
   {
      if(this._y + delY < this.scene.upLimit)
      {
         this._y += delY;
      }
      else
      {
         this._y = this.scene.upLimit;
      }
   }
   else if(delY < 0)
   {
      if(this._y + delY > com.poptropica.models.PopModelConst.gameplayHeight - this.scene.downLimit)
      {
         this._y += delY;
      }
      else
      {
         this._y = com.poptropica.models.PopModelConst.gameplayHeight - this.scene.downLimit;
      }
   }
   this.scene.bd._x = (- this._x) / 5;
   this.scene.bd._y = (- this._y) / 5;
   coordinate(this.scene);
}
function pan()
{
   delX = Math.round((com.poptropica.models.PopModelConst.gameplayWidth / 2 - this.scene.panChar._x - this._x) / 4);
   delY = Math.round((com.poptropica.models.PopModelConst.gameplayHeight / 2 - (this.scene.panChar._y - 90) - this._y) / 4);
   r = Math.sqrt(delX * delX + delY * delY);
   if(r > panMax)
   {
      delX = panMax * (delX / r);
      delY = panMax * (delY / r);
   }
   if(delX > 0)
   {
      if(this._x + delX < this.scene.leftLimit)
      {
         this._x += delX;
      }
      else
      {
         this._x = this.scene.leftLimit;
      }
   }
   else if(delX < 0)
   {
      if(this._x + delX > com.poptropica.models.PopModelConst.gameplayWidth - this.scene.rightLimit)
      {
         this._x += delX;
      }
      else
      {
         this._x = com.poptropica.models.PopModelConst.gameplayWidth - this.scene.rightLimit;
      }
   }
   if(delY > 0)
   {
      if(this._y + delY < this.scene.upLimit)
      {
         this._y += delY;
      }
      else
      {
         this._y = this.scene.upLimit;
      }
   }
   else if(delY < 0)
   {
      if(this._y + delY > com.poptropica.models.PopModelConst.gameplayHeight - this.scene.downLimit)
      {
         this._y += delY;
      }
      else
      {
         this._y = com.poptropica.models.PopModelConst.gameplayHeight - this.scene.downLimit;
      }
   }
   this.scene.bd._x = (- this._x) / 5;
   this.scene.bd._y = (- this._y) / 5;
   coordinate(this.scene);
}
function coordinate(clip)
{
   var _loc1_;
   for(var _loc3_ in clip)
   {
      _loc1_ = clip[_loc3_];
      if(_loc1_.isPlayer || _loc1_.isObject)
      {
         _loc1_.coordinates.x = 0;
         _loc1_.coordinates.y = 0;
         _loc1_.localToGlobal(_loc1_.coordinates);
      }
   }
}
function startSpring()
{
   i = 1;
   while(i <= 4)
   {
      b = this["b" + i];
      t = this["t" + i];
      b.vX = Math.random() * 60 - 30;
      b.vY = Math.random() * 60 - 30;
      springTo(b,t,b.vX,b.vY,0.3,0.8);
      i++;
   }
}
function loadChat(targetPlayer)
{
   var _loc3_;
   if(targetPlayer.interaction == "chat")
   {
      chat._alpha = 0;
      chat.nextFrame();
      chat.fld1.htmlText = targetPlayer.q1;
      chat.fld2.htmlText = targetPlayer.q2;
      chat.fld3.htmlText = targetPlayer.q3;
      chat.sizeBubbles();
   }
   else if(camera.scene.red5)
   {
      _loc3_ = new LoadVars();
      _loc3_.onLoad = function(success)
      {
         chat._alpha = 0;
         chat.nextFrame();
         if(success)
         {
            chat.fld1.htmlText = this.quest1.split("\\n").join("\n");
            chat.fld2.htmlText = this.quest2.split("\\n").join("\n");
            chat.fld3.htmlText = this.quest3.split("\\n").join("\n");
            chat.fld1.quest_id = this.q_id1;
            chat.fld2.quest_id = this.q_id2;
            chat.fld3.quest_id = this.q_id3;
         }
         else
         {
            chat.fld1.htmlText = "The first default question.";
            chat.fld2.htmlText = "This is the second\ndefault question.";
            chat.fld3.htmlText = "And the third.";
         }
         chat.sizeBubbles();
      };
      _loc3_.load(_root.getPrefix() + "/get_questions.php?cache=" + random(10000000));
   }
   else
   {
      _loc3_ = new LoadVars();
      _loc3_.onLoad = function(success)
      {
         chat._alpha = 0;
         chat.nextFrame();
         if(success)
         {
            answArray = this.answer.split("*");
            quesArray = this.question.split("*");
            camera.scene.char.targetPlayer.answ1 = answArray[0].split("\\n").join("\n");
            camera.scene.char.targetPlayer.answ2 = answArray[1].split("\\n").join("\n");
            camera.scene.char.targetPlayer.answ3 = answArray[2].split("\\n").join("\n");
            chat.fld1.htmlText = quesArray[0].split("\\n").join("\n");
            chat.fld2.htmlText = quesArray[1].split("\\n").join("\n");
            chat.fld3.htmlText = quesArray[2].split("\\n").join("\n");
            chat.sizeBubbles();
         }
         else
         {
            chat.fld1.htmlText = "The first default question.";
            chat.fld2.htmlText = "This is the second\ndefault question.";
            chat.fld3.htmlText = "And the third.";
         }
         chat.sizeBubbles();
      };
      _loc3_.load("get_quest.php?cache=" + random(10000000));
   }
}
function loadAnswers(quest_id)
{
   var _loc4_ = new LoadVars();
   var _loc3_ = new LoadVars();
   _loc3_.onLoad = function(success)
   {
      chat._alpha = 0;
      chat.nextFrame();
      if(success)
      {
         chat.fld1.htmlText = this.ans1.split("\\n").join("\n");
         chat.fld2.htmlText = this.ans2.split("\\n").join("\n");
         chat.fld3.htmlText = this.ans3.split("\\n").join("\n");
      }
      else
      {
         chat.fld1.htmlText = "No way!";
         chat.fld2.htmlText = "Sure I would. Why not?";
         chat.fld3.htmlText = "I already have!";
      }
      chat.fld1.quest_id = chat.fld2.quest_id = chat.fld3.quest_id = -1;
      chat.sizeBubbles();
   };
   _loc4_.quest_id = quest_id;
   _loc4_.sendAndLoad(_root.getPrefix() + "/get_answers.php",_loc3_,"POST");
}
function invited(game)
{
   chat._alpha = 0;
   chat.nextFrame();
   chat.fld1.htmlText = "";
   chat.fld1.quest_id = -1;
   chat.fld2.htmlText = "Sure!";
   chat.fld2.quest_id = -2;
   chat.fld2.game = game;
   chat.fld3.htmlText = "No, thank you!";
   chat.fld3.quest_id = -1;
   chat.battle = true;
   chat.sizeBubbles();
}
function positionChat(clip, target)
{
   if(target.talkHeight != undefined)
   {
      clip._y = target.coordinates.y - clip.clipHeight - (target.talkHeight + 10) - this._y;
      clip.line._y = target.coordinates.y - clip._y - (target.talkHeight - 100) - this._y;
   }
   else
   {
      clip._y = target.coordinates.y - clip.clipHeight - (target.charScale + 10) - this._y;
      clip.line._y = target.coordinates.y - clip._y - (target.charScale - 100) - this._y;
   }
   clip._x = target.coordinates.x - this._x;
   clip.line._xscale = 100 * Math.abs(target._xscale) / target._xscale;
   if(clip._y < camera._y + 10)
   {
      clip._y = camera._y + 10;
   }
   if(clip._x > camera.scene.rightLimit + camera._x - clip.txtBox._width / 2 - 10)
   {
      clip._x = camera.scene.rightLimit + camera._x - clip.txtBox._width / 2 - 10;
   }
   else if(clip._x < camera._x + 10 + clip.txtBox._width / 2)
   {
      clip._x = camera._x + 10 + clip.txtBox._width / 2;
   }
   clip.line._x = target.coordinates.x - clip._x - this._x;
   if(clip.line._x > clip.txtBox._width / 2 - 10)
   {
      clip.line._x = clip.txtBox._width / 2 - 10;
      clip.line._xscale = 100;
   }
   else if(clip.line._x < (- clip.txtBox._width) / 2 + 10)
   {
      clip.line._x = (- clip.txtBox._width) / 2 + 10;
      clip.line._xscale = -100;
   }
}
function showInfo(infoText, xPos, yPos)
{
   info.fld1.text = infoText;
   info.sizeBubbles();
   info._visible = true;
   info._alpha = 0;
   info.i = 0;
   info.wait = info.fld1.length * 2 + 31;
   info.onEnterFrame = function()
   {
      if(this.i > this.wait)
      {
         this._alpha -= 10;
         if(this._alpha <= 0)
         {
            this._visible = false;
            delete this.onEnterFrame;
         }
      }
      else if(this._alpha < 100)
      {
         this._alpha += 10;
      }
      this._x = xPos + camera._x;
      this._y = yPos + camera._y;
      this.i = this.i + 1;
   };
}
function showStaticInfo(infoText, xPos, yPos)
{
   info._x = xPos;
   info._y = yPos;
   info.fld1.text = infoText;
   info.sizeBubbles();
   info._visible = true;
   info._alpha = 0;
   info.i = 0;
   info.wait = info.fld1.length * 2 + 31;
   info.onEnterFrame = function()
   {
      if(this.i > this.wait)
      {
         this._alpha -= 10;
         if(this._alpha <= 0)
         {
            this._visible = false;
            delete this.onEnterFrame;
         }
      }
      else if(this._alpha < 100)
      {
         this._alpha += 10;
      }
      this.i = this.i + 1;
   };
}
function showNotification(noteText, clip)
{
   note.fld1.text = noteText;
   note.sizeBubbles();
   note._visible = true;
   note.wait = note.fld1.length * 2 + 30;
   note.i = 0;
   note.onEnterFrame = function()
   {
      doorPoint = {x:0,y:0};
      clip.localToGlobal(doorPoint);
      this._x = doorPoint.x;
      this._y = doorPoint.y - clip._height - this._height;
      this.i = this.i + 1;
      if(this.i > this.wait)
      {
         hideNote();
      }
   };
}
function showNote(noteText)
{
   note.fld1.text = noteText;
   note.sizeBubbles();
   note._visible = true;
   positionChat(note,null,camera.scene.char);
   note.onEnterFrame = function()
   {
      followChat(this,null,camera.scene.char);
   };
}
function hideNote()
{
   note._visible = false;
   delete note.onEnterFrame;
}
function showChat(target)
{
   com.poptropica.util.Debug.trace("  gameplay::frame1:showChat()  target=" + target,com.poptropica.util.Debug.VERBOSE_MESSAGE);
   if(camera.scene.red5)
   {
      if(server && camera.scene.char.stat != "thinking")
      {
         server.call("changeStatus",null,"thinking");
      }
   }
   this.attachMovie("Chat","chat",chatDepth);
   if(camera.scene.char.targetPlayer.isAd)
   {
      chat.adText._visible = true;
   }
   else
   {
      chat.adText._visible = false;
   }
   chat.clipHeight = 36;
   positionChat(chat,target);
   chat.onEnterFrame = function()
   {
      positionChat(this,target);
      if(this._alpha < 100)
      {
         this._alpha += 5;
      }
   };
   hideMenu();
}
function hideChat()
{
   if(!chat)
   {
      return undefined;
   }
   if(camera.scene.red5)
   {
      if(server && camera.scene.char.stat == "thinking")
      {
         if(!chat.battle)
         {
            server.call("changeStatus",null,"none");
         }
      }
   }
   bubbles.removeMovieClip();
   chat.removeMovieClip();
}
function showBattle(char1, char2, game)
{
   sayDepth++;
   say = this.attachMovie("_battleBubble","say" + sayDepth,sayDepth);
   char1.sayDepth = char2.sayDepth = sayDepth;
   say.Icon.attachMovie("_" + game,"icon",1);
   say._xscale = say._yscale = 0;
   say.onEnterFrame = function()
   {
      positionBattle(this,char1,char2);
      if(this._xscale < 99)
      {
         this._y += (100 - this._xscale) / 2;
         this._xscale = this._yscale += (100 - this._xscale) / 2;
      }
      else
      {
         this._xscale = this._yscale = 100;
      }
   };
}
function positionBattle(target, char1, char2)
{
   var _loc3_;
   if(char1.coordinates.x < char2.coordinates.x)
   {
      _loc3_ = char1.coordinates.x - this._x;
   }
   else
   {
      _loc3_ = char2.coordinates.x - this._x;
   }
   _loc3_ += Math.abs(char1.coordinates.x - char2.coordinates.x) / 2;
   target._x = _loc3_;
   target._y = char1.coordinates.y - target._height - this._y;
}
function showSay(target, sayText, id)
{
   if(!target || !sayText)
   {
      return undefined;
   }
   hideSay(target);
   target.engaged = true;
   sayDepth++;
   if(target.sayClip)
   {
      sayClip = target.sayClip;
   }
   else
   {
      sayClip = "SayClip";
   }
   say = this.attachMovie(sayClip,"say" + sayDepth,sayDepth);
   if(camera.scene.char.targetPlayer.isAd)
   {
      say.adText._visible = true;
   }
   else
   {
      say.adText._visible = false;
   }
   positionChat(say,target);
   say.fld.htmlText = sayText;
   if(camera.scene.common || target.charState != "stand")
   {
      target.avatar.gotoAndPlay("stand");
      target.charState = "stand";
   }
   target.talking = true;
   target.avatar.head.mouth.gotoAndStop("talk");
   target.avatar.head.eyes.pupils.gotoAndStop(2);
   target.sayDepth = sayDepth;
   say.targetPlayer = target;
   say.i = 0;
   say.wait = say.fld.length * 1.5 + 40;
   say._xscale = say._yscale = 0;
   if(target["askFunction" + id])
   {
      target["askFunction" + id]();
   }
   say.onEnterFrame = function()
   {
      this.sizeBubbles();
      positionChat(this,target);
      if(!camera.scene.pausedGame)
      {
         this.i = this.i + 1;
      }
      if(this.i > this.wait)
      {
         hideSay(target);
         if(!camera.scene.red5)
         {
            if(target == camera.scene.char.targetPlayer && playGame)
            {
               playGame = false;
               _root.game = "sudoku.swf";
               _root.popup("gameLoader.swf",true);
               useArrow();
            }
            if(responding || target.interaction == "phrase")
            {
               if(target["chatFunction" + id])
               {
                  target["chatFunction" + id]();
               }
               responding = false;
            }
            else if(camera.scene.char.targetPlayer.interaction == "chat")
            {
               responding = true;
               showSay(camera.scene.char.targetPlayer,camera.scene.char.targetPlayer["a" + id],id);
            }
            else
            {
               responding = true;
               if(id == -2)
               {
                  showSay(camera.scene.char.targetPlayer,"Sure");
                  playGame = true;
               }
               else
               {
                  showSay(camera.scene.char.targetPlayer,camera.scene.char.targetPlayer["answ" + id]);
               }
            }
         }
      }
      if(this._xscale < 99)
      {
         this._y += (100 - this._xscale) / 2;
         this._xscale = this._yscale += (100 - this._xscale) / 2;
      }
      else
      {
         this._xscale = this._yscale = 100;
      }
   };
}
function manualSay(target, sayText)
{
   hideSay(target.targetPlayer);
   hideSay(target);
   responding = true;
   showSay(target,sayText);
}
function hideSay(target)
{
   this["say" + target.sayDepth].onEnterFrame = shrinkSay;
   target.talking = false;
   target.avatar.head.mouth.gotoAndStop(target.avatar.mouthFrame);
   target.avatar.head.eyes.pupils.gotoAndStop(1);
   target.engaged = false;
   target.targeted = false;
}
function shrinkSay()
{
   if(this._xscale > 10)
   {
      this._y += 10;
      this._xscale = this._yscale += (- this._xscale) / 2;
   }
   else
   {
      if(this.targetPlayer.sayFunction != null && this.i > this.wait)
      {
         this.targetPlayer.sayFunction();
      }
      this.removeMovieClip();
   }
}
function showMenu(target)
{
   if(camera.scene.red5)
   {
      if(server && camera.scene.char.stat != "thinking")
      {
         server.call("changeStatus",null,"thinking");
      }
   }
   positionChat(menu,target);
   menu.animateIn();
   menu._visible = true;
   menu.onEnterFrame = function()
   {
      positionChat(this,target);
   };
}
function hideMenu()
{
   menu._visible = false;
   delete menu.onEnterFrame;
   gameMenu._visible = false;
   delete gameMenu.onEnterFrame;
}
function showGameMenu(target)
{
   menu._visible = false;
   delete menu.onEnterFrame;
   positionChat(gameMenu,target);
   gameMenu.animateIn();
   gameMenu._visible = true;
   gameMenu.onEnterFrame = function()
   {
      positionChat(this,target);
   };
}
function isInventoryActive()
{
   if(popupClip.deckDropDown)
   {
      return true;
   }
   return false;
}
function openInventoryPopup()
{
   com.poptropica.util.Debug.trace("  gameplay::frame1::openInventoryPopup ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   if(!camera.scene.pausedGame)
   {
      pauseGame();
   }
   pointer.gotoAndStop("loading");
   popupBack._visible = true;
   popupBack.btnClose._visible = false;
   popupClose._visible = false;
   createEmptyMovieClip("popupClip",popupDepth);
   popupClip.loadMovie("popups/inventory.swf");
   turnOffWardrobe();
}
function removeInventoryPopup()
{
   com.poptropica.util.Debug.trace("  gameplay::frame1::removeInventoryPopup ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   if(popupClip)
   {
      popupClip.removeMovieClip();
   }
   popupBack._visible = false;
}
function popup(popupName, showBack, btnCloseOnTop, hideBtnClose)
{
   com.poptropica.util.Debug.trace("  gameplay::frame1::popup ",com.poptropica.util.Debug.VERBOSE_MESSAGE);
   if(popupName == "stats.swf")
   {
      _popController.setPath("stats");
      return undefined;
   }
   if(popupName == "multiverse.swf")
   {
      _popController.setPath("friends");
      return undefined;
   }
   var _loc2_;
   if(popupName == "travelmap.swf" && island != "Home")
   {
      _loc2_ = {};
      com.poptropica.controllers.PopController.getInstance().showFrameworkPopup("popups/travelmap.swf",_loc2_);
      if(!camera.scene.pausedGame)
      {
         pauseGame();
      }
      return undefined;
   }
   if(_popModel.pathArray[0] != "gameplay")
   {
      _popController.setPath("gameplay");
   }
   if(popupName == "getcard.swf" || popupName == "givecard.swf" || popupName == "inventory.swf" || popupName == "map.swf" || popupName == "games.swf" || popupName == "wardrobe.swf")
   {
      pointer.gotoAndStop("loading");
   }
   if(!camera.scene.pausedGame)
   {
      pauseGame();
   }
   if(showBack)
   {
      popupBack.btnClose._visible = true;
      popupBack._visible = true;
   }
   if(btnCloseOnTop)
   {
      popupBack.btnClose._visible = false;
      popupClose._visible = true;
   }
   if(hideBtnClose)
   {
      popupBack.btnClose._visible = false;
      popupClose._visible = false;
   }
   createEmptyMovieClip("popupClip",popupDepth);
   popupClip.loadMovie("popups/" + popupName);
   turnOffWardrobe();
}
function closePopup()
{
   if(camera.scene.common)
   {
      if(server)
      {
         server.call("changeStatus",null,"none");
      }
   }
   unPauseGame();
   popupClip.removeMovieClip();
   popupBack._visible = false;
   popupClose._visible = false;
   _level0.ads_mc._ad1._visible = true;
   _level0.ads_mc._ad2._visible = true;
   if(closePopupFunction)
   {
      closePopupFunction();
   }
}
function emote(what)
{
   if(camera.scene.char.jumping)
   {
      return undefined;
   }
   if(server)
   {
      server.call("emotion",null,what);
   }
   else
   {
      camera.scene.char.action(what);
   }
}
function saveHighscore(game, score, wins, losses, max)
{
   if(score)
   {
      if(camera.scene.char.avatar.FunBrain_so.data[game + "Score"] != undefined)
      {
         if(max)
         {
            if(camera.scene.char.avatar.FunBrain_so.data[game + "Score"] < score)
            {
               camera.scene.char.avatar.FunBrain_so.data[game + "Score"] = score;
               saveScore = true;
            }
         }
         else if(camera.scene.char.avatar.FunBrain_so.data[game + "Score"] > score)
         {
            camera.scene.char.avatar.FunBrain_so.data[game + "Score"] = score;
            saveScore = true;
         }
      }
      else
      {
         camera.scene.char.avatar.FunBrain_so.data[game + "Score"] = score;
         saveScore = true;
      }
   }
   var _loc4_;
   var _loc8_;
   if(wins)
   {
      if(camera.scene.char.avatar.FunBrain_so.data[game + "Wins"] != undefined)
      {
         camera.scene.char.avatar.FunBrain_so.data[game + "Wins"]++;
      }
      else
      {
         camera.scene.char.avatar.FunBrain_so.data[game + "Wins"] = 1;
      }
      if(camera.scene.char.avatar.FunBrain_so.data.Registred)
      {
         _loc4_ = new LoadVars();
         _loc8_ = new LoadVars();
         _loc4_.login = camera.scene.char.avatar.loadLogin();
         _loc4_.pass_hash = camera.scene.char.avatar.FunBrain_so.data.password;
         _loc4_.dbid = camera.scene.char.avatar.FunBrain_so.data.dbid;
         _loc4_.game = game;
         _loc4_.sendAndLoad(_root.getPrefix() + "/win.php",_loc8_,"POST");
      }
   }
   if(losses)
   {
      if(camera.scene.char.avatar.FunBrain_so.data[game + "Losses"] != undefined)
      {
         camera.scene.char.avatar.FunBrain_so.data[game + "Losses"]++;
      }
      else
      {
         camera.scene.char.avatar.FunBrain_so.data[game + "Losses"] = 1;
      }
      if(camera.scene.char.avatar.FunBrain_so.data.Registred)
      {
         _loc4_ = new LoadVars();
         _loc8_ = new LoadVars();
         _loc4_.login = camera.scene.char.avatar.loadLogin();
         _loc4_.pass_hash = camera.scene.char.avatar.FunBrain_so.data.password;
         _loc4_.dbid = camera.scene.char.avatar.FunBrain_so.data.dbid;
         _loc4_.game = game;
         _loc4_.sendAndLoad(_root.getPrefix() + "/lose.php",_loc8_,"POST");
      }
   }
   var _loc7_;
   if(camera.scene.red5)
   {
      if(server)
      {
         _loc7_ = _root.getUserInfo();
         server.call("changeInfo",null,_loc7_);
      }
   }
   var _loc3_;
   var _loc6_;
   if(saveScore && camera.scene.char.avatar.FunBrain_so.data.Registred)
   {
      _loc3_ = new LoadVars();
      _loc6_ = new LoadVars();
      _loc6_.onLoad = function()
      {
      };
      _loc3_.login = camera.scene.char.avatar.loadLogin();
      _loc3_.pass_hash = camera.scene.char.avatar.FunBrain_so.data.password;
      _loc3_.dbid = camera.scene.char.avatar.FunBrain_so.data.dbid;
      _loc3_.game = game;
      _loc3_.score = score;
      _loc3_.sendAndLoad(_root.getPrefix() + "/save_highscore.php",_loc6_,"POST");
   }
}
function kick()
{
   var _loc3_ = camera.scene.char.avatar;
   this.createEmptyMovieClip("loader_mc",this.getNextHighestDepth());
   if(_root.camera.scene.PartyRoom)
   {
      loader_mc.room = _root.camera.scene.char.avatar.FunBrain_so.data.lastRoom;
      loader_mc.island = _root.camera.scene.char.avatar.FunBrain_so.data.lastIsland;
   }
   else
   {
      loader_mc.title = roomName[islandMain];
      loader_mc.room = islandMain;
      loader_mc.island = island;
   }
   loader_mc.getURL("base.php","_self","POST");
}
function saveSceneVisit()
{
   var _loc1_ = camera.scene.char.avatar.loadVisited().split(",");
   _loc1_[camera.scene.roomNo] = 1;
   camera.scene.char.avatar.saveVisited(_loc1_.toString());
}
function sendSceneVisit()
{
   var _loc2_;
   var _loc3_;
   if(camera.scene.char.avatar.FunBrain_so.data.Registred && !camera.scene.ad && !globalScene && desc != "Home" && navBar._visible && navBar.btnSave._visible)
   {
      _loc2_ = new LoadVars();
      _loc3_ = new LoadVars();
      _loc3_.onLoad = function()
      {
      };
      _loc2_.login = camera.scene.char.avatar.loadLogin();
      _loc2_.pass_hash = camera.scene.char.avatar.FunBrain_so.data.password;
      _loc2_.dbid = camera.scene.char.avatar.FunBrain_so.data.dbid;
      if(_loc2_.pass_hash == undefined)
      {
         _loc2_.pass_hash = "";
      }
      _loc2_.visited = camera.scene.char.avatar.loadVisited();
      _loc2_.lastRoom = desc;
      _loc2_.island = island;
      _loc2_.lastx = camera.scene.char._x;
      _loc2_.lasty = camera.scene.char._y;
      _loc2_.sendAndLoad(_root.getPrefix() + "/visit_scene.php",_loc3_,"POST");
      navBar.savingGame.play();
   }
}
function saveChangedLook()
{
   var _loc2_;
   var _loc3_;
   if(camera.scene.char.avatar.FunBrain_so.data.Registred)
   {
      _loc2_ = new LoadVars();
      _loc3_ = new LoadVars();
      _loc3_.onLoad = function()
      {
      };
      _loc2_.login = camera.scene.char.avatar.loadLogin();
      _loc2_.pass_hash = camera.scene.char.avatar.FunBrain_so.data.password;
      _loc2_.dbid = camera.scene.char.avatar.FunBrain_so.data.dbid;
      _loc2_.look = camera.scene.char.avatar.loadLook();
      _loc2_.sendAndLoad(_root.getPrefix() + "/change_look.php",_loc3_,"POST");
   }
   broadcastLookUpdates();
}
function broadcastLookUpdates()
{
   if(camera.scene.red5 && server)
   {
      server.call("changeLook",null,camera.scene.char.avatar.loadLook());
   }
}
function visitPartyRoom(roomName, roomType)
{
   _root.camera.scene.char.avatar.FunBrain_so.data.partyRoom = roomName;
   if(!_root.camera.scene.PartyRoom)
   {
      _root.camera.scene.char.avatar.FunBrain_so.data.lastRoom = _root.desc;
      _root.camera.scene.char.avatar.FunBrain_so.data.lastIsland = _root.island;
   }
   var _loc2_ = [roomType];
   _root.camera.scene.char.exitRoom({desc:_loc2_,island:"Party"});
}
function showErrorMessage(errMsg)
{
   clearInterval(errorTimer);
   var _loc3_ = new LoadVars();
   _loc3_.onLoad = function(success)
   {
      var _loc3_;
      if(errMsg)
      {
         _loc3_ = errMsg;
      }
      else
      {
         _loc3_ = "We\'re sorry, we seem to be experiencing\ntechnical issues. Please try back later.";
      }
      var _loc4_ = 8000;
      if(success)
      {
         _loc3_ = this.errorMessage;
         _loc4_ = parseInt(this.messageTime);
      }
      error.fld1.text = _loc3_.split("\\n").join("\n");
      error.sizeBubbles();
      error._visible = true;
      error.swapDepths(blueDepth);
      error._x = com.poptropica.models.PopModelConst.gameplayWidth / 2;
      error._y = com.poptropica.models.PopModelConst.gameplayHeight / 2 - error._height / 2;
      redirectTimer = setInterval(_root,"gotoHomepage",_loc4_);
   };
   _loc3_.load(_root.getPrefix() + "/error_message.php");
}
function gotoHomepage()
{
   getURL("index.php", "_self");
}
function trackCampaign(campaignName, event, choice, subChoice)
{
   loadVariablesNum("/brain/track.php?cluster=" + ClusterName + "&scene=" + SceneName + "&campaign=" + campaignName + "&event=" + event + "&grade=" + CharacterGrade + "&gender=" + CharacterGender + "&lang=" + CharacterLanguage + (!choice ? "" : "&choice=" + choice) + (!subChoice ? "" : "&subchoice=" + subChoice) + "&brain=Poptropica&randomNumber=" + random(10000),0);
   if(_root._url.substr(0,_root._url.indexOf(":")) == "file" || _root._url.substr(0,_root._url.indexOf(".")) == "http://feta" || _root._url.substr(0,_root._url.indexOf(".")) == "http://localhost/pop/base")
   {
      _root.trc("trackCampaign c:" + campaignName + " e:" + event + " c:" + choice + " sc:" + subChoice);
   }
   if(gActivityTimer)
   {
      gActivityTimer.checkEvent(arguments);
   }
}
function trackEvent(EventToTrack)
{
   loadVariablesNum("/brain/track.php?cluster=" + ClusterName + "&scene=" + SceneName + "&event=" + EventToTrack + "&grade=" + CharacterGrade + "&gender=" + CharacterGender + "&lang=" + CharacterLanguage + "&brain=Poptropica&randomNumber=" + random(10000),0);
   if(gActivityTimer && EventToTrack == "Loaded")
   {
      gActivityTimer.checkScene(desc);
   }
}
function trackActivityTime(time, campaignName, event, choice, subChoice)
{
   trace("ActivityTimer :: trackActivityTime : " + arguments);
   var _loc3_ = new LoadVars();
   var _loc4_ = new LoadVars();
   if(choice != undefined)
   {
      _loc3_.choice = choice;
   }
   if(subChoice != undefined)
   {
      _loc3_.subchoice = subChoice;
   }
   _loc3_.cluster = ClusterName;
   _loc3_.scene = SceneName;
   _loc3_.campaign = campaignName;
   _loc3_.event = event;
   _loc3_.grade = CharacterGrade;
   _loc3_.gender = CharacterGender;
   _loc3_.numvals = "TimeSpent:" + time;
   _loc3_.sendAndLoad(_root.getPrefix() + "/brain/track.php",_loc4_,"GET");
}
function GATrackEvent(category, action, label_opt, value_opt)
{
   trace("GATrackEvent : " + arguments);
   flash.external.ExternalInterface.call("GATrackEvent",category,action,label_opt,value_opt);
}
function checkBossesBeat()
{
   numBosses = 0;
   b = 1;
   while(b <= 6)
   {
      curEvent = "beatBoss" + b;
      if(camera.scene.char.avatar.checkEvent(curEvent))
      {
         numBosses++;
      }
      b++;
   }
   return numBosses;
}
function showSound(frameName, posX, posY, shakeAmount, isPopup)
{
   sayDepth++;
   soundDepth = sayDepth;
   if(isPopup)
   {
      soundDepth += popupDepth;
   }
   snd = this.attachMovie("SoundBubble","snd" + soundDepth,soundDepth);
   snd.gotoAndStop(frameName);
   snd.startX = posX;
   snd.startY = posY;
   if(isPopup)
   {
      snd.isPopup = true;
      snd._x = posX;
      snd._y = posY;
   }
   else
   {
      snd._x = posX + camera._x;
      snd._y = posY + camera._y;
   }
   snd._xscale = snd._yscale = 0;
   snd.scaleSpeed = 25;
   snd.scaleAccel = 0;
   snd.wait = 0;
   if(shakeAmount > 0)
   {
      snd.shakeAmount = shakeAmount;
      snd.shake = true;
      snd.t = 0;
   }
   snd.onEnterFrame = function()
   {
      if(this.isPopup)
      {
         this._x = this.startX;
         this._y = this.startY;
      }
      else
      {
         this._x = this.startX + camera._x;
         this._y = this.startY + camera._y;
      }
      this.wait = this.wait + 1;
      if(this.wait > 31)
      {
         this._xscale = this._yscale += (- this._xscale) / 4;
         if(this._xscale < 25)
         {
            this.removeMovieClip();
         }
      }
      else
      {
         this.scaleAccel = (100 - this._xscale) / 5;
         this.scaleSpeed += this.scaleAccel;
         this.scaleSpeed *= 0.8;
         this._xscale = this._yscale += this.scaleSpeed;
         if(this.shake)
         {
            this.t += 0.8;
            this._rotation = this.shakeAmount * Math.sin(this.t);
         }
      }
   };
}
function setClipColor(clip, newColor)
{
   setColor = new Color(clip);
   setColor.setRGB(newColor);
}
function turnOffWardrobe()
{
   useWardrobe = false;
   usePinkPainter = false;
   useSelectCharacter = false;
   delete camera.scene.char.onPress;
   if(!camera.scene.common)
   {
      delete camera.scene.char.onRollOver;
   }
   navBar.wardrobeSelect._visible = false;
   navBar.wardrobeDim._visible = false;
}
function isActiveMember()
{
   if(camera.scene.char.avatar.FunBrain_so.data.mem_status == "active-renew" || camera.scene.char.avatar.FunBrain_so.data.mem_status == "active-norenew")
   {
      return true;
   }
   return false;
}
function setExitClick(clip)
{
   clip.onRelease = function()
   {
      if(camera.scene.red5 && server)
      {
         server.call("moveTo",null,Math.round(clip._x),Math.round(clip._y));
      }
      this._parent.char.clickClipTarget(this);
   };
   clip.targetFunction = function()
   {
      this._parent.char.exitRoom(this);
   };
   clip.onRollOver = exitClickRollOver;
}
function setBlimpClick(clip)
{
   clip.onRelease = function()
   {
      this._parent.char.clickClipTarget(this);
   };
   clip.targetFunction = function()
   {
      popup("travelmap.swf",false);
   };
   clip.onRollOver = exitClickRollOver;
}
function exitClickRollOver()
{
   if(this.angle == 360)
   {
      pointer.gotoAndStop("exit3D");
   }
   else
   {
      pointer.gotoAndStop("exit");
      pointer.exit._rotation = this.angle;
      pointer.exit._xscale = this.scale;
   }
   pointer.labelFld.text = this.labelText;
}
var cntrlIsDown = false;
var shiftIsDown = false;
var keyListener = new Object();
keyListener.onKeyDown = function()
{
   var _loc2_ = Key.getCode();
   if(_loc2_ == 17)
   {
      ctrlIsDown = true;
   }
   else if(_loc2_ == 16)
   {
      shiftIsDown = true;
   }
   var _loc3_;
   if(ctrlIsDown && shiftIsDown)
   {
      if(_loc2_ == 80)
      {
         if(_root.char.avatar.facialFrame == "pumpkinHead")
         {
            _root.char.avatar.facialFrame = 1;
            _root.char.avatar.savePartsToSO();
            _root.char.avatar.setParts();
         }
         else
         {
            _root.char.avatar.facialFrame = "pumpkinHead";
            _root.char.avatar.savePartsToSO();
            _root.char.avatar.setParts();
         }
      }
      else if(_loc2_ == 82)
      {
         _root.char.avatar.createRandomParts(_root.char.avatar.gender,"both");
         _root.char.changeSkinColor(_root.char.avatar.colors[Math.floor(Math.random() * _root.char.avatar.colors.length)]);
         _root.char.avatar.savePartsToSO();
         _root.char.avatar.setParts();
         _root.char.action("pop");
      }
      else if(_loc2_ == 72)
      {
         _root.char.avatar.hairColor = _root.char.avatar.normalHairColors[Math.floor(Math.random() * _root.char.avatar.normalHairColors.length)];
         _root.char.avatar.savePartsToSO();
         _root.char.avatar.setParts();
         _root.char.action("pop");
      }
      else if(_loc2_ == 83)
      {
         _root.char.changeSkinColor(_root.char.avatar.colors[Math.floor(Math.random() * _root.char.avatar.colors.length)]);
      }
      else if(_loc2_ == 49)
      {
         _root.char.action("laugh");
      }
      else if(_loc2_ == 50)
      {
         _root.char.action("cry");
      }
      else if(_loc2_ == 51)
      {
         _root.char.action("angry");
      }
      else if(_loc2_ == 52)
      {
         if(!jumping)
         {
            _root.char.action("celebrate");
         }
      }
   }
   else if(Key.isDown(115))
   {
      if(_root.traceSO.data.debugAccess == true)
      {
         _root.traceSO.data.trcVisible = _root.trace_txt._visible = !_root.trace_txt._visible;
         _root.traceSO.flush();
      }
   }
   else if(Key.isDown(123))
   {
      _root.dev_console._visible = !_root.dev_console._visible;
      if(_root.traceSO.data.debugAccess != undefined)
      {
         _root.traceSO.data.devVisible = _root.dev_console._visible;
      }
      Selection.setFocus(_root.dev_console);
   }
   else if(Key.isDown(38))
   {
      if(_root.dev_console != null && _root.dev_console._visible == true)
      {
         _root.traceSO.data.historyIndex--;
         if(_root.traceSO.data.historyIndex < 0)
         {
            _root.traceSO.data.historyIndex = 0;
         }
         if(_root.traceSO.data.commandHistory[_root.traceSO.data.historyIndex] != undefined)
         {
            _root.dev_console.text = _root.traceSO.data.commandHistory[_root.traceSO.data.historyIndex];
            _root.dev_console.oldText = _root.traceSO.data.commandHistory[_root.traceSO.data.historyIndex];
         }
         Selection.setFocus(_root.dev_console);
         _root.dev_console.id = setInterval(_root,"moveCarot",5);
      }
   }
   else if(Key.isDown(40))
   {
      if(_root.dev_console != null && _root.dev_console._visible == true)
      {
         _root.traceSO.data.historyIndex++;
         if(_root.traceSO.data.historyIndex >= _root.traceSO.data.commandHistory.length)
         {
            _root.traceSO.data.historyIndex = _root.traceSO.data.commandHistory.length;
            _root.dev_console.text = "";
            _root.dev_console.oldtext = "";
         }
         else
         {
            _root.dev_console.text = _root.traceSO.data.commandHistory[_root.traceSO.data.historyIndex];
            _root.dev_console.oldText = _root.traceSO.data.commandHistory[_root.traceSO.data.historyIndex];
         }
         Selection.setFocus(_root.dev_console);
         _loc3_ = _root.dev_console.text.length - 1;
         Selection.setSelection(_loc3_,_loc3_);
      }
   }
   else if(Key.isDown(83))
   {
      _root.say.wait = 0;
   }
   else if(Key.isDown(119))
   {
      if(com.poptropica.models.PopModelConst.section == "gameplay")
      {
         btnPause.onRelease();
      }
   }
};
keyListener.onKeyUp = function()
{
   var _loc3_ = Key.getCode();
   var _loc2_;
   if(_loc3_ == 32)
   {
      if(_root.popupClip)
      {
         _root.popupClip.char.avatar.item.action();
         _root.popupClip.char.avatar.head.action();
         _root.popupClip.char.avatar.pack.action();
         _root.popupClip.char.avatar.body.action();
         _root.popupClip.char.avatar.hair.action();
         _root.popupClip.char1.avatar.item.action();
         _root.popupClip.char1.avatar.head.action();
         _root.popupClip.char1.avatar.pack.action();
         _root.popupClip.char1.avatar.body.action();
         _root.popupClip.char1.avatar.hair.action();
         _loc2_ = _root.popupClip["card" + _root.popupClip.activeCard];
         if(_loc2_)
         {
            _loc2_.container.card.outfit.model.avatar.item.action();
            _loc2_.container.card.outfit.model.avatar.head.action();
            _loc2_.container.card.outfit.model.avatar.pack.action();
            _loc2_.container.card.outfit.model.avatar.body.action();
            _loc2_.container.card.outfit.model.avatar.hair.action();
         }
      }
      else if(_root.camera.scene.red5)
      {
         if(_root.server)
         {
            _root.server.call("emotion",null,"specialAction");
         }
      }
      else
      {
         _root.camera.scene.char.avatar.item.action();
         _root.camera.scene.char.avatar.head.action();
         _root.camera.scene.char.avatar.pack.action();
         _root.camera.scene.char.avatar.body.action();
         _root.camera.scene.char.avatar.hair.action();
         trace("Doing action");
         _root.doActiveCardAction();
      }
   }
   else if(_loc3_ == 17)
   {
      ctrlIsDown = false;
   }
   else if(_loc3_ == 16)
   {
      shiftIsDown = false;
   }
};
Key.addListener(keyListener);
var refreshInterval;
var prefix;
var MMOprefix;
_root.Settings = SharedObject.getLocal("settings","/");
checkPrefixUpdate();
var _proxy = com.poptropica.util.PopCompanionProxy.getInstance();
var stageWidth = com.poptropica.models.PopModelConst.gameplayWidth;
var stageHeight = com.poptropica.models.PopModelConst.gameplayHeight;
stop();
var hex_chr = "0123456789abcdef";
var hexcase = 0;
var b64pad = "";
var chrsz = 8;
var jsonLib = new asLib.JSON();
if(_root._url.indexOf("?") != -1)
{
   if(_root._url.substr(0,_root._url.indexOf(":")) != "file")
   {
      if(_root._url.substr(0,_root._url.indexOf(".")) == "http://static" || _root._url.substr(0,_root._url.indexOf(".")) == "http://www" || _root._url.indexOf(".poptropica.com") == -1)
      {
         getURL("http://www.poptropica.com");
      }
   }
}
_root.debugAccess = false;
var substr = _root._url.substr(0,_root._url.indexOf("."));
switch(substr)
{
   case "http://www":
      _root.debugAccess = false;
      break;
   case "http://dev":
   case "http://test":
   case "http://cert":
   case "http://feta":
   case "http://surus":
   case "http://localhost/pop/base":
      _root.debugAccess = true;
      break;
   default:
      substr = _root._url.substr(0,_root._url.indexOf(":"));
      if(substr == "file")
      {
         _root.debugAccess = true;
      }
      else
      {
         _root.debugAccess = false;
      }
}
var scene = camera.scene;
var char = scene.char;
var avatar = char.avatar;
var historyIndex = 0;
var ipCheckComplete = false;
initTraceSO(_root.debugAccess);
mkConsole();
trc("");
var showTraces = _root.traceSO.data.trcLoading != undefined ? _root.traceSO.data.trcLoading : false;
wrapLoadClip();
wrapLoadMovie();
var gActivityTimer = new ActivityTimer(this);
var _popModel = com.poptropica.models.PopModel.getInstance();
var _popController = com.poptropica.controllers.PopController.getInstance(_popModel);
var _adController = com.poptropica.controllers.AdController.getInstance(_popModel);
var _gameplayView = new com.poptropica.views.GameplayView(_popModel,_popController,this);
_popModel.addObserver(_gameplayView);
var _proxy = com.poptropica.util.PopCompanionProxy.getInstance();
_proxy.init("_popCompanionProxy",this);
var LSO;
var gLSOWarningManager;
loadProgress = com.poptropica.models.PopModel.getInstance().rt_mc.loadProgress;
Stage.scaleMode = "noScale";
Stage.align = "TL";
fscommand("allowscale","false");
this.tabChildren = false;
stop();
island = _popModel.island;
desc = _popModel.desc;
_proxy.sendSceneData(island,desc);
if(!desc)
{
   desc = "Home";
}
if(!island || desc == "Home")
{
   island = "Home";
}
com.poptropica.util.Debug.getInstance().severity_level = com.poptropica.util.Debug.VERBOSE_MESSAGE;
com.poptropica.util.Debug.trace("  gameplay::frame1 island=" + island,com.poptropica.util.Debug.VERBOSE_MESSAGE);
com.poptropica.util.Debug.trace("  gameplay::frame1 desc=" + desc,com.poptropica.util.Debug.VERBOSE_MESSAGE);
if(island == "FactMonster" || desc == "HomeFM")
{
   navBar.logo.nextFrame();
}
islandMain = String(_popModel.getIslandProperty(island,"island_main"));
if(islandMain == null || islandMain == undefined)
{
   islandMain = "City2";
}
com.poptropica.util.Debug.trace("  gameplay::frame1 islandMain=" + islandMain,com.poptropica.util.Debug.VERBOSE_MESSAGE);
ClusterName = String(_popModel.getIslandProperty(island,"cluster_name"));
com.poptropica.util.Debug.trace("  gameplay::frame1 ClusterName=" + ClusterName,com.poptropica.util.Debug.VERBOSE_MESSAGE);
sceneName = "scene" + desc + ".swf";
var loader = new MovieClipLoader();
this.onLoadInit = function()
{
   nextFrame();
};
this.onLoadError = function(target, errorCode, htmlCode)
{
   showErrorMessage();
};
if(desc.substr(0,6) == "Global")
{
   globalScene = true;
}
loader.addListener(this);
var scenePath = "";
if(globalScene)
{
   scenePath = "scenes/Global/" + sceneName;
}
else
{
   scenePath = "scenes/island" + island + "/" + sceneName;
}
com.poptropica.util.Debug.trace("  gameplay::frame1 scenePath=" + scenePath,com.poptropica.util.Debug.VERBOSE_MESSAGE);
loader.loadClip(scenePath,camera);
chat._visible = false;
menu._visible = false;
bubbles._visible = false;
note._visible = false;
say._visible = false;
sayLine._visible = false;
crosshairs._visible = false;
popupBack._visible = false;
popupClose._visible = false;
blue.onEnterFrame = function()
{
   if(this._alpha > 0)
   {
      this._alpha -= 10;
   }
   else
   {
      this._visible = false;
      delete this.onEnterFrame;
   }
};
blue.onPress = function()
{
};
responding = false;
Chats = new Array();
timeout = 0;
clickWait = 0;
campaignVars = new Object();
_global.baseDrag = 0.7;
_global.slipperyDrag = 0.95;
blueDepth = 900001;
loaderDepth = 900000;
popup2Depth = 510000;
popupCloseDepth = 500001;
popupDepth = 500000;
popupBackDepth = 490000;
pauseBtnDepth = 480000;
navDepth = 400000;
popunderDepth = 300000;
gameMenuDepth = 10000;
sayDepth = 2000;
chatDepth = 1000;
walkToClipDepth = 900;
pauseDepth = 1;
timeoutInterval = 300000;
errorInterval = 15000;
var cameraBitmap = new flash.display.BitmapData(com.poptropica.models.PopModelConst.gameplayWidth,com.poptropica.models.PopModelConst.gameplayHeight,false,4294967295);
var cameraPaused = this.createEmptyMovieClip("pausedClip",pauseDepth);
cameraPaused.attachBitmap(cameraBitmap,1);
cameraPaused._visible = false;
navBar.swapDepths(navDepth);
takeClick.swapDepths(navDepth + 1);
popupBack.swapDepths(popupBackDepth);
popupClose.swapDepths(popupCloseDepth);
blue.swapDepths(blueDepth);
com.poptropica.util.Debug.trace("  gameplay::frame1:: create pointer",com.poptropica.util.Debug.VERBOSE_MESSAGE);
var pointer = com.poptropica.views.PointerView.getInstance().pointer_mc;
var _gameplay_width = _popModel.gameplay_width;
var _gameplay_height = _popModel.gameplay_height;
var gEnterFrameEvents = new Object();
attachMovie("BtnPause","btnPause",pauseBtnDepth);
btnPause._x = 14;
btnPause._y = 14;
btnPause.onRollOver = _root.useArrow;
btnPause.onRelease = function()
{
   if(popupClip && !popupClip.pausedGame || !camera.scene.pausedGame)
   {
      if(camera.scene.red5)
      {
         if(server)
         {
            server.call("changeStatus",null,"busy");
         }
      }
      trackEvent("PausedGame");
      pauseGame(true);
      btnPause.gotoAndStop(2);
      if(clickToUnPause)
      {
         clickToUnPause._visible = true;
      }
      else
      {
         createEmptyMovieClip("clickToUnPause",pauseBtnDepth - 1);
         clickToUnPause.lineStyle(1,0,0);
         clickToUnPause.beginFill(0,0);
         clickToUnPause.moveTo(0,0);
         clickToUnPause.lineTo(640,0);
         clickToUnPause.lineTo(640,480);
         clickToUnPause.lineTo(0,480);
         clickToUnPause.endFill();
         clickToUnPause.onRollOver = function()
         {
            pointer.gotoAndStop("loading");
         };
         clickToUnPause.onRelease = btnPause.onRelease;
      }
   }
   else
   {
      unPauseGame(true);
      pointer.gotoAndStop("arrow");
   }
};
panMax = 70;
bdScale = 0.88;
blue.useHandCursor = false;
blue.onPress = function()
{
};
navBar.btnInventory.onRelease = function()
{
   if(camera.scene.red5)
   {
      if(server)
      {
         server.call("changeStatus",null,"busy");
      }
   }
   popup("inventory.swf",true);
};
navBar.btnWardrobe.onRelease = function()
{
   if(camera.scene.red5)
   {
      if(server)
      {
         server.call("changeStatus",null,"busy");
      }
   }
   useWardrobe = true;
   usePinkPainter = false;
   useSelectCharacter = false;
   navBar.wardrobeSelect._visible = true;
   navBar.wardrobeSelect.gotoAndPlay(1);
   navBar.wardrobeDim._visible = true;
   trackEvent("CostumizerClicked");
};
navBar.btnMap.onRelease = function()
{
   if(camera.scene.red5)
   {
      if(server)
      {
         server.call("changeStatus",null,"busy");
      }
   }
   popup("map.swf",true);
   trackEvent("MapClicked");
};
navBar.btnSave.onRelease = function()
{
   if(camera.scene.red5)
   {
      if(server)
      {
         server.call("changeStatus",null,"busy");
      }
   }
   if(this.saved)
   {
      trackEvent("SaveAndQuitClicked");
      sendSceneVisit();
   }
   else
   {
      createEmptyMovieClip("popupClip2",popup2Depth);
      popupClip2.loadMovie("popups/register.swf");
   }
};
navBar.btnTime.onRelease = function()
{
   popup("timemachine.swf",true);
};
navBar.btnVentMap.onRelease = function()
{
   popup("ventmap.swf",true);
};
navBar.btnSuperPower.onRelease = function()
{
   if(this.superGlow._visible)
   {
      this.superGlow._visible = false;
      camera.scene.char.soaring = false;
      camera.scene.char.avatar.FunBrain_so.data.soaring = false;
   }
   else
   {
      this.superGlow._visible = true;
      camera.scene.char.soaring = true;
      camera.scene.char.avatar.FunBrain_so.data.soaring = true;
   }
};
navBar.btnGrapple.onRelease = function()
{
   pointer.gotoAndStop("target");
   camera.scene.char.clearGrapple();
   navBar.grappleHit._visible = true;
};
navBar.btnMap.onRollOver = useArrow;
navBar.btnWardrobe.onRollOver = useArrow;
navBar.btnInventory.onRollOver = useArrow;
navBar.area.onRollOver = useArrow;
navBar.btnSave.onRollOver = useArrow;
navBar.btnHome.onRollOver = useArrow;
navBar.btnTime.onRollOver = useArrow;
navBar.btnVentMap.onRollOver = useArrow;
navBar.btnSuperPower.onRollOver = useArrow;
navBar.btnGrapple.onRollOver = useArrow;
var Games = new Array("sudoku","switch","hoopshot","skydive","paintwar","dotgame","balloongame","boggle","hex","Sumo");
var MMOGames = new Array("sudoku","hoopshot","skydive","paintwar","dotgame","balloongame","boggle","hex");
var MMOGamesNames = new Array("Sudoku","Hoops","Sky Dive","Paint War","Star Link","Balloons","Soupwords","Pathwise");
