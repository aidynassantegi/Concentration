//
//  ViewController.swift
//  Concentration
//
//  Created by Aidyn Assan on 11.05.2022.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game: Concentration = {
        let game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        game.delegate = self
        return game
    }()
    
    @IBOutlet private weak var flipsCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    private var emojiChoices = [ "🐼", "👀", "🍭", "🎲", "🤡", "🦋", "🍏", "🦉"]
    private var emojiesCache = Dictionary<Card, String>()
    
    @IBAction private func restartButton(_ sender: UIButton) {
        emojiChoices = [ "🐼", "👀", "🍭", "🎲", "🤡", "🦋", "🍏", "🦉"]
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        game.delegate = self
        flipsCountLabel.text = "Flips: 0"
        for cardButton in cardButtons {
            cardButton.isHidden = false
            cardButton.backgroundColor = .systemOrange
            cardButton.setTitle("", for: .normal)
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard let index = cardButtons.firstIndex(of: sender) else {return}
        game.chooseCard(at: index)
        updateFromModel()
    }
    
    private func updateFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(getEmoji(for: card), for: .normal)
                button.backgroundColor = .white
            }else {
                button.setTitle("", for: .normal)
                if card.isMatched {
                    button.isHidden = true
                } else {
                    button.backgroundColor = .orange
                }
            }
        }
    }
    
    func getEmoji(for card: Card) -> String {
        if let emoji = emojiesCache[card] {
            return emoji
        }else {
            guard let randomIndex = emojiChoices.indices.randomElement() else {return "?"}
            let emoji = emojiChoices.remove(at: randomIndex)
            emojiesCache[card] = emoji
            return emoji
        }
    }

}

extension ViewController: ConcentrationDelegate {
    func didUpdate(with count: Int) {
        flipsCountLabel.text = "Flips: \(count)"
    }
}
