//
//  ViewController.swift
//  NBCTest4(CounterApp, storyboard)
//
//  Created by YoungJin on 11/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var number: Int = 0

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBAction func minusButtonTapped(_ sender: Any) {
        self.number -= 1
        label.text = "\(self.number)"
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        self.number += 1
        label.text = "\(self.number)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
    }


}

