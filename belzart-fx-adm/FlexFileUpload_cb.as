// Code Behind for FlexFileUpload.mxml


            import mx.core.SoundAsset;
            import mx.controls.Alert;
            import com.newmediateam.fileIO.MultiFileUpload;
            import flash.media.Sound;
            import flash.media.SoundChannel;
            import mx.controls.Button;
            import flash.net.FileFilter;

            public var multiFileUpload:MultiFileUpload;
            
            // Sound to play when all files complete uploading
            [Embed(source="assets/audio/Ding.mp3")]
            public var soundClass:Class;
            public var snd:SoundAsset = new soundClass() as SoundAsset;
            public var sndChannel:SoundChannel;
            
            // Set the File Filters you wish to impose on the applicaton
            public var imageTypes:FileFilter = new FileFilter("Images (*.jpg; *.jpeg; *.gif; *.png)" ,"*.jpg; *.jpeg; *.gif; *.png");
        	public var videoTypes:FileFilter = new FileFilter("Flash Video Files (*.flv)","*.flv");
        	public var documentTypes:FileFilter = new FileFilter("Documents (*.pdf), (*.doc), (*.rtf), (*.txt)",("*.pdf; *.doc; *.rtf, *.txt"));
            
            // Place File Filters into the Array that is passed to the MultiFileUpload instance
            public var filesToFilter:Array = new Array(imageTypes,videoTypes,documentTypes);
            
            public var uploadDestination:String = "http://[yourserver]/MultiFileUpload/upload.cfm";  // Modify this variable to match the  URL of your site
            
            public function initApp():void{
            
	            var postVariables:URLVariables = new URLVariables;
	            postVariables.projectID = 55;
	            postVariables.test ="Hello World";    
	                
	            multiFileUpload = new MultiFileUpload(
	                filesDG,
	                browseBTN,
	                clearButton,
	                delButton,
	                upload_btn,
	                progressbar,
	                uploadDestination,
	                postVariables,
	                350000,
	                filesToFilter
	                );
	            
	           multiFileUpload.addEventListener(Event.COMPLETE,uploadsfinished);
          
           }
           
           public function uploadsfinished(event:Event):void{
           
           		sndChannel=snd.play();
           		
           }