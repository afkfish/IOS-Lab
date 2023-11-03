//
//  NetworkManager.swift
//  GeoMessenger
//
//  Created by Beni Kis on 02/11/2023.
//

import Foundation

class NetworkManager : ObservableObject {
    @Published var fetchedMessages = [Message]()
    
    func fetchMessages() {
        let urlString = "http://13.74.10.16/igniter/Messages"
        if let url = URL(string: urlString) {
            URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print(error)
                } else if let data = data {
                    let decoder = JSONDecoder()
                    do{
                        let messages = try decoder.decode(Array<Message>.self, from: data)
                        DispatchQueue.main.async {
                            self.fetchedMessages = messages
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func sendMessage(message: String, sender: String){
        let message = Message(id:"2", sender: sender, content: message)
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(message) else { return }
        
        let url = URL(string: "http://13.74.10.16/igniter/Messages/post")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: .default)
        session.uploadTask(with: request, from: jsonData) { data, response, error in
            if let error = error {
                print(error)
                return
            } else {
                self.fetchMessages()
            }
        }.resume()
    }
}
