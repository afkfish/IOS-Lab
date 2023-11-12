//
//  ContentView.swift
//  GeoMsg
//
//  Created by László Blázovics on 2021. 11. 10..
//

import SwiftUI



struct MessageListView: View {
    @EnvironmentObject var messageViewModel : MessageViewModel
    
    @State var newMessage = ""
    
    var body: some View {
        VStack {
            List(messageViewModel.messages) {message in
                ListRowView(message:message)
                    .rotationEffect(.degrees(180))
            }
            .onAppear{
                messageViewModel.fetchMessages()
            }
            .refreshable {
                self.messageViewModel.fetchMessages()
            }
                .rotationEffect(.degrees(180))
                .listStyle(.plain)
            TextField("New message", text: $newMessage)
                .textFieldStyle(.roundedBorder)
                .padding(EdgeInsets(top: 0, leading: 7, bottom: 2, trailing: 7))
                .onSubmit {
                    self.messageViewModel.sendMessage(message: newMessage)
                    self.newMessage = ""
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
            .environmentObject(MessageViewModel(threadId: 1))
    }
}
