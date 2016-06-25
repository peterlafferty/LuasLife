//
//  TramLineTableViewController.swift
//  LuasLife
//
//  Created by Peter Lafferty on 22/05/2016.
//  Copyright © 2016 Peter Lafferty. All rights reserved.
//

import UIKit
import LuasLifeKit

class TramLineTableViewController: UITableViewController {

    var dataSource = TramLineDataSource()
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "showStopsSegue" {

            if let indexPath = tableView.indexPathForSelectedRow {
                if let vc = segue.destinationViewController as? StopPickerViewControllerTableViewController {
                    vc.line = dataSource[indexPath.row]
                }
            }
        }
    }
    
}


class TramLineDataSource: NSObject {
    var lines = [Line]()
    let reuseIdentifier = "TramLineCell"
    
    func load(completionHandler:(Void) -> (Void)) {
        
        let request = GetLinesRequest() { (result) -> Void in
            let error:ErrorType?
            
            if case let .Error(e) = result {
                error = e
            } else {
                error = nil
            }
            
            if case let .Success(l) = result {
                print(l)
                self.lines = l
            } else {
                self.lines = [Line]()
            }
            
            print(error)
            completionHandler()
        }
        
        request.start()
    }
    
    subscript(index: Int) -> Line {
        return lines[index]
    }
}

extension TramLineDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
     
        cell.textLabel?.text = lines[indexPath.row].name
        
        return cell
    }
    
}

extension TramLineDataSource: UITableViewDelegate {
    
}
