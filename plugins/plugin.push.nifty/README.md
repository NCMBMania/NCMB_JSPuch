
#Nifty Cloud for Push Notfication Plugin

##Spec

 - PhoneGap/Cordova2.9 ~
 - iOS/Andorid

##method

###window.NCMB.monaca.setDeviceToken(applicationKey,clientKey,senderId)

Register devicetoken to Nifty server.

 - (String)applicationKey
 
 - (String)clientKey

 - (String)senderId
 
###window.NCMB.monaca.setHandler(callback)

Set the callback when app receive a push notification.

- (function)callback(jsonData)

##Sample

		<!DOCTYPE HTML>
		<html>
		<head>
		    <meta charset="utf-8">
		    <script src="plugins/plugin-loader.js"></script>
		    <link rel="stylesheet" href="plugins/plugin-loader.css">
		    <script>
		        
		        window.addEventListener("load",function()
		        {
					window.NCMB.monaca.setHandler
					(
	                    function(jsonData){
	                        alert("callback :::" + JSON.stringify(jsonData));
	                    }
	                );
	                
	                document.addEventListener("deviceready", function()
	                {
	                    window.NCMB.monaca.setDeviceToken(
	                                               "#####application_key#####",
	                                               "#####client_key#####",
	                                               "#####sender_id#####"
	                                               );
	                }, false);
	                
		        },false);
		        
		    </script>
		</head>
		<body>
		
		<h1>PushNotification Sample</h1>
		
		</body>
		</html>

