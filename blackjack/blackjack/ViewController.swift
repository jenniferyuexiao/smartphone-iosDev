//
//  ViewController.swift
//  blackjack
//
//  Created by 肖玥 on 12/16/20.
//

import UIKit
import GameplayKit
import AVFoundation

class ViewController: UIViewController {


    @IBOutlet var comCards: [UIImageView]!
    @IBOutlet var userCards: [UIImageView]!
    
    
    @IBOutlet weak var userScoreLabel: UILabel!
  
    @IBOutlet weak var comScoreLabel: UILabel!
    
    @IBOutlet weak var userChipLabel: UILabel!
    
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var giveUpButton: UIButton!
    
    @IBOutlet weak var openFoldCardButton: UIButton!
    @IBOutlet weak var betLabel: UILabel!
    
    var userCloseCard = ""
    var comCloseCard = ""
    var userOpenedCard = ""
    var comOpenedCard = ""
    var uCards = [String]()
    var cCards = [String]()
    
    let distribution = GKShuffledDistribution(lowestValue: 0, highestValue: cards.count - 1)
    
    
    var userScore = 0
    var comScore = 0
    var comTotalScore = 0
    
    var userChip = 1000
    
    var count = 2
    var userAceCount = 0
    var comAceCount = 0
    var bet = 100
    
    
    
    
   //Show fold card
    @IBAction func closeCard(_ sender: Any) {

        userCards[0].isHighlighted = false
        UIView.transition(with: userCards[0], duration: 0.2, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        if userScore == 21 && uCards.count == 2{
            hitButton.isEnabled = false
        }
    }
    
    @IBAction func seeCard(_ sender: Any) {
        userCards[0].isHighlighted = true
        userScoreLabel.isHidden = false
        UIView.transition(with: userCards[0], duration: 0.2, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        
        hitButton.isEnabled = true
        if userScore >= 15{
            openButton.isEnabled = true
        }
        
    }
    
    //Deal Card
    @IBAction func deal(_ sender: Any) {
        if userChip >= bet{
            userCloseCard = cards[distribution.nextInt()]
            userOpenedCard = cards[distribution.nextInt()]
            comCloseCard = cards[distribution.nextInt()]
            comOpenedCard = cards[distribution.nextInt()]
            
            uCards += ["\(userCloseCard)", "\(userOpenedCard)"]
            cCards += ["\(comCloseCard)", "\(comOpenedCard)"]
            
            comCards[0].isHidden = false
            userCards[0].image = UIImage(named: "back")
            userCards[0].highlightedImage = UIImage(named: userCloseCard)
            userCards[0].isHidden = false
            userCards[1].image = UIImage(named: userOpenedCard)
            userCards[1].isHidden = false
            comCards[1].image = UIImage(named: comOpenedCard)
            comCards[1].isHidden = false
            
            userScore += scoreCal(card: userOpenedCard)
            userScore += scoreCal(card: userCloseCard)
            if (userOpenedCard.contains("A") || userCloseCard.contains("A")) && userScore > 21{
                userScore -= 10
            }
            
            userScoreLabel.text = "\(userScore)"
            
            comScore += scoreCal(card: comOpenedCard)
            comScoreLabel.text = "\(comScore)"
            comScoreLabel.isHidden = false
            
            dealButton.isEnabled = false
            openFoldCardButton.isEnabled = true
            giveUpButton.isEnabled = true
            
            
            comTotalScore = comScore + scoreCal(card: comCloseCard)
            if (comCloseCard.contains("A") || comOpenedCard.contains("A")) && comTotalScore > 21{
                comTotalScore -= 10
            }
            
            for uCard in uCards{
                if uCard.contains("A"){
                    userAceCount += 1
                }
            }
            for cCard in cCards{
                if cCard.contains("A"){
                    comAceCount += 1
                }
            }
        }else{
            noEnougnMoney()
        }
        
    }
    
//Add card
    @IBAction func hit(_ sender: Any) {
        var addCard = ""
        addCard = cards[distribution.nextInt()]
        userCards[count].isHidden = false
        userCards[count].image = UIImage(named: addCard)
        UIView.transition(with: userCards[count], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
        uCards += ["\(addCard)"]
        
        if addCard.contains("A"){
            userAceCount += 1
        }
        
        userScore += scoreCal(card: addCard)
        for uCard in uCards{
            if uCard.contains("A") && userScore > 21{
                userScore -= 10
                uCards = uCards.filter({(card : String) -> Bool in return !card.contains("A")})
            }
        }
        if addCard.contains("A") && userAceCount >= 2{
            uCards += ["\(addCard)"]
        }
        
        userScoreLabel.text = "\(userScore)"
        
        if userScore >= 15{
            openButton.isEnabled = true
        }
        if userScore == 21{
            hitButton.isEnabled = false
        }
        
        count += 1
        if (count == 5 && userScore <= 21) && !(comTotalScore == 21){
            fiveCardTrick()
        }else if (count == 5 && userScore <= 21) && (comTotalScore == 21){
            comBlackJack()
        }else if userScore > 21{
            bust()
        }
        
    }
        //Open Cards
    @IBAction func open(_ sender: Any) {
        userCards[0].image = UIImage(named: userCloseCard)
        UIView.transition(with: userCards[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        comCards[0].image = UIImage(named: comCloseCard)
        UIView.transition(with: comCards[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        comScoreLabel.text = "\(comTotalScore)"
        
        
        
        count = 2
        var comAddCard = ""
        while (comTotalScore < 17 && count < 6) || (comTotalScore == 17 && cCards.contains("A") && count == 2){
            comAddCard = cards[distribution.nextInt()]
            comCards[count].isHidden = false
            comCards[count].image = UIImage(named: comAddCard)
            UIView.transition(with: comCards[count], duration: 0.8, options: .transitionCurlDown, animations: nil, completion: nil)
            cCards += ["\(comAddCard)"]
            
            if comAddCard.contains("A"){
                comAceCount += 1
            }
            
            comTotalScore += scoreCal(card: comAddCard)
            for cCard in cCards{
                if cCard.contains("A") && comTotalScore > 21{
                    comTotalScore -= 10
                    cCards = cCards.filter({(card : String) -> Bool in return !card.contains("A")})
                }
            }
            if comAddCard.contains("A") && comAceCount >= 2{
                cCards += ["\(comAddCard)"]
            }
            
            comScoreLabel.text = "\(comTotalScore)"
            count += 1
        }
        
        if comTotalScore == 21 && cCards.count == 2{
            comScoreLabel.text = "\(comTotalScore)"
            comBlackJack()
        }else if userScore == 21 && uCards.count <= 2{
            playerBlackJack()
        }else if comTotalScore > 21 || userScore > comTotalScore{
            win()
        }else if comTotalScore > userScore{
            lose()
        }else if comTotalScore == userScore{
            tie()
        }else if count == 5 && comTotalScore < 21{
            comFiveCardTrick()
        }
        
        
        
    }
    

 //Give Up
    
    @IBAction func giveUp(_ sender: Any) {
        userScore = 0
        userScoreLabel.text = "\(userScore)"
        giveUp()
    }
    
//Next Round
    func nextRound () {
        if userChip <= 0 {
            performSegue(withIdentifier: "gameOverSegue", sender: nil)
        }
        
        userCards[0].isHidden = true
        userCards[1].isHidden = true
        userCards[2].isHidden = true
        userCards[3].isHidden = true
        userCards[4].isHidden = true
        
        comCards[0].image = UIImage(named:"back")
        comCards[0].isHidden = true
        comCards[1].isHidden = true
        comCards[2].isHidden = true
        comCards[3].isHidden = true
        comCards[4].isHidden = true
        
        comScore = 0
        comTotalScore = 0
        userScore = 0
        comScoreLabel.text = "0"
        comScoreLabel.isHidden = true
        userScoreLabel.text = "0"
        userScoreLabel.isHidden = true
        uCards.removeAll()
        cCards.removeAll()
        
        dealButton.isEnabled = true
        hitButton.isEnabled = false
        openButton.isEnabled = false
        giveUpButton.isEnabled = false
        openFoldCardButton.isEnabled = false
        
        userCloseCard = ""
        comCloseCard = ""
        userOpenedCard = ""
        comOpenedCard = ""
        count = 2
        userAceCount = 0
        comAceCount = 0
        
        bet = 100
        betLabel.text = "Bet: \(bet)"
    }
    
//Calculte Lose or Win
    func nextHandler(action: UIAlertAction) {
        nextRound()
    }
    
    func lose () {
        let controller = UIAlertController(title: "You lose", message: "Lost \(bet)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        
        controller.addAction(action)
        show(controller, sender: nil)
        userChip -= bet
        userChipLabel.text = "Your money：\(userChip)"
    }
    
    func win () {
        let controller = UIAlertController(title: "You win", message: "Won \(bet)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip += bet
        userChipLabel.text = "Your money：\(userChip)"
    }
    
    func bust () {
        userCards[0].image = UIImage(named: userCloseCard)
        UIView.transition(with: userCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let controller = UIAlertController(title: "Bust", message: "Lost \(bet)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip -= bet
        userChipLabel.text = "Your money：\(userChip)"
    }
    
    func tie () {
        let controller = UIAlertController(title: "Tie", message: "Lost \(bet)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip -= bet
        userChipLabel.text = "Your money：\(userChip)"
    }
    
    func fiveCardTrick () {
        userCards[0].image = UIImage(named: userCloseCard)
        UIView.transition(with: userCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let controller = UIAlertController(title: "Five cards trick", message: "Won \(bet * 2)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip += (bet * 2)
        userChipLabel.text = "Your money：\(userChip)"
    }
    
    func playerBlackJack () {
        userCards[0].image = UIImage(named: userCloseCard)
        UIView.transition(with: userCards[0], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        let controller = UIAlertController(title: "Black Jack", message: "Won \(bet * 2)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip += (bet * 2)
        userChipLabel.text = "Your money：\(userChip)"
    }
    
    func comBlackJack () {
        comCards[0].image = UIImage(named: comCloseCard)
        UIView.transition(with: comCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        comScoreLabel.text = "\(comTotalScore)"
        let controller = UIAlertController(title: "Com Black Jack", message: "Lost \(bet * 2)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip -= (bet * 2)
        userChipLabel.text = "Your money：\(userChip)"
    }
    
    func comFiveCardTrick () {
        comCards[0].image = UIImage(named: comCloseCard)
        UIView.transition(with: comCards[0], duration: 0.2, options: .transitionFlipFromRight, animations: nil, completion: nil)
        comScoreLabel.text = "\(comTotalScore)"
        let controller = UIAlertController(title: "Com five cards trick", message: "Lost \(bet * 2)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip -= (bet * 2)
        userChipLabel.text = "Your money：\(userChip)"

    }
    
    func giveUp () {
        let controller = UIAlertController(title: "Give up", message: "Lost \(bet / 2)! Score: \(userScore)", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
        userChip -= (bet / 2)
        userChipLabel.text = "Your money：\(userChip)"
       
    }
    
    func noEnougnMoney () {
        let controller = UIAlertController(title: "No enough money", message: "You can't bet more than you have!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Next", style: UIAlertAction.Style.default, handler: nextHandler)
        controller.addAction(action)
        show(controller, sender: nil)
    }
    
    func scoreCal (card: String) -> Int {
        var score = 0
        if card.contains("A") {
            score = 11
        } else if card.contains("2") {
            score = 2
        } else if card.contains("3") {
            score = 3
        } else if card.contains("4") {
            score = 4
        } else if card.contains("5") {
            score = 5
        } else if card.contains("6") {
            score = 6
        } else if card.contains("7") {
            score = 7
        } else if card.contains("8") {
            score = 8
        } else if card.contains("9") {
            score = 9
        } else if card.contains("10") {
            score = 10
        } else if card.contains("J") {
            score = 10
        } else if card.contains("Q") {
            score = 10
        } else if card.contains("K") {
            score = 10
        }
        return score
    }
    
    //
    
    
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


