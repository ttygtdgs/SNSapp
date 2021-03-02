//
//  LoginViewController.swift
//  influencerSNS
//
//  Created by user on 2021/03/02.
//

import UIKit
import Firebase
import PKHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    
//    アカウント持ってなかったら登録画面に戻すアクション
    @IBAction func tappedDontHaveAccountButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
//    ログインボタン押したらnilチェック、その後authのメソッドで認証情報チェック
    @IBAction func tappedLoginButton(_ sender: Any) {
        HUD.show(.progress, onView: self.view)
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
//        ほとんど会員登録と変わらない、ここだけ違う！
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err{
                print("ログイン情報の取得に失敗しました：", err)
                return
            }
            print("ログインに成功しました。")
            guard let uid = Auth.auth().currentUser?.uid else {return}
            let userRef = Firestore.firestore().collection("users").document(uid)
            userRef.getDocument{(snapshot, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました。\(err)")
                    HUD.hide{(_)in
                        HUD.flash(.error, delay: 1)
                    }
                    return
                }
                guard let data = snapshot?.data() else {return}
                let user = User.init(dic: data)
                
                print("ユーザー情報の取得ができました。\(user.name)")
                HUD.hide{(_)in
                    HUD.flash(.success, onView: self.view,delay: 1){(_) in
                        self.presentToHomeViewController(user:user)
                    }
                }
            }
        }
    }
    
    
    private func presentToHomeViewController(user:User){
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            let homeViewController = storyBoard.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            homeViewController.user = user
            homeViewController.modalPresentationStyle = .fullScreen
            self.present(homeViewController, animated: true, completion: nil)
        }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 10
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
}

//デリゲートメソッドを使えるようにさせる（右側のクラス指定）
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled =  false
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
    
        }
    }
    
    
    //    他の場所触った時にキーボードが下がる処理
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    

}


