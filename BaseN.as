class com.Newgrounds.BaseN
{
   var ceiling;
   var hashIndex;
   var bitSize;
   var hashVal;
   var i;
   var debug = new Object();
   function BaseN(hash)
   {
      this.ceiling = 100000000000000;
      if(hash)
      {
         this.hashIndex = hash;
      }
      else
      {
         this.hashIndex = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`~@#$%^&*()+|;/";
      }
      this.bitSize = this.hashIndex.length;
      this.hashVal = new Object();
      this.i = 0;
      while(this.i < this.bitSize)
      {
         this.hashVal[this.hashIndex.charAt(this.i)] = this.i;
         this.i = this.i + 1;
      }
   }
   function verify(s)
   {
      if(this.hashVal[s] != undefined)
      {
         return true;
      }
      return false;
   }
   function encode(n, minchars)
   {
      this.debug.lastencode = "";
      if(typeof this.i != "string")
      {
         n = n.toString();
      }
      if(n.charAt(0) == "-")
      {
         var _loc3_ = "-";
         n = n.substring(1);
      }
      else
      {
         _loc3_ = "";
      }
      if(String(n).indexOf(".") > -1)
      {
         var _loc4_ = String(n).split(".",2);
         return _loc3_ + this.baseNEncoder(_loc4_[0],minchars) + "." + this.baseNEncoder(_loc4_[1]);
      }
      this.debug.lastencode += "\tNo decimal\r";
      return _loc3_ + this.baseNEncoder(n,minchars);
   }
   function decode(s)
   {
      var _loc4_ = 1;
      if(s.charAt(0) == "-")
      {
         _loc4_ = -1;
         s = s.substring(1,s.length);
      }
      var _loc3_ = s.indexOf(".");
      if(_loc3_ > -1)
      {
         var _loc5_ = Math.pow(10,this.baseNDecoder(s.substring(_loc3_ + 1,s.length)));
         return this.baseNDecoder(s.substring(0,_loc3_)) / _loc5_ * _loc4_;
      }
      return this.baseNDecoder(s) * _loc4_;
   }
   function baseNEncoder(n, minchars)
   {
      if(!minchars)
      {
         minchars = 1;
      }
      var _loc4_ = "";
      while(n != 0)
      {
         n = Math.round(n);
         var _loc3_ = n % this.bitSize;
         if(Math.round(_loc3_) != _loc3_)
         {
            trace("BaseN failed on " + n + "%" + this.bitSize + " = " + _loc3_ + " " + int(n) + " " + int(this.bitSize));
         }
         _loc4_ = this.hashIndex.charAt(_loc3_) + _loc4_;
         this.debug.lastencode += "\t-> n:" + n + " % bitSize:" + this.bitSize + " = " + _loc3_ + ", final char=" + _loc4_ + "\n";
         n -= _loc3_;
         n /= this.bitSize;
      }
      if(minchars)
      {
         while(_loc4_.length < minchars)
         {
            _loc4_ = this.hashIndex.charAt(0) + _loc4_;
         }
      }
      return _loc4_;
   }
   function baseNDecoder(s)
   {
      var _loc2_ = 0;
      var _loc6_ = 0;
      this.i = 0;
      while(this.i < s.length)
      {
         var _loc3_ = s.charAt(s.length - this.i - 1);
         if(_loc3_ == this.hashIndex.charAt(0))
         {
            var _loc5_ = 0;
         }
         else
         {
            _loc5_ = this.hashVal[_loc3_] * Math.pow(this.bitSize,this.i);
         }
         _loc2_ += _loc5_;
         if(_loc2_ >= this.ceiling)
         {
            _loc6_ += (_loc2_ - _loc2_ % this.ceiling) / this.ceiling;
            _loc2_ %= this.ceiling;
         }
         this.i = this.i + 1;
      }
      if(_loc6_ > 0)
      {
         _loc2_ = "" + _loc2_;
         while(_loc2_.length < this.ceiling.toString().length - 1)
         {
            _loc2_ = "0" + _loc2_;
         }
         _loc2_ = "" + _loc6_ + _loc2_;
      }
      return _loc2_;
   }
}
