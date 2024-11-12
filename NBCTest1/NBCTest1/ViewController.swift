//
//  ViewController.swift
//  NBCTest1
//
//  Created by YoungJin on 11/12/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBAction func buttonAction(_ sender: Any) {
        self.imageView.image = UIImage(named: "dog")
        self.button.tintColor = .red
        self.number += 1
        if number % 2 == 0 { self.imageView.image = UIImage(named: "cat") }
        else { self.imageView.image = UIImage(named: "dog") }
        print("버튼이 클릭 되었음.")
    }
    private var number: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

