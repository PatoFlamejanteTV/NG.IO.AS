class com.Newgrounds.ImageScanner
{
   var image_source;
   var source_width;
   var source_height;
   var sourceBitmap;
   var callback_target;
   var callback_function;
   var hash;
   var cube;
   var basen;
   var xpos;
   var ypos;
   var pixels;
   var busy;
   var canvas_width;
   var canvas_height;
   var resizedBitmap;
   var copyBitmap;
   var output;
   var draw_interval;
   var callback_interval;
   var image_width = 100;
   var image_height = 100;
   var crop = true;
   var debug = new Object();
   function ImageScanner(the_source)
   {
      if(the_source)
      {
         this.image_source = the_source;
      }
      else
      {
         this.image_source = _root;
      }
      this.reset();
      if(typeof this.image_source == "movieclip")
      {
         if(this.image_source == _root)
         {
            this.source_width = Stage.width;
            this.source_height = Stage.height;
         }
         else
         {
            this.source_width = Math.floor(this.image_source._width);
            this.source_height = Math.floor(this.image_source._height);
         }
         this.sourceBitmap = new flash.display.BitmapData(this.source_width,this.source_height,false,4294967295);
         this.sourceBitmap.draw(_root);
      }
      else if(this.image_source.width)
      {
         this.source_width = this.image_source.width;
         this.source_height = this.image_source.height;
         this.sourceBitmap = this.image_source;
      }
      else
      {
         this.error("You can only use BitMaptData and MovieClip objects to create images");
      }
   }
   function setCallback(target, funct)
   {
      if(target && funct)
      {
         this.callback_target = target;
         this.callback_function = funct;
      }
   }
   function reset()
   {
      this.callback_target = null;
      this.callback_function = null;
      this.debug.bad_pixels = 0;
      this.hash = "0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ<>?:;-_=+()!&";
      var _loc3_ = Math.pow(this.hash.length,2);
      trace("MAX COLORS: " + _loc3_);
      var _loc2_ = Math.floor(Math.pow(_loc3_,0.3333333333333333)) - 1;
      var _loc4_ = Math.pow(_loc2_,3);
      this.cube = _loc2_;
      this.basen = new com.Newgrounds.BaseN(this.hash);
      this.xpos = 0;
      this.ypos = 0;
      this.pixels = 0;
      this.busy = false;
   }
   function startScan(w, h, s)
   {
      if(w)
      {
         this.image_width = w;
      }
      if(h)
      {
         this.image_height = h;
      }
      if(s != undefined)
      {
         this.crop = s;
      }
      var _loc7_ = _root.getNextHighestDepth();
      var _loc6_ = _root.createEmptyMovieClip("API_image_container_" + _loc7_,_loc7_);
      var _loc5_ = _loc6_.createEmptyMovieClip("canvas",100);
      _loc5_.attachBitmap(this.sourceBitmap,100);
      if(this.crop)
      {
         if(this.image_width / this.source_width > this.image_height / this.source_height)
         {
            this.canvas_width = this.image_width;
            this.canvas_height = Math.ceil(this.source_height * (this.image_width / this.source_width));
         }
         else
         {
            this.canvas_height = this.image_height;
            this.canvas_width = Math.ceil(this.source_width * (this.image_height / this.source_height));
         }
      }
      else
      {
         this.canvas_width = this.image_width;
         this.canvas_height = this.image_height;
      }
      _loc5_._x = Math.round((this.image_width - this.canvas_width) / 2);
      _loc5_._width = this.canvas_width;
      _loc5_._height = this.canvas_height;
      this.resizedBitmap = new flash.display.BitmapData(this.image_width,this.image_height,false,4294967295);
      this.resizedBitmap.draw(_loc6_);
      _loc6_.removeMovieClip();
      this.copyBitmap = new flash.display.BitmapData(this.image_width,this.image_height,false,4294967295);
      var _loc3_ = "" + this.image_width;
      while(_loc3_.length < 3)
      {
         _loc3_ = "0" + _loc3_;
      }
      var _loc4_ = "" + this.image_height;
      while(_loc4_.length < 3)
      {
         _loc4_ = "0" + _loc4_;
      }
      this.output = _loc3_ + _loc4_;
      this.draw_interval = setInterval(this,"drawChunk",10);
      this.busy = false;
      return this.resizedBitmap;
   }
   function getBitmapData()
   {
      return this.copyBitmap;
   }
   function getBytesTotal()
   {
      return this.image_width * this.image_height * 2;
   }
   function getBytesScanned()
   {
      return this.pixels * 2;
   }
   function drawChunk()
   {
      if(!this.busy)
      {
         this.busy = true;
         var _loc2_ = 0;
         while(_loc2_ < 250)
         {
            if(!this.nextPixel())
            {
               clearInterval(this.draw_interval);
               this.callback_interval = setInterval(this,"doCallback",25);
               this.busy = true;
               break;
            }
            _loc2_ = _loc2_ + 1;
         }
         this.busy = false;
      }
   }
   function doCallback()
   {
      this.busy = false;
      clearInterval(this.callback_interval);
      if(this.callback_target and this.callback_function)
      {
         this.callback_target[this.callback_function](this.output);
      }
      else
      {
         this.onScanComplete(this.output);
      }
   }
   function onScanComplete(packet)
   {
      this.sendMessage("packet size: " + this.output.length + " bytes","onScanComplete");
   }
   function nextPixel()
   {
      var _loc15_ = this.xpos;
      var _loc14_ = this.ypos;
      var _loc7_ = this.resizedBitmap.getPixel(_loc15_,_loc14_);
      var _loc17_ = _loc7_ >> 16 & 0xFF;
      var _loc20_ = _loc7_ >> 8 & 0xFF;
      var _loc16_ = _loc7_ >> 0 & 0xFF;
      var _loc11_ = Math.round((_loc17_ + 1) / 256 * this.cube);
      var _loc10_ = Math.round((_loc20_ + 1) / 256 * this.cube);
      var _loc13_ = Math.round((_loc16_ + 1) / 256 * this.cube);
      var _loc12_ = _loc11_ * (this.cube + 1) * (this.cube + 1) + _loc10_ * (this.cube + 1) + _loc13_;
      var _loc6_ = this.basen.encode(_loc12_,2);
      this.output += _loc6_;
      if(_loc6_.length != 2)
      {
         trace("bad pixel " + _loc6_);
      }
      var _loc5_ = this.basen.decode(_loc6_);
      var _loc18_ = _loc5_;
      var _loc8_ = _loc5_ % (this.cube + 1);
      _loc5_ = (_loc5_ - _loc8_) / (this.cube + 1);
      var _loc9_ = _loc5_ % (this.cube + 1);
      var _loc19_ = (_loc5_ - _loc9_) / (this.cube + 1);
      if(_loc13_ != _loc8_ and _loc10_ != _loc9_ and _loc11_ != _loc10_)
      {
         this.debug.bad_pixels = this.debug.bad_pixels + 1;
         trace("BAD PIXEL " + this.debug.bad_pixels + ") " + _loc12_ + " != " + _loc18_ + " " + _loc6_);
         trace(this.basen.debug.lastencode);
      }
      var _loc2_ = Math.round(_loc19_ / this.cube * 255).toString(16);
      var _loc4_ = Math.round(_loc9_ / this.cube * 255).toString(16);
      var _loc3_ = Math.round(_loc8_ / this.cube * 255).toString(16);
      while(_loc2_.length < 2)
      {
         _loc2_ = "0" + _loc2_;
      }
      while(_loc4_.length < 2)
      {
         _loc4_ = "0" + _loc4_;
      }
      while(_loc3_.length < 2)
      {
         _loc3_ = "0" + _loc3_;
      }
      this.copyBitmap.setPixel(_loc15_,_loc14_,Number("0x" + _loc2_ + _loc4_ + _loc3_));
      this.pixels = this.pixels + 1;
      if(this.pixels >= this.image_width * this.image_height)
      {
         return false;
      }
      this.xpos = this.xpos + 1;
      if(this.xpos >= this.image_width)
      {
         this.xpos = 0;
         this.ypos = this.ypos + 1;
      }
      return true;
   }
   function error(e, f)
   {
      this.sendMessage(e,f,"ERROR");
   }
   function sendMessage(msg, func, type)
   {
      var _loc1_ = "ImageScanner";
      if(func)
      {
         _loc1_ += "." + func + "()";
      }
      if(type)
      {
         _loc1_ = type + " in " + _loc1_;
      }
      _loc1_ += " :: " + msg;
      trace(_loc1_);
   }
}
