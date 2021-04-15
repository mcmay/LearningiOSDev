//
//  ViewController.swift
//  Mandala
//
//  Created by Chao Mei on 30/3/21.
//

import UIKit

class MoodSelectionViewController: UIViewController {
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var addMoodButton: UIButton!
    
    var moods: [Mood] = [] {
        didSet {
            moodButtons = moods.map { mood in
                let moodButton = UIButton()
                
                moodButton.setImage(mood.image, for: .normal)
                moodButton.imageView?.contentMode = .scaleAspectFit
                moodButton.adjustsImageWhenHighlighted = false
                
                return moodButton
            }
        }
    }
    var moodButtons: [UIButton] = [] {
        didSet {
            oldValue.forEach{ $0.removeFromSuperview() }
            moodButtons.forEach{ stackView.addArrangedSubview($0) }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moods = [.happy, .sad, .angry, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }


}

