//
//  File.swift
//  SimplyCrypto
//
//  Created by Ryan Villalobos on 4/26/19.
//  Copyright © 2019 Group18. All rights reserved.
//

/* This file will contain a simple class that will have functionaity to connect to our
 third party price tracking API*/
import Foundation

enum cryptoCurrencies : String{
    case BTC, ETC, XRP, BCH, LTC
}

enum worldCurrencies : String{
    case USD, EUR, JPY, GBP, CAD
}

class CryptoContainer {
    
    // Just default to BTC and USD
    var desiredCrypto = cryptoCurrencies.BTC.rawValue
    var desiredWorld = worldCurrencies.USD.rawValue
    
    var cryptoVal: Double? = nil
    //var worldVal: Double? = nil
    
    init() {
        desiredCrypto = cryptoCurrencies.BTC.rawValue
        desiredWorld = worldCurrencies.USD.rawValue
        //self.getCurrentPrice(crypto: desiredCrypto, world: desiredWorld)
    }
    
    static func getCurrentPrice(crypto: String, world: worldCurrencies.RawValue, completionHandler: @escaping (Double, Error?)->Void){
        let requestString = "https://min-api.cryptocompare.com/data/price?fsym="+crypto+"&tsyms="+world
        let url = URL(string: requestString)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    print(dictionary[world]!)
                    completionHandler(dictionary[world] as! Double, nil)
                }
            } else {
                print(error!.localizedDescription)
            }
                
        }
        task.resume()
    }
    
    static func getCoinList(completionHandler: @escaping ([String: String]?, Error?)->Void){
        let requestString = "https://min-api.cryptocompare.com/data/all/coinlist"
        let url = URL(string: requestString)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    let dic = (dictionary["Data"] as? [String: [String: Any]])
                    var ret: [String: String] = [:]
                    for i in dic!.keys {
                        if (dic![i]!["IsTrading"]! as! Bool) {
                            ret[dic![i]!["FullName"]! as! String] = dic![i]!["Symbol"]! as? String
                        }
                    }
                    completionHandler(ret, nil)
                }
            } else {
                print(error!.localizedDescription)
            }
            
        }
        task.resume()
    }
    
}

