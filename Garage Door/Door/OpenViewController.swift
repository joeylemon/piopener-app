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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descLabel.text = " "
        self.getStatus() { (closed) -> () in
            self.updateStatus(closed: closed)
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        Utils.moveGarage(onlyOpen: false) { (closed, err) -> () in
            if err != "" {
                print("Err: " + err)
                
                self.finish(closed: true)
                
                // Can only change UILabel.text from main thread
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.descLabel.text = err
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.finish(closed: true)
                }
                return
            }
            
            self.begin(closed: closed)
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.OPEN_DURATION) {
                self.finish(closed: closed)
            }
        }
    }
    
    private func getStatus(completion: @escaping (Bool) -> ()) {
        Request.send(url: "https://jlemon.org/garage/status/\(Auth.TOKEN)") { (response, result) -> () in
            let httpResponse = response as! HTTPURLResponse
            
            // If the API didn't return 200 OK, something went wrong
            if httpResponse.statusCode != 200 {
                completion(false)
                return
            }
            
            completion(String(data: result!, encoding: .utf8) == "true")
            return
        }
    }
    
    // Begin the animation for moving the garage
    private func begin(closed: Bool) {
        DispatchQueue.main.async {
            self.button.isUserInteractionEnabled = false
            
            if closed {
                self.descLabel.text = "Opening garage ..."
            } else {
                self.descLabel.text = "Closing garage ..."
            }
            
            self.setImage(name: "moving")
        }
    }
    
    // End the animation for moving the garage
    private func finish(closed: Bool) {
        DispatchQueue.main.async {
            self.button.isUserInteractionEnabled = true
            
            self.updateStatus(closed: !closed)
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
    
    private func updateStatus(closed: Bool) {
        DispatchQueue.main.async {
            if closed {
                self.setImage(name: "closed")
                self.descLabel.text = "Press to open garage"
            } else {
                self.setImage(name: "open")
                self.descLabel.text = "Press to close garage"
            }
        }
    }

}

