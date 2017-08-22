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
    let badCredentialsMessage = "Your login attempt was not successful. The user credentials you entered were not valid, please try again."
    let missingFieldMessage = "One or more required fields were not entered."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegates()
        
        //Back button for the next screen is set in this screen.
        let backItem = UIBarButtonItem()
        backItem.title = "Log Out"
        navigationItem.backBarButtonItem = backItem
    }
    
    func setTextFieldDelegates() {
        self.userNameTextBox.delegate = self
        self.instanceTextBox.delegate = self
        self.passwordTextBox.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Make sure that the password is not saved when the login page reappears.
        passwordTextBox.text = ""
        userNameTextBox.text = ""
        instanceTextBox.text = ""
        
        unauthorizedLabel.isHidden = true
        unauthorizedLabel.text = badCredentialsMessage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInSubmitButton(_ sender: Any) {
        if checkRequiredFieldsNotEmpty() == false{
            return
        }
        let endpointString = buildCurrentUserEndpointString()
        RestHelper.hitEndpoint(atEndpointString: endpointString, withDelegate: self, httpMethod: "Get", username: userNameTextBox.text!, password: passwordTextBox.text!, timestamp: RestHelper.getCurrentTimestampString())
        
        loginButton.isEnabled = false
        
        //Make sure the cursor is not in one of the text boxes after the button is pressed
        userNameTextBox.resignFirstResponder()
        passwordTextBox.resignFirstResponder()
        instanceTextBox.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginButton.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func checkRequiredFieldsNotEmpty() -> Bool {
        if (userNameTextBox.text?.isEmpty)! || (passwordTextBox.text?.isEmpty)! || (instanceTextBox.text?.isEmpty)! {
            unauthorizedLabel.isHidden = false
            unauthorizedLabel.text = missingFieldMessage
            return false
        }
        unauthorizedLabel.isHidden = true
        return true
    }
    
    func buildCurrentUserEndpointString() -> String {
        let endpoint = RestHelper.getEndpointString(method: "Get", endpoint: "CurrentUser")
        return "https://" + instanceTextBox.text! + "." + endpoint
    }
    
    
    func reloadViewWithUsernameAndInstanceSaved() {
        //Show the unauth message and reset the password
        unauthorizedLabel.text = badCredentialsMessage
        self.unauthorizedLabel.isHidden = false
        self.passwordTextBox.text = ""
        
        //Save the username and instance, reload the view then set the username and instance again.
        let username = self.userNameTextBox.text
        let instance = self.instanceTextBox.text
        self.loadView()
        self.userNameTextBox.text = username
        self.instanceTextBox.text = instance
        setTextFieldDelegates()
    }
}

extension LoginViewController: EndpointDelegate{
    func didLoadEndpoint(data: [[String : AnyObject]]?, totalItems: Int, timestamp: String) {
        //Enable login button once async function returns.
        DispatchQueue.main.async {
            self.loginButton.isEnabled = true
        }
        
        guard let unwrappedData = data else {
            return
        }
        
        if unwrappedData[0]["Unauthorized"] != nil {
            
            //Notify user of unauthorized reload the view on the main thread
            DispatchQueue.main.async {
                self.reloadViewWithUsernameAndInstanceSaved()
            }
            return
        }
        
        DispatchQueue.main.async {
            //Make sure that the authorization error message is hidden
            self.unauthorizedLabel.isHidden = true
            //Extract the current user's information from the API returned data.
            self.currentUser.extractUser(fromData: unwrappedData[0])
            
            let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProjectListViewController") as! ProjectListViewController
            viewController.currentUser = self.currentUser
            viewController.username = self.userNameTextBox.text!
            viewController.password = self.passwordTextBox.text!
            viewController.instance = self.instanceTextBox.text!
            self.navigationController!.pushViewController(viewController, animated: true)
        }
    }
}
