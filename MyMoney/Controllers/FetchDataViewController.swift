//
//  FetchDataViewController.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 3.07.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//

import UIKit

class FetchDataViewController: UIViewController {
    var cryptos: [Crypto] = []
    var stocks: [Stock] = []
    var gold = Gold(symbol: "", amount: "")
    var currencies: [Currency] = []
    
    var cryptoTotal = 0.0
    var stocksTotal = 0.0
    var goldTotal = 0.0
    var currenciesTotal = 0.0
    var allTotal = 0.0
    var ounceDiv = 31.1034768 //divider from gold price in ounce to USD
    var list: [BasicModel] = []
    
    func setTotal(amount: String, price: String) -> Double {
        guard !amount.isEmpty && !price.isEmpty else {return 0}
        let amountStr = amount.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        if let amountD = Double(amountStr){
        let priceD = Double(price) ?? 0
        let total: Double = amountD * priceD
        return total
        } else {return 0}
    }
    
    func fetchStocks(symbol: String){
        //FCH.L <-for FC
        guard let url = URL(string: "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="+symbol+"&apikey=M6KQL9U8S30KNV5L") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: [String:Any]]  else {
                    return
                }
                var symb = ""
                var priceUSD = ""
                
                for (value) in jsonArray {
                    for val in value.value {
                        if (val.key).elementsEqual("01. symbol") || (val.key).elementsEqual("05. price") {
                            if (val.key).elementsEqual("01. symbol"){
                                symb =  val.value as! String
                            }
                              if (val.key).elementsEqual("05. price"){
                                 let price =  Double (val.value as! String)
                                 priceUSD = String (price! * 1.2507 / 100) // convert from gbp to usd
                            }
                            
                            for stock in self.stocks {
                                if stock.symbol?.caseInsensitiveCompare(symb) == .orderedSame && !priceUSD.isEmpty {
                                    stock.priceUSD = priceUSD
                                    stock.total = String(self.setTotal(amount: stock.amount!, price:stock.priceUSD!))
                                }
                            }
                            let helpData = NSKeyedArchiver.archivedData(withRootObject: self.stocks)
                            UserDefaults.standard.set(helpData, forKey: "stocksKey")
                        }
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
  
    func fetchCurrCrypGold(symbol: String, key: String ){
        //for Gold symbol = "XAU"
        guard let url = URL(string: "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency="+symbol+"&to_currency=USD&apikey=M6KQL9U8S30KNV5L") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [String: [String:Any]]  else {
                    return
                }
                
                var symb = ""
                var priceUSD = ""
            
                for (value) in jsonArray {
                    for val in value.value {
                        if (val.key).elementsEqual("1. From_Currency Code") || (val.key).elementsEqual("5. Exchange Rate") {
                            if (val.key).elementsEqual("1. From_Currency Code"){
                                symb =  val.value as! String
                            }
                            if (val.key).elementsEqual("5. Exchange Rate"){
                                priceUSD = (val.value as! String)
                            }
                            
                            if symbol.elementsEqual("XAU"){
                                self.gold.symbol = symbol
                                guard  let priceInUsd : Double = Double (priceUSD) else {
                                    return }
                                self.gold.priceUSD = String (priceInUsd / self.ounceDiv)
                                self.gold.total = String(self.setTotal(amount: self.gold.amount!, price:self.gold.priceUSD!))
                                let helpData = NSKeyedArchiver.archivedData(withRootObject: self.gold)
                                UserDefaults.standard.set(helpData, forKey: key)
                            }
 
                            if key.elementsEqual("currenciesKey") {
                                self.list = self.currencies
                            } else if key.elementsEqual("cryptoKey") {
                                self.list = self.cryptos
                            } else {
                                return
                            }
                            for l in self.list {
                                if l.symbol?.caseInsensitiveCompare(symb) == .orderedSame && !priceUSD.isEmpty {
                                    l.priceUSD = priceUSD
                                    l.total = String(self.setTotal(amount: l.amount!, price: l.priceUSD!))
                                    let helpData = NSKeyedArchiver.archivedData(withRootObject: self.list)
                                    UserDefaults.standard.set(helpData, forKey: key)
                                }
                            }
                        }
                    }
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
    
    func calculateTotal(list: [BasicModel], key: String) -> Double {
        var total = 0.0
        for c in list {
            if c.total != nil {
                let cTotal: Double = Double(c.total!) as! Double
                total += cTotal
            }
        }
        print(total)
        return Double(total)
    }

    func calculateAll()-> Double {
        if let helpData = UserDefaults.standard.object(forKey: "stocksKey") as? NSData {
        
            stocks = (NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? [Stock])!
        for stock in stocks {
            fetchStocks(symbol: stock.symbol!)
        }
        //1
        stocksTotal = calculateTotal(list: stocks, key: "stocksKey")
        }
        if let helpData = UserDefaults.standard.object(forKey: "cryptoKey") as? NSData {
            cryptos = (NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? [Crypto])!
            for crypto in cryptos {
                fetchCurrCrypGold(symbol: crypto.symbol!, key: "cryptoKey")
            }
         //2
        cryptoTotal = calculateTotal(list: stocks, key: "cryptoKey")
        }
        if let helpData = UserDefaults.standard.object(forKey: "currenciesKey") as? NSData {
            currencies = (NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? [Currency])!
        for currency in currencies {
            fetchCurrCrypGold(symbol: currency.symbol!, key: "currenciesKey")
        }
         //3
        currenciesTotal = calculateTotal(list: currencies, key: "currenciesKey")
        //4
        }
        if let helpData = UserDefaults.standard.object(forKey: "goldKey") as? NSData {
        gold = ((NSKeyedUnarchiver.unarchiveObject(with: helpData as Data) as? Gold)!)
            if gold.total != nil {
                goldTotal = Double(gold.total!) as! Double
            }
        }
        allTotal = stocksTotal + currenciesTotal + cryptoTotal + goldTotal
        print(allTotal)
        return allTotal
    }
}
