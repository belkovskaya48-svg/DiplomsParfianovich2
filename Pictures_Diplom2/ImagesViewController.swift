
import SnapKit
import UIKit

class ImagesViewController: UIViewController {
    
    private var isFilteringFavorites = false
    
    var userImagesArray = SaveLoadManager().loadUserImagesArray()
    
    private var displayedImages: [UserImage] {
        
        if isFilteringFavorites {
            return userImagesArray.filter { $0.imageName == "plus" || $0.isFavorite }
        } else {
            return userImagesArray
        }
    }

    
    private var sortingButton : UIButton = {
       let sortingButton = UIButton()
        sortingButton.contentMode = .scaleAspectFit
        sortingButton.clipsToBounds = true
        sortingButton.backgroundColor = .clear
        sortingButton.setImage(UIImage(systemName: "heart"), for: .normal)
        sortingButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        return sortingButton
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        loadContent()
        collectionView.reloadData()
    }
   
    private func configureUI () {
        
        view.addSubview(collectionView)
        view.addSubview(sortingButton)
        view.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.90, alpha: 1.0)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortingButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        sortingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(50)
            
        }
        
        let sortingAction = UIAction { _ in
            self.sortingkAction()
        }
        sortingButton.addAction(sortingAction, for: .touchUpInside)
    }
    
    func sortingkAction() {
       
        sortingButton.isSelected.toggle() 
           isFilteringFavorites.toggle()
           collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = displayedImages[indexPath.item]
        
        if selectedItem.imageName == "plus" {
            let addVC = AddImageViewController()
            navigationController?.pushViewController(addVC, animated: true)
        } else {
            let scrollVC = ScrollingImageViewController()
            
           
            scrollVC.photos = displayedImages
            scrollVC.currentIndex = indexPath.item
            
            scrollVC.onPhotosUpdate = { updatedPhotos in
                
                self.userImagesArray = updatedPhotos
                
                var toSave: [UserImage] = []
                for item in updatedPhotos {
                    if item.imageName != "plus" {
                        toSave.append(item)
                    }
                }
                SaveLoadManager().saveUserImagesArray(toSave)
                
                
                self.collectionView.reloadData()
            }
            
            navigationController?.pushViewController(scrollVC, animated: true)
        }
    }

    
    func loadContent() {
       
        self.userImagesArray.removeAll()
        let savedImages = SaveLoadManager().loadUserImagesArray()
        let plusItem = UserImage(imageName: "plus", description: "Добавить", isFavorite: false)
        self.userImagesArray = [plusItem] + savedImages
        
        collectionView.reloadData()
    }
    
}


extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource,
                                UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      displayedImages.count
 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let image = displayedImages[indexPath.item]
        cell.configure(with:image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 32) / CGFloat(3)
        let height = (width / 4) * 3
        return CGSize(width: width, height: height)
        
    }
    
    func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    
}






