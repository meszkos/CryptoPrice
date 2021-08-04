//
//  ViewController.swift
//  CryptoPrice
//
//  Created by MacOS on 02/08/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var coinManager=CoinManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate=self
        pickerView.dataSource=self
        coinManager.delegate=self
    }


}

//MARK:- PickerView Methods

extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0{
            return coinManager.cryptoArray.count
        }else{
            return coinManager.currencyArray.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return coinManager.cryptoArray[row]
        }else{
            return coinManager.currencyArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let crypto = coinManager.cryptoArray[pickerView.selectedRow(inComponent: 0)]
        let currency = coinManager.currencyArray[pickerView.selectedRow(inComponent: 1)]
        
        currencyLabel.text=currency
        cryptoImage.image=UIImage(named: crypto)
        
        coinManager.fetchData(crypto: crypto, currency: currency)
        
        
    }
    
    
}
//MARK:- CoinManager Methods

extension ViewController:CoinManagerDelegate{
    
    func didUpdatePrice(_ coinManager: CoinManager, price: CoinModel) {
        
        DispatchQueue.main.async {
            self.priceLabel.text = String(format: "%.2f", price.rate)
            
        }
        
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
