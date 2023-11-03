//
//  ListRowView.swift
//  GeoMessenger
//
//  Created by Beni Kis on 02/11/2023.
//

import SwiftUI

struct ListRowView: View {
    var message : Message
    
    var body: some View {
        let me = message.sender == "Teszt Elek"
        let color = me ? Color.green : Color.blue
        HStack {
            if me {
                Spacer()
            }
            HStack (alignment: .top) {
                Image(systemName: "person.fill")
                VStack (alignment: .leading) {
                    Text(message.sender)
                    Text(message.content)
                }
                    .environment(\.layoutDirection, me ? .rightToLeft : .leftToRight)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    
            )
            .foregroundColor(.white)
            if !me {
                Spacer()
            }
        }
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ListRowView(message: Message.getDummyData()[0])
}
