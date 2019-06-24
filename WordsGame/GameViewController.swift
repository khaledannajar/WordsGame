//
//  ViewController.swift
//  WordsGame
//
//  Created by khaledannajar on 6/21/19.
//  Copyright © 2019 khaledannajar. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var spaWordLabel: UILabel!
    @IBOutlet weak var enWordLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var wrongButton: UIButton!
    
    @IBOutlet weak var scoreValueLabel: UILabel!
    @IBOutlet weak var endLineView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wordLabelTopConstraint: NSLayoutConstraint!
    private let wordLabelTopConstraintDefaultValue: CGFloat = 10
    private var wordLabelMaxTopConstraintValue: CGFloat = 200
    let repo = WordsRepository()
    
    var tappedAbutton = false
    let timeBetweenWords = 3.0
    var timeWordShown = 0.0
    var currentWordIndex = 0
    var currentWord: Word?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        fetchWords()
    }
    
    func setupButtons() {
        rightButton.layer.cornerRadius = 5
        wrongButton.layer.cornerRadius = 5
    }
    
    func hideActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
    }
    
    func fetchWords() {
        activityIndicator.startAnimating()
        repo.getWords(refresh: true) { [weak self] (words, error) in
            DispatchQueue.main.async {
                self?.hideActivityIndicator()
            }
            if error != nil {
                print(error!)
            }
            if let words = words {
                print("words count = \(words.count)")
                
                DispatchQueue.main.async {
                    self.show()
                }
            }
        }
    }
    
    func show() {
        
    }
    
    @IBAction func wrongButtonTapped(_ sender: Any) {
        
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        
    }
    
    
}

