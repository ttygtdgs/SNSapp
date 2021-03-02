//
//  HomeViewController.swift
//  influencerSNS
//
//  Created by user on 2021/03/01.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController{
    
    
    @IBAction func tappedLogoutButton(_ sender: Any) {
        handleLogout()
    }
    
//    firebaseからサインアウトの処理メソッドを定義
    private func handleLogout(){
        do{
           try Auth.auth().signOut()
           presentToSignUpViewController()
        } catch (let err){
            print("ログアウトに失敗しました。:\(err)")
        }
        
    }
    
    var user: User?{
        didSet{
            print("user?.name:", user?.name)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.layer.cornerRadius = 10
        
        if let user = user {
        nameLabel.text = user.name + "さんようこそ"
        emailLabel.text = user.email
            let dateString = dateFormatterForCreatedAt(date: user.createdAt.dateValue())
        dateLabel.text = "作成日：　" + dateString
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confirmLoggedUser()
    }
    
    
    private func confirmLoggedUser(){
        if Auth.auth().currentUser?.uid == nil || user == nil {
            presentToSignUpViewController()
        }
    }
    
    
    private func presentToSignUpViewController(){
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: "ViewController") as! ViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
//    日付を綺麗な形式になおすメソッドを定義
    private func dateFormatterForCreatedAt(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
        
        
    }
}
