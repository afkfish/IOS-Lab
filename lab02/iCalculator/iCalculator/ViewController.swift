//
//  ViewController.swift
//  iCalculator
//
//  Created by Beni Kis on 07/09/2023.
//

import UIKit

class ViewController: UIViewController {
    
    enum OperationType {
        case add
        case multiply
        case divide
    }
    
    @IBOutlet weak var inputTextFieldA: UITextField!
    @IBOutlet weak var inputTextFieldB: UITextField!
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var operationSelector: UISegmentedControl!
    @IBOutlet weak var historyView: UITextView!
    
    private var operationType: OperationType = .add
    
    @IBAction func backgroundTouchUpInside(_ sender: UIControl) {
        view.endEditing(true)
    }
    
    @IBAction func calculateButtonTouchUpInside(_ sender: UIButton) {
        let numberFormatter = NumberFormatter()

        if
            let textA = inputTextFieldA.text,
            let textB = inputTextFieldB.text,
            let a = numberFormatter.number(from: textA)?.doubleValue,
            let b = numberFormatter.number(from: textB)?.doubleValue {
            switch operationType {
            case .add:
                let res = a + b
                resultLabel.text = "\(res)"
                let text = "\(a) + \(b) = \(res)\n" + historyView.text
                historyView.text = text
            case .multiply:
                let res = a * b
                resultLabel.text = "\(res)"
                let text = "\(a) * \(b) = \(res)\n" + historyView.text
                historyView.text = text
            case .divide:
                let res = a / b
                resultLabel.text = "\(res)"
                let text = "\(a) / \(b) = \(res)\n" + historyView.text
                historyView.text = text
            }
        }
    }
    
    @IBAction func operationSelectorValueChanged(_ sender: UISegmentedControl) {
        switch operationSelector.selectedSegmentIndex {
        case 0:
            operationType = .add
        case 1:
            operationType = .multiply
        case 2:
            operationType = .divide
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextFieldA.text = "13"
        operationSelector.selectedSegmentIndex = 0
    }


}

