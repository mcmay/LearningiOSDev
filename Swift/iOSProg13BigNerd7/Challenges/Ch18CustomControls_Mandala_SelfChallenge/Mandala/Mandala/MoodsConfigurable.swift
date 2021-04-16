//
//  MoodsConfigurable.swift
//  Mandala
//
//  Created by Chao Mei on 4/4/21.
//

import Foundation

protocol MoodsConfigurable {
    func create(from moodStore: MoodStore)
    func add (_ moodEntry: MoodEntry)
}
