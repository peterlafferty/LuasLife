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
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }

    //showRoutesSegue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showStopsSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let vc = segue.destinationViewController as? StopPickerViewController {
                    vc.route = dataSource[indexPath]
                }
            }
        }

    }

}


class RouteDataSource: NSObject {
    var routes = [Route]()
    let reuseIdentifier = "RouteCell"

    func load(line: Line, completionHandler: (Void) -> (Void)) {

        let request = GetRoutesRequest(line: line) { (result) -> Void in
            let error: ErrorType?

            if case let .Error(e) = result {
                error = e
            } else {
                error = nil
            }

            if case let .Success(r) = result {
                self.routes = r
            } else {
                self.routes = [Route]()
            }

            print(error)
            completionHandler()
        }

        request.start()
    }

    subscript(indexPath: NSIndexPath) -> Route {
        get {
            return routes[indexPath.row]
        }
    }
}

extension RouteDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = routes[indexPath.row].origin.name + " to " + routes[indexPath.row].destination.name
        print("\(indexPath.row ) " + routes[indexPath.row].origin.name + " " + routes[indexPath.row].destination.name
)
        return cell
    }

}

extension RouteDataSource: UITableViewDelegate {

}
