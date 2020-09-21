//
//  ViewController.swift
//  CommonMethods
//
//  Created by technomac8 on 21/09/20.
//  Copyright © 2020 technomac8. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //var dic = [AnyHashable:Any]()
    
//    //MARK:- getApiCallMethod
//    func getApiCallMethod() {
//
//        GOCProgress.shared.defaultConfig()
//        GOCProgress.show()
//
//        APIManager.shared.jsonCallwithGet(dicData: nil, ApiName: .none) { (dict, didSuccess, rescode)    in
//
//            print("dict is \(String(describing: dict))")
//            DispatchQueue.main.async {
//                GOCProgress.dismiss()
//                if didSuccess {
//                    let data = dict?.value(forKey: "data") as? NSDictionary
//                    let dictData = data?.value(forKey: "key") as? NSArray
//
//                    do
//                    {
//                        let dictData1 = try JSONSerialization.data(withJSONObject: dictData!, options: .prettyPrinted)
//                        self.arrWalletData = try JSONDecoder().decode([History].self, from: dictData1)
//
//                        DispatchQueue.main.async {
//                            self.tableviewHistory.reloadData()
//                        }
//                    }catch {
//                        print("exception \(error.localizedDescription)")
//                    }
//                }else{
//                    print("error______")
//                }
//            }
//        }
//    }
    
}

