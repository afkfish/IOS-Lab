//
//  ComposeMessageViewController.swift
//  Messenger
//
//  Copyright © 2017. BME AUT. All rights reserved.
//

import UIKit

protocol ComposeMessageViewControllerDelegate: AnyObject {
    // Called when the user presses the Send button to issue sending the message
    func composeMessageViewControllerDidSend(_ viewController: ComposeMessageViewController)
}

class ComposeMessageViewController: UITableViewController {

    // MARK: - Properties

    weak var delegate: ComposeMessageViewControllerDelegate?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHelpLabel: UILabel!
    @IBOutlet weak var recipientTextField: UITextField!
    @IBOutlet weak var topicTextField: UITextField!
    


    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Actions

    @IBAction func sendButtonTap(_ sender: Any) {
        delegate?.composeMessageViewControllerDidSend(self)
    }

    @IBAction func imageViewTap(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func textFieldDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ComposeMessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageView.image = image
            imageViewHelpLabel.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
