//
//  ViewController.swift
//  NBCTest2
//
//  Created by YoungJin on 11/12/24.
//

import UIKit

class ViewController: UIViewController {

    private let id: String = "adam"
    private let password: String = "1234"
    
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func buttonAction(_ sender: Any) {
        let result: Bool = idTextField.text == self.id && passwordTextField.text == self.password
        print(result ? "로그인 성공" : "로그인 실패")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
