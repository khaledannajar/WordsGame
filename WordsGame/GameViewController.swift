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
            view.updateWord()
        }
    }
    var currentTranslation: Word! {
        didSet {
            view.updateTranslationWord()
        }
    }
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
        reset()
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
        showNextWord()
        reset()
        score = calculateScore()
    }
    
    func calculateScore() -> String {
        return "\(successCount) success of \(totalTries) "
    }
    
    func nextWord(){
        if index >= words.count {
            allWordsShown = true
            return
        }
        
        let word = words[index]
        currentWord = word
        index += 1
    }
    
    func getTranslationWord() {
        if allWordsShown {
            return
        }
        let index = Int.random(in: 0 ..< words.count)
        currentTranslation = words[index]
    }
    func showNextWord() {
        if index >= words.count {
            resetToBegining()
            return
        }
        
    }
    func reset() {
        showingAWord = false
        allWordsShown = false
        view.reset {
            self.startGame()
        }
    }
    func resetToBegining() {
        index = 0
    }
    
    func startGame() {
        
        self.nextWord()
        self.getTranslationWord()
        if allWordsShown {
            index = 0
            return
        }
        showingAWord = true
        
        
      view.animateWordMovment()
    }
    
}

class GameViewController: UIViewController {
    func updateTranslationWord() {
        let translation = model.currentTranslation
        spaWordLabel.text = translation?.textSpa
    }
    func updateWord() {
        let word = model.currentWord
        enWordLabel.text = word?.textEng
    }
    func animateWordMovment() {
        animator = UIViewPropertyAnimator(duration: model.movingTime, curve: UIView.AnimationCurve.easeIn) {
            
            self.wordLabelTopConstraint.constant = self.endLineView.frame.origin.y - self.spaWordLabel.frame.height //- UIApplication.shared.statusBarFrame.height
            self.view.layoutIfNeeded()
        }
        animator.addCompletion { (animatingPosition) in
            self.spaWordLabel.isHidden = true
            self.reset()
            self.model.totalTries += 1
            self.updateScore()
        }
        animator.startAnimation()
    }
//    func startGame() {
//
//        let nextWord = self.nextWord()
//        let translationWord = self.getTranslationWord()
//        if allWordsShown {
//            index = 0
//            return
//        }
//        showingAWord = true
//        self.enWordLabel.text = nextWord.textEng
//        self.spaWordLabel.text = translationWord.textSpa
//
//        self.view.layoutIfNeeded()
//        animator = UIViewPropertyAnimator(duration: movingTime, curve: UIView.AnimationCurve.easeIn) {
//
//            self.wordLabelTopConstraint.constant = self.endLineView.frame.origin.y - self.spaWordLabel.frame.height //- UIApplication.shared.statusBarFrame.height
//            self.view.layoutIfNeeded()
//        }
//        animator.addCompletion { (animatingPosition) in
//            self.spaWordLabel.isHidden = true
//            self.reset()
//            self.totalTries += 1
//            self.updateScore()
//        }
//        animator.startAnimation()
//    }
    
    func reset(completion:(()->Void)? = nil) {
        
        spaWordLabel.text = "--"
        enWordLabel.text = "--"
        let resetAnimator = UIViewPropertyAnimator(duration: 0, curve: .easeOut, animations: {
            self.wordLabelTopConstraint.constant = 10
            self.view.layoutIfNeeded()
        })
        resetAnimator.addCompletion { (position) in
            self.spaWordLabel.show()
        }
        resetAnimator.startAnimation()
    }
    
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
    
    
    func updateTextLabels() {
        spaWordLabel.text = model.getTranslationWord().textSpa
        enWordLabel.text = model.currentWord.textEng
    }
    
    
    
    @IBAction func startTapped(_ sender: Any? = nil) {
        
        reset {
            self.startGame()
        }
        
    }
}

