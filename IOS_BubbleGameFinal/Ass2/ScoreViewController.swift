//
//  ScoreViewController.swift
//  Ass2
//
//  Created by Martin Liang on 27/4/21.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var playerScores = [[String]]()
    
    @IBOutlet weak var HighScoreTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = UserDefaults.standard.value(forKey: "playerScores") as? [[String]]{
            self.playerScores = items
        }
        
    
        let nib = UINib(nibName: "customTableViewCell", bundle: nil)
        HighScoreTable.register(nib, forCellReuseIdentifier: "customTableViewCell")
        
        HighScoreTable.delegate = self
        HighScoreTable.dataSource = self
        

    }
    
    //Sets Table Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "High Scores"
    }
    //Sets Table Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerScores.count
    }
    //Populates Table With Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HighScoreTable.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = playerScores[indexPath.row][0]
        cell.detailTextLabel?.text = playerScores[indexPath.row][1]
        return cell
    }
    
}
