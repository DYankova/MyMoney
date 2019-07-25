//
//  ViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 19.06.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class LaunchViewController: FetchDataViewController, UIScrollViewDelegate {

    let titleLbl: UILabel = {
        let label = UILabel()
        label.text = "Profit"
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    let totalTextLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cryptoLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cryptoBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 1
        return btn
    }()
    
    let stockLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
 
    let stocksBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 2
        return btn
    }()
    
    let goldLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let goldBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 3
        return btn
    }()
    
    let currencyLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currencyBtn: UIButton = {
        let btn = UIButton()
        btn.tag = 4
        return btn
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        designButton(btn: totalBtn , title: "My total (in $)")
        designButton(btn: cryptoBtn , title: "Go to crypto")
        designButton(btn: stocksBtn , title: "Go to Stocks")
        designButton(btn: currencyBtn , title: "Go to currency")
        designButton(btn: goldBtn , title: "Go to gold (in grams)")
        totalBtn.addTarget(self, action:#selector(hideShowTotal), for: .touchUpInside)
        
        view.addSubview(titleLbl)
        view.addSubview(totalBtn)
        view.addSubview(totalTextLbl)

        view.addSubview(cryptoLbl)
        view.addSubview(cryptoBtn)
      
        view.addSubview(stockLbl)
        view.addSubview(stocksBtn)
        
        view.addSubview(goldLbl)
        view.addSubview(goldBtn)
        
        view.addSubview(currencyLbl)
        view.addSubview(currencyBtn)
        
        addConstraints()
    }

    func addConstraints(){

        titleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLbl.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        titleLbl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalBtn.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
        totalBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        totalBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        totalTextLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 35).isActive = true
        totalTextLbl.topAnchor.constraint(equalTo: totalBtn.bottomAnchor, constant: 7).isActive = true
        totalTextLbl.widthAnchor.constraint(equalToConstant: 150).isActive = true
        totalTextLbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
        addConstr(title: cryptoLbl, button: cryptoBtn, topAnchor: totalTextLbl.topAnchor)
        addConstr(title: stockLbl,  button: stocksBtn, topAnchor: cryptoBtn.topAnchor)
        addConstr(title: goldLbl,  button: goldBtn, topAnchor: stocksBtn.topAnchor)
        addConstr(title: currencyLbl,  button: currencyBtn, topAnchor: goldBtn.topAnchor)
    }

    func designButton(btn: UIButton, title: String) {
        btn.backgroundColor = .clear
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.tintColor = .white
        btn.setTitleColor(.white, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action:#selector(openClass(sender:)), for: .touchUpInside)
    }
    
    @objc func openClass(sender: UIButton){
        var nextViewController  = UIViewController()
        switch sender.tag {
        case 1:
            nextViewController = CryptoViewController()
        case 2:
            nextViewController = StocksViewController()
        case 3:
            nextViewController = GoldViewController()
        case 4:
            nextViewController = CurrencyViewController()
       
        default:
            return
        }
        self.present(nextViewController, animated: true, completion: nil)
    }
 
    
    @objc func hideShowTotal(){
        let allTotal = calculateAll()
        totalTextLbl.text = String(format: "%.5f", allTotal)
        totalTextLbl.isHidden = !totalTextLbl.isHidden
        cryptoLbl.isHidden = !cryptoLbl.isHidden
        stockLbl.isHidden = !stockLbl.isHidden
        goldLbl.isHidden = !goldLbl.isHidden
        currencyLbl.isHidden = !currencyLbl.isHidden
        cryptoLbl.text =  "Total USD in crypto: " + String( calculateTotal(list: cryptos, key: "cryptoKey"))
        stockLbl.text =  "Total USD in stocks: " +  String( calculateTotal(list: stocks, key: "stocksKey"))
        currencyLbl.text = "Total USD in currencies: " +  String( calculateTotal(list: currencies, key: "currenciesKey"))
        fetchCurrCrypGold(symbol: "XAU",key: "goldKey")
        goldLbl.text =   "Total USD in gold: " + String(gold.total ?? "")
    }
    
    func addConstr(title : UILabel , button: UIButton, topAnchor :NSLayoutYAxisAnchor ){
        title.centerXAnchor.constraint(equalTo: totalBtn.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
        title.widthAnchor.constraint(equalToConstant: 270).isActive = true
        button.centerXAnchor.constraint(equalTo: totalBtn.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topAnchor, constant: 70).isActive = true
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
}

