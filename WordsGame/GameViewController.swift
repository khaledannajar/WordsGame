//
//  ViewController.swift
//  WordsGame
//
//  Created by khaledannajar on 6/21/19.
//  Copyright © 2019 khaledannajar. All rights reserved.
//

import UIKit

class ViewModel {
    let view: GameViewController // use protocol
    let repo = WordsRepository()
    
    var showingAWord = false
    let movingTime = TimeInterval(2)
    
    var index: Int = 0
    var allWordsShown = false
    var successCount = 0
    var totalTries = 0
    
    var currentWord: Word! {
        didSet {
            
        }
    }
    var currentTranslation: Word!
    var words: [Word]! {
        didSet {
            //            view.startGame()
        }
    }
    var score: String {
        didSet {
            view.updateScore()
        }
    }
    
    init(view: GameViewController) {
        self.view = view
    }
    var callingServer = false {
        didSet {
            DispatchQueue.main.async {
                self.view.hideProgress()
            }
        }
    }
    func fetchWords() {
        callingServer = true
        repo.getWords(refresh: true) { [weak self] (words, error) in
            self?.callingServer = false
            if error != nil {
                print(error!)
            }
            if let words = words {
                print("words count = \(words.count)")
                self?.words = words
                DispatchQueue.main.async {
                    self?.view.startGame()
                }
            }
        }
    }
    
    func rightAction() {
        if allWordsShown || !showingAWord{
            return
        }
        
        totalTries += 1
        if currentWord == currentTranslation {
            successCount += 1
        }
        view.distrubWordShowing()
        reset(completion: {self.startGame()})
        score = calculateScore()
    }
    func wrongAction() {
        if allWordsShown || !showingAWord{
            return
        }
        
        totalTries += 1
        if currentWord != currentTranslation {
            successCount += 1
        }
        view.distrubWordShowing()
        reset(completion: {self.startGame()})
        score = calculateScore()
    }
    
    func calculateScore() -> String {
        return "\(successCount) success of \(totalTries) "
    }
    
    func nextWord(){
        if index >= words.count {
            index = 0
            allWordsShown = true
        }
        let word = words[index]
        index += 1
        currentWord = word
    }
}

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
    var animator: UIViewPropertyAnimator!
    lazy var model = ViewModel(view: self)
    func distrubWordShowing() {
        animator.stopAnimation(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        model.fetchWords()
        spaWordLabel.text = "--"
        enWordLabel.text = "--"
        scoreValueLabel.text = "--"
        
    }
    
    func setupButtons() {
        rightButton.layer.cornerRadius = 5
        wrongButton.layer.cornerRadius = 5
    }
    
    
    func showProgress() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideProgress() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    
    func updateScore() {
        scoreValueLabel.text = model.score
    }
    
    
    @IBAction func wrongButtonTapped(_ sender: Any) {
        model.wrongAction()
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
       model.rightAction()
    }
    
    
    func getTranslationWord() -> Word {
        let index = Int.random(in: 0 ..< words.count)
        currentTranslation = words[index]
        return currentTranslation
    }
    
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

