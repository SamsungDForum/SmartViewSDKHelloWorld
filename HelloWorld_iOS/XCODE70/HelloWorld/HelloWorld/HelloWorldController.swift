/*

Copyright (c) 2014 Samsung Electronics

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

import Foundation
import AssetsLibrary
import SmartView



class HelloWorldController: NSObject, ServiceSearchDelegate, ChannelDelegate
{
    /// The service discovery
    let search = Service.search()
    var app: Application?
    var appURL: String = "http://prod-multiscreen-examples.s3-website-us-west-1.amazonaws.com/examples/helloworld/tv/"
    var channelId: String = "com.samsung.multiscreen.helloworld"
    var isConnecting: Bool = false
    var isConnected: Bool = false
    var services = [Service]()
    
    var selectedService: Service?
    var connectStatus:Bool = false
    
    var totalDurationOfVideo = 0
    var currentPage:Int = 0
    var mediaStyleDict = [String:String] ()
    var currentElement:String?
    
    class var sharedInstance : HelloWorldController
    {
        struct Static
        {
            static var onceToken : dispatch_once_t = 0
            static var instance : HelloWorldController? = nil
        }
        dispatch_once(&Static.onceToken)
        {
            Static.instance = HelloWorldController()
        }
        return Static.instance!
    }

    override init ()
    {
        super.init()
        search.delegate = self
        
    }

    func searchServices()
    {
        search.start()
        updateCastStatus()
    }

    func connect(service: Service)
    {
        if (app == nil){
        app = service.createApplication(NSURL(string: appURL)!,channelURI: channelId, args: nil)
        }
        
        app!.delegate = self
        app!.connectionTimeout = 5
        self.isConnecting = true
        self.isConnected = false
        self.updateCastStatus()
        app!.connect()
    }

    func disconnect()
    {
        if(app != nil){
            app?.disconnect()
        }
    }
    func getCastStatus() -> CastStatus {
        var castStatus = CastStatus.notReady
        if isConnected {
            castStatus = CastStatus.connected
        } else if isConnecting {
            castStatus = CastStatus.connecting
        } else if services.count > 0 {
            castStatus = CastStatus.readyToConnect
        }
        return castStatus
    }
    
    func sendData(data: NSString)
    {
        if isConnected {
            app!.publish(event: "say", message: data)
        }
    }
    
    // MARK: Private Methods

    private func updateCastStatus() {
        // Update the cast button status: Since they may be many cast buttons and
        NSNotificationCenter.defaultCenter().postNotificationName("CastStatusDidChange", object: self, userInfo: ["status":getCastStatus().rawValue])
    }

    private func  runafterDelay()
    {
        let time = dispatch_time(DISPATCH_TIME_NOW,Int64(5.0 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.updateCastStatus()
        }
    }
    // MARK: - ChannelDelegate -

    @objc  func onConnect(client: SmartView.ChannelClient?, error: NSError?)
    {
        if (error != nil) {
            search.start()
            print(error?.localizedDescription)
        }
        isConnecting = false
        isConnected = true
        runafterDelay()
        
    }
    
    @objc func onDisconnect(client: SmartView.ChannelClient?, error: NSError?)
    {
        if (isConnected)
        {
            search.start()
            isConnecting = false
            isConnected = false
            updateCastStatus()
        }
    }
    
    // MARK: - ServiceDiscoveryDelegate Methods -

    // These two delegate method will help us know when to change the cast button status

    @objc func onServiceFound(service: Service) {
        services.append(service)
        updateCastStatus()
    }

    @objc func onServiceLost(service: Service) {
        removeObject(&services,object: service)
        updateCastStatus()
    }

    @objc func onStop() {
        services.removeAll(keepCapacity: false)
    }

    func removeObject<T:Equatable>(inout arr:Array<T>, object:T) -> T? {
        if let found = arr.indexOf(object) {
            return arr.removeAtIndex(found)
        }
        return nil
    }
    
    @objc func onMessage(message: Message)
    {
        NSLog("Message Received")
        print("message is \(message.data) from \(message.from)")
        let item:NSString = message.data as! NSString
        
        print(item)
    }
    
    @objc func onData(message: Message, payload: NSData)
    {
        NSLog("Data Received")
        print("data is \(message.data) from \(message.from) with payload \(payload)")
    }
    
  }