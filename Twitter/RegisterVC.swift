//
//  RegisterVC.swift
//  Twitter
//
//  Created by Abylbek Khassenov on 11/26/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterVC: UIViewController {

    var users: [UserInfo] = []
    var dateOfBirth : String?
    @IBOutlet weak var name_field: UITextField!
    @IBOutlet weak var surname_field: UITextField!
    @IBOutlet weak var mail_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var indecator: UIActivityIndicatorView!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var dataPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register.layer.borderWidth = 1
        register.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        register.layer.cornerRadius = 5
        dataPicker.datePickerMode = .date
        dataPicker.preferredDatePickerStyle = .compact

        // Do any additional setup after loading the view.
    }
    
    @IBAction func register_clicked(_ sender: UIButton) {
        let email = mail_field.text
        let password = password_field.text
        let name = name_field.text
        let surname = surname_field.text
        if email != "" && password != "" && name != "" && surname != "" && dateOfBirth != ""{
            let user = UserInfo(name!, surname!, dateOfBirth! , email!)
            indecator.startAnimating()
            Auth.auth().createUser(withEmail: email!, password: password!){
                [weak self](resilt , error) in
                let currentUser = Auth.auth().currentUser
                currentUser?.sendEmailVerification(completion: nil)
                Database.database().reference().child("Users").child(currentUser!.uid).setValue(user.dict)
                self?.indecator.stopAnimating()
                if error == nil{
                    self?.showMessage(title: "Success", message: "Please verify your email")
                    
                }else{
                    self?.showMessage(title: "Error", message: "Some problem.Try again")
                }
            }
        }else{
            self.showMessage(title: "Error", message: "Fill all fields")
        }
    }
    
    @IBAction func dataPicked(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, YYYY"
        let somedateString = dateFormatter.string(from: sender.date)
        dateOfBirth = somedateString
    }
    
    func showMessage(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default){
            (UIAlertAction) in
            if title  != "Error"{
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }

}
