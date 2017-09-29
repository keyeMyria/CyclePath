//
//  SideMenuAction.swift
//  CyclePath
//
//  Created by Guillaume Loulier on 26/09/2017.
//  Copyright © 2017 Guillaume Loulier. All rights reserved.
//

import UIKit
import Firebase

class SideMenuAction: UIViewController
{
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBAction func registerUser(_ sender: Any)
    {
        guard let registerAction = storyboard?.instantiateViewController(withIdentifier: "RegisterAction") as? RegisterAction else { return }
        // TODO : Present the action.
    }
    
    @IBAction func loginUser(_ sender: Any)
    {
        
    }
    
    @IBAction func LogoutUser(_ sender: Any)
    {
        let logoutPopUp = UIAlertController(
            title: "Logout ?",
            message: "Are you sure ?",
            preferredStyle: .actionSheet
        )
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTaped) in
            do {
                try Auth.auth().signOut()
                let loginAction = self.storyboard?.instantiateViewController(withIdentifier: "LoginAction") as? LoginAction
                self.present(loginAction!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopUp.addAction(logoutAction)
        present(logoutPopUp, animated: true, completion: nil)
    }
    
    @IBAction func userProfile(_ sender: Any)
    {
        
    }
    
    @IBAction func userPaths(_ sender: Any)
    {
        
    }
}
