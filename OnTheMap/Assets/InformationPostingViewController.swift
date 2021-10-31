//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/09/30.
//

import UIKit

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var yourLocationTextField: UITextField!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //FIND LOCATION SEGUE
    @IBAction func findLocationTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FindLocationTapped", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindLocationTapped" {
            let addVC = segue.destination as! AddLocationViewController
            addVC.yourLocation = yourLocationTextField.text ?? ""
            addVC.yourLink = linkTextField.text ?? ""
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        

        // Do any additional setup after loading the view.
    }

}
