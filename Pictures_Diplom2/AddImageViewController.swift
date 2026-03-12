import UIKit
import Foundation
import SnapKit

final class AddImageViewController : UIViewController {
    
    var image = UserImage(imageName: "", description: "", isFavorite: false)
    var saveLoadManager = SaveLoadManager()
    var currentIndex = 0
    
    
    private var isFavorite: Bool = false

    
    private let imagePlusView : UIImageView = {
        let imagePlusView = UIImageView()
        imagePlusView.contentMode = .scaleAspectFit
        imagePlusView.clipsToBounds = true
        imagePlusView.isUserInteractionEnabled = true
        imagePlusView.image = UIImage(systemName: "plus")
        return imagePlusView
    }()
    
    private let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "description photo"
        textField.borderStyle = .line
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.blue.cgColor
        return textField
    }()
    
    private let backButton : UIButton = {
        let backButton = UIButton()
        backButton.contentMode = .scaleAspectFit
        backButton.clipsToBounds = true
        backButton.backgroundColor = .blue
        backButton.setImage(UIImage(named: "кнопкаВлево"), for: .normal)
        return backButton
    }()
    
    private let cancelButton : UIButton = {
        let cancelButton = UIButton()
        cancelButton.contentMode = .scaleAspectFit
        cancelButton.clipsToBounds = true
        cancelButton.backgroundColor = .blue
        cancelButton.setTitle("❌", for: .normal)
        return cancelButton
    }()
    
    private let favoriteButton : UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.contentMode = .scaleAspectFit
        favoriteButton.clipsToBounds = true
        favoriteButton.backgroundColor = .blue
        favoriteButton.setTitle("♡", for: .normal)
        return favoriteButton
    }()
    
    private var userImagesArray: [UserImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    func configureUI () {
        
        view.backgroundColor = .white
        view.addSubview(imagePlusView)
        view.addSubview(textField)
        view.addSubview(backButton)
        view.addSubview(cancelButton)
        view.addSubview(favoriteButton)
        
        
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickerAction))
        imagePlusView.addGestureRecognizer(imageRecognizer)
        
        let cancelAction = UIAction { _ in
            self.cancelAction()
        }
        cancelButton.addAction(cancelAction, for: .touchUpInside)
        
        let favoriteAction = UIAction { _ in
            self.isFavoriteAction()
        }
        favoriteButton.addAction(favoriteAction, for: .touchUpInside)
        
        let backAction = UIAction { _ in
            self.backAction()
        }
       backButton.addAction(backAction, for: .touchUpInside)
        
        imagePlusView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(imagePlusView.snp.height)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imagePlusView.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
         
    }
    
    func isFavoriteAction() {
        
            isFavorite.toggle()
        image.isFavorite = isFavorite

            if isFavorite {
                favoriteButton.setTitle("❤️", for: .normal)
                
            } else {
                favoriteButton.setTitle("♡", for: .normal)
            }
        }
    
    func backAction() {
        
            let imageName = saveLoadManager.loadImageName() ?? ""
            let description = textField.text ?? ""
            
        let newImage = UserImage(imageName: imageName, description: description, isFavorite: self.isFavorite)
            
            var currentArray = saveLoadManager.loadUserImagesArray()
            currentArray.append(newImage)
            saveLoadManager.saveUserImagesArray(currentArray)
            
      
            navigationController?.popViewController(animated: true)
        
    }
  
    func cancelAction() {
        if let viewControllers = navigationController?.viewControllers {
            for controller in viewControllers {
                if let imagesViewController = controller as? ImagesViewController {
                    navigationController?.popToViewController(imagesViewController, animated: true)
                    return
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    private func showPicker(_ sourceType : UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }
    
    private func showImagePickerAlert() {
        let alert = UIAlertController(title: "Choose media source", message: "Do you want to leave the screen?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {[weak self] _ in self?.showPicker(.camera)}
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) {[weak self] _ in self?.showPicker(.photoLibrary)}
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc func pickerAction (_ sender: UITapGestureRecognizer) {
        print ("ALERT")
        showImagePickerAlert()
    }
    
}


extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        self.imagePlusView.image = image
        
        if let imageName = saveLoadManager.saveImage(image: image) {
            saveLoadManager.saveImageName(imageName)
            
        }
         
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            picker.dismiss(animated: true)
        }
    }
    
    extension AddImageViewController: UITextFieldDelegate {
        func textFieldShouldReturn (_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            return true
        }
    }

