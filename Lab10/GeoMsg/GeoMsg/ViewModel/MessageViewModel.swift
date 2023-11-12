//
//  NetworkManager.swift
//  GeoMsg
//
//  Created by László Blázovics on 2021. 11. 10..
//

import Foundation
import CoreLocation
import Combine

class MessageViewModel: ObservableObject {
    @Published var messages = [Message]()

    var sender =  "USERNAME"
    var threadId: Int
    
    var locationManager = LocationManager()
    var location : CLLocation?
    
    var cancellable : Cancellable?
    
    init(threadId: Int) {
        self.threadId = threadId
        locationManager.locationObserver = self
        locationManager.startLocationManager()
    }

    func fetchMessages() {
        let urlString = URL(string: "http://13.74.10.16/igniter/index.php/messages?thread_id=\(threadId)")
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: urlString!)
            .tryMap() { $0.data }
            .decode(type: Array<Message>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Succesful fetch")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { messages in
                self.messages = messages
                
            })
    }
    
    func sendMessage(message: String){
        locationManager.startLocationManager()
        
        let message = Message(id:2, sender: sender, content: message, latitude: location?.coordinate.latitude ?? 0.0, longitude: location?.coordinate.longitude ?? 0.0, threadId: threadId)
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(message) else { return }
        
        let url = URL(string: "http://13.74.10.16/igniter/messages/post")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .tryMap() { String(decoding: $0.data, as: UTF8.self) }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Succesful post")
                    self.fetchMessages()
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { message in
                print(message)
            })
    }
}

extension MessageViewModel : LocationObserver {
    func updateLocation(_ location: CLLocation) {
        self.location = location;
    }
}
