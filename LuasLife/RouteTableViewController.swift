//
//  RouteTableViewController.swift
//  LuasLife
//
//  Created by Peter Lafferty on 13/07/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import UIKit
import LuasLifeKit

class RouteTableViewController: UITableViewController {
    var dataSource = RouteDataSource()
    var line = Line(id: 1, name: "Green")
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource

        dataSource.load(line) {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }

    //showRoutesSegue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStopsSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let vc = segue.destination as? StopPickerViewController {
                    vc.route = dataSource[indexPath]
                }
            }
        }

    }

}

class RouteDataSource: NSObject {
    var routes = [Route]()
    let reuseIdentifier = "RouteCell"

    func load(_ line: Line, completionHandler: @escaping (Void) -> (Void)) {

        let request = GetRoutesRequest(line: line) { (result) -> Void in
            let error: Error?

            if case let .error(e) = result {
                error = e
            } else {
                error = nil
            }

            if case let .success(r) = result {
                self.routes = r
            } else {
                self.routes = [Route]()
            }

            print(error ?? "no error")
            completionHandler()
        }

        request.start()
    }

    subscript(indexPath: IndexPath) -> Route {
        get {
            return routes[indexPath.row]
        }
    }
}

extension RouteDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.text = routes[indexPath.row].origin.name + " to " + routes[indexPath.row].destination.name
        print("\(indexPath.row ) " + routes[indexPath.row].origin.name + " " + routes[indexPath.row].destination.name
)
        return cell
    }

}

extension RouteDataSource: UITableViewDelegate {

}
