//
//  TVDataManager.swift
//  SmartViewSDK
//
//  Created by aseemkapoor on 06/01/17.
//  Copyright © 2017 Samsung. All rights reserved.
//

import Foundation

private let kInfoFile = "connectedTVs.plist"

class TVDataManager: NSObject
{
    
    internal enum TVProperty: Int
    {
        case Name = 0
        case SSID
        case IP
        case MACID
    }
    
    var previousConnectedTVList: NSDictionary?
    var currentUpdatedTVList: Dictionary<String, Dictionary<TVProperty, Any>>?
    
    let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    
    private func pathOfDocument() -> URL?
    {
        if let documents = self.directories.first
        {
            if let urlDocuments = NSURL(string: documents)
            {
                let urlConnectedTVs = urlDocuments.appendingPathComponent(kInfoFile)
                
                return urlConnectedTVs!
            }
        }
        
        
    }
    
    
    internal func getUpdatedListFromDB() -> Dictionary<String, Any>
    {
        return previousConnectedTVList! as! Dictionary<String, Any>
    }
    
    internal func storeTVinDB(/*_ service: Service*/)
    {
        
        
        if let urlFile = pathOfDocument()
        {
            if (previousConnectedTVList?.write(toFile: urlFile.path, atomically: true))!
            {
                print("previousConnectedTVList saved successfully")
            }
        }
        
    }
    
    
    
    private func getListFromDB() -> Dictionary<String, Dictionary<TVProperty, Any>>?
    {
        if let urlFile = pathOfDocument()
        {
            if let loadedDictionary = NSDictionary(contentsOfFile: urlFile.path)
            {
                print(loadedDictionary)
            }
        }
    }
    
    class func testInfoPlist()
    {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if let documents = directories.first {
            if let urlDocuments = NSURL(string: documents) {
                let urlFruits = urlDocuments.appendingPathComponent("fruits.plist")
                let urlDictionary = urlDocuments.appendingPathComponent("dictionary.plist")
                
                print(urlFruits!)
                
                // Write Array to Disk
                let fruits = ["Apple", "Mango", "Pineapple", "Plum", "Apricot"] as NSArray
                let dictionary = ["anArray" : fruits, "aNumber" : 12345, "aBoolean" : true] as NSDictionary
                
                if fruits.write(toFile: urlFruits!.path, atomically: true)
                {
                    print("Fruits Added")
                }
                
                
                if let loadedFruits = NSArray(contentsOfFile: urlFruits!.path)
                {
                    print(loadedFruits)
                }
                
                if dictionary.write(toFile: urlDictionary!.path, atomically: false)
                {
                    print("Dictionary Added")
                }
                // Load from Disk
                if let loadedDictionary = NSDictionary(contentsOfFile: urlDictionary!.path)
                {
                    print(loadedDictionary)
                }
            }
        }
    }
    
    
}
