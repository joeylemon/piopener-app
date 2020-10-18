//
//  OpenViewController.swift
//  Garage Door
//
//  Created by Joey Lemon on 6/17/20.
//  Copyright © 2020 Joey Lemon. All rights reserved.
//

import UIKit

class OpenViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    
    // Haptic feedback for opening/closing garage
    let feedback = UINotificationFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descLabel.text = " "
        self.getStatus() { (status, error) -> () in
            self.updateStatus(status: status, error: error)
        }
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        Utils.moveGarage(onlyOpen: false) { (status, err) -> () in
            if err != "" {
                print("Err: " + err)
                self.feedback.notificationOccurred(.error)
                
                DispatchQueue.main.async {
                    self.button.isUserInteractionEnabled = false
                    self.descLabel.text = err
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.finish(status: status)
                }
                return
            }
            
            self.feedback.notificationOccurred(.success)
            self.begin(status: status)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.OPEN_DURATION) {
                self.finish(status: status == "open" ? "closed" : "open")
            }
        }
    }
    
    @IBAction func refreshed(_ sender: Any) {
        self.setImage(name: "open")
        self.descLabel.text = " "
        self.getStatus() { (status, error) -> () in
            self.updateStatus(status: status, error: error)
        }
    }
    
    // (String, String) -> (Status, Error)
    private func getStatus(completion: @escaping (String, String) -> ()) {
        Request.send(url: "https://jlemon.org/garage/status/\(Auth.TOKEN)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            let body = String(data: result!, encoding: .utf8)
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                completion("", body!)
                return
            }
            
            completion(body!, "")
            return
        }
    }
    
    // Begin the animation for moving the garage
    private func begin(status: String) {
        DispatchQueue.main.async {
            self.button.isUserInteractionEnabled = false
            
            if status == "closed" {
                self.descLabel.text = "Opening garage ..."
            } else {
                self.descLabel.text = "Closing garage ..."
            }
            
            self.setImage(name: "moving")
        }
    }
    
    // End the animation for moving the garage
    private func finish(status: String) {
        DispatchQueue.main.async {
            self.button.isUserInteractionEnabled = true
            
            self.updateStatus(status: status, error: "")
        }
    }
    
    private func setImage(name: String) {
        DispatchQueue.main.async {
            if name == "moving" {
                self.button.setBackgroundImage(UIImage.gif(name: "moving"), for: UIControl.State.normal)
                return
            }
            self.button.setBackgroundImage(UIImage(named: name), for: UIControl.State.normal)
        }
    }
    
    private func updateStatus(status: String, error: String) {
        DispatchQueue.main.async {
            if error != "" {
                self.setImage(name: "error")
                self.descLabel.text = error
                return
            }
            
            if status == "closed" {
                self.setImage(name: "closed")
                self.descLabel.text = "Press to open garage"
            } else if status == "open" {
                self.setImage(name: "open")
                self.descLabel.text = "Press to close garage"
            } else {
                self.setImage(name: "between")
                self.descLabel.text = "Garage is in between"
            }
        }
    }

}

