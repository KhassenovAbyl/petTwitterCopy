//
//  LoginVC.swift
//  Twitter
//
//  Created by Abylbek Khassenov on 11/26/20.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginVC: UIViewController {

    @IBOutlet weak var email_field: UITextField!
    @IBOutlet weak var password_field: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var login: UIButton!
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.layer.borderWidth = 1
        login.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        login.layer.cornerRadius = 5
        currentUser = Auth.auth().currentUser
        // Do any additional setup afloading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser != nil && currentUser!.isEmailVerified{
             goToMainPage()
        }
    }
    @IBAction func login_clicked(_ sender: UIButton) {
        let email = email_field.text
        let password = password_field.text
        indicator.startAnimating()
        if email != "" && password != ""{
            Auth.auth().signIn(withEmail: email!, password: password!){[weak self](result , error) in
                self?.indicator.stopAnimating()
                if error == nil{
                    if Auth.auth().currentUser!.isEmailVerified{
                        self?.goToMainPage()
                    }else{
                        self?.showMessage(title: "Error", message: "Your email is not verified")
                    }
                }else{
                     self?.showMessage(title: "Error", message: "You not registrated yet")
                }
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func showMessage(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    func goToMainPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let mainPage = storyboard.instantiateViewController(identifier: "MainPageVC") as? MainPageVC{
            mainPage.modalPresentationStyle = .fullScreen
            present(mainPage, animated: true, completion: nil)
        }
    }
}
