//
//  ProfileViewController.swift
//  ChatChat
//
//  Created by Ricardo Ruiz on 4/5/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController : UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Load username and image
        UserData.LoadUserName()
        UserData.LoadUserImage()
        
        // Set username textbox and image
        username.text = UserData.username
        
        if (UserData.image != nil)
        {
            userImage.image = UIImage (data: UserData.image!)
        }
    }
    
    @IBAction func SelectUserImage(sender: UITapGestureRecognizer)
    {
        // Hide the keyboard.
        username.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        userImage.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Button Actions
    
    @IBAction
    func BackToLogin ()
    {
        // Save username and image
        UserData.SaveUserName (username.text!);
        UserData.SaveUserImage (UIImagePNGRepresentation (userImage.image!)!);
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier ("Main")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}