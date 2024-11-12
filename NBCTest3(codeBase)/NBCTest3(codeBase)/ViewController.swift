//
//  ViewController.swift
//  NBCTest3(codeBase)
//
//  Created by YoungJin on 11/12/24.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    
    let imageView = UIImageView()
    let label = UILabel()
    let imageView2 = UIImageView()
    let label2 = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }

    private func configureUI() {
        view.backgroundColor = .white
        
        imageView.image = UIImage(named: "cat")
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        label.text = "고양이"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        imageView2.image = UIImage(named: "dog")
        imageView2.backgroundColor = .black
        imageView2.contentMode = .scaleAspectFit
        label2.text = "강아지"
        label2.textColor = .black
        label2.font = UIFont.boldSystemFont(ofSize: 30)
        
        [imageView, label, imageView2, label2]
            .forEach { view.addSubview($0) }
        
       
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(160)
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.centerX.equalTo(imageView.snp.centerX)
            $0.top.equalTo(imageView.snp.bottom).offset(16)
        }
        
        imageView2.snp.makeConstraints {
            $0.width.height.equalTo(imageView)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        label2.snp.makeConstraints {
            $0.centerX.equalTo(imageView2.snp.centerX)
            $0.top.equalTo(imageView2.snp.bottom).offset(16)
        }
        
        }
    

}

