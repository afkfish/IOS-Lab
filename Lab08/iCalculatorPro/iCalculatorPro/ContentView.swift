//
//  ContentView.swift
//  iCalculatorPro
//
//  Created by Beni Kis on 26/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var operand1: String = ""
    @State private var operand2: String = ""
    @State private var result: String = "Result"
    @State private var selectedOperation = OperationType.add
    @State private var textFieldsOK = true
    @State private var history: String = ""
    
    enum OperationType: String, Identifiable, CaseIterable {
        case add = "+"
        case subtract = "-"
        case multiply = "*"
        case divide = "/"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        VStack {
            Text("iCalculator Pro")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            TextField("1. operandus", text: $operand1)
                .keyboardType(.decimalPad)
                .padding(.horizontal)
            
            Picker("Operation", selection: $selectedOperation) {
                ForEach(OperationType.allCases) { operation in
                    Text(operation.rawValue).tag(operation)
                }
            }
                .pickerStyle(.segmented)
                .padding()
            
            TextField("2. operandus", text: $operand2)
                .keyboardType(.decimalPad)
                .padding(.horizontal)
            
            Button {
                if let o1 = Float(operand1), let o2 = Float(operand2) {
                    self.textFieldsOK = true
                    switch(selectedOperation){
                    case .add:
                        self.result = String(o1 + o2)
                    case .subtract:
                        self.result = String(o1 - o2)
                    case .multiply:
                        self.result = String(o1 * o2)
                    case .divide:
                        self.result = String(o1 / o2)
                    }
                    self.history = "\(o1) \(self.$selectedOperation.id) \(o2) = \(self.result) \n" + self.history
                } else {
                    withAnimation {
                        self.textFieldsOK = false
                        self.operand1 = ""
                        self.operand2 = ""
                    }
                }
            } label: {
                Text("=")
                    .frame(width: 100, height: 30, alignment: .center)
            }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(self.textFieldsOK ? .purple : .red)
            
            Text("\(result)")
                .font(.title2)
                .contextMenu {
                    Button {
                        UIPasteboard.general.string = result
                    } label: {
                        Label("Copy result", systemImage: "doc.on.doc")
                    }
                }
            
            Spacer()
            
            ScrollView {
                Text(self.history)
            }
            .frame(height: 300)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

#Preview {
    ContentView()
}
