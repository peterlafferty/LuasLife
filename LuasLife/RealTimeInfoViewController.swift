//
//  RealTimeInfoViewController.swift
//  LuasLife
//
//  Created by Peter Lafferty on 11/05/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import UIKit
import LuasLifeKit

class RealTimeInfoViewController: UITableViewController {
    var dataSource = RealTimeInfoDataSource()
    var stop = Stop(id:14, name: "Central Park")

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.delegate = dataSource

        dataSource.load(stop, completionHandler: {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })

        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


class RealTimeInfoDataSource: NSObject {
    var trams = [Tram]()

    func load(stop: Stop, completionHandler: (Void) -> (Void)) {
        let request = GetRealtimeInfoRequest(stop: stop, completionHandler: { (result) -> Void in
            let trams: [Tram]?

            switch result {
            case .Error(let e):
                _ = e
                trams = nil
            case .Success(let r):
                trams = r
            }

            if let t = trams {
                self.trams = t
            }

            completionHandler()
        })

        request.start()
    }

    func tramAtIndex(indexPath: NSIndexPath) -> Tram {
        return trams[indexPath.row]
    }

    subscript(index: Int) -> Tram {
        get {
            return trams[index]
        }
    }

    subscript(indexPath: NSIndexPath) -> Tram {
        get {
            return trams[indexPath.row]
        }
    }
}

extension RealTimeInfoDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trams.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(trams[indexPath.row].destination) in \(trams[indexPath.row].dueInMinutes)"

        return cell
    }

}

extension RealTimeInfoDataSource: UITableViewDelegate {

}
