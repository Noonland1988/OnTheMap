//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by 嶋田省吾 on 2021/10/07.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        OTMClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addInfoTapped(_ sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addLocationTapped", sender: nil)
    }
    
    
    func openLink(url: String){
        guard let url = URL(string: url) else {
            showAlert(title: "Invalid URL", message: "No URL")
            return
        }
        UIApplication.shared.open(url, completionHandler: { success in
            if success{
                print("succeed")
            } else {
                print("failed")
                self.showAlert(title: "Invalid URL", message: "Given URL was invalid")
            }
        
        }
    )}
    
    
    func showAlert(title: String, message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
}
