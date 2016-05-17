//
//  StopPickerViewControllerTableViewController.swift
//  LuasLife
//
//  Created by Peter Lafferty on 12/05/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import UIKit
import LuasLifeKit

class StopPickerViewControllerTableViewController: UITableViewController {
    var dataSource = StopPickerDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        
        dataSource.load({
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
            })
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class StopPickerDataSource: NSObject {
    var routes = [Route]()
    
    func load(completionHandler:(Void) -> (Void)) {
        let line = Line(type: "LUAS", name: "GREEN")
        
        let request = GetRoutesRequest(line: line) { (result) -> Void in
            let error:ErrorType?
            
            if case let .Error(e) = result {
                error = e
            } else {
                error = nil
            }
            
            if case let .Success(r) = result {
                print(r)
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
    }
    
    subscript(indexPath: NSIndexPath) -> Route {
        get {
            return routes[0].stops[indexPath.row]
        }
    }*/
}

extension StopPickerDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("Number of routes: \(routes.count)")
        return routes.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of stops in route: \(routes[section].stops.count)")
        return routes[section].stops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = routes[indexPath.section].stops[indexPath.row].name
        
        return cell
    }
    
}

extension StopPickerDataSource: UITableViewDelegate {
    
}
