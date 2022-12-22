//
//  DiceViewController.swift
//  diceAPP
//
//  Created by 廖晨如 on 2022/12/20.
//

import UIKit

class DiceViewController: UIViewController {

    @IBOutlet var cpuDiceImageView: [UIImageView]!
    @IBOutlet var playerDiceImageView: [UIImageView]!
    
    @IBOutlet weak var cpuMoney: UILabel!
    @IBOutlet weak var playerMoney: UILabel!
    
    @IBOutlet weak var redEnvelope: UILabel!
    
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var betUISegmentedControl: UISegmentedControl!
    @IBOutlet weak var startUIButton: UIButton!
    
    var redEnvelopeValue = 2000
    var cpuMoneyValue = 0
    var playerMoneyValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        restart()
    }
    

    
    @IBAction func play(_ sender: Any) {
        
        if startUIButton.currentTitle == "Play" {
            playGame()
        }else{ //
            restart()
       }
        
    }
    
    func playGame(){
        
        var betMoney: Int = 0
        switch betUISegmentedControl.selectedSegmentIndex {
        case 0:
            betMoney = 100
        case 1:
            betMoney = 500
        case 2:
            betMoney = redEnvelopeValue
        default:
            betMoney = 0
        }
        if redEnvelopeValue < betMoney {// 錢不夠就自動all in
            betMoney = redEnvelopeValue
        }
        
        
        //random cpu dice
        var cpuPoint = 0
        for cpuDice in cpuDiceImageView{
            let number = Int.random(in: 1...6)
            cpuPoint = cpuPoint + number
            cpuDice.image = UIImage(systemName: "die.face.\(number).fill")
        }
        //random player dice
        var playerPoint = 0
        for playerice in playerDiceImageView{
            let number = Int.random(in: 1...6)
            playerPoint = playerPoint + number
            playerice.image = UIImage(systemName: "die.face.\(number).fill")
        }
        
        var alertTitle = ""
        var alertMessage = ""
        if(playerPoint == cpuPoint){//平局處理
            alertTitle = "平手"
            alertMessage = "都沒有搶到紅包"
            
        }else if(typeSegmentedControl.selectedSegmentIndex == 0 && playerPoint < cpuPoint) || (typeSegmentedControl.selectedSegmentIndex == 1 && playerPoint > cpuPoint){//勝局處理
            playerMoneyValue = playerMoneyValue + betMoney
            alertTitle = "YA~~"
            alertMessage = "搶到紅包了, 總共搶到 $\(playerMoneyValue)"
            playerMoney.text = "$\(playerMoneyValue)"
            redEnvelopeValue = redEnvelopeValue - betMoney
            
        }else{//敗局處理
            cpuMoneyValue = cpuMoneyValue + betMoney
            alertTitle = "OH NO~~"
            alertMessage = "沒搶到紅包, Peter 總共搶回 $\(cpuMoneyValue)"
            cpuMoney.text = "$\(cpuMoneyValue)"
            redEnvelopeValue = redEnvelopeValue - betMoney
        }
        redEnvelope.text = "$\(redEnvelopeValue)"
        
        //show alert
        let controller = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        if(redEnvelopeValue > 0){
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            let playAction = UIAlertAction(title: "再來一次", style: .default){ _ in
                self.playGame()
            }
            controller.addAction(playAction)
        }else{
            let okAction = UIAlertAction(title: "紅包沒了", style: .default){ _ in
                self.startUIButton.setTitle("重新再來", for: .normal)
            }
            controller.addAction(okAction)
        }
        present(controller, animated: true)
        
    }
    
    func restart(){
        startUIButton.setTitle("Play", for: .normal)
        redEnvelopeValue = 2000
        cpuMoneyValue = 0
        playerMoneyValue = 0
        redEnvelope.text = "$\(redEnvelopeValue)"
        cpuMoney.text = "$\(cpuMoneyValue)"
        playerMoney.text = "$\(playerMoneyValue)"
        typeSegmentedControl.selectedSegmentIndex = 0
        betUISegmentedControl.selectedSegmentIndex = 0
        for cpuDice in cpuDiceImageView{
            cpuDice.image = UIImage(systemName: "die.face.1.fill")
        }
        for playerice in playerDiceImageView{
            playerice.image = UIImage(systemName: "die.face.1.fill")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
