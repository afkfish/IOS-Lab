//
//  MessageTabView.swift
//  GeoMsg
//
//  Created by Beni Kis on 12/11/2023.
//

import SwiftUI

struct MessageTabView: View {
    @ObservedObject var messageViewModel: MessageViewModel
    var title: String
    
    init(threadId: Int, title: String){
        messageViewModel = MessageViewModel(threadId: threadId)
        self.title = title
    }
    
    var body: some View {
        TabView {
            MessageListView()
                .tabItem {
                    Label("List", systemImage: "chart.bar.doc.horizontal.fill")
                }
                .environmentObject(messageViewModel)
            MessageMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .environmentObject(messageViewModel)
        }
        .navigationTitle(title)
    }
}

#Preview {
    MessageTabView(threadId: 1, title: "asd")
}
