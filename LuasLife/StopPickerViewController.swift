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
    var line = Line(type: "LUAS", name: "GREEN")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource

        dataSource.load(line, completionHandler: {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })

        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTramsSegue" {

            if let indexPath = tableView.indexPathForSelectedRow {
                if let vc = segue.destinationViewController as? RealTimeInfoViewController {
                    vc.stop = dataSource[indexPath]
                }
            }
        }

    }


}

class StopPickerDataSource: NSObject {
    var routes = [Route]()
    let reuseIdentifier = "StopCell"

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
    /*
    func stopAt(indexPath: NSIndexPath) -> Route {
        return routes[indexPath.section].stops[indexPath.row]
    }

    subscript(index: Int) -> Route {
        get {
            return routes[0].stops[index]
        }
     }    */


    subscript(indexPath: NSIndexPath) -> Stop {
        get {
            return routes[indexPath.section].stops[indexPath.row]
        }
    }
}

extension StopPickerDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return routes.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes[section].stops.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        cell.textLabel?.text = routes[indexPath.section].stops[indexPath.row].name

        return cell
    }

}

extension StopPickerDataSource: UITableViewDelegate {

}
