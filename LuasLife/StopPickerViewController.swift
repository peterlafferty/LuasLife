//
//  StopPickerViewController.swift
//  LuasLife
//
//  Created by Peter Lafferty on 12/05/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import UIKit
import LuasLifeKit

class StopPickerViewController: UITableViewController {
    var dataSource = StopPickerDataSource()
    fileprivate static let fakeStop = Stop(id:14, name: "Central Park")
    var route = Route(id: 0, origin: fakeStop, destination: fakeStop, stops: [])

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource

        dataSource.load(route, completionHandler: {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })

        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTramsSegue" {

            if let indexPath = tableView.indexPathForSelectedRow {
                if let vc = segue.destination as? RealTimeInfoViewController {
                    vc.stop = dataSource[indexPath]
                }
            }
        }

    }

}

class StopPickerDataSource: NSObject {
    var stops = [Stop]()
    let reuseIdentifier = "StopCell"

    func load(_ route: Route, completionHandler: @escaping (Void) -> (Void)) {

        let request = GetStopsRequest(route: route) { (result) -> Void in
            let error: Error?

            if case let .error(e) = result {
                error = e
            } else {
                error = nil
            }

            if case let .success(s) = result {
                self.stops = s
            } else {
                self.stops = [Stop]()
            }

            print(error ?? "no error")
            completionHandler()
        }

        request.start()
    }
    /*
    func stopAt(indexPath: NSIndexPath) -> Route {
        return routes[indexPath.section].stops[indexPath.row]
    }

    subscript(index: Int) -> Route {
        get {
            return routes[0].stops[index]
        }
     }    */

    subscript(indexPath: IndexPath) -> Stop {
        get {
            return stops[indexPath.row]
        }
    }
}

extension StopPickerDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.text = stops[indexPath.row].name

        return cell
    }

}

extension StopPickerDataSource: UITableViewDelegate {

}
