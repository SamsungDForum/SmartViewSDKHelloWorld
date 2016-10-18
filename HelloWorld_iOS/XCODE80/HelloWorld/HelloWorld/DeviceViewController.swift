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
            if deviceListButton.imageView!.isAnimating {
                deviceListButton.imageView!.stopAnimating()
            }
            
            switch castStatus {
            case .notReady:
                let castImage = UIImage(named: "cast_off.png")?.withRenderingMode(.alwaysTemplate)
                deviceListButton.setImage(castImage, for: UIControlState())
                deviceListButton.tintColor = UIColor.black
                deviceListButton.isEnabled = false
                mDisConnectTvButton.setTitleColor(UIColor.gray,for: UIControlState())
                mDisConnectTvButton.isEnabled = false
            case .readyToConnect:
                let castImage = UIImage(named: "cast_off.png")?.withRenderingMode(.alwaysTemplate)
                deviceListButton.setImage(castImage, for: UIControlState())
                deviceListButton.tintColor = UIColor.black
                deviceListButton.isEnabled = true
                deviceListButton.tintColor = UIColor.gray
                mDisConnectTvButton.setTitleColor(UIColor.gray,for: UIControlState())
                mDisConnectTvButton.isEnabled = false
            case .connecting:
                deviceListButton.imageView!.animationImages = [UIImage(named: "cast_on0.png")!.withRenderingMode(.alwaysTemplate) ,UIImage(named: "cast_on1.png")!.withRenderingMode(.alwaysTemplate), UIImage(named: "cast_on2.png")!.withRenderingMode(.alwaysTemplate), UIImage(named: "cast_on1.png")!.withRenderingMode(.alwaysTemplate)]
                deviceListButton.imageView!.animationDuration = 2
                deviceListButton.imageView!.startAnimating()
                mDisConnectTvButton.setTitleColor(UIColor.gray,for: UIControlState())
                mDisConnectTvButton.isEnabled = false
                
            case .connected:
                if deviceListButton.imageView!.isAnimating {
                    deviceListButton.imageView!.stopAnimating()
                }
                let castImage = UIImage(named: "cast_on.png")!.withRenderingMode(.alwaysTemplate)
                deviceListButton.setImage(castImage, for: UIControlState())
                deviceListButton.tintColor = UIColor.blue
                deviceListButton.isEnabled = true
                mDisConnectTvButton.setTitleColor(UIColor.blue,for: UIControlState())
                mDisConnectTvButton.isEnabled = true
            }
        }
    }
    
    
    func statusDidChange(_ notification: Notification!) {
        let status = notification.userInfo?["status"] as! NSString
        self.castStatus = CastStatus(rawValue: status as String)!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBOutlet weak var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DeviceViewController.statusDidChange(_:)), name: NSNotification.Name(rawValue: "CastStatusDidChange"), object: nil)
    }
    
    
    @IBAction func deviceListTouchUp(_ sender: AnyObject) {
        let deviceList = DeviceListController(style: UITableViewStyle.plain)
        presentPopover(deviceList)
    }
  
    func presentPopover(_ viewController: UIViewController) {
        viewController.preferredContentSize = CGSize(width: 320, height: 186)
        viewController.modalPresentationStyle = UIModalPresentationStyle.popover
        let presentationController = viewController.popoverPresentationController
        presentationController!.sourceView = deviceListButton
        presentationController!.sourceRect = deviceListButton.bounds
        presentationController!.delegate = self
        present(viewController, animated: false, completion: {})
    }
    
   
    @IBAction func OnDisconnectTV(_ sender:AnyObject) {
        HelloWorldController.sharedInstance.disconnect()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        // Return no adaptive presentation style, use default presentation behaviour
        return .none
    }
    
    
    // MARK: - UITextFieldDelegate -
    
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
}
