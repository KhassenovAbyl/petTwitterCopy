//
//  UserPageVC.swift
//  Twitter
//
//  Created by Abylbek Khassenov on 12/2/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserPageVC: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSurname: UILabel!
    @IBOutlet weak var userBirth: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    var currentUser : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = Auth.auth().currentUser
        let parent = Database.database().reference().child("Users").child(currentUser!.uid)
        parent.observe(.value){[weak self](snapshot) in
            let value = snapshot.value as? NSDictionary
            self?.userName.attributedText = self?.boldText(bold: value?["name"] as? String ?? "", normal: "User name : ")
            self?.userSurname.attributedText = self?.boldText(bold: value?["surname"] as? String ?? "", normal: "User surname : ")
            self?.userBirth.attributedText = self?.boldText(bold: value?["dateOfBirth"] as? String ?? "", normal: "User birthday : ")
            self?.userEmail.attributedText = self?.boldText(bold: value?["email"] as? String ?? "", normal: "User email : ")
        }
    }
    
    
    @IBAction func editInfo(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Change information", message: "Enter new data", preferredStyle: .alert)
        
        alert.addTextField{(textField) in
            textField.placeholder = "Change name ?"
        }
        alert.addTextField{(textField) in
            textField.placeholder = "Change surname ?"
        }
        alert.addTextField{(textField) in
            textField.placeholder = "Change email ?"
        }
        alert.addTextField{(textField) in
            textField.placeholder = "Change birthday date ?"
        }
        
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: {[weak alert] (_) in
            let currentUser = Auth.auth().currentUser
            let parent = Database.database().reference().child("Users").child(currentUser!.uid)
            let nametextfield = alert?.textFields![0]
            let surtextfield = alert?.textFields![1]
            let emailtextfielde = alert?.textFields![2]
            let birthtextfield = alert?.textFields![3]
            if nametextfield?.text != ""{
                parent.updateChildValues(["name": (nametextfield?.text)! as String])
                self.userName.text = nametextfield?.text
            }
            if surtextfield?.text != ""{
                parent.updateChildValues(["surname" : (surtextfield?.text)! as String])
                self.userSurname.text = surtextfield?.text
            }
            if emailtextfielde?.text != ""{
                parent.updateChildValues(["email" : (emailtextfielde?.text)! as String])
                self.userEmail.text = emailtextfielde?.text
            }
            if birthtextfield?.text != ""{
                parent.updateChildValues(["birthday" : (birthtextfield?.text)! as String])
                self.userBirth.text = birthtextfield?.text
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func boldText(bold : String , normal : String) -> NSMutableAttributedString{
        let boldText = bold
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        let normalText = normal
        let normalString = NSMutableAttributedString(string:normalText)
        
        normalString.append(attributedString)
        return normalString
    }
}
