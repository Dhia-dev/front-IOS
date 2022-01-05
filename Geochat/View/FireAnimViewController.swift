//
//  FireAnimViewController.swift
//  Geochat
//
//  Created by Apple Esprit on 3/1/2022.
//

import UIKit

class FireAnimViewController: UIViewController {

   // let seconds = 4.0
    // outlets
    
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let fireGif = UIImage.gifImageWithName("firedhead")
        img.image = fireGif
        foo()
       
        // Do any additional setup after loading the view.
    }
    
    func foo()   {
        // await Task.sleep(UInt64(seconds * Double(NSEC_PER_SEC)))
        // Put your code which should be executed with a delay here
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //call any function
            self.performSegue(withIdentifier: "start", sender: nil)
         }
       
    }
    

}
