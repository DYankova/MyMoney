//
//  BasicModel.swift
//  MyMoney
//
//  Created by Dilyana Yankova on 11.07.19.
//  Copyright © 2019 Dilyana Yankova. All rights reserved.
//
import UIKit

class BasicModel: NSObject, NSCoding  {
    
    var symbol: String?
    var amount:  String?
    var priceUSD : String?
    var total : String?
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(symbol, forKey: "symbol")
        aCoder.encode(amount,    forKey: "amount")
        aCoder.encode(priceUSD,    forKey: "priceUSD")
        aCoder.encode(total,    forKey: "total")
    }
    
    required init?(coder aDecoder: NSCoder) {
        symbol = aDecoder.decodeObject(forKey: "symbol") as? String
        amount    = aDecoder.decodeObject(forKey: "amount")    as? String
        priceUSD    = aDecoder.decodeObject(forKey: "priceUSD")    as? String
        total    = aDecoder.decodeObject(forKey: "total")    as? String
    }
    
    init( symbol:String, amount: String ) {
        self.symbol = symbol
        self.amount = amount
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
