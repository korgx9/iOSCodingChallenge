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

class PoisListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let viewTitle = NSLocalizedString("TestTaxi", comment: "View title")
    private let hamburgBounds =  (53.356523, 9.625692, 53.817100, 10.444173)
    
    private var isRequestSent = true
    
    fileprivate let cellIdentifier = "Cell"
    
    fileprivate var poiList: PoiWrapper = PoiWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewTitle
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getListOfPoi()
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