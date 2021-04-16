//
//  ViewController.swift
//  Mandala
//
//  Created by Chao Mei on 30/3/21.
//

import UIKit

class MoodSelectionViewController: UIViewController {
    //@IBOutlet var stackView: UIStackView!
    @IBOutlet var moodSelector: ImageSelector!
    @IBOutlet var addMoodButton: UIButton!
    
    var moodStore: MoodStore!
    
    private var moods: [Mood] = [] {
        didSet {
            moodSelector.images = moods.map{ $0.image }
            currentMood = moods.first
            /*moodButtons = moods.map { mood in
                let moodButton = UIButton()
                
                moodButton.setImage(mood.image, for: .normal)
                moodButton.imageView?.contentMode = .scaleAspectFit
                moodButton.adjustsImageWhenHighlighted = false
                moodButton.addTarget(self, action: #selector(moodSelectionChanged(_:)), for: .touchUpInside)
                
                return moodButton
            }*/
        }
    }
    /*var moodButtons: [UIButton] = [] {
        didSet {
            oldValue.forEach{ $0.removeFromSuperview() }
            moodButtons.forEach{ stackView.addArrangedSubview($0) }
        }
    }*/
    private var currentMood: Mood? {
        didSet {
            guard let currentMood = currentMood else {
                addMoodButton?.setTitle(nil, for: .normal)
                addMoodButton?.backgroundColor = nil
                return
            }
            addMoodButton?.setTitle("I'm \(currentMood.name)", for: .normal)
            addMoodButton?.backgroundColor = currentMood.color
        }
    }
    // This method is referred to as a #selector argument in var moods: [Mood]
    /*@objc private func moodSelectionChanged (_ sender: UIButton) {
        guard let selectedIndex = moodButtons.firstIndex(of: sender) else {
            preconditionFailure("Unable to find the tapped button in the button array")
        }
        currentMood = moods[selectedIndex]
    }*/
    @IBAction private func moodSelectionChanged (_ sender: ImageSelector) {
        let selectedIndex = sender.selectedIndex
        
        currentMood = moods[selectedIndex]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        moods = [.happy, .sad, .angry, .goofy, .crying, .confused, .sleepy, .meh]
        addMoodButton.layer.cornerRadius = addMoodButton.bounds.height / 2
    }

    private var moodsConfigurable: MoodsConfigurable!
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "embedContainerViewController":
            guard let moodsConfigurable = segue.destination as? MoodsConfigurable else {
                preconditionFailure("View controller expected to conform to MoodsConfgirable")
            }
            self.moodsConfigurable = moodsConfigurable
            self.moodsConfigurable.create(from: moodStore)
            segue.destination.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @IBAction private func addMoodTapped (_ sender: Any) {
        guard let currentMood = currentMood else {
            return
        }
        let newMoodEntry = MoodEntry(mood: currentMood, timpestamp: Date())
        moodsConfigurable.add(newMoodEntry)
    }
}

