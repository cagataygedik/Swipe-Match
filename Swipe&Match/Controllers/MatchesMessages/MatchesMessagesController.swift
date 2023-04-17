//
//  MatchesMessagesController.swift
//  Swipe&Match
//
//  Created by Celil Çağatay Gedik on 17.04.2023.
//

import LBTATools

class MatchCell: LBTAListCell<UIColor> {
    
    let profileImageView = UIImageView(image: Placeholder.image, contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "Username", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
        }
    }
    
    override func setupViews() {
        super.setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 40
        stack(stack(profileImageView, alignment: .center), userNameLabel)
    }
}

class MatchesMessagesController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {
    
    let customNavigationBar = MatchesNavigationBar()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCustomNavBar()
        
        items = [
            .red, .blue, .green]
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 150
    }
    
    private func configureCustomNavBar() {
        customNavigationBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        view.addSubview(customNavigationBar)
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
    
    @objc private func handleBack() {
        navigationController?.popViewController(animated: true)
    }
}
