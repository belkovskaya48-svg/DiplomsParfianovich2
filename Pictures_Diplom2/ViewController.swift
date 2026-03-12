import KeychainSwift
import SnapKit
import UIKit

class ViewController: UIViewController {
    
    let saveLoadManager = SaveLoadManager()
    let keychain = KeychainSwift()
    
    private let saveButton : UIButton = {
        let saveButton = UIButton()
        saveButton.setTitle("Save Password", for: .normal)
        saveButton.backgroundColor = .green
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 12
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        return saveButton
    }()
    
    private let labelCreate : UILabel = {
        let labelCreate = UILabel()
        labelCreate.textAlignment = .center
        labelCreate.textColor = .black
        labelCreate.font = .systemFont(ofSize: 32)
        labelCreate.text = "Create password:"
        return labelCreate
    }()
    
    private let labelRepeat : UILabel = {
        let labelRepeat = UILabel()
        labelRepeat.textAlignment = .center
        labelRepeat.textColor = .black
        labelRepeat.font = .systemFont(ofSize: 32)
        labelRepeat.text = "Repeat password:"
        return labelRepeat
    }()
    
    private let textField1 : UITextField = {
        let textField1 = UITextField()
        textField1.placeholder = "Password"
        textField1.borderStyle = .none
        textField1.layer.borderColor = UIColor.systemBlue.cgColor
        textField1.layer.borderWidth = 2
        textField1.keyboardType = .numberPad
        textField1.textAlignment = .center
        textField1.backgroundColor = .white
        textField1.layer.cornerRadius = 12
        textField1.isSecureTextEntry =  true
        
        return textField1
    }()
    
    private let textField2 : UITextField = {
        let textField2 = UITextField()
        textField2.placeholder = "Password"
        textField2.borderStyle = .none
        textField2.layer.borderColor = UIColor.systemBlue.cgColor
        textField2.layer.borderWidth = 2
        textField2.keyboardType = .numberPad
        textField2.textAlignment = .center
        textField2.backgroundColor = .white
        textField2.layer.cornerRadius = 12
        textField2.isSecureTextEntry =  true
        return textField2
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(labelCreate)
        view.addSubview(textField1)
        view.addSubview(labelRepeat)
        view.addSubview(textField2)
        view.addSubview(saveButton)
        
        let saveButtonAction = UIAction { _ in
            self.saveButtonAction()
        }
        saveButton.addAction(saveButtonAction, for: .touchUpInside)
        
        labelCreate.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        labelRepeat.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        textField1.snp.makeConstraints { make in
            make.top.equalTo(labelCreate).offset(50)
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().inset(70)
            make.height.equalTo(50)
        }
        
        textField2.snp.makeConstraints { make in
            make.top.equalTo(labelRepeat).offset(50)
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().inset(70)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(100)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    func saveButtonAction() {
        
        guard let password1 = textField1.text, let password2 = textField2.text else {
                return
            }
        if password1 == password2 {
            do {
            
                try keychain.set(password1, forKey: "password")
                
                saveLoadManager.savePassword(true)
                
                textField1.layer.borderColor = UIColor.green.cgColor
                textField2.layer.borderColor = UIColor.green.cgColor
                
                let imagesViewController = ImagesViewController()
                navigationController?.pushViewController(imagesViewController, animated: true)
           
            } catch {
            }
        } else {
            textField1.layer.borderColor = UIColor.red.cgColor
            textField2.layer.borderColor = UIColor.red.cgColor
        }
        
    }
}
