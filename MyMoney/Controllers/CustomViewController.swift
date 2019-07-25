//
//  CustomViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 21.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class CustomViewController:  FetchDataViewController {
   
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add +", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("<- Back", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 4
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let addAmountTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.textColor = .gray
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.keyboardType = .numberPad
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "add amount "
        label.textColor = .gray
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "add the symbol"
        label.textColor = .gray
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let notOkLabel: UILabel = {
        let label = UILabel()
        label.text = "Not found, please add correct symbol and amount"
        label.textColor = .red
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .red
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount"
        label.textColor = .red
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let singlePriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.textColor = .red
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.textColor = .red
        label.font = label.font.withSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backButton)
        view.addSubview(addButton)
        view.addSubview(addTextView)
        view.addSubview(addAmountTextView)
        view.addSubview(amountLabel)
        view.addSubview(symbolLabel)
        view.addSubview(notOkLabel)
        
        view.addSubview(nameLabel)
        view.addSubview(amountTextLabel)
        view.addSubview(singlePriceLabel)
        view.addSubview(totalPriceLabel)
        
        backButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        addAmountTextView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        addAmountTextView.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 50).isActive = true
        addAmountTextView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addAmountTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
       
        amountLabel.bottomAnchor.constraint(equalTo: addTextView.topAnchor, constant: 60).isActive = true
        amountLabel.leftAnchor.constraint(equalTo: backButton.rightAnchor, constant: 20).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addTextView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        addTextView.leftAnchor.constraint(equalTo: addAmountTextView.rightAnchor, constant: 10).isActive = true
        addTextView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        symbolLabel.bottomAnchor.constraint(equalTo: addTextView.topAnchor, constant: 60).isActive = true
        symbolLabel.leftAnchor.constraint(equalTo: addAmountTextView.rightAnchor).isActive = true
        symbolLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        symbolLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addButton.addTarget(self, action: #selector(chechIfaddNewRecord), for: .touchUpInside)
        
        notOkLabel.bottomAnchor.constraint(equalTo: addTextView.topAnchor, constant: 60).isActive = true
        notOkLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        notOkLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: addTextView.topAnchor, constant: 60).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: backButton.leftAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        amountTextLabel.topAnchor.constraint(equalTo: addTextView.topAnchor, constant: 60).isActive = true
        amountTextLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
        amountTextLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        amountTextLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        singlePriceLabel.topAnchor.constraint(equalTo: addTextView.topAnchor, constant: 60).isActive = true
        singlePriceLabel.leftAnchor.constraint(equalTo: amountTextLabel.rightAnchor, constant: 10).isActive = true
        singlePriceLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        singlePriceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalPriceLabel.topAnchor.constraint(equalTo: addTextView.topAnchor, constant: 60).isActive = true
        totalPriceLabel.leftAnchor.constraint(equalTo: singlePriceLabel.rightAnchor, constant: 10).isActive = true
        totalPriceLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        totalPriceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc  func chechIfaddNewRecord(){
        if addTextView.text.elementsEqual("") || addAmountTextView.text.elementsEqual(""){
            notOkLabel.isHidden = false
            amountLabel.isHidden = true
            symbolLabel.isHidden = true
        } else {
            addNewRecord()
            notOkLabel.isHidden = true
            amountLabel.isHidden = false
            symbolLabel.isHidden = false
        }
    }
    func addNewRecord(){}
    
}
