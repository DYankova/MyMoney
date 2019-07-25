//
//  StocksViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 20.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class StocksViewController : CustomViewController  {

    let stocksKey = "stocksKey"

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
        
        let helpData = UserDefaults.standard.object(forKey: stocksKey) as? NSData
        if let helpData = helpData {
            stocks = (NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? [Stock])!
        }
        self.collectionView.reloadData()
    }

    @objc  override func addNewRecord() {
        if let amount = addAmountTextView.text {
            if let symbol = addTextView.text {
                checkIfAlreadyAvailable(symbol: symbol)
                creatStock(symbol: symbol, amount: amount)
                fetchStocks(symbol: symbol)
            }
        }
        self.collectionView.reloadData()
    }

    func checkIfAlreadyAvailable(symbol: String){
        for stock in stocks {
            if (stock.symbol?.caseInsensitiveCompare(symbol) == ComparisonResult.orderedSame){
                stocks.index(of: stock).map { stocks.remove(at: $0) }
            }
        }
    }

    func creatStock(symbol: String, amount: String){
        let stock = Stock(symbol: symbol, amount: amount)
        stock.symbol = symbol
        stock.amount = amount
        stocks.append(stock)
        
        let helpData = NSKeyedArchiver.archivedData(withRootObject: stocks)
        UserDefaults.standard.set(helpData, forKey: stocksKey)
        
        self.collectionView.reloadData()
    }

}

extension StocksViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as! RecordCell
        fetchStocks(symbol: stocks[indexPath.item].symbol!)
        cell.nameLabel.text = stocks[indexPath.item].symbol
        cell.amountLabel.text = stocks[indexPath.item].amount
        cell.priceLabel.text = stocks[indexPath.item].priceUSD
        cell.totalLabel.text = stocks[indexPath.item].total
        cell.removeBtn.tag = indexPath.item
        cell.removeBtn.addTarget(self, action: #selector(deleteRecord), for: .touchUpInside)
        
        stocksTotal = calculateTotal(list: stocks, key: stocksKey)
        return cell
    }
    
    @objc func deleteRecord(sender:UIButton){
        stocks.remove(at: sender.tag)
        let helpData = NSKeyedArchiver.archivedData(withRootObject: stocks)
        UserDefaults.standard.set(helpData, forKey: stocksKey)
        collectionView.reloadData()
    }
}

extension StocksViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(collectionView.frame.width), height: 40)
    }
}
