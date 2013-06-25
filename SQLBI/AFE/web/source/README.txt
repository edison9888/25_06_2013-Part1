PROCDURE FOR PRODUCTION
=========================


  1) Enter into the current directory [where the index.html is residing/project root/here it is the dir "source"]
      
	  *** Make sure that the index.html is using "ext-debug.js" and no loader setting
	  
  2) "sencha create jsb -a index.html -p app.jsb3"
  
  3) "sencha build -p app.jsb3 -d ."
  
  4) Then you will get an "app-all.js" file in the current directory.
  
  5) GO TO "resources/sass/" and compile sass.
  
  6) Now copy the following files into "production" directory
  
       *Clear the dir production/resources/js ,css ,data and images
	   
       Copy files to the following dir,
	   
	    1) production/js/ 
		
		        * ext-all.js from  sdk/
				* app-all.js from  .[current directory]
				* all js files from  resources/js/util/*.*
				
		2) production/css/

		        * ext-all.css from sdk/resources/css/
                * all files from resources/css/
				
		3) 2) production/images/
		
		      * copy all images from resources/images/
			  
        4)[optional] resources/data/
		
		        * all files from resources/data/
		
		
  7) Adjust the production/index.html accordingly				