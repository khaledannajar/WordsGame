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
    var currentWord: Word!
    var words: [Word] = [Word]()
    let movingTime = TimeInterval(2)
    var animator: UIViewPropertyAnimator!
    var index: Int = 0
    var allWordsShown = false
    var successCount = 0
    var totalTries = 0
    var currentTranslation: Word!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        fetchWords()
        spaWordLabel.text = "--"
        enWordLabel.text = "--"
        scoreValueLabel.text = "--"
        
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
                self?.words = words
                DispatchQueue.main.async {
                    self?.startGame()
                }
            }
        }
    }
    
    func updateScore() {
        let score = calculateScore()
        scoreValueLabel.text = score
    }
    func calculateScore() -> String {
        return "\(successCount) success of \(totalTries) "
    }
    
    @IBAction func wrongButtonTapped(_ sender: Any) {
        if allWordsShown || !showingAWord{
            return
        }
        
        totalTries += 1
        if currentWord != currentTranslation {
            successCount += 1
        }
        animator.stopAnimation(true)
        reset(completion: {self.startGame()})
        updateScore()
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        if allWordsShown || !showingAWord{
            return
        }
       
        totalTries += 1
        if currentWord == currentTranslation {
            successCount += 1
        }
        animator.stopAnimation(true)
        reset(completion: {self.startGame()})
        updateScore()
    }
    
    func nextWord() -> Word {
        if index >= words.count {
            index = 0
            allWordsShown = true
        }
        let word = words[index]
        index += 1
        currentWord = word
        return word
        
    }
    func getTranslationWord() -> Word {
        let index = Int.random(in: 0 ..< words.count)
        currentTranslation = words[index]
        return currentTranslation
    }
    var showingAWord = false
    func reset(completion:(()->Void)? = nil) {
        showingAWord = false
        spaWordLabel.text = "--"
        enWordLabel.text = "--"
        let resetAnimator = UIViewPropertyAnimator(duration: 0, curve: .easeOut, animations: {
            
            self.wordLabelTopConstraint.constant = 10
            self.view.layoutIfNeeded()
        })
        resetAnimator.startAnimation()
        resetAnimator.addCompletion { (position) in
            
            self.spaWordLabel.show()
            self.spaWordLabel.text = "Ready"
            self.animator.startAnimation()
            self.restart()
        }
    }
    
    func startGame() {
        
        let nextWord = self.nextWord()
        let translationWord = self.getTranslationWord()
        if allWordsShown {
            index = 0
            return
        }
        showingAWord = true
        self.enWordLabel.text = nextWord.textEng
        self.spaWordLabel.text = translationWord.textSpa
        
        self.view.layoutIfNeeded()
        animator = UIViewPropertyAnimator(duration: movingTime, curve: UIView.AnimationCurve.easeIn) {
            
            self.wordLabelTopConstraint.constant = self.endLineView.frame.origin.y - self.spaWordLabel.frame.height //- UIApplication.shared.statusBarFrame.height
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { (animatingPosition) in
            self.spaWordLabel.isHidden = true
            self.reset()
            self.totalTries += 1
            self.updateScore()
        }
        animator.startAnimation()
    }
    func restart() {
        allWordsShown = false
        self.startGame()
    }
    @IBAction func startTapped(_ sender: Any? = nil) {
        
        reset {
            self.startGame()
        }
        
    }
}

