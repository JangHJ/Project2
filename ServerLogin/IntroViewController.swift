//
//  IntroViewController.swift
//  ServerLogin
//
//  Created by SWU mac on 2020/07/05.
//  Copyright © 2020 SWU mac. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet var bookImg: UIImageView!
     
    override func viewWillAppear(_ animated: Bool) {
        bookImg.alpha = 0;
        
        
        UIView.animate(withDuration: 1.0, delay: 0.3,
                                      options: UIView.AnimationOptions.curveEaseOut, animations: ({
                                        self.bookImg.alpha = 1;
                                      }),completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func startBtn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                   let naviViewController = storyboard.instantiateViewController(withIdentifier: "naviView")
                                   naviViewController.modalPresentationStyle = .fullScreen
                                   self.present(naviViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
