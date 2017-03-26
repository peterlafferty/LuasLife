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
            DispatchQueue.main.async(execute: {
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

    func load(_ stop: Stop, completionHandler: @escaping (Void) -> (Void)) {
        let request = GetRealtimeInfoRequest(stop: stop, completionHandler: { (result) -> Void in
            let trams: [Tram]?

            switch result {
            case .error(let e):
                _ = e
                trams = nil
            case .success(let r):
                trams = r
            }

            if let t = trams {
                self.trams = t
            }

            completionHandler()
        })

        request.start()
    }

    func tramAtIndex(_ indexPath: IndexPath) -> Tram {
        return trams[indexPath.row]
    }

    subscript(index: Int) -> Tram {
        get {
            return trams[index]
        }
    }

    subscript(indexPath: IndexPath) -> Tram {
        get {
            return trams[indexPath.row]
        }
    }
}

extension RealTimeInfoDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(trams[indexPath.row].destination) in \(trams[indexPath.row].dueInMinutes)"

        return cell
    }

}

extension RealTimeInfoDataSource: UITableViewDelegate {

}
