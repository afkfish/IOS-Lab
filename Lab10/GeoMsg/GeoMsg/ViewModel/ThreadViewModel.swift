//
//  ThreadViewModel.swift
//  GeoMsg
//
//  Created by Beni Kis on 12/11/2023.
//

import Foundation

class ThreadViewModel: ObservableObject {
    @Published var threads = [Thread]()
    
    func fetchThreads() {
        let urlString = "http://13.74.10.16/igniter/index.php/Messages/getThreads"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            session.dataTask(with: url) { (data, response, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    if let data = data{
                        do{
                            let threads = try decoder.decode(Array<Thread>.self, from: data)
                            DispatchQueue.main.async {
                                self.threads = threads
                            }
                        } catch{
                            print(error)
                        }
                    }
                }
            }.resume()
        }
    }
}
