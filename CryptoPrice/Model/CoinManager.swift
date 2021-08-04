//
//  CoinManager.swift
//  CryptoPrice
//
//  Created by MacOS on 04/08/2021.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didUpdatePrice(_ coinManager:CoinManager, price:CoinModel)
    func didFailWithError(error:Error)
}

struct CoinManager{
    
    var delegate:CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "CBDD22EF-8FEF-41B7-906A-F30C83773197"
    
    let currencyArray=["BRL","CAD","CNY","EUR","GBP","INR","JPY","MXN","NOK",
                        "PLN","RUB","SEK","USD"]
    
    let cryptoArray=["BTC","ETH","BNB","ADA","DOGE","LINK","LTC"]
    
    func fetchData(crypto:String, currency:String){
        let urlString = "\(baseURL)\(crypto)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with url:String){
        
        if let url = URL(string: url){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData=data{
                    if let price=self.parseJSON(safeData){
                        self.delegate?.didUpdatePrice(self, price: price)
                    }
                }
            }
            task.resume()
        }
        
        
        
    }
    
    func parseJSON(_ coinData:Data)->CoinModel?{
        
        let decoder=JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let price = CoinModel(rate: rate)
            return price
        }catch{
            return nil
            }
        }
}
