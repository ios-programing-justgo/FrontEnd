//
//  ViewController.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/3.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

////structs for decoding JSON from url
//struct Product: Decodable{
//    let name:String
//    let price:String
//    let picture:URL
//    
//}

//struct Shop: Decodable{
//    let drinks:[Product]
//    let food:[Product]
//    let id:String
//    let lat:String
//    let lon:String
//    let address:String
//    let name:String
//
//    enum CodingKeys : String, CodingKey {
//        case name = "store_Name"
//        case address
//        case lat = "store_Latitude"
//        case lon = "store_Longtitude"
//        case id = "ID"
//        case drinks = "Drinks"
//        case food = "Food"
//
//    }
//}

class ViewController: UIViewController {
//
//    //the url of json file
//    let url = "http://justgo.serveo.net/"
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        print("program started")
//        getJson()
//
//    }
//
//    //get data from url
//    func getJson(){
//        print("getting json")
//        let urlObj = URL(string: url)
//
//        var request: URLRequest = URLRequest(url: urlObj!)
//        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "GET"
//
//
//        let task = URLSession.shared.dataTask(with: request){ (data,res,err) in
//            // ensure there is no error for this HTTP response
//
//            guard err == nil else {
//                print ("error: \(err!)")
//                return
//            }
//
//            // ensure there is data returned from this HTTP response
//            guard let json = data else {
//                print("No data")
//                return
//            }
//
//            guard json.count != 0 else{
//                print("zero bytes of data")
//                return
//            }
//
////for error checking
////            do{
////                let stores = try JSONDecoder().decode([Shop].self, from: json)
////            }catch{
////                print("error \(error)")
////            }
//
//            // Parse JSON into Dictionary that contains Array of Car struct using JSONDecoder
//            guard let stores = try? JSONDecoder().decode([Shop].self, from: json) else {
//                print(data!.count)
//                print(res)
//                print("Error: Couldn't decode data into array of shops")
//                return
//            }
//
//            //loop through the data and
//            for store in stores{
//                print("The name of name: \(store.name)")
//            }
//        }
//        task.resume()
//    }
}

