//
//  PoisListViewController.swift
//  iOSCodingChallenge
//
//  Created by Kesh Pola on 10/22/17.
//  Copyright © 2017 KeshPola. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SVProgressHUD
import Mapbox

class PoisListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let mapStoryboardIdentifier = "Map"
    private let mapVCIdentifier = "MapViewController"
    private let viewTitle = NSLocalizedString("TestTaxi", comment: "View title")
    private let mapButtonTitle = NSLocalizedString("Map", comment: "Button title switch to map")
    private let hamburgBounds =   MGLCoordinateBounds(
        sw: CLLocationCoordinate2D(latitude: 53.356523, longitude: 9.625692),
        ne: CLLocationCoordinate2D(latitude: 53.817100, longitude: 10.444173))
    
    private var isRequestSent = true
    
    fileprivate let cellIdentifier = "Cell"
    
    fileprivate var poiList: PoiWrapper = PoiWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewTitle
        
        removeBackButtonText()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let mapBarButton = UIBarButtonItem(
            title: mapButtonTitle,
            style: .plain,
            target: self,
            action: #selector(PoisListViewController.mapBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = mapBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getListOfPoi()
    }
    
    // MARK: - Miscellaneous Methods
    func mapBarButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: mapStoryboardIdentifier, bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: mapVCIdentifier) as! MapViewController
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    // MARK: - API Request
    func getListOfPoi() {
        isRequestSent = true
        SVProgressHUD.show()
        RemoteApiFactory.instance.getPoiListBy(bounds: hamburgBounds)
            .validate()
            .responseObject { [weak self] (response: DataResponse<PoiWrapper>) in
                guard let selfNotNil = self else { return }
                switch response.result {
                case .success:
                    if let poiList = response.result.value {
                        selfNotNil.poiList = poiList
                        selfNotNil.tableView.reloadData()
                    }
                    break
                case .failure(let error):
                    print("Error Fetching Poi Lists: " + error.localizedDescription)
                    break
                }
                selfNotNil.isRequestSent = false
                SVProgressHUD.dismiss()
        }
    }
}

extension PoisListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiList.pois.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let poi = poiList.pois[row]
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
        
        cell.textLabel?.text = poi.type
        cell.detailTextLabel?.text = poi.state
        return cell
    }
}
