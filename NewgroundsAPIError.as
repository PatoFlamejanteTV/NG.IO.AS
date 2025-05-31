class com.Newgrounds.NewgroundsAPIError
{
   var message;
   var name;
   var alias;
   static var aliases = new Array("UNKNOWN_ERROR","INVALID_API_ID","MISSING_PARAM","INVALID_STAT_ID","INVALID_COMMAND_ID","FLASH_ADS_NOT_APPROVED","PERMISSION_DENIED","IDENTIFICATION_REQUIRED","INVALID_EMAIL_ADDRESS","BANNED_USER","SESSION_EXPIRED","INVALID_SCORE","INVALID_MEDAL","INVALID_FOLDER","FILE_NOT_FOUND","SITE_ID_REQUIRED","UPLOAD_IN_PROGRESS","USER_CANCELLED","CONFIRM_REQUEST","CONNECTION_FAILED");
   static var always_caps = new Array("API","URL","ID");
   static var error_codes = com.Newgrounds.NewgroundsAPIError.init_codes();
   static var error_names = com.Newgrounds.NewgroundsAPIError.init_names();
   var code = 0;
   function NewgroundsAPIError(error, msg)
   {
      if(Number(error).toString() == String(error))
      {
         error = Number(error);
      }
      else if(com.Newgrounds.NewgroundsAPIError.error_codes[String(error)])
      {
         error = com.Newgrounds.NewgroundsAPIError.error_codes[String(error)];
      }
      else
      {
         error = 0;
      }
      this.code = error;
      this.message = msg;
      this.name = com.Newgrounds.NewgroundsAPIError.error_names[error];
      this.alias = com.Newgrounds.NewgroundsAPIError.aliases[error];
   }
   static function init_codes()
   {
      var _loc2_ = new Object();
      var _loc1_ = 0;
      while(_loc1_ < com.Newgrounds.NewgroundsAPIError.aliases.length)
      {
         _loc2_[com.Newgrounds.NewgroundsAPIError.aliases[_loc1_]] = _loc1_;
         _loc1_ = _loc1_ + 1;
      }
      return _loc2_;
   }
   static function init_names()
   {
      var _loc5_ = new Array();
      var _loc3_ = 0;
      while(_loc3_ < com.Newgrounds.NewgroundsAPIError.aliases.length)
      {
         var _loc2_ = com.Newgrounds.NewgroundsAPIError.aliases[_loc3_].toLowerCase().split("_");
         var _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc2_[_loc1_] = _loc2_[_loc1_].substr(0,1).toUpperCase() + _loc2_[_loc1_].substr(1,_loc2_[_loc1_].length);
            for(var _loc4_ in com.Newgrounds.NewgroundsAPIError.always_caps)
            {
               if(_loc2_[_loc1_].toUpperCase() == com.Newgrounds.NewgroundsAPIError.always_caps[_loc4_])
               {
                  _loc2_[_loc1_] = _loc2_[_loc1_].toUpperCase();
               }
            }
            _loc1_ = _loc1_ + 1;
         }
         _loc5_[_loc3_] = _loc2_.join(" ");
         _loc3_ = _loc3_ + 1;
      }
      return _loc5_;
   }
   function isError()
   {
      return true;
   }
}
