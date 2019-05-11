//
//  ItemListScreen.swift
//  JustGo
//
//  Created by Ronan Chang on 2019/5/5.
//  Copyright © 2019 ios.nyu.edu. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
import CoreLocation

var storeArr = [Store]()
var itemArr = [Item]()
var imageArr = [UIImage]()


class custom_Pin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    
    init(pinTitle:String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        
        self.coordinate = location
    }
}


class ItemListScreen: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var tempStoreArr = [Store]()
    var tempItemArr = [Item]()
    let locationManager = CLLocationManager()
    
    
    //setup search controller
    var search_text:String?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //for searching results
    var filteredItems = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTypedAround()

        
        
        //setting up searchController and navigation bar
        self.setupSearchController()
        self.setupNavBar()
        

        print("search_text is: \(search_text)")
        print("is search bar empty? \(searchBarIsEmpty())")

        
        print("program started")
        //use Firebase to load data for table
        let ref = Database.database().reference()
        ref.observe(.value, with: {(Snapshot) in
            if (Snapshot.childrenCount > 0) {
                storeArr = []
                itemArr = []
                for store in Snapshot.children.allObjects as! [DataSnapshot] {
                    let childRef = ref.child(store.key)
                    childRef.child("Food").observe(.value, with: { (Snapshot) in
                        for eachfood in Snapshot.children.allObjects as! [DataSnapshot] {
                            let foodObject = eachfood.value as? [String: AnyObject]
                            let foodName = foodObject?["name"]
                            let foodStoreID = foodObject?["store_ID"]
                            let foodPrice = foodObject?["price"]
                            let foodImage = foodObject?["image"]
                            let foodPicture = foodObject?["picture"]
                            //create a new food item and add to table
                            let new_food = Item(name:foodName as! String, price:foodPrice as! String, picture:foodPicture as! String, storeID:foodStoreID as! String, image:UIImage(named:foodImage as! String)!)
                            itemArr.append(new_food)
                            self.tableView.reloadData()
                        }
                    })
                    childRef.child("Drinks").observe(.value, with: {(Snapshot) in
                        for eachDrink in Snapshot.children.allObjects as! [DataSnapshot] {
                            let drinkObject = eachDrink.value as? [String: AnyObject]
                            let drinkName = drinkObject?["name"]
                            let drinkStoreID = drinkObject?["store_ID"]
                            let drinkPrice = drinkObject?["price"]
                            let drinkImage = drinkObject?["image"]
                            let drinkPicture = drinkObject?["picture"]
                            //create a new drink item and add to table
                            let new_drink = Item(name:drinkName as! String,price:drinkPrice as! String, picture:drinkPicture as! String, storeID:drinkStoreID as! String, image:UIImage(named:drinkImage as! String)!)
                        //  new_drink.getInfo()
                            itemArr.append(new_drink)
                        }
                    })
                    let storeObject = store.value as? [String: AnyObject]
                    let storeName = storeObject?["store_Name"]
                    let storeID = storeObject?["ID"]
                    let storeAddress = storeObject?["address"]
                    let storeLatitude = storeObject?["store_Latitude"]
                    let storeLongtitude = storeObject?["store_Longtitude"]
                    let storeCount = storeObject?["count"]
                    //print(storeCount)
                    //create a new store
                    let new_store = Store(name:storeName as! String, storeID:storeID as! String,address:storeAddress as! String, lat:storeLatitude as! String,lon:storeLongtitude as! String, count: storeCount as! String)
                    
                    storeArr.append(new_store)
                    self.tableView.reloadData()
                    
                    //perform search when everything is loaded!!!!
                    //
                    self.searchController.searchBar.becomeFirstResponder()
                    
                    
                }
            }
            self.searchController.searchBar.text = self.search_text
            
            self.searchController.searchBar.becomeFirstResponder()
            print(storeArr.count)
            //FOR JIMMY: loop through storeArr to get the coordinates and store name
            func createNewPin(name: String, latt: Double, long: Double){
                let another_pin_coor = CLLocationCoordinate2D(latitude: latt, longitude: long)
                let another_pin = custom_Pin(pinTitle: name, location: another_pin_coor)
                self.mapView.addAnnotation(another_pin)
            }
            
            let lat = 40.7308
            let log = -73.9973
            let location = CLLocationCoordinate2D(latitude: lat, longitude: log)
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)


            
            for curr_store in storeArr{
                createNewPin(name: curr_store.name, latt: Double(curr_store.lat)! , long: Double(curr_store.lon)!)
                print(curr_store.name)
            }

        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "ListToDetail"{
                    let destination = segue.destination as! DetailViewController
                    destination.item = sender as? Item
                }
            }
    
    //setting up search controller
    func setupSearchController(){        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Food"
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
    func createNewPin(name: String, latt: Double, long: Double){
        let another_pin_coor = CLLocationCoordinate2D(latitude: latt, longitude: long)
        let another_pin = custom_Pin(pinTitle: name, location: another_pin_coor)
        self.mapView.addAnnotation(another_pin)
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != ""{
            
            filterContentForSearchText(searchController.searchBar.text!)
            self.mapView.removeAnnotations(self.mapView.annotations)
            for item in self.filteredItems{
                for store in storeArr{
                    if store.storeID == item.storeID{
                        createNewPin(name: store.name, latt: Double(store.lat)!, long: Double(store.lon)!)
                    }
                }
            }
        }
        }

}
