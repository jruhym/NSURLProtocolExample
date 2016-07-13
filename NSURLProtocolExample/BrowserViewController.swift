//
//  BrowserViewController.swift
//  NSURLProtocolExample
//
//  Created by Zouhair Mahieddine on 7/10/14.
//  Copyright (c) 2014 Zedenem. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController, UITextFieldDelegate {
  
    @IBOutlet var textField: UITextField!
    @IBOutlet weak private var countLabel: UILabel!

    var session: NSURLSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var protocolClasses = [AnyClass]()
        protocolClasses.append(MyURLProtocol)
        configuration.protocolClasses = protocolClasses

        session = NSURLSession(configuration: configuration)
    }

    //MARK: IBAction
    @IBAction func buttonGoClicked(sender: UIButton) {
        if self.textField.isFirstResponder() {
            self.textField.resignFirstResponder()
        }
        sendRequest()
    }
  
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendRequest()
        return true
    }

    //MARK: Private
    func sendRequest() {
        guard let text = self.textField.text, url = NSURL(string:text) else {
            return
        }
        let request = NSMutableURLRequest(URL:url)
        let ch: NSURLSessionCompletionHandler = {data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 200 {
                        print("Wunderbar!")
                    }
                }
                if let data = data {
                    do {
                        let JSONArray = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.countLabel.text = "\(JSONArray.count) user(s)"
                        })
                    } catch {
                        print("huh")
                    }
                }
            }
        }

        NSURLProtocol.setProperty(Wrapper(ch), forKey: kCompletionHandlerKey, inRequest: request)
        let dataTask = session?.dataTaskWithRequest(request) //{data, response, error in
        dataTask?.resume()
    }
}
