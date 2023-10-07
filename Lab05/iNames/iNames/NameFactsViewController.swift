//
//  NameFactsViewController.swift
//  iNames
//
//  Created by Beni Kis on 07/10/2023.
//

import UIKit

class NameFactsViewController: UIViewController {
  
  @IBOutlet weak var nicksLabel: UILabel!
  @IBOutlet weak var originLabel: UILabel!
  @IBOutlet weak var meaningLabel: UILabel!
  
  var nameToDisplay: [NSString: NSString]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nicksLabel.text = "\(nameToDisplay!["nicks"]!)"
    originLabel.text = "Eredete: \(nameToDisplay!["origin"]!)"
    meaningLabel.text = "Jelentése: \(nameToDisplay!["meaning"]!)"
  }
}
