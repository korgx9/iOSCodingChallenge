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
import Mapbox
import DZNEmptyDataSet

class PoisListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let mapStoryboardIdentifier = "Map"
    private let mapVCIdentifier = "MapViewController"
    private let viewTitle = NSLocalizedString("TestTaxi", comment: "View title")
    private let mapButtonTitle = NSLocalizedString("Map", comment: "Button title switch to map")
    private let hamburgBounds =   MGLCoordinateBounds(
        sw: CLLocationCoordinate2D(latitude: 53.356523, longitude: 9.625692),
        ne: CLLocationCoordinate2D(latitude: 53.817100, longitude: 10.444173))
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(PoisListViewController.getListOfPoi as (PoisListViewController) -> () -> ()), for: .valueChanged)
        return refreshControl
    }()
    
    fileprivate let cellIdentifier = "Cell"
    fileprivate let detailsStoryBoardIdentifier = "PoiDetails"
    fileprivate let detailsVCIdentifier = "PoiDetailsViewController"
    fileprivate let loadingText = NSLocalizedString("Loading ...", comment: "Loading text")
    fileprivate let emptyText = NSLocalizedString("Nothing to show", comment: "No data fetched")
    
    fileprivate var isRequestSent = true
    fileprivate var poiList: PoiWrapper = PoiWrapper()
    fileprivate var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewTitle
        
        removeBackButtonText()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        let mapBarButton = UIBarButtonItem(
            title: mapButtonTitle,
            style: .plain,
            target: self,
            action: #selector(PoisListViewController.mapBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = mapBarButton
        
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getListOfPoi()
        determineMyCurrentLocation()
    }
    
    // MARK: - Miscellaneous Methods
    func mapBarButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: mapStoryboardIdentifier, bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: mapVCIdentifier) as! MapViewController
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - API Request
    func getListOfPoi() {
        isRequestSent = true
        RemoteApiFactory.instance.getPoiListBy(bounds: hamburgBounds)
            .validate()
            .responseObject { [weak self] (response: DataResponse<PoiWrapper>) in
                guard let selfNotNil = self else { return }
                switch response.result {
                case .success:
                    if let poiList = response.result.value {
                        selfNotNil.poiList = poiList

                    }
                    break
                case .failure(let error):
                    print("Error Fetching Poi Lists: " + error.localizedDescription)
                    break
                }
                selfNotNil.isRequestSent = false
                selfNotNil.refreshControl.endRefreshing()
                selfNotNil.tableView.reloadData()
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
        
        cell.textLabel?.text = "\(poi.type): \(poi.id)"
        cell.detailTextLabel?.text = poi.state
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let poi = poiList.pois[row]
        let storyboard = UIStoryboard(name: detailsStoryBoardIdentifier, bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: detailsVCIdentifier) as! PoiDetailsViewController
        detailsVC.poi = poi
        detailsVC.locationManager = locationManager
        detailsVC.preferredContentSize = CGSize(width: 300, height: 350)
        detailsVC.modalPresentationStyle = .popover
        detailsVC.modalTransitionStyle = .crossDissolve
        
        let popover = detailsVC.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        popover?.delegate = self
        popover?.sourceView = view
        
        detailsVC.popoverPresentationController?.sourceRect =
            CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        
        present(detailsVC, animated: true, completion: nil)
    }
}

extension PoisListViewController: UIPopoverPresentationControllerDelegate {
    // MARK: - Popver delegates
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PoisListViewController: CLLocationManagerDelegate {
    // MARK: - Location manager delegates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension PoisListViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    // MARK: - Empty dataset delegations
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text = ""
        let font =  UIFont.systemFont(ofSize: 14)
        let textColor = UIColor.lightGray
        
        if isRequestSent {
            text = loadingText
        }
        else if poiList.pois.isEmpty {
            text = emptyText
        }
        
        return NSAttributedString(string: text, attributes:[NSFontAttributeName: font, NSForegroundColorAttributeName: textColor])
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 18.0
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}
