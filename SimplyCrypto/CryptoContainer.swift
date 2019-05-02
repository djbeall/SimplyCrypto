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

enum timeType : String {
    case histoday, histohour, histominute
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
                    completionHandler(dictionary[world] as! Double, nil)
                }
            } else {
                print(error!.localizedDescription)
            }
                
        }
        task.resume()
    }
    
    /*
     OHCLV stands for Open, High, Low, Close, Volume, these are the paramters that our API
     returns when requesting historical data for any period of time i.e.
     (each element in the reuturnecd JSON Array has these members)
     0: Object
     time: 1547856000
     close: 3729.78
     high: 3799.62
     low: 3643.01
     open: 3648.05
     volumefrom: 38341.35
     volumeto: 143238228.4
     */
    struct Ohlcv :Codable {
        /*time is stored as a unix/epoch timestamp*/
        var time : Double?
        var close : Double?
        var high : Double?
        var low : Double?
        var open : Double?
        /*for some reason I cant seem to get volumeFrom and volumeTo to parse, but we probably wont use these anyways*/
        var volumeFrom : Double?
        var volumeTo : Double?
    }
    /**
     *This function will get the historical proice data for minutes, hours, and days which can be slected with
     *the timeType paramter (options listed in enum).  The limit paramter is called for how many data points
     *can be returned by the API.  timeAggregte is the time period to aggregate the data over (for daily it's days,
     *for hourly it's hours and for minute histo it's minutes), there is a min of 1, and a max of 30.
     * The completionhandler will return an array of Ohclv structs, info from which we can use to populate
     *the charts.
     */
    static func getHistoricalPrice(crypto: String, world: worldCurrencies.RawValue, timeType : timeType.RawValue, limit :Int, timeAggregate: Int, completionHandler: @escaping ([Ohlcv], Error?) -> Void) {
        let requestString = "https://min-api.cryptocompare.com/data/"+timeType+"?fsym="+crypto+"&tsym="+world+"&limit="+String(limit)+"&aggregate="+String(timeAggregate)
        print(requestString)
        let url = URL(string:requestString)!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                var ret : [Ohlcv] = []
                if let dictionary = json as? [String:Any] {
                    /*need to parse json return here*/
                    let dic = dictionary["Data"]
                    if let arr = try? JSONSerialization.data(withJSONObject: dic!, options: []) {
                        let decoder = JSONDecoder()
                        //print(String(data: arr, encoding: String.Encoding.utf8))
                        do {
                            ret = try decoder.decode([Ohlcv].self, from: arr)
                            //print(ret)
                        } catch {
                            print(error.localizedDescription)
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
