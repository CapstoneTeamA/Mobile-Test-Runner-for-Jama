//
//  LoginViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var unauthorizedLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    @IBOutlet weak var instanceTextBox: UITextField!
    var currentUser: UserModel = UserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextBox.delegate = self
        self.instanceTextBox.delegate = self
        self.passwordTextBox.delegate = self
        unauthorizedLabel.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInSubmitButton(_ sender: Any) {
        let endpointString = buildCurrentUserEndpointString()
        RestHelper.hitEndpoint(atEndpointString: endpointString, withDelegate: self, httpMethod: "Get", username: userNameTextBox.text!, password: passwordTextBox.text!)
        
        loginButton.isEnabled = false
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func buildCurrentUserEndpointString() -> String {
        let endpoint = RestHelper.getEndpointString(method: "Get", endpoint: "CurrentUser")
        return "https://" + instanceTextBox.text! + "." + endpoint
    }
    
    func parseCurrentUserInfo(currentUserData: [String : AnyObject]) {
        currentUser.firstName = currentUserData["firstName"] as! String
        currentUser.lastName = currentUserData["lastName"] as! String
        currentUser.email = currentUserData["email"] as! String
        currentUser.id = currentUserData["id"] as! Int
        currentUser.username = currentUserData["username"] as! String
    }
    
    func reloadViewWithUsernameAndInstanceSaved() {
        //Save the username and instance, reload the view then set the username and instance again.
        let username = self.userNameTextBox.text
        let instance = self.instanceTextBox.text
        self.loadView()
        self.userNameTextBox.text = username
        self.instanceTextBox.text = instance
    }
}

extension LoginViewController: EndpointDelegate{
    func didLoadEndpoint(data: [[String : AnyObject]]?) {
        //Enable login button once async function returns.
        //This can take a while if you provide a bad instance name.
        DispatchQueue.main.async {
            self.loginButton.isEnabled = true
        }
        guard let unwrappedData = data else {
            return
        }
        if unwrappedData[0]["Unauthorized"] != nil {
            
            //Notify user of unauthorized reload the view on the main thread
            DispatchQueue.main.async {
                self.unauthorizedLabel.isHidden = false
                self.passwordTextBox.text = ""
                self.reloadViewWithUsernameAndInstanceSaved()
            }
            return
        }

        DispatchQueue.main.async {
            //Extract the users name and will eventually call a segue to next screen.
            self.parseCurrentUserInfo(currentUserData: unwrappedData[0])
            
            //This should be replaced in the future by using a singleton for the current user and using a segue.
            let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProjectListViewController") as! ProjectListViewController
            viewController.currentUser = self.currentUser
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
}
