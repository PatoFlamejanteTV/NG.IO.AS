class com.Newgrounds.RC4
{
   static var sbox = new Array(255);
   static var mykey = new Array(255);
   function RC4()
   {
   }
   static function encrypt(src, key)
   {
      var _loc3_ = com.Newgrounds.RC4.strToChars(src);
      var _loc1_ = com.Newgrounds.RC4.strToChars(key);
      var _loc2_ = com.Newgrounds.RC4.calculate(_loc3_,_loc1_);
      return com.Newgrounds.RC4.charsToHex(_loc2_);
   }
   static function encryptbin(src, key)
   {
      var _loc3_ = com.Newgrounds.RC4.strToChars(src);
      var _loc1_ = com.Newgrounds.RC4.strToChars(key);
      var _loc2_ = com.Newgrounds.RC4.calculate(_loc3_,_loc1_);
      return _loc2_;
   }
   static function decrypt(src, key)
   {
      var _loc3_ = com.Newgrounds.RC4.hexToChars(src);
      var _loc1_ = com.Newgrounds.RC4.strToChars(key);
      var _loc2_ = com.Newgrounds.RC4.calculate(_loc3_,_loc1_);
      return com.Newgrounds.RC4.charsToStr(_loc2_);
   }
   static function initialize(pwd)
   {
      var _loc2_ = 0;
      var _loc3_ = undefined;
      var _loc4_ = pwd.length;
      var _loc1_ = 0;
      while(_loc1_ <= 255)
      {
         com.Newgrounds.RC4.mykey[_loc1_] = pwd[_loc1_ % _loc4_];
         com.Newgrounds.RC4.sbox[_loc1_] = _loc1_;
         _loc1_ = _loc1_ + 1;
      }
      _loc1_ = 0;
      while(_loc1_ <= 255)
      {
         _loc2_ = (_loc2_ + com.Newgrounds.RC4.sbox[_loc1_] + com.Newgrounds.RC4.mykey[_loc1_]) % 256;
         _loc3_ = com.Newgrounds.RC4.sbox[_loc1_];
         com.Newgrounds.RC4.sbox[_loc1_] = com.Newgrounds.RC4.sbox[_loc2_];
         com.Newgrounds.RC4.sbox[_loc2_] = _loc3_;
         _loc1_ = _loc1_ + 1;
      }
   }
   static function calculate(plaintxt, psw)
   {
      com.Newgrounds.RC4.initialize(psw);
      var _loc1_ = 0;
      var _loc2_ = 0;
      var _loc9_ = new Array();
      var _loc7_ = undefined;
      var _loc5_ = undefined;
      var _loc6_ = undefined;
      var _loc3_ = 0;
      while(_loc3_ < plaintxt.length)
      {
         _loc1_ = (_loc1_ + 1) % 256;
         _loc2_ = (_loc2_ + com.Newgrounds.RC4.sbox[_loc1_]) % 256;
         _loc5_ = com.Newgrounds.RC4.sbox[_loc1_];
         com.Newgrounds.RC4.sbox[_loc1_] = com.Newgrounds.RC4.sbox[_loc2_];
         com.Newgrounds.RC4.sbox[_loc2_] = _loc5_;
         var _loc4_ = (com.Newgrounds.RC4.sbox[_loc1_] + com.Newgrounds.RC4.sbox[_loc2_]) % 256;
         _loc7_ = com.Newgrounds.RC4.sbox[_loc4_];
         _loc6_ = plaintxt[_loc3_] ^ _loc7_;
         _loc9_.push(_loc6_);
         _loc3_ = _loc3_ + 1;
      }
      return _loc9_;
   }
   static function charsToHex(chars)
   {
      var _loc4_ = new String("");
      var _loc3_ = new Array("0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f");
      var _loc1_ = 0;
      while(_loc1_ < chars.length)
      {
         _loc4_ += _loc3_[chars[_loc1_] >> 4] + _loc3_[chars[_loc1_] & 0x0F];
         _loc1_ = _loc1_ + 1;
      }
      return _loc4_;
   }
   static function hexToChars(hex)
   {
      var _loc3_ = new Array();
      var _loc1_ = hex.substr(0,2) != "0x" ? 0 : 2;
      while(_loc1_ < hex.length)
      {
         _loc3_.push(parseInt(hex.substr(_loc1_,2),16));
         _loc1_ += 2;
      }
      return _loc3_;
   }
   static function charsToStr(chars)
   {
      var _loc3_ = new String("");
      var _loc1_ = 0;
      while(_loc1_ < chars.length)
      {
         _loc3_ += String.fromCharCode(chars[_loc1_]);
         _loc1_ = _loc1_ + 1;
      }
      return _loc3_;
   }
   static function strToChars(str)
   {
      var _loc3_ = new Array();
      var _loc1_ = 0;
      while(_loc1_ < str.length)
      {
         _loc3_.push(str.charCodeAt(_loc1_));
         _loc1_ = _loc1_ + 1;
      }
      return _loc3_;
   }
}
