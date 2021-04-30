//
//  GameViewController.swift
//  Ass2
//
//  Created by Martin Liang on 27/4/21.
//

import UIKit
import Foundation

class GameViewController: UIViewController {

    @IBOutlet var GameScreen: UIView!
    
    var existingBubbles = [UIButton]()
    var username: String = ""
    var timerX: Int!
    var numOfBubbles: Int!
    var prevBubble: UIButton!
    var scores = 0
    var playerScores = [[String]]()
    
    @IBOutlet weak var GameTimer: UILabel!
    
    @IBOutlet weak var UsernameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UsernameLbl?.text = username
        if let items = UserDefaults.standard.value(forKey: "playerScores") as? [[String]]{
            self.playerScores = items
        }
        
        GameTimer.text = String(timerX)
        Score.text = String(scores)
        //sets time, each seond, creates bubles up to the set limit and removes a random amount of bubbles, when timer hits 0, stops the game and sends to high score screen
        var _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            self.timerX -= 1
            self.GameTimer.text = String(self.timerX)
            if(self.timerX == 0){
                self.saveScore()
                let destination = self.storyboard?.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
                self.navigationController?.pushViewController(destination, animated: true)
                timer.invalidate()
            }
            self.loadScreen()
            self.removeBubbles()
        }
    }
    //Ssves the current score into the UserDefuault session
    func saveScore(){
        var change = true
        if(playerScores.count > 0){
            for i in 0...playerScores.count - 1 {
                if(playerScores[i][0] == username && Int(playerScores[i][1])! < scores){
                    playerScores[i][0] = username
                    playerScores[i][1] = String(scores)
                    change = false
                } else if(playerScores[i][0] == username){ change = false }
            }
        }
        if (change){
        playerScores.append([username, String(scores)])
        }
        
        playerScores.sort{$0[1].compare($1[1], options: .numeric) == .orderedDescending}
        
        UserDefaults.standard.set(playerScores, forKey: "playerScores")
    }
        
    @IBOutlet weak var Score: UILabel!
    
    //Loads the bubbles onto the screen
    func loadScreen(){
        
        
        if(existingBubbles.isEmpty){
            let tmp = createButton()
            existingBubbles.append(tmp)
            view.addSubview(tmp)
        }
        // Making sure there is always less than the maximum number of bubbles
        while(existingBubbles.count < numOfBubbles){
            var intersects = true
            let tmpBtn = createButton()
            //checking overlaps
            for buttons in existingBubbles {
                if(buttons.frame.intersects(tmpBtn.frame)){
                    intersects = false
                }
            }
            if(intersects){
                existingBubbles.append(tmpBtn)
                view.addSubview(tmpBtn)
            }
        }
    }
    // Removes the a random amount of bubbles 
    func removeBubbles(){
        let rndBubbles = Int.random(in: 0...4)
        if existingBubbles.count > rndBubbles{
            for _ in (0...rndBubbles){
                let bubbleToRmv = Int.random(in: 0...existingBubbles.count-1)
                existingBubbles[bubbleToRmv].removeFromSuperview()
                existingBubbles.remove(at: bubbleToRmv)
                
            }
        }
    }
    //Creates the button within the bounds of the screen
    func createButton() -> UIButton{
        let width = UIScreen.main.bounds.width - 80
        let height = UIScreen.main.bounds.height
        
        let x = Int.random(in: 0...Int(width))
        let y = Int.random(in: 0 + 180...Int(height) - 100)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: x,y: y, width: 80, height: 80)
        button.setImage(UIImage(named: getColour()), for: .normal)
        button.addTarget(self, action: #selector(removeButton(_ :)), for: .touchUpInside)
        
        
        return button
    }
    // Returns the points for every bubble
    func buttonPoints(Button: UIButton) -> Int {
        let curImage = Button.currentImage
        switch(curImage){
        case UIImage(named: "Red"):
            return 1
        case UIImage(named: "Pink"):
            return 2
        case UIImage(named: "Green"):
            return 5
        case UIImage(named: "Blue"):
            return 8
        case UIImage(named: "Black"):
            return 10
        default:
            return 0
        }
    }
    
    //Removes bubble when button is clicked and assigns the points
    @objc func removeButton(_ button: UIButton) {
        if(button.currentImage == prevBubble?.currentImage){
            scores += Int(Double(buttonPoints(Button: button)) * 1.5)
        } else {
            scores += buttonPoints(Button: button)
        }
        prevBubble = button
        Score.text = String(scores)
        button.removeFromSuperview()
        
        let index = existingBubbles.firstIndex(of: button)
        existingBubbles.remove(at: index!)
        
    }
    //assigns the colours toe each bubble in the correct percentages
    func getColour() -> String {
        let randomInt = Int.random(in: 1..<101)
        
        switch (randomInt){
        case let (randomInt) where randomInt <= 40:
            return "Red"
        case let (randomInt) where randomInt > 40 && randomInt <= 70:
            return "Pink"
        case let (randomInt) where randomInt > 70 && randomInt <= 85:
            return "Green"
        case let (randomInt) where randomInt > 85 && randomInt <= 95:
            return "Blue"
        case let (randomInt) where randomInt > 95 && randomInt <= 100:
            return "Black"
        default:
            break
        }
        return "null"
    }
}
