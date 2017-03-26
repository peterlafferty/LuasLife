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

    }

    override func viewDidAppear(_ animated: Bool) {
        dataSource.load({
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

        if segue.identifier == "showRoutesSegue" {

            if let indexPath = tableView.indexPathForSelectedRow {
                if let vc = segue.destination as? RouteTableViewController {
                    vc.line = dataSource[indexPath.row]
                }
            }
        }
    }

}

class TramLineDataSource: NSObject {
    var lines = [Line]()
    let reuseIdentifier = "TramLineCell"

    func load(_ completionHandler: @escaping (Void) -> (Void)) {

        let request = GetLinesRequest { (result) -> Void in
            let error: Error?

            if case let .error(e) = result {
                error = e
            } else {
                error = nil
            }

            if case let .success(l) = result {
                print(l)
                self.lines = l
            } else {
                self.lines = [Line]()
            }

            print(error ?? "no error")
            completionHandler()
        }

        request.start()
    }

    subscript(index: Int) -> Line {
        return lines[index]
    }
}

extension TramLineDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.text = lines[indexPath.row].name

        return cell
    }

}

extension TramLineDataSource: UITableViewDelegate {

}
