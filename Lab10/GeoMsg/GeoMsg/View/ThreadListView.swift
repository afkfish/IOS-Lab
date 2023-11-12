//
//  ThreadListView.swift
//  GeoMsg
//
//  Created by Beni Kis on 12/11/2023.
//

import SwiftUI

struct ThreadListView: View {
    @StateObject var threadViewModel = ThreadViewModel()
    
    var body: some View {
        NavigationView {
            List(threadViewModel.threads){ thread in
                NavigationLink(destination: MessageTabView(threadId: thread.id, title: thread.name)) {
                    Text(thread.name)
                }
            }
            .navigationTitle("Threads")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear{
            threadViewModel.fetchThreads()
        }
    }
}

#Preview {
    ThreadListView()
}
