//
//  ListRowView.swift
//  GeoMsg
//
//  Created by László Blázovics on 2021. 11. 10..
//

import SwiftUI

struct ListRowView: View {
    
    var message : Message
    
    var body: some View {
        HStack {
            HStack (alignment: .top) {
                Image(systemName: "person.fill")
                VStack (alignment: .leading) {
                    Text(message.sender)
                    Text(message.content)
                }
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            )
            .foregroundColor(.white)
            Spacer()
        }
        .listRowSeparator(.hidden)
        
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        ListRowView(message: messages[0])
    }
}
