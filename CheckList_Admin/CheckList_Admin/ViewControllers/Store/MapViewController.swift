//
//  MapViewController.swift
//  CheckList_Admin
//
//  Created by Muaaz Ahmed on 09/02/2022.
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps

class MapViewController: BaseViewController, UISearchControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var searchBarContainer: UIView!
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var adress = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchBarContainer.isHidden = true
        if let c = mainContainer {
            c.viewTopColour.isHidden = true
            c.navigationController?.isNavigationBarHidden = false
            c.setupSearchController()
           // c.navigationController?.navigationBar.isHidden = false

        }
    }
    
    
    func setupSearchController() {
        resultsViewController = GMSAutocompleteResultsViewController()
        searchController = UISearchController(searchResultsController: resultsViewController)
        resultsViewController?.delegate = self
        searchController?.delegate = self
        if #available(iOS 13.0, *) {
            searchController?.searchBar.searchTextField.delegate = self
        }
        searchController?.searchResultsUpdater = resultsViewController
        
        let searchBar = searchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        //searchBarContainer.addSubview(searchController!.searchBar)
        if let c = mainContainer {
            c.viewTopColour.isHidden = true
            c.navigationController?.isNavigationBarHidden = false
            // c.navigationController?.navigationBar.isHidden = false
            c.navigationItem.titleView = searchController?.searchBar
        }
       // navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true
    
        
    }

    func gotoLocation(place: GMSPlace) {
       // if #available(iOS 13.0, *) {
//            searchController?.showsSearchResultsController = false
//           // searchController?.searchBar.searchTextField.resignFirstResponder()
//        }
        adress = place.formattedAddress ?? ""
        searchController?.searchBar.text = place.formattedAddress
            searchController?.isActive = false
        mapview.animate(to: GMSCameraPosition(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16))
        let  position = CLLocationCoordinate2DMake(place.coordinate.latitude,  place.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.map = mapview

    }
}

extension MapViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if #available(iOS 13.0, *) {
            searchController?.showsSearchResultsController = true
           
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if #available(iOS 13.0, *) {
            searchController?.searchBar.searchTextField.text = adress
        }
    }
}

extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        gotoLocation(place: place)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
}
