//
//  PlayerDetailsView.swift
//  Ass2
//
//  Created by Martin Liang on 29/4/21.
//

import UIKit

class PlayerDetailsView: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.value = 40
        NumOfBubbles.value = 12
        ShowTimer.text = "40 Seconds"
        ShowBubbles.text = "12 Bubbles"
        self.UsernameText.delegate = self
    }
    
    @IBAction func TimerMove(_ sender: Any) {
        ShowTimer.text = String(Int(Timer.value)) + " Seconds"
    }
    @IBOutlet weak var Timer: UISlider!
    
    @IBOutlet weak var UsernameText: UITextField!
    
    @IBAction func NumBubblesMove(_ sender: Any) {
        ShowBubbles.text = String(Int(NumOfBubbles.value)) + " Bubbles"
    }
    @IBOutlet weak var ShowTimer: UILabel!
    
    @IBOutlet weak var ShowBubbles: UILabel!
    
    @IBOutlet weak var NumOfBubbles: UISlider!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    // Sends Username, Timer and Max Bubbles to View Control
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let username = UsernameText.text
        let timerSlide = String(Int(Timer.value))
        let numOfBubbles = String(Int(NumOfBubbles.value))
        let vc = segue.destination as? GameViewController
        
        vc?.username = username!
        vc?.timerX = Int(timerSlide)
        vc?.numOfBubbles = Int(numOfBubbles)
    }

}
