//
//  GameSelectorViewController.swift
//  PictureGuess
//
//  Created by Beni Kis on 17/09/2023.
//

import Foundation
import UIKit

class GameSelectorViewController: UIViewController {
    @IBAction func unwindToGameSelector(_ segue: UIStoryboardSegue)  {}
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameViewController = segue.destination as? GameViewController
        gameViewController?.difficultyFactor = CGFloat(difficultySegmentedControl.selectedSegmentIndex + 1)
    }
}
