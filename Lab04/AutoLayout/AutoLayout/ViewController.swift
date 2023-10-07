//
//  ViewController.swift
//  AutoLayout
//
//  Created by Beni Kis on 23/09/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func editingDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBOutlet weak var saveUsernameSwitch: UISwitch!
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Successful login!", message: "Congratulation!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)

        UserDefaults.standard.set(saveUsernameSwitch.isOn, forKey: "usernameSaved")
        if saveUsernameSwitch.isOn {
            UserDefaults.standard.set(usernameTextField.text, forKey: "username")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveUsernameSwitch.setOn(UserDefaults.standard.bool(forKey: "usernameSaved"), animated: false)
        if saveUsernameSwitch.isOn {
              usernameTextField.text = UserDefaults.standard.value(forKey: "username") as? String
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
      if let userInfo = notification.userInfo,
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
        if passwordTextField.frame.maxY > (view.frame.height - keyboardSize.height) {
          UIView.animate(withDuration: duration, animations: {
            self.imageViewTopConstraint.constant = -1 * (self.passwordTextField.frame.maxY - (self.view.frame.height - keyboardSize.height))
            self.view.layoutIfNeeded()
          })
        }
      }
    }

    @objc private func keyboardWillHide(notification: Notification) {
      if let userInfo = notification.userInfo,
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
        UIView.animate(withDuration: duration) {
          self.imageViewTopConstraint.constant = 0
          self.view.layoutIfNeeded()
        }
      }
    }
}

