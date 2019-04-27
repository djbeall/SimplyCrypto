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
    var worldVal: Double? = nil
    
    init() {
        desiredCrypto = cryptoCurrencies.BTC.rawValue
        desiredWorld = worldCurrencies.USD.rawValue
        self.getCurrentPrice(crypto: desiredCrypto, world: desiredWorld)
    }
    
    func getCurrentPrice(crypto: cryptoCurrencies.RawValue, world: worldCurrencies.RawValue)
        -> (crptoValue:Double?, worldValue:Double?) {
            //need this for the bootleg block
            worldVal = nil
            desiredCrypto = crypto
            desiredWorld = world
            print(crypto)
            print(world)
            let requestString = "https://min-api.cryptocompare.com/data/price?fsym="+crypto+"&tsyms="+world
            let url = URL(string: requestString)!
            cryptoVal = 1;
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else {
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    print(dictionary[world])
                    if let value = dictionary[world] as? Double?{
                        //print(value)
                        self.worldVal = value
                    }
                }
                //print(String(data: data, encoding: .utf8)!)
            }
            task.resume()
            while(worldVal == nil || task.error != nil) {
                //bootleg block
            }
            print(worldVal)
            
            return (worldVal,cryptoVal)
    }
}
