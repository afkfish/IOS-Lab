//
//  StatsViewController.swift
//  PictureGuess
//
//  Created by Beni Kis on 18/09/2023.
//

import Foundation
import UIKit

class StatsViewController: UIViewController {
    @IBOutlet weak var queriedPicturesCountLabel: UILabel!
    @IBOutlet weak var correctAnswerCountLabel: UILabel!
    @IBOutlet weak var wrongAnswerCountLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        queriedPicturesCountLabel.text = "\(PictureManager.requestedPictureCount)"
        correctAnswerCountLabel.text = "\(PictureManager.correctGuessCount)"
        wrongAnswerCountLabel.text = "\(PictureManager.wrongGuessCount)"
    }
}
