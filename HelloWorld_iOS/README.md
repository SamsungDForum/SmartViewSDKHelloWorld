# SmartViewSDK Hello World Sample App #

##Prerequisite



###1. Library
1. Download library manually [SmartView SDK iOS framework](http://developer.samsung.com/tv/develop/tools/extension-libraries/smart-view-sdk-download):  iOS Package(Mobile)

	add smartview.framework
2. Download and install by [Cocoapods](https://cocoapods.org/pods/smart-view-sdk) (recommended)

		pod 'smart-view-sdk'
	**Note** Application project should be unlocked before fetching pod. To unlock open .xcodeproj in Xcode and click unlock and close. Refer [Cocoapods guide](https://cocoapods.org) for more.

###2. Build Environment
1. This sample app is developed using swift language.
2. Use 'smart-view-sdk' cocoapods. More information at "Install By Cocoapods" http://developer.samsung.com/tv/develop/extension-libraries/smart-view-sdk/sender-apps/ios-sender-app


###3. Recommendation for  iOS framework
1. This sample app includes Podfile with 'smart-view-sdk' as pod item
2. iphoneos+iphonesimulator library: works on devices and simulator( + i386,x86_64)

 **Note**: Apple App Store will reject your app  when you register your app with iphoneos+iphonesimulator framework.
 You need to run shell 'remove\_unused\_archs.sh' to remove unused architectures from the final binary. This script is in the iphoneos+iphonesimulator folder.
refer to: [Stripping Unwanted Architectures From Dynamic Libraries In Xcode](http://ikennd.ac/blog/2015/02/stripping-unwanted-architectures-from-dynamic-libraries-in-xcode/)
 
###4. Discover : Search devices around your mobile.
1. Pressing 'Cast' button in ActionBar, must start search API [search.start()].
2. Populate device list by overriding onFound() & onLost() listeners.
3. Stop device discovery, by calling stop search API [search.stop()].

### 5.Code Snippet with Examples(Swift):

	
```swift

		// Inside HelloWorldController.swift file

         var app: Application?
         static var sharedInstance = PhotoShareController()
         let search = Service.search()
         var services = [Service]()

		/* Start TV Discovery */
		 
            func searchServices() {
                 search.start()
             }

		/*
		 * Method to update (add) new service (tv).
         * event recieved when service(tv) found on Network.
		 */

        @objc func onServiceFound(_ service: Service) {
                services.append(service)
            }

        /*
        * Method to remove lost service (tv).
        * event recieved when service(tv) lost from metwork.
        */

        @objc func onServiceLost(_ service: Service) {
                removeObject(&services,object: service)
            }
		/* Stop TV Discovery */
		public void stopDiscovery() {
			if (null != search)
			{ 
               search.stop()
			}
		}
		
```

##  Launch TV application.

```swift

        func connect(_ service: Service)
        {
            if (app == nil){
            app = service.createApplication(URL(string: appURL)! as AnyObject,channelURI: channelId, args: nil)
            }

            app!.delegate = self
            app!.connectionTimeout = 5
            self.isConnecting = true
            self.isConnected = false
            self.updateCastStatus()
            app!.connect()
        }
       
        @IBAction func DisconnectTV(_ sender:AnyObject) {
            HelloWorldController.sharedInstance.disconnect()
        }
        /* Event recieved When a TV application connects to the channel */
        func onConnect(_ error: NSError?)
        {
            if (error != nil) {
            search.start()
            }
        }

        /* Event recieved When a TV application DisConnects from channel */
        func onDisconnect(_ error: NSError?)
        {
            if (isPlayerConnected)
            {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "onDisconnect"), object: self, userInfo: nil)
                search.start()
            }

        }

```

##  Say Hello to TV.
        
```swift
		
        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            textField.resignFirstResponder()

            if textField.text == ""  {
            return true
            }

            HelloWorldController.sharedInstance.sendData(textField.text! as NSString)
            textField.text = ""
            return true
        }
        func sendData(_ data: NSString)
        {
            if isConnected {
            app!.publish(event: "say", message: data)
            }
        }

```
