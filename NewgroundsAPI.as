class com.Newgrounds.NewgroundsAPI
{
   static var version;
   static var user_email;
   static var movie_id;
   static var debug;
   static var session_id;
   static var publisher_id;
   static var timeout;
   static var connected;
   static var tracker_id;
   static var encryption_key;
   static var user_id;
   static var user_name;
   static var host;
   static var error_format;
   static var normal_format;
   static var link_format;
   static var header_format;
   static var ad_url;
   static var ad_swf_url;
   static var do_echo = false;
   static var GATEWAY_URL = "http://www.ngads.com/gateway_v2.php";
   static var AD_TERMS_URL = "http://www.newgrounds.com/wiki/flashads/terms/";
   static var COMMANDS_WIKI_URL = "http://www.newgrounds.com/wiki/flashapi/commands/";
   static var ad_reset = 0;
   static var save_file = null;
   static var medals = null;
   static var score_page_counts = new Object();
   static var compression_radix = "/g8236klvBQ#&|;Zb*7CEA59%s`Oue1wziFp$rDVY@TKxUPWytSaGHJ>dmoMR^<0~4qNLhc(I+fjn)X";
   static var compressor = new com.Newgrounds.BaseN(com.Newgrounds.NewgroundsAPI.compression_radix);
   static var errors = com.Newgrounds.NewgroundsAPIError.init_codes();
   static var sharedObjects = new Object();
   static var events = {MOVIE_CONNECTED:1,ADS_APPROVED:2,AD_ATTACHED:3,HOST_BLOCKED:4,NEW_VERSION_AVAILABLE:5,EVENT_LOGGED:6,SCORE_POSTED:7,SCORES_LOADED:8,MEDAL_UNLOCKED:9,MEDALS_LOADED:10,FILE_PRIVS_LOADED:11,FILE_SAVED:12};
   static var listeners = com.Newgrounds.NewgroundsAPI.setDefaultListeners();
   static var periods = com.Newgrounds.NewgroundsAPI.getPeriodAliases();
   static var period_aliases = {t:{name:"Today",alias:"TODAY"},p:{name:"Yesterday",alias:"YESTERDAY"},w:{name:"This Week",alias:"THIS_WEEK"},m:{name:"This Month",alias:"THIS_MONTH"},y:{name:"This Year",alias:"THIS_YEAR"},a:{name:"All-Time",alias:"ALL_TIME"}};
   function NewgroundsAPI()
   {
   }
   static function setMovieVersion(v)
   {
      if(v)
      {
         com.Newgrounds.NewgroundsAPI.version = String(v);
      }
   }
   static function setUserEmail(e)
   {
      com.Newgrounds.NewgroundsAPI.user_email = e;
   }
   static function getOfficialVersionURL()
   {
      var _loc1_ = com.Newgrounds.NewgroundsAPI.GATEWAY_URL + "?tracker_id=" + com.Newgrounds.NewgroundsAPI.movie_id + "&command_id=" + com.Newgrounds.NewgroundsAPI.getCommandID("loadOfficalVersion") + "&seed=" + Math.random();
      if(com.Newgrounds.NewgroundsAPI.debug)
      {
         _loc1_ += "&debug=1";
      }
      return _loc1_;
   }
   static function hasUserSession()
   {
      if(com.Newgrounds.NewgroundsAPI.session_id && com.Newgrounds.NewgroundsAPI.publisher_id)
      {
         return true;
      }
      if(_root.NewgroundsAPI_PublisherID && _root.NewgroundsAPI_SessionID)
      {
         return true;
      }
      return false;
   }
   static function isNewgrounds()
   {
      return com.Newgrounds.NewgroundsAPI.publisher_id == 1 || _root.NewgroundsAPI_PublisherID == 1 || com.Newgrounds.NewgroundsAPI.getHost().toLowerCase().indexOf("ungrounded.net") > -1;
   }
   static function hasPublisher()
   {
      return com.Newgrounds.NewgroundsAPI.publisher_id || _root.NewgroundsAPI_PublisherID;
   }
   static function hasUserEmail()
   {
      if(com.Newgrounds.NewgroundsAPI.user_email)
      {
         return true;
      }
      return false;
   }
   static function connectionTimeOut()
   {
      clearInterval(com.Newgrounds.NewgroundsAPI.timeout);
      com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.MOVIE_CONNECTED,false,new com.Newgrounds.NewgroundsAPIError("CONNECTION_FAILED","Connection to NewgroundsAPI gateway timed out."));
   }
   static function connectMovie(m_id, encrypt_key, debug_mode)
   {
      if(com.Newgrounds.NewgroundsAPI.connected)
      {
         return undefined;
      }
      var _loc2_ = function()
      {
         com.Newgrounds.NewgroundsAPI.connectionTimeOut();
      };
      com.Newgrounds.NewgroundsAPI.timeout = setInterval(_loc2_,8000,null);
      if(!m_id)
      {
         com.Newgrounds.NewgroundsAPI.fatalError("NewgroundsAPI.connectMovie() - missing required movie_id parameter","connectMovie");
      }
      com.Newgrounds.NewgroundsAPI.movie_id = String(m_id);
      com.Newgrounds.NewgroundsAPI.tracker_id = Number(com.Newgrounds.NewgroundsAPI.movie_id.substring(0,com.Newgrounds.NewgroundsAPI.movie_id.indexOf(":")));
      com.Newgrounds.NewgroundsAPI.encryption_key = encrypt_key;
      com.Newgrounds.NewgroundsAPI.debug = debug_mode;
      if(_root.NewgroundsAPI_PublisherID)
      {
         com.Newgrounds.NewgroundsAPI.publisher_id = _root.NewgroundsAPI_PublisherID;
         if(_root.NewgroundsAPI_SessionID)
         {
            com.Newgrounds.NewgroundsAPI.session_id = _root.NewgroundsAPI_SessionID;
         }
      }
      else
      {
         com.Newgrounds.NewgroundsAPI.publisher_id = 1;
         com.Newgrounds.NewgroundsAPI.session_id = null;
         com.Newgrounds.NewgroundsAPI.user_id = 0;
         com.Newgrounds.NewgroundsAPI.user_name = "Guest";
      }
      if(_root.NewgroundsAPI_UserName)
      {
         com.Newgrounds.NewgroundsAPI.user_name = _root.NewgroundsAPI_UserName;
      }
      if(_root.NewgroundsAPI_UserID)
      {
         com.Newgrounds.NewgroundsAPI.user_id = _root.NewgroundsAPI_UserID;
      }
      com.Newgrounds.NewgroundsAPI.connected = true;
      com.Newgrounds.NewgroundsAPI.sendCommand("connectMovie",{host:com.Newgrounds.NewgroundsAPI.getHost(),movie_version:com.Newgrounds.NewgroundsAPI.version});
   }
   static function getHost()
   {
      if(!com.Newgrounds.NewgroundsAPI.host)
      {
         var _loc1_ = _url;
         if(_loc1_.indexOf("http://") > -1 or _loc1_.indexOf("https://") > -1)
         {
            com.Newgrounds.NewgroundsAPI.host = _loc1_.split("/")[2].toLowerCase();
         }
         else
         {
            com.Newgrounds.NewgroundsAPI.host = "localhost";
         }
      }
      return com.Newgrounds.NewgroundsAPI.host;
   }
   static function loadNewgrounds()
   {
      com.Newgrounds.NewgroundsAPI.sendCommand("loadNewgrounds",{host:com.Newgrounds.NewgroundsAPI.getHost()},true);
   }
   static function loadMySite()
   {
      com.Newgrounds.NewgroundsAPI.sendCommand("loadMySite",{host:com.Newgrounds.NewgroundsAPI.getHost()});
   }
   static function loadCustomLink(link)
   {
      com.Newgrounds.NewgroundsAPI.sendCommand("loadCustomLink",{host:com.Newgrounds.NewgroundsAPI.getHost(),link:link},true);
   }
   static function logCustomEvent(event)
   {
      com.Newgrounds.NewgroundsAPI.sendCommand("logCustomEvent",{host:com.Newgrounds.NewgroundsAPI.getHost(),event:event});
   }
   static function postScore(score, value, get_best)
   {
      if(!score or value == undefined)
      {
         com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID("postScore")},new com.Newgrounds.NewgroundsAPIError("MISSING_PARAM","missing required parameter(s)"));
         return undefined;
      }
      com.Newgrounds.NewgroundsAPI.sendSecureCommand("postScore",{score:score,value:value,get_best:get_best});
   }
   static function getTodaysScores(score, params)
   {
      com.Newgrounds.NewgroundsAPI.getScores(score,"t",params,"getTodaysScores");
   }
   static function getYesterdaysScores(score, params)
   {
      com.Newgrounds.NewgroundsAPI.getScores(score,"y",params,"getYesterdaysScores");
   }
   static function getThisWeeksScores(score, params)
   {
      com.Newgrounds.NewgroundsAPI.getScores(score,"w",params,"getThisWeeksScores");
   }
   static function getThisMonthsScores(score, params)
   {
      com.Newgrounds.NewgroundsAPI.getScores(score,"m",params,"getThisMonthsScores");
   }
   static function getThisYearsScores(score, params)
   {
      com.Newgrounds.NewgroundsAPI.getScores(score,"y",params,"getThisYearsScores");
   }
   static function getAlltimeScores(score, params)
   {
      com.Newgrounds.NewgroundsAPI.getScores(score,"a",params,"getAlltimeScores");
   }
   static function getScores(score, period, params, command_name)
   {
      if(!score)
      {
         com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID(command_name)},new com.Newgrounds.NewgroundsAPIError("MISSING_PARAM","missing required score name"));
         return undefined;
      }
      if(!params)
      {
         params = new Object();
      }
      if(!com.Newgrounds.NewgroundsAPI.hasUserSession())
      {
         com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.SCORES_LOADED,false,new com.Newgrounds.NewgroundsAPIError("SITE_ID_REQUIRED","Host \'" + com.Newgrounds.NewgroundsAPI.getHost() + "\' does not have high scores enabled"));
         return undefined;
      }
      params.publisher_id = com.Newgrounds.NewgroundsAPI.publisher_id;
      params.period = period;
      params.score = score;
      if(params.user_id)
      {
         var _loc3_ = period;
      }
      else
      {
         _loc3_ = period + "-u";
      }
      if(com.Newgrounds.NewgroundsAPI.score_page_counts[_loc3_] == undefined)
      {
         params.request_page_count = true;
      }
      com.Newgrounds.NewgroundsAPI.sendCommand("getScores",params);
   }
   static function unlockMedal(medal, get_score)
   {
      if(!medal)
      {
         com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID("unlockMedal")},new com.Newgrounds.NewgroundsAPIError("MISSING_PARAM","missing required medal name"));
         return undefined;
      }
      var _loc1_ = new Object();
      _loc1_.medal = medal;
      if(get_score)
      {
         _loc1_.get_score = get_score;
      }
      com.Newgrounds.NewgroundsAPI.sendSecureCommand("unlockMedal",_loc1_);
   }
   static function loadMedals()
   {
      if(com.Newgrounds.NewgroundsAPI.medals)
      {
         com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.MEDALS_LOADED,true,{medals:com.Newgrounds.NewgroundsAPI.medals});
         return undefined;
      }
      var _loc1_ = new Object();
      if(com.Newgrounds.NewgroundsAPI.hasUserSession())
      {
         _loc1_.publisher_id = com.Newgrounds.NewgroundsAPI.publisher_id;
         _loc1_.user_id = com.Newgrounds.NewgroundsAPI.user_id;
      }
      com.Newgrounds.NewgroundsAPI.sendCommand("getMedals",_loc1_);
   }
   static function getMedals()
   {
      return com.Newgrounds.NewgroundsAPI.medals;
   }
   static function saveLocal(save_id, save_data, size_allocation)
   {
      if(!com.Newgrounds.NewgroundsAPI.sharedObjects[save_id])
      {
         com.Newgrounds.NewgroundsAPI.sharedObjects[save_id] = SharedObject.getLocal("ng_ap_secure_" + com.Newgrounds.NewgroundsAPI.movie_id + "_" + save_id);
      }
      com.Newgrounds.NewgroundsAPI.sharedObjects[save_id].data[save_id] = com.Newgrounds.NewgroundsAPI.encodeData(save_data);
      com.Newgrounds.NewgroundsAPI.sharedObjects[save_id].flush();
   }
   static function loadLocal(save_id)
   {
      if(!com.Newgrounds.NewgroundsAPI.sharedObjects[save_id])
      {
         com.Newgrounds.NewgroundsAPI.sharedObjects[save_id] = SharedObject.getLocal("ng_ap_secure_" + com.Newgrounds.NewgroundsAPI.movie_id + "_" + save_id);
      }
      com.Newgrounds.NewgroundsAPI.sharedObjects[save_id].flush();
      if(com.Newgrounds.NewgroundsAPI.sharedObjects[save_id].data[save_id])
      {
         return com.Newgrounds.NewgroundsAPI.decodeData(com.Newgrounds.NewgroundsAPI.sharedObjects[save_id].data[save_id]);
      }
      return null;
   }
   static function encodeData(data)
   {
      return com.Newgrounds.NewgroundsAPI.compressHex(com.Newgrounds.RC4.encrypt(com.Newgrounds.JSON.encode(data),com.Newgrounds.NewgroundsAPI.encryption_key));
   }
   static function decodeData(base)
   {
      return com.Newgrounds.JSON.decode(com.Newgrounds.RC4.decrypt(com.Newgrounds.NewgroundsAPI.uncompressHex(base),com.Newgrounds.NewgroundsAPI.encryption_key));
   }
   static function compressHex(hex_value)
   {
      var _loc5_ = hex_value.length % 6;
      var _loc4_ = "";
      var _loc1_ = 0;
      while(_loc1_ < hex_value.length)
      {
         var _loc2_ = Number("0x" + hex_value.substr(_loc1_,6));
         _loc4_ += com.Newgrounds.NewgroundsAPI.compressor.encode(_loc2_,4);
         _loc1_ += 6;
      }
      return _loc5_ + _loc4_;
   }
   static function uncompressHex(base_value)
   {
      var _loc8_ = Number(base_value.charAt(0));
      var _loc7_ = "";
      var _loc3_ = undefined;
      var _loc2_ = 1;
      while(_loc2_ < base_value.length)
      {
         var _loc6_ = base_value.substr(_loc2_,4);
         var _loc5_ = com.Newgrounds.NewgroundsAPI.compressor.decode(_loc6_);
         var _loc1_ = com.Newgrounds.NewgroundsAPI.dec2hex(_loc5_);
         if(_loc2_ + 4 < base_value.length)
         {
            _loc3_ = 6;
         }
         else
         {
            _loc3_ = _loc8_;
         }
         while(_loc1_.length < _loc3_)
         {
            _loc1_ = "0" + _loc1_;
         }
         _loc7_ += _loc1_;
         _loc2_ += 4;
      }
      return _loc7_;
   }
   static function dec2hex(dec)
   {
      var _loc4_ = "0123456789ABCDEF";
      var _loc3_ = "";
      while(dec > 0)
      {
         var _loc2_ = dec % 16;
         _loc3_ = _loc4_.charAt(_loc2_) + _loc3_;
         dec = (dec - _loc2_) / 16;
      }
      return _loc3_;
   }
   static function saveFile(folder, filename, contents, thumbnail_source)
   {
      if(!com.Newgrounds.NewgroundsAPI.save_file)
      {
         com.Newgrounds.NewgroundsAPI.save_file = new com.Newgrounds.NewgroundsAPISaveFile(com.Newgrounds.NewgroundsAPI.movie_id,folder,filename);
         com.Newgrounds.NewgroundsAPI.save_file.setContents(contents);
         if(thumbnail_source)
         {
            com.Newgrounds.NewgroundsAPI.save_file.setThumbnail(thumbnail_source);
         }
         com.Newgrounds.NewgroundsAPI.save_file.onError = function(msg)
         {
            var _loc1_ = new com.Newgrounds.NewgroundsAPIError("PERMISSION_DENIED",msg);
            com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID("saveFile")},_loc1_);
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.FILE_SAVED,false,_loc1_);
         };
         com.Newgrounds.NewgroundsAPI.save_file.onCancel = function(msg)
         {
            var _loc1_ = new com.Newgrounds.NewgroundsAPIError("USER_CANCELLED",msg);
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.FILE_SAVED,false,_loc1_);
         };
         com.Newgrounds.NewgroundsAPI.save_file.submit();
      }
      else
      {
         var _loc1_ = new com.Newgrounds.NewgroundsAPIError("UPLOAD_IN_PROGRESS","Please wait for the previous file to finish uploading");
         com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID("saveFile")},_loc1_);
         com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.FILE_SAVED,false,_loc1_);
      }
   }
   static function checkFilePrivs(folder, filename)
   {
      if(com.Newgrounds.NewgroundsAPI.user_id)
      {
         var _loc1_ = com.Newgrounds.NewgroundsAPI.user_id;
      }
      else
      {
         _loc1_ = 0;
      }
      var _loc2_ = {folder:folder,filename:filename,user_id:_loc1_,publisher_id:com.Newgrounds.NewgroundsAPI.publisher_id};
      com.Newgrounds.NewgroundsAPI.sendCommand("checkFilePrivs",_loc2_);
   }
   static function finishFileSave(folder, filename, description, share, file, thumbnail)
   {
      var _loc2_ = undefined;
      _loc2_ = {folder:folder,filename:filename,description:description,share:share};
      var _loc1_ = undefined;
      _loc1_ = {file:file,thumbnail:thumbnail};
      com.Newgrounds.NewgroundsAPI.sendSecureCommand("saveFile",_loc2_,null,_loc1_);
   }
   static function getFiles(folder, options)
   {
      var _loc7_ = {name:1,date:2,score:3};
      var _loc2_ = {user_only:false,sort_on:"date",page:1,results_per_page:20,sort_descending:true};
      var _loc6_ = new Array();
      for(var _loc10_ in _loc7_)
      {
         _loc6_.push("\'" + _loc10_ + "\'");
      }
      var _loc4_ = new Array();
      for(var _loc9_ in _loc2_)
      {
         _loc4_.push("\'" + _loc9_ + "\'");
      }
      if(options.sort_descending && !_loc7_[options.sort_descending])
      {
         var _loc3_ = new com.Newgrounds.NewgroundsAPIError("MISSING_PARAM","\'" + options.sort_descending + "\' is not a valid sort_on value.  Valid values are: " + _loc6_.join(", "));
         com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID("getFiles")},_loc3_);
         delete options.sort_descending;
      }
      var _loc8_ = undefined;
      if(options)
      {
         for(_loc10_ in options)
         {
            if(_loc2_[_loc10_] == undefined)
            {
               _loc3_ = new com.Newgrounds.NewgroundsAPIError("MISSING_PARAM","\'" + _loc10_ + "\' is not a valid option.  Valid options are: " + _loc4_.join(", "));
               com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID("getFiles")},_loc3_);
               delete options[_loc10_];
            }
            else if(typeof options[_loc10_] != typeof _loc2_[_loc10_])
            {
               _loc3_ = new com.Newgrounds.NewgroundsAPIError("MISSING_PARAM","option \'" + _loc10_ + "\' should be the following type: " + typeof _loc2_[_loc10_]);
               com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID("getFiles")},_loc3_);
               delete options[_loc10_];
            }
         }
         _loc8_ = options;
      }
      else
      {
         _loc8_ = new Object();
      }
      if(com.Newgrounds.NewgroundsAPI.hasUserSession())
      {
         _loc8_.publisher_id = com.Newgrounds.NewgroundsAPI.publisher_id;
         _loc8_.user_id = com.Newgrounds.NewgroundsAPI.user_id;
      }
      _loc8_.folder = folder;
      com.Newgrounds.NewgroundsAPI.sendCommand("getFiles",_loc8_);
   }
   static function getConfirmation(command_name, event, msg, target, confirm, cancel)
   {
      var _loc1_ = new com.Newgrounds.NewgroundsAPIError("CONFIRM_REQUEST",msg);
      _loc1_.confirm = function()
      {
         target[confirm]();
      };
      _loc1_.cancel = function()
      {
         target[cancel]();
      };
      _loc1_.command = com.Newgrounds.NewgroundsAPI.getCommandID(command_name);
      com.Newgrounds.NewgroundsAPI.callListener(event,false,_loc1_);
   }
   static function doBlockHost(event)
   {
      _root.stop();
      com.Newgrounds.NewgroundsAPI.initTextFormats();
      _root.createEmptyMovieClip("NGAPI_deny_host_overlay",_root.getNextHighestDepth());
      _root.NGAPI_deny_host_overlay.lineStyle(20,0,100);
      _root.NGAPI_deny_host_overlay.beginFill(6684672);
      _root.NGAPI_deny_host_overlay.moveTo(0,0);
      _root.NGAPI_deny_host_overlay.lineTo(Stage.width,0);
      _root.NGAPI_deny_host_overlay.lineTo(Stage.width,Stage.height);
      _root.NGAPI_deny_host_overlay.lineTo(0,Stage.height);
      _root.NGAPI_deny_host_overlay.lineTo(0,0);
      _root.NGAPI_deny_host_overlay.endFill();
      var _loc2_ = "This movie has not been approved for use on " + com.Newgrounds.NewgroundsAPI.getHost() + ".";
      _loc2_ += "\r\rFor an aproved copy, please visit:\r";
      var _loc4_ = _loc2_.length;
      _loc2_ += event.data.movie_url;
      var _loc3_ = _loc2_.length;
      _root.NGAPI_deny_host_overlay.createTextField("mousekill",100,0,0,Stage.width,Stage.height);
      _root.NGAPI_deny_host_overlay.createTextField("error",101,(Stage.width - 400) / 2,Stage.height / 2 - 100,400,200);
      _root.NGAPI_deny_host_overlay.error.text = "ERROR!";
      _root.NGAPI_deny_host_overlay.error.setTextFormat(com.Newgrounds.NewgroundsAPI.error_format);
      _root.NGAPI_deny_host_overlay.createTextField("message",102,(Stage.width - 400) / 2,Stage.height / 2,400,200);
      _root.NGAPI_deny_host_overlay.message.text = _loc2_;
      _root.NGAPI_deny_host_overlay.message.multiline = true;
      _root.NGAPI_deny_host_overlay.message.wordWrap = true;
      _root.NGAPI_deny_host_overlay.message.html = true;
      _root.NGAPI_deny_host_overlay.message.setTextFormat(com.Newgrounds.NewgroundsAPI.normal_format);
      com.Newgrounds.NewgroundsAPI.link_format.url = event.data.redirect_url;
      _root.NGAPI_deny_host_overlay.message.setTextFormat(_loc4_,_loc3_,com.Newgrounds.NewgroundsAPI.link_format);
   }
   static function onNewVersionAvailable(event)
   {
      _root.stop();
      com.Newgrounds.NewgroundsAPI.initTextFormats();
      var _loc2_ = new Object();
      _loc2_.x = Stage.width / 2;
      _loc2_.y = Stage.height / 2;
      _root.createEmptyMovieClip("NGAPI_new_version_overlay",_root.getNextHighestDepth());
      _root.NGAPI_new_version_overlay.lineStyle(1,0,100);
      _root.NGAPI_new_version_overlay.beginFill(0,70);
      _root.NGAPI_new_version_overlay.moveTo(-10,-10);
      _root.NGAPI_new_version_overlay.lineTo(-10,1000);
      _root.NGAPI_new_version_overlay.lineTo(1000,1000);
      _root.NGAPI_new_version_overlay.lineTo(1000,-10);
      _root.NGAPI_new_version_overlay.lineTo(-10,-10);
      _root.NGAPI_new_version_overlay.endFill();
      _root.NGAPI_new_version_overlay.lineStyle(10,0,100);
      _root.NGAPI_new_version_overlay.beginFill(51);
      _root.NGAPI_new_version_overlay.moveTo(_loc2_.x - 240,_loc2_.y - 120);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x + 240,_loc2_.y - 120);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x + 240,_loc2_.y + 80);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x - 240,_loc2_.y + 80);
      _root.NGAPI_new_version_overlay.lineTo(_loc2_.x - 240,_loc2_.y - 120);
      _root.NGAPI_new_version_overlay.endFill();
      _root.NGAPI_new_version_overlay.createEmptyMovieClip("exit",1000);
      _root.NGAPI_new_version_overlay.exit.lineStyle(2,39423,100);
      _root.NGAPI_new_version_overlay.exit.beginFill(0,50);
      _root.NGAPI_new_version_overlay.exit.moveTo(_loc2_.x + 210,_loc2_.y - 110);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 230,_loc2_.y - 110);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 230,_loc2_.y - 90);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 210,_loc2_.y - 90);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 210,_loc2_.y - 110);
      _root.NGAPI_new_version_overlay.exit.endFill();
      _root.NGAPI_new_version_overlay.exit.moveTo(_loc2_.x + 214,_loc2_.y - 106);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 226,_loc2_.y - 94);
      _root.NGAPI_new_version_overlay.exit.moveTo(_loc2_.x + 226,_loc2_.y - 106);
      _root.NGAPI_new_version_overlay.exit.lineTo(_loc2_.x + 214,_loc2_.y - 94);
      _root.NGAPI_new_version_overlay.exit.onMouseUp = function()
      {
         if(_root.NGAPI_new_version_overlay.exit.hitTest(_root._xmouse,_root._ymouse))
         {
            _root.NGAPI_new_version_overlay.removeMovieClip();
         }
      };
      var _loc3_ = "Version " + event.data.movie_version + " is now available at:" + "\n";
      var _loc6_ = _loc3_.length;
      _loc3_ += event.data.movie_url;
      var _loc4_ = _loc3_.length;
      _root.NGAPI_new_version_overlay.createTextField("mouseblocker",99,-10,-10,1000,1000);
      _root.NGAPI_new_version_overlay.createTextField("newversion",100,_loc2_.x - 210,_loc2_.y - 90,400,80);
      _root.NGAPI_new_version_overlay.newversion.text = "New Version Available!";
      _root.NGAPI_new_version_overlay.newversion.setTextFormat(com.Newgrounds.NewgroundsAPI.header_format);
      _root.NGAPI_new_version_overlay.createTextField("message",101,(Stage.width - 400) / 2,Stage.height / 2,400,40);
      _root.NGAPI_new_version_overlay.message.text = _loc3_;
      _root.NGAPI_new_version_overlay.message.multiline = true;
      _root.NGAPI_new_version_overlay.message.wordWrap = true;
      _root.NGAPI_new_version_overlay.message.html = true;
      _root.NGAPI_new_version_overlay.message.setTextFormat(com.Newgrounds.NewgroundsAPI.normal_format);
      com.Newgrounds.NewgroundsAPI.link_format.url = event.data.redirect_url;
      _root.NGAPI_new_version_overlay.message.setTextFormat(_loc6_,_loc4_,com.Newgrounds.NewgroundsAPI.link_format);
   }
   static function initTextFormats()
   {
      if(!com.Newgrounds.NewgroundsAPI.error_format)
      {
         com.Newgrounds.NewgroundsAPI.error_format = new TextFormat();
         com.Newgrounds.NewgroundsAPI.error_format.font = "Arial Black";
         com.Newgrounds.NewgroundsAPI.error_format.size = 48;
         com.Newgrounds.NewgroundsAPI.error_format.color = 16711680;
      }
      if(!com.Newgrounds.NewgroundsAPI.header_format)
      {
         com.Newgrounds.NewgroundsAPI.header_format = new TextFormat();
         com.Newgrounds.NewgroundsAPI.header_format.font = "Arial Black";
         com.Newgrounds.NewgroundsAPI.header_format.size = 24;
         com.Newgrounds.NewgroundsAPI.header_format.color = 16777215;
      }
      if(!com.Newgrounds.NewgroundsAPI.normal_format)
      {
         com.Newgrounds.NewgroundsAPI.normal_format = new TextFormat();
         com.Newgrounds.NewgroundsAPI.normal_format.font = "Arial";
         com.Newgrounds.NewgroundsAPI.normal_format.bold = true;
         com.Newgrounds.NewgroundsAPI.normal_format.size = 12;
         com.Newgrounds.NewgroundsAPI.normal_format.color = 16777215;
      }
      if(!com.Newgrounds.NewgroundsAPI.link_format)
      {
         com.Newgrounds.NewgroundsAPI.link_format = new TextFormat();
         com.Newgrounds.NewgroundsAPI.link_format.color = 16776960;
         com.Newgrounds.NewgroundsAPI.link_format.underline = true;
      }
   }
   static function doEvent(e)
   {
      switch(com.Newgrounds.NewgroundsAPI.getCommandName(e.command_id))
      {
         case "connectMovie":
            clearInterval(com.Newgrounds.NewgroundsAPI.timeout);
            com.Newgrounds.NewgroundsAPI.sendMessage("You have successfully connected to the Newgrounds API Gateway");
            com.Newgrounds.NewgroundsAPI.sendMessage("Movie identified as \"" + e.movie_name + "\"");
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.MOVIE_CONNECTED,e.success,{movie_name:e.movie_name});
            var _loc4_ = false;
            if(e.ad_status === -1)
            {
               var _loc6_ = "This movie was not approved to run Flash Ads.";
               com.Newgrounds.NewgroundsAPI.sendWarning(_loc6_);
               com.Newgrounds.NewgroundsAPI.sendWarning("visit " + com.Newgrounds.NewgroundsAPI.AD_TERMS_URL + " to view our approval guidelines");
               if(!e.ad_url)
               {
                  com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.ADS_APPROVED,false,new com.Newgrounds.NewgroundsAPIError("FLASH_ADS_NOT_APPROVED",_loc6_));
               }
               else
               {
                  _loc4_ = true;
               }
            }
            else if(e.ad_status === 0)
            {
               _loc6_ = "Flash Ads are currently awaiting approval.";
               com.Newgrounds.NewgroundsAPI.sendNotice(_loc6_);
               if(!e.ad_url)
               {
                  com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.ADS_APPROVED,false,new com.Newgrounds.NewgroundsAPIError("FLASH_ADS_NOT_APPROVED",_loc6_));
               }
               else
               {
                  _loc4_ = true;
               }
            }
            if(e.ad_url)
            {
               com.Newgrounds.NewgroundsAPI.ad_url = unescape(e.ad_url);
               if(!_loc4_)
               {
                  com.Newgrounds.NewgroundsAPI.sendMessage("This movie has been approved to run Flash Ads!");
               }
               com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.ADS_APPROVED,true);
            }
            if(e.deny_host)
            {
               _loc6_ = com.Newgrounds.NewgroundsAPI.getHost() + " does not have permission to run this movie!";
               com.Newgrounds.NewgroundsAPI.sendWarning(_loc6_);
               com.Newgrounds.NewgroundsAPI.sendWarning("\tUpdate your API configuration to unblock " + com.Newgrounds.NewgroundsAPI.getHost());
               com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.HOST_BLOCKED,true,{movie_url:unescape(e.movie_url),redirect_url:com.Newgrounds.NewgroundsAPI.getOfficialVersionURL()});
            }
            if(e.movie_version)
            {
               com.Newgrounds.NewgroundsAPI.sendWarning("According to your API Configuration, this version is out of date.");
               if(com.Newgrounds.NewgroundsAPI.version)
               {
                  com.Newgrounds.NewgroundsAPI.sendWarning("\tThe this movie is version " + com.Newgrounds.NewgroundsAPI.version);
               }
               com.Newgrounds.NewgroundsAPI.sendWarning("\tThe most current version is " + e.movie_version);
               com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.NEW_VERSION_AVAILABLE,true,{movie_version:e.movie_version,movie_url:unescape(e.movie_url),redirect_url:com.Newgrounds.NewgroundsAPI.getOfficialVersionURL()});
            }
            if(e.request_portal_url)
            {
               com.Newgrounds.NewgroundsAPI.sendCommand("setPortalID",{portal_url:_url});
            }
            break;
         case "logCustomEvent":
            if(e.success)
            {
               com.Newgrounds.NewgroundsAPI.sendMessage("Event \'" + e.event + "\' was logged.");
            }
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.EVENT_LOGGED,e.success,{event:e.event});
            break;
         case "postScore":
            var _loc7_ = undefined;
            if(e.success)
            {
               var _loc3_ = "User";
               if(com.Newgrounds.NewgroundsAPI.user_email)
               {
                  _loc3_ = com.Newgrounds.NewgroundsAPI.user_email;
               }
               else if(com.Newgrounds.NewgroundsAPI.user_name)
               {
                  _loc3_ = com.Newgrounds.NewgroundsAPI.user_name;
               }
               com.Newgrounds.NewgroundsAPI.sendMessage(_loc3_ + " posted " + e.value + " to \'" + e.score + "\'");
               _loc7_ = {score:e.score,value:e.value,username:_loc3_};
            }
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.SCORE_POSTED,e.success,_loc7_);
            break;
         case "getScores":
            _loc7_ = new Object();
            if(e.user_id)
            {
               var _loc5_ = e.period;
            }
            else
            {
               _loc5_ = e.period + "-u";
            }
            if(e.total_pages)
            {
               com.Newgrounds.NewgroundsAPI.score_page_counts[_loc5_] = e.total_pages;
            }
            _loc7_.user_id = e.user_id;
            _loc7_.current_page = e.current_page;
            _loc7_.total_pages = com.Newgrounds.NewgroundsAPI.score_page_counts[_loc5_];
            _loc7_.scores = e.scores;
            _loc7_.period = com.Newgrounds.NewgroundsAPI.getPeriodName(e.period);
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.SCORES_LOADED,e.success,_loc7_);
            break;
         case "unlockMedal":
            if(com.Newgrounds.NewgroundsAPI.medals)
            {
               var _loc2_ = 0;
               while(_loc2_ < com.Newgrounds.NewgroundsAPI.medals.length)
               {
                  if(com.Newgrounds.NewgroundsAPI.medals[_loc2_].medal_name === e.medal_name)
                  {
                     com.Newgrounds.NewgroundsAPI.medals[_loc2_].medal_unlocked = true;
                     break;
                  }
                  _loc2_ = _loc2_ + 1;
               }
            }
            _loc7_ = {medal_name:e.medal_name,medal_value:e.medal_value,medal_difficulty:e.medal_difficulty};
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.MEDAL_UNLOCKED,e.success,_loc7_);
            break;
         case "getMedals":
            com.Newgrounds.NewgroundsAPI.medals = e.medals;
            _loc7_ = {medals:e.medals};
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.MEDALS_LOADED,e.success,_loc7_);
            break;
         case "getFiles":
         case "getSystemFiles":
            break;
         case "saveFile":
            com.Newgrounds.NewgroundsAPI.save_file = null;
            _loc7_ = {file_id:e.file_id,filename:e.filename,file_url:e.file_url,thumbnail:e.thumbnail,icon:e.icon};
            com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.FILE_SAVED,e.success,_loc7_);
            break;
         case "checkFilePrivs":
            if(com.Newgrounds.NewgroundsAPI.save_file)
            {
               com.Newgrounds.NewgroundsAPI.save_file.checkPrivs(e);
            }
            else
            {
               _loc7_ = {filename:e.filename,folder:e.folder,can_read:e.can_read,can_write:e.can_write};
               com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.FILE_PRIVS_LOADED,e.success,_loc7_);
            }
      }
   }
   static function setDefaultListeners()
   {
      var _loc1_ = new Array();
      _loc1_[com.Newgrounds.NewgroundsAPI.events.HOST_BLOCKED] = {listener:com.Newgrounds.NewgroundsAPI.doBlockHost};
      _loc1_[com.Newgrounds.NewgroundsAPI.events.NEW_VERSION_AVAILABLE] = {listener:com.Newgrounds.NewgroundsAPI.onNewVersionAvailable};
      return _loc1_;
   }
   static function addEventListener(event, listener, params)
   {
      com.Newgrounds.NewgroundsAPI.listeners[event] = {listener:listener,params:params};
   }
   static function removeEventListener(event)
   {
      delete com.Newgrounds.NewgroundsAPI.listeners[event];
   }
   static function getEventName(event)
   {
      for(var _loc2_ in com.Newgrounds.NewgroundsAPI.events)
      {
         if(com.Newgrounds.NewgroundsAPI.events[_loc2_] == event)
         {
            return _loc2_;
         }
      }
      return undefined;
   }
   static function callListener(event, success, data, target)
   {
      com.Newgrounds.NewgroundsAPI.echo("Fired Event: " + com.Newgrounds.NewgroundsAPI.getEventName(event));
      if(com.Newgrounds.NewgroundsAPI.listeners[event])
      {
         if(data.isError())
         {
            com.Newgrounds.NewgroundsAPI.listeners[event].listener({event:event,success:success,error:data,target:target},com.Newgrounds.NewgroundsAPI.listeners[event].params);
         }
         else
         {
            com.Newgrounds.NewgroundsAPI.listeners[event].listener({event:event,success:success,data:data,target:target},com.Newgrounds.NewgroundsAPI.listeners[event].params);
         }
      }
   }
   static function getCommandName(id)
   {
      return id;
   }
   static function getCommandID(name)
   {
      return name;
   }
   static function getPeriodAliases()
   {
      var _loc1_ = new Object();
      for(var _loc2_ in com.Newgrounds.NewgroundsAPI.period_aliases)
      {
         _loc1_[com.Newgrounds.NewgroundsAPI.period_aliases[_loc2_].alias] = _loc2_;
      }
      return _loc1_;
   }
   static function getPeriodName(p)
   {
      for(var _loc2_ in com.Newgrounds.NewgroundsAPI.period_aliases)
      {
         if(_loc2_ == p)
         {
            return com.Newgrounds.NewgroundsAPI.period_aliases[_loc2_].name;
         }
      }
      return null;
   }
   static function getPeriodAlias(p)
   {
      for(var _loc2_ in com.Newgrounds.NewgroundsAPI.period_aliases)
      {
         if(_loc2_ == p)
         {
            return com.Newgrounds.NewgroundsAPI.period_aliases[_loc2_].alias;
         }
      }
      return null;
   }
   static function sendError(c, e)
   {
      trace("[NewgroundsAPI ERROR] :: " + com.Newgrounds.NewgroundsAPI.getCommandName(c.command_id) + "() - " + e.name + ":" + "\n" + "\t\t\t\t" + e.message);
   }
   static function sendWarning(m, c)
   {
      if(c)
      {
         m += "\r[NewgroundsAPI WARNING] :: \tSee " + com.Newgrounds.NewgroundsAPI.COMMANDS_WIKI_URL + c.toLowerCase() + " for additional information.";
      }
      trace("[NewgroundsAPI WARNING] :: " + m);
   }
   static function sendNotice(m, c)
   {
      if(c)
      {
         m += "\r[NewgroundsAPI NOTICE] :: \tSee " + com.Newgrounds.NewgroundsAPI.COMMANDS_WIKI_URL + c.toLowerCase() + " for additional information.";
      }
      trace("[NewgroundsAPI NOTICE] :: " + m);
   }
   static function fatalError(m, c)
   {
      if(c)
      {
         m += "\r\tSee " + com.Newgrounds.NewgroundsAPI.COMMANDS_WIKI_URL + c.toLowerCase() + " for additional information.";
      }
      throw "***ERROR*** frame=" + _root._currentframe + ", class=NewgroundsAPI" + "\n" + "\n" + m;
   }
   static function sendSecureCommand(command, secure_params, unsecure_params, files)
   {
      if(!com.Newgrounds.NewgroundsAPI.debug && !com.Newgrounds.NewgroundsAPI.hasUserSession() && !com.Newgrounds.NewgroundsAPI.hasUserEmail())
      {
         com.Newgrounds.NewgroundsAPI.sendError({command_id:com.Newgrounds.NewgroundsAPI.getCommandID(command)},new com.Newgrounds.NewgroundsAPIError("IDENTIFICATION_REQUIRED","You must be logged in or provide an e-mail address ( using NewgroundsAPI.setUserEmail(\"name@domain.com\"); ) to use " + command + "()."));
         return undefined;
      }
      if(!command)
      {
         com.Newgrounds.NewgroundsAPI.fatalError("Missing command","sendSecureCommand");
      }
      if(!secure_params)
      {
         com.Newgrounds.NewgroundsAPI.fatalError("Missing secure_params","sendSecureCommand");
      }
      if(!unsecure_params)
      {
         unsecure_params = new Object();
      }
      var _loc2_ = "";
      var _loc1_ = 0;
      while(_loc1_ < 16)
      {
         _loc2_ += com.Newgrounds.NewgroundsAPI.compression_radix.charAt(Math.floor(Math.random() * com.Newgrounds.NewgroundsAPI.compression_radix.length));
         _loc1_ = _loc1_ + 1;
      }
      if(com.Newgrounds.NewgroundsAPI.debug)
      {
         secure_params.session_id = "";
      }
      else
      {
         secure_params.session_id = com.Newgrounds.NewgroundsAPI.session_id;
      }
      secure_params.as_version = 2;
      secure_params.user_email = com.Newgrounds.NewgroundsAPI.user_email;
      secure_params.publisher_id = com.Newgrounds.NewgroundsAPI.publisher_id;
      secure_params.seed = _loc2_;
      secure_params.command_id = com.Newgrounds.NewgroundsAPI.getCommandID(command);
      var _loc8_ = com.Newgrounds.MD5.calculate(_loc2_);
      var _loc6_ = com.Newgrounds.RC4.encrypt(com.Newgrounds.JSON.encode(secure_params),com.Newgrounds.NewgroundsAPI.encryption_key);
      var _loc7_ = _loc8_ + _loc6_;
      unsecure_params.secure = com.Newgrounds.NewgroundsAPI.compressHex(_loc7_);
      com.Newgrounds.NewgroundsAPI.sendCommand("securePacket",unsecure_params,false,files);
   }
   static function sendCommand(command, params, open_browser, files)
   {
      if(!com.Newgrounds.NewgroundsAPI.connected and command != "connectMovie")
      {
         var _loc11_ = "NewgroundsAPI." + command + "() - NewgroundsAPI.connectMovie() must be called before this command can be called" + "\n";
         com.Newgrounds.NewgroundsAPI.fatalError(_loc11_,"connectMovie");
      }
      if(open_browser)
      {
         var _loc1_ = new Object();
      }
      else
      {
         _loc1_ = new LoadVars();
      }
      _loc1_.command_id = com.Newgrounds.NewgroundsAPI.getCommandID(command);
      _loc1_.tracker_id = com.Newgrounds.NewgroundsAPI.movie_id;
      if(com.Newgrounds.NewgroundsAPI.debug)
      {
         _loc1_.debug = com.Newgrounds.NewgroundsAPI.debug;
      }
      if(params)
      {
         for(var _loc8_ in params)
         {
            _loc1_[_loc8_] = params[_loc8_];
         }
      }
      if(files)
      {
         for(_loc8_ in files)
         {
            _loc1_[_loc8_] = files[_loc8_];
         }
      }
      com.Newgrounds.NewgroundsAPI.echo("OUTPUT: \r" + com.Newgrounds.JSON.encode(_loc1_) + "\n");
      if(open_browser)
      {
         var _loc5_ = com.Newgrounds.NewgroundsAPI.GATEWAY_URL + "?seed=" + Math.random();
         for(_loc8_ in _loc1_)
         {
            _loc5_ += "&" + escape(_loc8_) + "=" + escape(_loc1_[_loc8_]);
         }
         getURL(_loc5_,"_blank");
         _loc1_.removeMovieClip();
      }
      else
      {
         var _loc9_ = new LoadVars();
         _loc9_.onData = function(data)
         {
            com.Newgrounds.NewgroundsAPI.echo("INPUT: \r" + data + "\n");
            if(data)
            {
               var _loc1_ = com.Newgrounds.JSON.decode(data);
            }
            else
            {
               _loc1_ = {success:false};
            }
            if(!_loc1_.success)
            {
               var _loc3_ = new com.Newgrounds.NewgroundsAPIError(_loc1_.error_code,_loc1_.error_msg);
               com.Newgrounds.NewgroundsAPI.sendError(_loc1_,_loc3_);
            }
            else
            {
               com.Newgrounds.NewgroundsAPI.doEvent(_loc1_);
            }
         };
         var _loc4_ = new Array();
         for(var _loc7_ in _loc1_)
         {
            _loc4_.push(_loc7_ + "=" + escape(_loc1_[_loc7_]));
         }
         com.Newgrounds.NewgroundsAPI.echo("POST " + com.Newgrounds.NewgroundsAPI.GATEWAY_URL + "?" + _loc4_.join("&"));
         _loc1_.sendAndLoad(com.Newgrounds.NewgroundsAPI.GATEWAY_URL + "?seed=" + Math.random(),_loc9_,"POST");
      }
   }
   static function renderAd(target)
   {
      if(com.Newgrounds.NewgroundsAPI.ad_swf_url)
      {
         target.background = target.createEmptyMovieClip("background",100);
         target.background.beginFill(0);
         target.background.moveTo(0,0);
         target.background.lineTo(300,0);
         target.background.lineTo(300,250);
         target.background.lineTo(0,250);
         target.background.lineTo(0,0);
         target.background.endFill();
         target.mask = target.createEmptyMovieClip("mask",101);
         target.mask.beginFill(0);
         target.mask.moveTo(0,0);
         target.mask.lineTo(300,0);
         target.mask.lineTo(300,250);
         target.mask.lineTo(0,250);
         target.mask.lineTo(0,0);
         target.mask.endFill();
         target.clip = target.createEmptyMovieClip("clip",102);
         target.clip.ad = target.clip.createEmptyMovieClip("ad",100);
         target.clip.setMask(target.mask);
         loadMovie(com.Newgrounds.NewgroundsAPI.ad_swf_url,target.clip.ad);
         com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.AD_ATTACHED,true,null,target);
      }
      else
      {
         com.Newgrounds.NewgroundsAPI.callListener(com.Newgrounds.NewgroundsAPI.events.AD_ATTACHED,false,new com.Newgrounds.NewgroundsAPIError("FLASH_ADS_NOT_APPROVED","Unable to render ad"));
      }
   }
   static function attachFlashAd(target)
   {
      System.security.allowDomain("http://server.cpmstar.com");
      System.security.allowDomain("http://www.cpmstar.com");
      System.security.allowDomain("https://server.cpmstar.com");
      System.security.allowDomain("https://www.cpmstar.com");
      System.security.allowInsecureDomain("http://server.cpmstar.com");
      System.security.allowInsecureDomain("http://www.cpmstar.com");
      System.security.allowInsecureDomain("https://server.cpmstar.com");
      System.security.allowInsecureDomain("https://www.cpmstar.com");
      com.Newgrounds.NewgroundsAPI.sendMessage("You may get a security sandbox violation from this ad.  This is nothing to worry about!");
      if(com.Newgrounds.NewgroundsAPI.resetAdTimer())
      {
         if(com.Newgrounds.NewgroundsAPI.ad_url)
         {
            var _loc1_ = new LoadVars();
            _loc1_.onData = function(data)
            {
               if(data)
               {
                  com.Newgrounds.NewgroundsAPI.ad_swf_url = data;
               }
               else
               {
                  com.Newgrounds.NewgroundsAPI.ad_swf_url = null;
               }
               com.Newgrounds.NewgroundsAPI.renderAd(target);
            };
            if(com.Newgrounds.NewgroundsAPI.ad_url.indexOf("?") > -1)
            {
               _loc1_.load(com.Newgrounds.NewgroundsAPI.ad_url + "&random=" + Math.random());
            }
            else
            {
               _loc1_.load(com.Newgrounds.NewgroundsAPI.ad_url + "?random=" + Math.random());
            }
         }
      }
      else
      {
         com.Newgrounds.NewgroundsAPI.renderAd(target);
      }
   }
   static function resetAdTimer()
   {
      if(!com.Newgrounds.NewgroundsAPI.ad_url)
      {
         return false;
      }
      var _loc1_ = new Date();
      if(_loc1_.getTime() >= com.Newgrounds.NewgroundsAPI.ad_reset)
      {
         com.Newgrounds.NewgroundsAPI.ad_reset = _loc1_.getTime() + 300000;
         return true;
      }
      return false;
   }
   static function sendMessage(m, r)
   {
      var _loc1_ = "[NewgroundsAPI] :: " + m;
      if(r)
      {
         return _loc1_;
      }
      trace(_loc1_);
   }
   static function echo(m)
   {
      if(com.Newgrounds.NewgroundsAPI.do_echo)
      {
         trace(m);
      }
   }
}
