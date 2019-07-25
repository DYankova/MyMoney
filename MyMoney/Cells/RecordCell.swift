//
//  RecordCell.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 21.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import  UIKit

class RecordCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let nameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor  = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    let amountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor  = UIColor.black
        return label
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor  = UIColor.black
        return label
    }()
    
    let totalLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor  = UIColor.red
        return label
    }()
    
    let removeBtn : UIButton = {
        let btn = UIButton()
        btn.tintColor = .clear
        btn.setTitleColor(.blue, for: .normal)
        if let image = UIImage(named: "delete") {
            btn.setImage(image, for: .normal)
        }
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let separator : UIView = {
        let lineView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 0.5))
        lineView.layer.borderWidth = 0.3
        lineView.layer.borderColor = UIColor.gray.cgColor
        return lineView
    }()
    
    func setupViews(){
        addSubview(separator)
        addSubview(nameLabel)
        addSubview(amountLabel)
        addSubview(priceLabel)
        addSubview(totalLabel)
        addSubview(removeBtn)
        
        amountLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        nameLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20).isActive = true
        
        amountLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 10).isActive = true
        amountLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        amountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        amountLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20).isActive = true
        
        priceLabel.leftAnchor.constraint(equalTo: amountLabel.rightAnchor, constant: 10).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        priceLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20).isActive = true
        
        totalLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 10).isActive = true
        totalLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        totalLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        totalLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20).isActive = true
        
        removeBtn.leftAnchor.constraint(equalTo: totalLabel.rightAnchor, constant: 10).isActive = true
        removeBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        removeBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        removeBtn.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 25).isActive = true
        
    }
}
