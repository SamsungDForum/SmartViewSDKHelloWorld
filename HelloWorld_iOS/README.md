##Prerequisite



###1. Library
1. [SmartView SDK iOS framework](http://www.samsungdforum.com/AddLibrary/SmartViewDownload):  iOS Package(Mobile)

add smartview.framework


###2. Build Environment
1. This sample app is developed using swift language.
2. Required XCode version 7.2 for XCODE70 and version 8.0 for XCODE80	


###3. Recommendation for  iOS framework
1. This sample app includes SmartView SDK with
2. iphoneos+iphonesimulator library: works on devices and simulator( + i386,x86_64)
> ** Apple App Store will reject your app  when you register your app with iphoneos+iphonesimulator framework.
> So, you should change iphoneos framework finally when you develop iphoneos+iphonesimulator framework, 
> or you should  remove manually that unused architectures from the final binary.
> refer to : [Stripping Unwanted Architectures From Dynamic Libraries In Xcode](http://ikennd.ac/blog/2015/02/stripping-unwanted-architectures-from-dynamic-libraries-in-xcode/)**

## Discover : Search devices around your mobile.
1. Pressing 'Cast' button in ActionBar, must start search API [search.start()].
2. Populate device list by overriding onFound() & onLost() listeners.
3. Stop device discovery, by calling stop search API [search.stop()].

	HelloWorldController.swift
	

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


##  launch a TV application.


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
##  Say Hello to TV.
        
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

