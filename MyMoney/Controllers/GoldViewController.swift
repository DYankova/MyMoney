//
//  GoldViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 20.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class GoldViewController : CustomViewController  {
   
    let goldKey = "goldKey"
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .white
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.collectionView.bounds.width, height: 120)
        }
    }
    
    override func loadView() {
        super.loadView()
        addTextView.text = "XAU"
        addTextView.isEditable = false
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 130),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(RecordCell.self, forCellWithReuseIdentifier: "RecordCell")
        
        let helpData = UserDefaults.standard.object(forKey: goldKey) as? NSData
        if let helpData = helpData {
            gold = ((NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? Gold)!)
        }
        self.collectionView.reloadData()
    }
    
    @objc  override func addNewRecord() {
        if let amount = addAmountTextView.text {
            if let symbol = addTextView.text {
                createGold(symbol: symbol, amount: amount)
                fetchCurrCrypGold(symbol: "XAU", key: "goldKey")
            }
        }
        self.collectionView.reloadData()
    }
    
    func createGold(symbol: String, amount: String){
        gold.symbol = symbol
        if gold.amount != "" {
            guard let gam = gold.amount else { return }
            let first = Double(gam)
            let second = Double(amount)!
            let new : Double = first! + second
            gold.amount = String(new)
        } else {
            gold.amount = amount
        }

        let helpData = NSKeyedArchiver.archivedData(withRootObject: gold)
        UserDefaults.standard.set(helpData, forKey: goldKey)
        
        self.collectionView.reloadData()
    }
    
}

extension GoldViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCell
        fetchCurrCrypGold(symbol: "XAU", key: "goldKey")
        cell.nameLabel.text = gold.symbol
        cell.amountLabel.text = gold.amount
        cell.priceLabel.text = gold.priceUSD
        cell.totalLabel.text = gold.total
        cell.removeBtn.tag = indexPath.item
        cell.removeBtn.addTarget(self, action: #selector(deleteRecord), for: .touchUpInside)
        if (gold.symbol?.elementsEqual(""))! {
            cell.removeBtn.isHidden = true
        } else {
             cell.removeBtn.isHidden =  false
        }
        return cell
    }
    
    @objc func deleteRecord(sender:UIButton){
        gold = Gold(symbol: "", amount: "")
        collectionView.reloadData()
        let helpData = NSKeyedArchiver.archivedData(withRootObject: gold)
        UserDefaults.standard.set(helpData, forKey: goldKey)
        collectionView.reloadData()
    }
    
}

extension GoldViewController:  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.frame.width), height: 40)
    }
}
