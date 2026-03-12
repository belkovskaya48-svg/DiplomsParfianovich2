import UIKit
import Foundation
import SnapKit


final class ScrollingImageViewController : UIViewController {
    
    var onPhotosUpdate: (([UserImage]) -> Void)?
    var isFavorite = false
    var photos: [UserImage] = []
    var currentIndex: Int = 0
    let saveLoadManager = SaveLoadManager()
    
    private let imageMainView : UIImageView = {
        let imageMainView = UIImageView()
        imageMainView.contentMode = .scaleAspectFit
        imageMainView.clipsToBounds = true
        return imageMainView
    }()
    
    private let prevButton : UIButton = {
        let prevButton = UIButton()
        prevButton.contentMode = .scaleAspectFit
        prevButton.clipsToBounds = true
        prevButton.backgroundColor = .clear
        prevButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return prevButton
    }()
    
    private let nextButton : UIButton = {
        let nextButton = UIButton()
        nextButton.contentMode = .scaleAspectFit
        nextButton.clipsToBounds = true
        nextButton.backgroundColor = .clear
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return nextButton
    }()
    
    private let backButton : UIButton = {
        let backButton = UIButton()
        backButton.contentMode = .scaleAspectFit
        backButton.clipsToBounds = true
        backButton.backgroundColor = .clear
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return backButton
    }()
    
    private let textField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "description photo"
        textField.borderStyle = .line
        textField.layer.cornerRadius = 12
        textField.layer.borderColor = UIColor.blue.cgColor
        return textField
    }()
    
    private let favoriteButton : UIButton = {
        let favoriteButton = UIButton()
        favoriteButton.contentMode = .scaleAspectFit
        favoriteButton.clipsToBounds = true
        favoriteButton.backgroundColor = .clear
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        return favoriteButton
    }()
    
    private let deleteButton : UIButton = {
        let deleteButton = UIButton()
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.clipsToBounds = true
        deleteButton.backgroundColor = .clear
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        return deleteButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        updateContent()
    }
    
    func configureUI() {
        
        view.backgroundColor = .white
        view.addSubview(imageMainView)
        view.addSubview(textField)
        view.addSubview(backButton)
        view.addSubview(prevButton)
        view.addSubview(favoriteButton)
        view.addSubview(nextButton)
        view.addSubview(deleteButton)
        
        
        imageMainView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(imageMainView.snp.height)
        }
        
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageMainView.snp.bottom)
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
        
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(50)
            make.right.equalTo(imageMainView.snp.centerX)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-50)
            make.left.equalTo(imageMainView.snp.centerX)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(80)
            make.height.equalTo(50)
        }
        
        let nextPhotoAction = UIAction { _ in
            self.nextPhotoAction()
        }
        nextButton.addAction(nextPhotoAction, for: .touchUpInside)
        
        let prevPhotoAction = UIAction { _ in
            self.prevPhotoAction()
        }
        prevButton.addAction(prevPhotoAction, for: .touchUpInside)
        
        let backAction = UIAction { _ in
            self.backAction()
        }
        backButton.addAction(backAction, for: .touchUpInside)
        
        let isFavoriteAction = UIAction { _ in
            self.isFavoriteAction()
        }
        favoriteButton.addAction(isFavoriteAction, for: .touchUpInside)
        
        let deleteAction = UIAction { _ in
            self.deleteAction()
        }
        deleteButton.addAction(deleteAction, for: .touchUpInside)
    }
    
    func updateContent() {
        
        let currentPhoto = photos[currentIndex]
        imageMainView.image = saveLoadManager.loadImage(name: currentPhoto.imageName)
        textField.text = currentPhoto.description
        favoriteButton.isSelected.toggle()
        
    }
    
    func nextPhotoAction() {
        
        var nextIndex = currentIndex + 1
        if nextIndex >= photos.count {
            nextIndex = 0
        }
        if photos[nextIndex].imageName == "plus" {
            nextIndex += 1
            if nextIndex >= photos.count {
                nextIndex = 0
            }
        }
        
        let extraImageView = UIImageView()
        extraImageView.image = saveLoadManager.loadImage(name: photos[nextIndex].imageName)
        extraImageView.contentMode = .scaleAspectFit
        extraImageView.layer.cornerRadius = 10
        extraImageView.clipsToBounds = true
        view.addSubview(extraImageView)
        
        extraImageView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.right)
            make.centerY.equalTo(imageMainView.snp.centerY)
            make.height.width.equalTo(imageMainView)
        }
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            extraImageView.snp.remakeConstraints { make in
                make.edges.equalTo(self.imageMainView)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.currentIndex = nextIndex
            self.updateContent()
            extraImageView.removeFromSuperview()
        }
    }
    
    func prevPhotoAction() {
        
        var prevIndex = currentIndex - 1
        if prevIndex < 0 {
            prevIndex = photos.count - 1
        }
        
        if photos[prevIndex].imageName == "plus" {
            prevIndex -= 1
            if prevIndex < 0 { prevIndex = photos.count - 1 }
        }
        
        self.currentIndex = prevIndex
        self.updateContent()
        
        let extraImageView = UIImageView()
        extraImageView.backgroundColor = .clear
        extraImageView.layer.cornerRadius = 10
        extraImageView.contentMode = .scaleAspectFit
        extraImageView.clipsToBounds = true
        
        view.addSubview(extraImageView)
        
        extraImageView.snp.makeConstraints { make in
            make.right.equalTo(view.snp.left)
            make.centerY.equalTo(imageMainView.snp.centerY)
            make.height.width.equalTo(imageMainView.snp.height)
        }
        self.view.layoutIfNeeded()
        extraImageView.image = saveLoadManager.loadImage(name: photos[currentIndex].imageName)
        
        UIView.animate(withDuration: 0.3) {
            extraImageView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(120)
                make.centerX.equalToSuperview()
                make.left.equalToSuperview().offset(16)
                make.right.equalToSuperview().offset(-16)
                make.width.equalTo(extraImageView.snp.height)
            }
            self.view.layoutIfNeeded()
        } completion: { _ in
            extraImageView.removeFromSuperview()
        }
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    func isFavoriteAction() {
        
        if currentIndex < photos.count {
            photos[currentIndex].isFavorite.toggle()
            let isFav = photos[currentIndex].isFavorite
            favoriteButton.isSelected.toggle()
            onPhotosUpdate?(photos)
        }
    }
    
    func deleteAction() {
        
        let alert = UIAlertController(
            title: "Удаление",
            message: "Вы уверены, что хотите удалить это фото?",
            preferredStyle: .alert
        )
        let deleteBtn = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.deletePhoto()
        }
        
        let cancelBtn = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(deleteBtn)
        alert.addAction(cancelBtn)
        
        present(alert, animated: true)
        
    }
    
    func deletePhoto() {
        
        guard currentIndex < photos.count else { return }
        photos.remove(at: currentIndex)
        
        onPhotosUpdate?(photos)
        
        if photos.count <= 1 {
            
            navigationController?.popViewController(animated: true)
        } else {
            
            if currentIndex >= photos.count {
                currentIndex = photos.count - 1
            }
            
            if photos[currentIndex].imageName == "plus" {
                nextPhotoAction()
            } else {
                updateContent()
            }
        }
    }
    
}
