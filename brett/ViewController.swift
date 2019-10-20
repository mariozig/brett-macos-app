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
        
        // Get data we care about
        guard let deviceName = Host.current().localizedName else {
            print("Error: couldn't get device name")
            return
        }
        // Just some dummy endpoint that returns JSON
        let url = "https://jsonplaceholder.typicode.com/posts"
        // Pass a url and device name to the func that will make the request
        setTextFieldToJsonResponse(url: url, deviceName: deviceName)
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

    fileprivate func setTextFieldToJsonResponse(url: String, deviceName: String){
        // Just printing out the device name for now since the dummy API i used
        // won't do anything with it
        print("Device Name is: ", deviceName)
        
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

            // The `as? [[String: Any]]` in the line below is just because the dummy API returns an array of objects.
            // If your API returns an JSON object instead of an array just take the outer `[]` off
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [[String: Any]] else {
                print("Error: Does not contain JSON")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                // Display the data in the UI -- just dumping the whole thing into a text field
                self.datTextField.stringValue = String(describing: json)
            }
        }
        
        task.resume()
    }


}

