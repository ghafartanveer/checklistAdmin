import UIKit
import GooglePlaces
import GoogleMapsBase
import GoogleMaps

class SearchPlacesViewController: BaseViewController {
    //MARK:- Outlets
    @IBOutlet weak var resultText: UITextView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: GMSMapView!
    //MARK:- Variables
    var placePridictions : [GMSAutocompletePrediction] = []
    var fetcher: GMSAutocompleteFetcher?
   // var delegate : SearchPlacesViewControllerDelegate?
    //MARK:- Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let c = mainContainer {
            c.titleLabel.text = "Select Loction"
        }
        setupView()
        
        self.textField.becomeFirstResponder()
        view.backgroundColor = .white
        self.autoCompleteFilter()
    }
    //MARK:- functions
    @objc func textFieldDidChange(textField: UITextField) {
        fetcher?.sourceTextHasChanged(textField.text!)
    }
    
    func setupView() {
        
        textField.delegate = self
        tableView.isHidden = true
    }
    func autoCompleteFilter(){
        edgesForExtendedLayout = []
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()
        fetcher = GMSAutocompleteFetcher()
        fetcher?.delegate = self
        fetcher?.provide(token)
        textField?.addTarget(self, action: #selector(textFieldDidChange(textField:)),
                             for: .editingChanged)
    }
}
//MARK:- GMSAutocompleteFetcherDelegate
extension SearchPlacesViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.placePridictions = predictions
        self.tableView.reloadData()
    }
    func didFailAutocompleteWithError(_ error: Error) {
        self.showAlertView(message: error.localizedDescription)
    }
}
//MARK:- TABLEVIEW METHODS
extension SearchPlacesViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placePridictions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlacesTableViewCell", for: indexPath) as! PlacesTableViewCell
        cell.configureView(place: placePridictions[indexPath.row].attributedFullText )
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let del = self.delegate{
           // del.getAddress(Address:  placePridictions[indexPath.row].attributedFullText, LocationID: placePridictions[indexPath.row].placeID)
//        }
        
       // placePridictions[indexPath.row].
        
        self.navigationController?.popViewController(animated: true)
    }
    func getAddressAndLatLngFromPlaceID(LocationID: String) {
        //        self.placesClient.lookUpPlaceID(LocationID) { (place,error) in
        //            if let place = place {
        //                // self.getAddressFromLatLong(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        //                // self.txtLocatinSearch.text = place.formattedAddress
        //                self.setMarkerOnUserLocation(loc: place.coordinate)
        //                self.cameraMoveToLocation(location: place.coordinate)
        //                self.lat = place.coordinate.latitude
        //                self.lng = place.coordinate.longitude
        //                if(!self.isFromAddAddress){
        //                    self.getResturantListApi(params: [DictKeys.latitude: place.coordinate.latitude,
        //                                                      DictKeys.longitude: place.coordinate.longitude])
        //                }
        //            } else {
        //                self.showAlertView(message: PopupMessages.locationNotFound)      }
        //        }
            }
}

extension SearchPlacesViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        tableView.isHidden = false
       
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
}
