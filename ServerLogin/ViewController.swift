//
//  ViewController.swift
//  ServerLogin
//
//  Created by SWU mac on 2020/06/02.
//  Copyright © 2020 SWU mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginPrefix: UITextField!
    @IBOutlet var loginUserid: UITextField!
    @IBOutlet var loginPassword: UITextField!
    //@IBOutlet var labelStatus: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginUserid {
            textField.resignFirstResponder()
            self.loginPassword.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    @IBAction func loginPressed() {
               
        /*let urlString: String = "http://localhost:8888/login/loginUser.php"*/
        let urlString: String = "http://condi.swu.ac.kr/student/T09/login/loginUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        //self.labelStatus.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + loginUserid.text! + "&password=" + loginPassword.text!
        
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return
                }
                
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                if success == "YES" {
                    if let name = jsonData["name"] as? String {
                        DispatchQueue.main.async {
                            //self.labelStatus.text = name + "님 안녕하세요?"
                          
                            let appDelegate = UIApplication.shared.delegate as!AppDelegate
                            appDelegate.ID = self.loginUserid.text
                            appDelegate.userName = name
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let naviViewController = storyboard.instantiateViewController(withIdentifier: "introView")
                            naviViewController.modalPresentationStyle = .fullScreen
                            self.present(naviViewController, animated: true, completion: nil)
                        }
                    }
                } else{
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            //self.labelStatus.text = errMessage
                            let alert = UIAlertController(title: "\(errMessage)",
                                                                                    message: "Login Failed!!", preferredStyle: .alert)
                                                      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                          alert.dismiss(animated: true, completion: nil)}))
                                             self.present(alert, animated: true)
                            print(errMessage)
                        }
                    }
                }
            } catch {
                print("Error: \(error)") }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
