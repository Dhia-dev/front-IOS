//
//  QrCodeViewController.swift
//  Geochat
//
//  Created by Apple Esprit on 28/12/2021.
//

import UIKit

class QrCodeViewController: UIViewController {
    // vars
    
    var userInfo: String?
    // variables
    let token = UserDefaults.standard.string(forKey: "userToken")!
    var user: User?
    // user info as String fir the Qr Code generator
   

   
    var imageView = UIImageView()
    // outlets
    

    //

    override func viewDidLoad() {
      
        super.viewDidLoad()
       
      
        let img = generateQRCode(from: userInfo!)
        imageView = UIImageView(image: img!)
        imageView.frame = CGRect(x: 50, y: 200, width: 300, height: 300 )
        view.addSubview(imageView)
        // Do any additional setup after loading the view

    }
    
        
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    ////
    ///

}

