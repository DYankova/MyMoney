//
//  CurrencyViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 20.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class CurrencyViewController : CustomViewController  {
    
    let currenciesKey = "currenciesKey"
    
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
        
        let helpData = UserDefaults.standard.object(forKey: currenciesKey) as? NSData
        if let helpData = helpData {
            currencies = (NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? [Currency])!
        }
        self.collectionView.reloadData()
    }
    
    @objc  override func addNewRecord() {
        if let amount = addAmountTextView.text {
            if let symbol = addTextView.text {
                checkIfAlreadyAvailable(symbol: symbol)
                createCurrency(symbol: symbol, amount: amount)
                fetchCurrCrypGold(symbol: symbol, key: currenciesKey)
            }
        }
        self.collectionView.reloadData()
    }
    
    func checkIfAlreadyAvailable(symbol: String){
        for currency in currencies {
            if (currency.symbol?.caseInsensitiveCompare(symbol) == ComparisonResult.orderedSame){
                currencies.index(of: currency).map { currencies.remove(at: $0) }
            }
        }
    }
    
    func createCurrency(symbol: String, amount: String){
        let currency = Currency(symbol: symbol, amount: amount)
        currency.symbol = symbol
        currency.amount = amount
        currencies.append(currency)
        
        let helpData = NSKeyedArchiver.archivedData(withRootObject: currencies)
        UserDefaults.standard.set(helpData, forKey: currenciesKey)
        
        self.collectionView.reloadData()
    }
    
}

extension CurrencyViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCell
        fetchCurrCrypGold(symbol: currencies[indexPath.item].symbol!, key: "currenciesKey")
        cell.nameLabel.text = currencies[indexPath.item].symbol
        cell.amountLabel.text = currencies[indexPath.item].amount
        cell.priceLabel.text = currencies[indexPath.item].priceUSD
        cell.totalLabel.text = currencies[indexPath.item].total
        cell.removeBtn.tag = indexPath.item
        cell.removeBtn.addTarget(self, action: #selector(deleteRecord), for: .touchUpInside)
        
        currenciesTotal = calculateTotal(list: currencies, key: currenciesKey)
        return cell
    }
    
    @objc func deleteRecord(sender:UIButton){
        currencies.remove(at: sender.tag)
        let helpData = NSKeyedArchiver.archivedData(withRootObject: currencies)
        UserDefaults.standard.set(helpData, forKey: currenciesKey)
        collectionView.reloadData()
    }
    
}

extension CurrencyViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.frame.width), height: 40)
    }
}
