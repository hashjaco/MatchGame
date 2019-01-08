//
//  ViewController.swift
//  Match App
//
//  Created by Hashim Jacobs on 12/30/18.
//  Copyright © 2018 Syntheticheroism. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?

    var timer:Timer?
    var milliseconds:Float = 30 * 1000 // 10 Seconds
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Call the getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        // Allows the timer to keep running during other actions
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // When the timer has reached zero...
        if milliseconds <= 0 {
            
            // Stop the timer
            timer?.invalidate()
            
            // Change color of timer to red
            timerLabel.textColor = UIColor.red
        }
    }

    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a CardCollectionViewCell Object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the CollectionView is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check to see if there is any time left
        if milliseconds <= 0 {
            return
        }
        
        // Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            // Flip card
            cell.flip()
            
            // Play flipping sound
            SoundManager.playSound(.flip)
            
            // Set the status of the card
            card.isFlipped = true
            
            // Determine if it's the first card or second card that is being flipped over
            if firstFlippedCardIndex == nil {
                
                // This is the first card being flipped
                firstFlippedCardIndex = indexPath
            }
            else {
                
                // This is the second card being flipped
                
                // TODO: Perform the matching logic
                checkForMatches(indexPath)
            }
        }
        
    } // End the didSelectItemAt method
    
    // MARK: Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        
        // Get the cells for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if the game is over
            checkGameEnded()
        }
        else {
            
            // It's not a match
            SoundManager.playSound(.noMatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip the cards back over
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Tell the collectionView to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        
        var isWon = true
        
        for card in cardArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        // Messaging variables
        var title = ""
        var message = ""
        
        
        if isWon == true {
            
            // Stop timer
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've Won!"
            
        }
        else {
           
            if milliseconds > 0 {
                return
            }
            
            title = "Game Over"
            message = "You've Lost"
        }
        
        showAlert(title, message)
        
    }
    
    
    func showAlert(_ title:String, _ message:String){
        // Show Won/Lost message
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
} // End ViewController
