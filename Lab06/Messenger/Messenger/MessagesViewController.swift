//
//  MessagesViewController.swift
//  Messenger
//
//  Copyright © 2017. BME AUT. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {
  
    // MARK: - Properties
    private lazy var urlSession: URLSession = {
        let sessionConfiguration = URLSessionConfiguration.default
        return URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    private var imageCache = [URL: UIImage]()
    private var messages = [Message]()
    let activityIndicator = UIActivityIndicatorView()
  
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createActivityIndicator()
    }
    
    private func createActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
        
        view.addSubview(activityIndicator)
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell

        let message = messages[indexPath.row]
        cell.recipientLabel.text = "\(message.sender) -> \(message.recipient)"
        cell.topicLabel.text = message.topic
        
        if let imageUrlString = message.imageUrl, let imageUrl = URL(string: imageUrlString) {
            setImage(from: imageUrl, for: cell)
        }
        else {
            cell.messageImageView.image = nil
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComposeMessageSegue" {
            let vc = segue.destination as? ComposeMessageViewController
            vc?.delegate = self
        }
    }

    // MARK: - Actions

    @IBAction func refreshButtonTap(_ sender: Any) {
        activityIndicator.startAnimating()
        let url = URL(string: "http://13.74.10.16/igniter/Messages")
        urlSession.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error during communication: \(error.localizedDescription)")
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    self.messages = try decoder.decode(Array<Message>.self, from: data)
                    self.tableView.reloadData()
                } catch let decodeError {
                    print("Error during JSON decoding: \(decodeError.localizedDescription)")
                }
            }
        }.resume()
        activityIndicator.stopAnimating()
    }

    // MARK: - Helper methods

    func setImage(from url: URL, for cell: MessageCell) {
        if let cachedImage = imageCache[url] {
            cell.messageImageView.image = cachedImage
        } else {
            cell.messageImageView.image = nil
            
            activityIndicator.startAnimating()
            urlSession.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    self.imageCache[url] = image
                    cell.messageImageView.image = image
                }
            }.resume()
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - ComposeMessageViewControllerDelegate

extension MessagesViewController: ComposeMessageViewControllerDelegate {
  
    func composeMessageViewControllerDidSend(_ viewController: ComposeMessageViewController) {
        navigationController?.popToRootViewController(animated: true)
        guard let recipient = viewController.recipientTextField.text, let topic = viewController.topicTextField.text else { return }
        
        var message = Message(sender: "Alma Paprika", recipient: recipient, topic: topic)
        if let image = viewController.imageView.image, let jpegImageData = image.jpegData(compressionQuality: 0.5) {
            message.image = jpegImageData.base64EncodedString()
        }
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(message) else { return }
        
        let url = URL(string: "http://13.74.10.16/igniter/Messages/add")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        activityIndicator.startAnimating()
        urlSession.uploadTask(with: request, from: jsonData) { data, response, error in
          if let error = error {
            print("Error during comminication: \(error.localizedDescription).")
            return
          } else if let data = data {
            let decoder = JSONDecoder()
            do {
              let sendResponse = try decoder.decode(MessageSendResponse.self, from: data)
                    
              let alert = UIAlertController(title: "Server response", message: sendResponse.result, preferredStyle: .alert)
              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alert.addAction(okAction)
                    
              self.present(alert, animated: true, completion: nil)
            } catch {
              print("Error during JSON decoding: \(error.localizedDescription)")
            }
          }
        }.resume()
        activityIndicator.stopAnimating()
    }
}
