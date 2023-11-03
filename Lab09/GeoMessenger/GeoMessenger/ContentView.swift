//
//  ContentView.swift
//  GeoMessenger
//
//  Created by Beni Kis on 02/11/2023.
//

import SwiftUI

struct ContentView: View {
    private var messages = Message.getDummyData()
    @State var newMessage = ""
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        VStack {
            List(networkManager.fetchedMessages){message in
                ListRowView(message:message)
                    .rotationEffect(.degrees(180))
            }
                .rotationEffect(.degrees(180))
                .listStyle(.plain)
            TextField("New message", text: $newMessage)
                .padding(EdgeInsets(top: 0, leading: 7, bottom: 2, trailing: 7))
            .onSubmit {
                self.networkManager.sendMessage(message: newMessage, sender: "Teszt Elek")
                self.newMessage = ""
            }
        }.onAppear {
            self.networkManager.fetchMessages()
        }
        .refreshable {
            self.networkManager.fetchMessages()
        }
    }
}

#Preview {
    ContentView()
}
