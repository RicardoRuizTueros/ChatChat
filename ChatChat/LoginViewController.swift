/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Firebase

class LoginViewController: UIViewController {
  
    // MARK: Properties
    var ref = Firebase(url: "https://resplendent-fire-2168.firebaseio.com")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ref.authAnonymouslyWithCompletionBlock { error, authData in
            if error != nil {
                print ("Error loging in")
            } else {
                UserData.ID = self.ref.authData.uid
                print ("Authenticated with random ID: " + UserData.ID)
            }
        }
    }

  @IBAction func LoginToChat(sender: AnyObject)
  {
    self.performSegueWithIdentifier("LoginToChat", sender: sender)
  }
    
    @IBAction func LoadProfile (sender: AnyObject)
    {
        let storyboard = UIStoryboard (name: "Profile", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier ("Profile")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func LoadContacts(sender: UIButton)
    {
        let storyboard = UIStoryboard (name: "Contacts", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier ("Contacts")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    super.prepareForSegue(segue, sender: sender)
    let navVc = segue.destinationViewController as! UINavigationController
    let chatVc = navVc.viewControllers.first as! ChatViewController
    chatVc.senderId = ref.authData.uid
    chatVc.senderDisplayName = ""
  }
  
}

