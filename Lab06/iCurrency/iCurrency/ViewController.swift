//
//  ViewController.swift
//  iCurrency
//
//  Created by Beni Kis on 18/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: properties
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var exchangeAmountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    private var currency: Currency!
    private lazy var urlSession: URLSession = {
      let sessionConfiguration = URLSessionConfiguration.default
      return URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: funtions
    @IBAction func calculateButtonTouchUpInside(_ sender: UIButton) {
        var currencyVal = "USD"
        if (!currencyTextField.text!.isEmpty) {
            currencyVal = currencyTextField.text!
        }
        
        let url = URL(string: "http://api.exchangeratesapi.io/latest?base=\(currencyVal)&symbols=HUF&access_key=49a2fa932849f1e10eac242cf61ec766")
        urlSession.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error during communication: \(error.localizedDescription)")
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    self.currency = try decoder.decode(Currency.self, from: data)
                    
                    var exchangeAmount = 0.0
                    if (!self.exchangeAmountTextField.text!.isEmpty) {
                        exchangeAmount = Double(self.exchangeAmountTextField.text!)!
                    }
                    
                    let result = exchangeAmount * self.currency.rates.HUF
                    self.resultLabel.text = String(result)
                } catch let decodeError {
                    print("Error during JSON decoding: \(decodeError.localizedDescription)")
                }
            }
        }.resume()
    }
}
