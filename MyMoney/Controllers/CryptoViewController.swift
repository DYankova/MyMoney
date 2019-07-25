//
//  CryptoViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 20.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//
import UIKit

class CryptoViewController: CustomViewController {
  
    let cryptoKey = "cryptoKey"
    var total = 100
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
        
        let helpData = UserDefaults.standard.object(forKey: cryptoKey) as? NSData
        if let helpData = helpData {
            cryptos = (NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? [Crypto])!
        }
        self.collectionView.reloadData()
    }
    
    @objc  override func addNewRecord() {
        if let amount = addAmountTextView.text {
            if let symbol = addTextView.text {
                checkIfAlreadyAvailable(symbol: symbol)
                createCrypto(symbol: symbol, amount: amount)
                fetchCurrCrypGold(symbol: symbol, key: cryptoKey)
            }
        }
        self.collectionView.reloadData()
    }
    
    func checkIfAlreadyAvailable(symbol: String){
        for crypto in cryptos {
            if (crypto.symbol?.caseInsensitiveCompare(symbol) == ComparisonResult.orderedSame){
               cryptos.index(of: crypto).map { cryptos.remove(at: $0) }
            }
        }
    }
    
    func createCrypto(symbol: String, amount: String){
        let crypto = Crypto(symbol: symbol, amount: amount)
        crypto.symbol = symbol
        crypto.amount = amount
        cryptos.append(crypto)
       
        let helpData = NSKeyedArchiver.archivedData(withRootObject: cryptos)
        UserDefaults.standard.set(helpData, forKey: cryptoKey)
        
        self.collectionView.reloadData()
    }
    
}

extension CryptoViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fetchCurrCrypGold(symbol: cryptos[indexPath.item].symbol!, key: cryptoKey)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCell
        cell.nameLabel.text = cryptos[indexPath.item].symbol
        cell.amountLabel.text = cryptos[indexPath.item].amount
        cell.priceLabel.text = cryptos[indexPath.item].priceUSD
        cell.totalLabel.text = cryptos[indexPath.item].total
        cell.removeBtn.tag = indexPath.item
        cell.removeBtn.addTarget(self, action: #selector(deleteRecord), for: .touchUpInside)
        cryptoTotal = calculateTotal(list: cryptos, key: cryptoKey)
        return cell
    }
    
    @objc func deleteRecord(sender:UIButton){
        cryptos.remove(at: sender.tag)
        let helpData = NSKeyedArchiver.archivedData(withRootObject: cryptos)
        UserDefaults.standard.set(helpData, forKey: cryptoKey)
        collectionView.reloadData()
    }
    
}

extension CryptoViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.frame.width), height: 40)
    }
}
