//
//  ViewController.swift
//  brett
//
//  Created by Mario Zigliotto on 10/19/19.
//  Copyright © 2019. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var datTextField: NSTextField!
    @IBOutlet weak var datButton: NSButton!
    
    @IBAction func doSomething(sender: AnyObject) {
        print("On Snap, button clicked!")
        setTextFieldToJsonResponse(url: "https://jsonplaceholder.typicode.com/posts")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    fileprivate func setTextFieldToJsonResponse(url: String){
        let url = URL(string: url)!

        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }

            if error != nil {
                print("Error: ", error!)
                return
            }
                        
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Response has a non 2XX status")
                return
            }
            
            guard let content = data else {
                print("Error: no data")
                return
            }

            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [[String: Any]] else {
                print("Error: Does not contain JSON")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.datTextField.stringValue = String(describing: json)
            }
        }
        
        task.resume()
    }


}

