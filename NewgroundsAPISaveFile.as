class com.Newgrounds.NewgroundsAPISaveFile
{
   var tracker_id;
   var folder;
   var filename;
   var contents;
   var thumbnail;
   var icon_url;
   var thumbnail_url;
   var description;
   var scan;
   var scanner;
   var can_write = false;
   var share = true;
   function NewgroundsAPISaveFile(tracker_id, folder, filename)
   {
      this.tracker_id = tracker_id;
      this.folder = folder;
      this.filename = filename;
      this.contents = null;
      this.thumbnail = null;
      this.icon_url = null;
      this.thumbnail_url = null;
   }
   function setDescription(description)
   {
      this.description = description;
   }
   function setShared(share)
   {
      this.share = share;
   }
   function setContents(contents)
   {
      this.contents = contents;
   }
   function setThumbnail(thumb)
   {
      if(thumb)
      {
         this.thumbnail = thumb;
      }
      else
      {
         this.thumbnail = null;
      }
   }
   function onError(msg)
   {
      trace("[NewgroundsAPISaveFile ERROR] :: " + msg);
   }
   function onCancel(msg)
   {
      trace("[NewgroundsAPISaveFile] :: " + msg);
   }
   function submit()
   {
      this.scan = null;
      com.Newgrounds.NewgroundsAPI.checkFilePrivs(this.folder,this.filename);
   }
   function checkPrivs(p)
   {
      if(p.success)
      {
         if(p.can_write)
         {
            this.can_write = p.can_write;
            if(p.exists)
            {
               com.Newgrounds.NewgroundsAPI.getConfirmation("saveFile",com.Newgrounds.NewgroundsAPI.events.FILE_SAVED,"File \'" + this.filename + "\' exists, overwrite?",this,"startFile","cancelFile");
            }
            else
            {
               this.startFile();
            }
         }
         else
         {
            this.onError("This filename is owned by another user.");
         }
      }
      else
      {
         this.onError("There was a problem looking up your file\'s details");
      }
   }
   function cancelFile()
   {
      this.onCancel("Overwrite was cancelled");
   }
   function startFile()
   {
      if(this.can_write)
      {
         if(this.thumbnail)
         {
            this.scanner = new com.Newgrounds.ImageScanner(this.thumbnail);
            this.scanner.setCallback(this,"writeFile");
            this.scanner.startScan(100,100,true);
         }
         else
         {
            this.writeFile();
         }
      }
      else
      {
         this.onError("You cannot write to filename \"" + this.filename + "\"");
      }
   }
   function writeFile(img)
   {
      trace("FINISHED");
      com.Newgrounds.NewgroundsAPI.finishFileSave(this.folder,this.filename,this.description,this.share,com.Newgrounds.JSON.encode(this.contents),img);
   }
}
