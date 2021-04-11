//
//  ViewController.swift
//  Quiz
//
//  Created by Chao Mei on 11/2/21.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentQuestionIndex]
    }
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    let questions: [String] = [
        "What is 7+7?",
        "What is the capital of Vermont?",
        "What is cognac made from?"
    ]
    let answers: [String] = [
        "14",
        "Montpelier",
        "Grapes"
    ]
    var currentQuestionIndex: Int = 0
    
    @IBAction func showNextQuestion (_ sender: UIButton) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        questionLabel.text = questions[currentQuestionIndex]
        answerLabel.text = "???"
    }
    @IBAction func showAnswer (_ sender: UIButton) {
        answerLabel.text = answers[currentQuestionIndex]
    }
}

