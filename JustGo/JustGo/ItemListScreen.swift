//
//  ItemListScreen.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/5.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit

//structs for decoding JSON from url
struct Product: Decodable{
    let name:String
    let price:String
    let picture:String
    let storeID:String
    let image:String
    
    enum CodingKeys : String, CodingKey {
        case name
        case price
        case picture
        case storeID = "store_ID"
        case image
    
        
    }
    
}

struct Shop: Decodable{
    let drinks:[Product]
    let food:[Product]
    let id:String
    let lat:String
    let lon:String
    let address:String
    let name:String
    
    enum CodingKeys : String, CodingKey {
        case name = "store_Name"
        case address
        case lat = "store_Latitude"
        case lon = "store_Longtitude"
        case id = "ID"
        case drinks = "Drinks"
        case food = "Food"
        
    }
}

var storeArr = [Store]()
var itemArr = [Item]()
var imageArr = [UIImage]()


class ItemListScreen: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //the url of json file
    let url = "http://justgo1.serveo.net/"
    
    //setup search controller
    var search_text:String = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //for searching results
    var filteredItems = [Item]()
    var homepageFilteredItems = [Item]()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         print(search_text)
        
        //setting up searchController and navigation bar
        self.setupSearchController()
        self.setupNavBar()
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        
        if !search_text.isEmpty {
            filterArray(keyword: search_text)
        }

        print("search_text is: \(search_text)")
        print("is search bar empty? \(searchBarIsEmpty())")

        
        print("program started")
        getJson{
            result in
            storeArr = result.0
            itemArr = result.1
            //self.generateCells()
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }            
           
        }
        
    }
    //setting up search controller
    func setupSearchController(){
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Food"
        searchController.isActive = true
        searchController.searchBar.text = search_text
        definesPresentationContext = true
    }
    
    //setting up navigation bar
    func setupNavBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //implement searching
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = itemArr.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    func filterArray(keyword:String){
        filteredItems = itemArr.filter({( item : Item) -> Bool in
            return item.name.lowercased().contains(keyword.lowercased())
        })
        tableView.reloadData()
    }

    
    //get data from url
    func getJson(_ completionHandler:  @escaping(([Store],[Item])) -> ()){
       
        let urlObj = URL(string: url)
        var tempStoreArr = [Store]()
        var tempItemArr = [Item]()
        
        var request: URLRequest = URLRequest(url: urlObj!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request){ (data,res,err) in
            // ensure there is no error for this HTTP response
            
            
            guard err == nil else {
                print ("error: \(err!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let json = data else {
                print("No data")
                return
            }
            
            guard json.count != 0 else{
                print("zero bytes of data")
                return
            }
            
            //for error checking
            //            do{
            //                let stores = try JSONDecoder().decode([Shop].self, from: json)
            //            }catch{
            //                print("error \(error)")
            //            }
            
            // Parse JSON into Dictionary that contains Array of Car struct using JSONDecoder
            guard let stores = try? JSONDecoder().decode([Shop].self, from: json) else {
                print(data!.count)
                //print(res)
                print("Error: Couldn't decode data into array of shops")
                return
            }
            
            //loop through the data and
    
     
            for store in stores{
                //loop through drinks items
                var drinksArr = [Item]()
                for drink in store.drinks{
                    let new_drink = Item(name:drink.name,price:drink.price,picture:drink.picture,storeID:drink.storeID,image:UIImage(named:drink.image)!)
                    //print(new_drink)
                    //new_drink.getInfo()
                    drinksArr.append(new_drink)
                    
                }
                
                //print(drinksArr)
                //add these to the item array
                tempItemArr += drinksArr
                //loop through food items
                var foodArr = [Item]()
                for food in store.food{
                    let new_food = Item(name:food.name,price:food.price,picture:food.picture,storeID:food.storeID,image:UIImage(named:food.image)!)
                    //print(new_food)
                    //new_food.getInfo()
                    foodArr.append(new_food)
                }
                //print(foodArr)
                tempItemArr += foodArr
                
                //create Store objects
                let new_store = Store(name:store.name,storeID:store.id,drinks:drinksArr,food:foodArr,address:store.address,lat:store.lat,lon:store.lon)
                
                tempStoreArr.append(new_store)
                
            }
            completionHandler((tempStoreArr,tempItemArr))
        }
        task.resume()
        
    }
    

    
    //passing data from list view to detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail"{
            let destination = segue.destination as! DetailViewController
            destination.item = sender as? Item 
        }
    }

}

extension ItemListScreen: UITableViewDataSource, UITableViewDelegate{
    //update searching
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredItems.count
        }
        return itemArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let item: Item
        if ( isFiltering()) {
            item = filteredItems[indexPath.row]
        } else {
            item = itemArr[indexPath.row]
        }
        cell.setItem(item: item)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemArr[indexPath.row]
        performSegue(withIdentifier: "ListToDetail", sender: item)
    }

}

extension ItemListScreen: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
