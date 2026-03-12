import KeychainSwift
import SnapKit
import UIKit

class EnterViewController: UIViewController {
    
    let saveLoadManager = SaveLoadManager()
    let keychain = KeychainSwift()
    
    private let labelEnter : UILabel = {
        let labelEnter = UILabel()
        labelEnter.textAlignment = .center
        labelEnter.textColor = .black
        labelEnter.font = .systemFont(ofSize: 32)
        labelEnter.text = "Enter password:"
        return labelEnter
    }()
    
    private let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.systemBlue.cgColor
        textField.layer.borderWidth = 2
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.isSecureTextEntry =  true
        return textField
    }()
    
    private let enterButton : UIButton = {
        let enterButton = UIButton()
        enterButton.setTitle("Enter", for: .normal)
        enterButton.backgroundColor = .green
        enterButton.setTitleColor(.black, for: .normal)
        enterButton.layer.cornerRadius = 12
        enterButton.layer.borderColor = UIColor.systemBlue.cgColor
        return enterButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    func configureUI () {
        
        view.backgroundColor = .white
        view.addSubview(labelEnter)
        view.addSubview(textField)
        view.addSubview(enterButton)
        
        
        let enterButtonAction = UIAction { _ in
            self.enterButtonAction()
        }
        enterButton.addAction(enterButtonAction, for: .touchUpInside)
        
        labelEnter.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(labelEnter).offset(50)
            make.left.equalToSuperview().offset(70)
            make.right.equalToSuperview().inset(70)
            make.height.equalTo(50)
        }
        
        enterButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
        }
    }
    
    func enterButtonAction() {
        guard let enteredPassword = textField.text else { return }
        if let savedPassword = keychain.get("password"), enteredPassword == savedPassword {
        
            let ImagesViewController = ImagesViewController()
            navigationController?.pushViewController(ImagesViewController, animated: true)
        } else {
            textField.layer.borderColor = UIColor.red.cgColor
      
        }
    }
}

