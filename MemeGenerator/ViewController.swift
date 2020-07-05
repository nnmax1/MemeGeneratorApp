//
//  ViewController.swift
//  MemeGenerator
//
//  Created by Admin on 7/5/20.
//  Copyright © 2020 nnmax1. All rights reserved.
//

import UIKit


//Uses this API https://github.com/R3l3ntl3ss/Meme_Api

class ViewController: UIViewController {

    @IBOutlet weak var memeImageField: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func showMeme(_ sender: Any) {
        
        //set url of the meme api
        let url = URL(string: "https://meme-api.herokuapp.com/gimme")
        //create an install of URLSession
        let session = URLSession.shared
        
        //closure
        let task = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                self.showAlert(errorMessage: error!.localizedDescription)
            }else {
                if data != nil {
                    do {
                        //response is a dictionary because of the key-value pair syntax of a .json file
                        let response = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        //async
                        DispatchQueue.main.async {
                            //get title from the json data
                            if let title = response["title"] as? String {
                                self.memeLabel.text = title
                            }
                            //get image url of the meme from json data
                            if let imageUrl = response["url"] as? String {
                                do {
                                //process the image, then set it as the image in the UIImage field
                                let url = URL(string: imageUrl)!
                                let imgData = try Data(contentsOf: url)
                                    self.memeImageField.image = UIImage(data: imgData)
                                } catch {
                                    self.showAlert(errorMessage: "Could not get image from url.")
                                }
                            }
                        }
                    } catch {
                        self.showAlert(errorMessage: "Could not get JSON data")
                    }
                }
            }
        }
        task.resume()
        
    }
    
    //function to display an alert message in case there is an error
    func showAlert(errorMessage: String ){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
        let alertBtn = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(alertBtn)
        self.present(alert, animated: true)
    }
}

