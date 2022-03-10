//  Created by Wabbit on 29/08/18.
//  Copyright © 2018 Wabbit. All rights reserved.

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
//protocol MapPlacesViewControllerDelegate : AnyObject {
//    func updateAdress(address:String, zipCode: String, isFromMap: Bool)
//}

class MapPlacesViewController: BaseViewController {
    
    
    @IBOutlet weak var textfieldAddress: UITextField!
    @IBOutlet weak var tableviewSearch: UITableView!
    @IBOutlet weak var constraintSearchIconWidth: NSLayoutConstraint!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapview: MKMapView!
    
    var autocompleteResults :[GApiResponse.Autocomplete] = []
    var locationManager: CLLocationManager!
    
    var storemodel = StoreViewModel()
    var zipCode = ""
    var cityName = ""
    var lat = 0.0
    var lng = 0.0
    
    // weak var mapDelegate: MapPlacesViewControllerDelegate?
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        textfieldAddress.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // getAddressFromLatLong(latitude: 31.48115075552822, longitude: 74.31113822682003)
                if let c = mainContainer {
                    c.viewTopColour.isHidden = false
                    c.titleLabel.text = "Choose location"
                }
        setCurrentlocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // setCurrentlocation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let c = mainContainer {
            c.viewTopColour.isHidden = false
        }
    }
    func setCurrentlocation() {
        
        if self.isLocationOn()
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func showResults(string:String){
        var input = GInput()
        input.keyword = string
        GoogleApi.shared.callApi(input: input) { (response) in
            if response.isValidFor(.autocomplete) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = false
                    self.autocompleteResults = response.data as! [GApiResponse.Autocomplete]
                    self.tableviewSearch.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
    
    func hideResults(){
        searchView.isHidden = true
        autocompleteResults.removeAll()
        tableviewSearch.reloadData()
    }
    
    @IBAction func setCruntLocation(_ sender: Any) {
        setCurrentlocation()
    }
    
    @IBAction func chooseLocationAction(_ sender: Any) {
        self.storemodel.address = textfieldAddress.text ?? self.storemodel.address
        self.getAddressFromLatLong(latitude: self.lat, longitude: self.lng)
        //   mapDelegate?.updateAdress(address: textfieldAddress.text ?? self.storemodel.address, zipCode: self.zipCode, isFromMap: true)
      //  navigationController?.popViewController(animated: true)
    }
    
}

extension MapPlacesViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideResults() ; return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let fullText = text.replacingCharacters(in: range, with: string)
        if fullText.count > 2 {
            showResults(string:fullText)
        }else{
            hideResults()
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        constraintSearchIconWidth.constant = 0.0 ; return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        constraintSearchIconWidth.constant = 38.0 ; return true
    }
}

extension MapPlacesViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var input = GInput()
        let destination = GLocation.init(latitude: mapview.region.center.latitude, longitude: mapview.region.center.longitude)
        input.destinationCoordinate = destination
        GoogleApi.shared.callApi(.reverseGeo , input: input) { (response) in
            if let places = response.data as? [GApiResponse.ReverseGio], response.isValidFor(.reverseGeo) {
                DispatchQueue.main.async { [self] in
                    self.textfieldAddress.text = places.first?.formattedAddress
                    self.lat = mapview.region.center.latitude
                    self.lng = mapview.region.center.longitude
                    self.zipCode = places.first?.placeZipCode ?? ""
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
}

extension MapPlacesViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocompleteResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell")
        let label = cell?.viewWithTag(1) as! UILabel
        label.text = autocompleteResults[indexPath.row].formattedAddress
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textfieldAddress.text = autocompleteResults[indexPath.row].formattedAddress
        textfieldAddress.resignFirstResponder()
        var input = GInput()
        input.keyword = autocompleteResults[indexPath.row].placeId
        GoogleApi.shared.callApi(.placeInformation,input: input) { (response) in
            if let place =  response.data as? GApiResponse.PlaceInfo, response.isValidFor(.placeInformation) {
                DispatchQueue.main.async {
                    self.searchView.isHidden = true
                    if let lat = place.latitude, let lng = place.longitude{
                        self.lat = lat
                        self.lng = lng
                        let center  = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        self.mapview.setRegion(region, animated: true)
                    }
                    self.tableviewSearch.reloadData()
                }
            } else { print(response.error ?? "ERROR") }
        }
    }
}

extension MapPlacesViewController: CLLocationManagerDelegate {
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        if let location = locations.last{
    //            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    //            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    //            self.mapview.setRegion(region, animated: true)
    //        }
    //    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.lat = location.coordinate.latitude
        self.lng = location.coordinate.longitude
        self.mapview.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = self.getUrl(lat: latitude, lng: longitude)
        self.cityName = ""
        self.zipCode = ""
        print(url)
        self.startActivity()
        Alamofire.request(url, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            self.stopActivity()
            switch response.result {
            case .success:
                let responseJson = response.value as! NSDictionary
                print(responseJson)
                if let results = responseJson.object(forKey: DictKeys.results)! as? [NSDictionary] {
                    if results.count > 0 {
                        _ = results[0][DictKeys.formatted_address] as? String
                        if let adress2 = results[0]["address_components"] {
                            let jsonData2 = JSON(adress2)
                            let city = jsonData2[4]["long_name"].rawValue
                            self.cityName = city as? String ?? ""
                            if jsonData2.count > 5 {
                                let pCode = jsonData2[7]["long_name"].rawValue
                                if (jsonData2[7]["types"].rawValue as? String ?? "") == "postal_code" {
                                    self.zipCode = pCode as? String ?? ""
                                }
                            }
                            if self.zipCode == "" {
                                for res in results {
                                    for (key,value) in res {
                                        if (key as! String) == "postal_code" {
                                            break
                                        }
                                        
                                        let componentArray = value as? NSArray ?? []
                                        for component1 in componentArray {
                                            let objDic = component1 as? NSDictionary ?? [:]
                                            // for (_,_) in objDic {
                                            let objDicType = objDic["types"] as? NSArray ?? []
                                            for type in objDicType {
                                                if type as! String == "postal_code" {
                                                    self.zipCode = objDic["short_name"] as? String ?? ""
                                                    break
                                                }
                                                //}
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                self.storemodel.zip_code = self.zipCode
                self.storemodel.city = self.cityName
               // mapDelegate?.updateAdress(address: textfieldAddress.text ?? self.storemodel.address, zipCode: self.zipCode, isFromMap: true)
                self.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}


