//
//  DeviceViewController.swift
//
//  Created by Om on 5/3/16.
//  Copyright © 2016 Samsung. All rights reserved.
//

import Foundation
import UIKit
import SmartView

enum CastStatus: String {
    case notReady = "notReady"
    case readyToConnect = "readyToConnect"
    case connecting = "connecting"
    case connected = "connected"
}
class  DeviceViewController: UIViewController,UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
     let  picker = UIImagePickerController()

    
    @IBOutlet  var imageView: UIImageView!
    @IBOutlet weak var mDisConnectTvButton: UIButton!
    @IBOutlet weak var deviceListButton: UIButton!
    var didFindServiceObserver: AnyObject? = nil
    var didRemoveServiceObserver: AnyObject? = nil
    
    var castStatus: CastStatus = CastStatus.notReady
    {
        didSet {
            if deviceListButton.imageView!.isAnimating() {
                deviceListButton.imageView!.stopAnimating()
            }
            
            switch castStatus {
            case .notReady:
                let castImage = UIImage(named: "cast_off.png")?.imageWithRenderingMode(.AlwaysTemplate)
                deviceListButton.setImage(castImage, forState: UIControlState.Normal)
                deviceListButton.tintColor = UIColor.blackColor()
                deviceListButton.enabled = false
                mDisConnectTvButton.setTitleColor(UIColor.grayColor(),forState: .Normal)
                mDisConnectTvButton.enabled = false
            case .readyToConnect:
                let castImage = UIImage(named: "cast_off.png")?.imageWithRenderingMode(.AlwaysTemplate)
                deviceListButton.setImage(castImage, forState: UIControlState.Normal)
                deviceListButton.tintColor = UIColor.blackColor()
                deviceListButton.enabled = true
                deviceListButton.tintColor = UIColor.grayColor()
                mDisConnectTvButton.setTitleColor(UIColor.grayColor(),forState: .Normal)
                mDisConnectTvButton.enabled = false
            case .connecting:
                deviceListButton.imageView!.animationImages = [UIImage(named: "cast_on0.png")!.imageWithRenderingMode(.AlwaysTemplate) ,UIImage(named: "cast_on1.png")!.imageWithRenderingMode(.AlwaysTemplate), UIImage(named: "cast_on2.png")!.imageWithRenderingMode(.AlwaysTemplate), UIImage(named: "cast_on1.png")!.imageWithRenderingMode(.AlwaysTemplate)]
                deviceListButton.imageView!.animationDuration = 2
                deviceListButton.imageView!.startAnimating()
                mDisConnectTvButton.setTitleColor(UIColor.grayColor(),forState: .Normal)
                mDisConnectTvButton.enabled = false
                
            case .connected:
                if deviceListButton.imageView!.isAnimating() {
                    deviceListButton.imageView!.stopAnimating()
                }
                let castImage = UIImage(named: "cast_on.png")!.imageWithRenderingMode(.AlwaysTemplate)
                deviceListButton.setImage(castImage, forState: UIControlState.Normal)
                deviceListButton.tintColor = UIColor.blueColor()
                deviceListButton.enabled = true
                mDisConnectTvButton.setTitleColor(UIColor.blueColor(),forState: .Normal)
                mDisConnectTvButton.enabled = true
            }
        }
    }
    
    
    func statusDidChange(notification: NSNotification!) {
        let status = notification.userInfo?["status"] as! NSString
        self.castStatus = CastStatus(rawValue: status as String)!
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @IBOutlet weak var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "statusDidChange:", name: "CastStatusDidChange", object: nil)
    }
    
    
    @IBAction func deviceListTouchUp(sender: AnyObject) {
        let deviceList = DeviceListController(style: UITableViewStyle.Plain)
        presentPopover(deviceList)
    }
  
    func presentPopover(viewController: UIViewController) {
        viewController.preferredContentSize = CGSize(width: 320, height: 186)
        viewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        let presentationController = viewController.popoverPresentationController
        presentationController!.sourceView = deviceListButton
        presentationController!.sourceRect = deviceListButton.bounds
        presentationController!.delegate = self
        presentViewController(viewController, animated: false, completion: {})
    }
    
   
    @IBAction func OnDisconnectTV(sender:AnyObject) {
        HelloWorldController.sharedInstance.disconnect()
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .None
    }
    
    
    // MARK: - UITextFieldDelegate -
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if textField.text == ""  {
            return true
        }
        
        HelloWorldController.sharedInstance.sendData(textField.text!)
        textField.text = ""
        return true
    }
}