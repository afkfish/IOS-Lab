//
//  ResultsViewController.swift
//  PictureGuess
//
//  Created by Beni Kis on 18/09/2023.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var pictureView: UIImageView!
    
    var caption: String?
    var picture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsLabel.text = caption
        pictureView.image = picture
    }
}
