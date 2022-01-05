//
//  NotificationView.swift
//  Geolike
//
//  Created by Apple Mac on 4/12/2021.
//

import Foundation
import UIKit

class NotificationView: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // variables
    var likes : [Like] = []
    var currentLike : Like?
    var refreshTimer : Timer?
    
    // iboutlets
    @IBOutlet weak var tableView: UITableView!
    
    // protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mCell = tableView.dequeueReusableCell(withIdentifier: "mCell")
        let contentView = mCell?.contentView
        
        let userImage = contentView?.viewWithTag(1) as! UIImageView
        let messageLabel = contentView?.viewWithTag(2) as! UILabel
        
        let liker = likes[indexPath.row].liker
        
        messageLabel.text = liker!.firstname! + " " + liker!.lastname! + " liked your profile"
        
        return mCell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            LikeViewModel().deleteLike(_id: likes[indexPath.row]._id) { success in
                if success {
                    print("deleted like")
                    self.likes.remove(at: indexPath.row)
                    tableView.reloadData()
                } else {
                    print("error while deleting like")
                }
            }
        }
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHistory()
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        initializeHistory()
    }
    
    // methods
    func startTimer () {
        guard refreshTimer == nil else { return }
        
        refreshTimer =  Timer.scheduledTimer(
            timeInterval: 5,
            target      : self,
            selector    : #selector(update),
            userInfo    : nil,
            repeats     : true)
    }
    
    @objc
    func update()  {
        initializeHistory()
    }
    
    func initializeHistory() {
        LikeViewModel().getMyLikes{ success, likesFromRep in
            if success {
                self.likes = likesFromRep!
                self.tableView.reloadData()
            } else {
                self.present(Alert.makeAlert(titre: "Error", message: "Could not load history"),animated: true)
            }
        }
        tableView.reloadData()
    }
    
    // actions
    
}
