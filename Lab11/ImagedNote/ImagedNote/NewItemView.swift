//
//  NewItemView.swift
//  ImagedNote
//
//  Created by Beni Kis on 25/11/2023.
//

import SwiftUI

struct NewItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            if  inputImage != nil {
                Image(uiImage: inputImage!)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
            } else {
                NavigationLink(destination: ImagePicker(image: self.$inputImage)) {
                    Text("Pick an Image")
                }
            }
            Button {
                self.addItem()
            } label: {
                Text("Add Item")
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.image = self.inputImage

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            dismiss()
        }
    }
}

#Preview {
    NewItemView()
}
