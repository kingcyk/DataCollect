//
//  SecondViewController.swift
//  DataCollect
//
//  Created by kingcyk on 22/10/2017.
//  Copyright © 2017 kingcyk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let documentPath = NSHomeDirectory() + "/Documents/"

    var files = [String]()
    
    var documentInteractionController: UIDocumentInteractionController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barStyle = .black
        
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: documentPath)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "File")
        cell.textLabel?.text = files[indexPath.row]
        cell.backgroundColor = tableView.backgroundColor
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let filePath = URL(fileURLWithPath: documentPath + files[indexPath.row])
        documentInteractionController = UIDocumentInteractionController(url: filePath)
        documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
    }
}
