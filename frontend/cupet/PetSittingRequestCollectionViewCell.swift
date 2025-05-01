//
//  PetSittingRequestCollectionViewCell.swift
//  cupet
//
//  Created by Shreya Majumdar on 4/30/25.
//

import UIKit

class PetSittingRequestCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties (view)

    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let activenessLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let contactButton = UIButton()
    private let petImage = UIImageView()
    private let petsitDateLabel = UILabel()
    private let locationLabel = UILabel()
    

    // MARK: - Properties (data)
    private var name:String = "Petunia"
    private var type:String = "Stuffed Toy"
    static let reuse: String = "PetSittingRequestCollectionViewCellReuse"
    private var activeness:String = "None"
    private var desc:String = "This is my childhood stuffed toy"
    private var contact:String = "sm2435@cornell.edu"
    private let contactButtonText:String = "Contact"
    private var location:String = "North"
    private var startDate:Date = Date()
    private var endDate:Date = Date()

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        layer.cornerRadius = 16

        // change these
        setupNameLabel()
        setupTypeLabel()
        setupActivenessLabel()
        setupDescriptionLabel()
        setupDateLabel()
        setupLocationLabel()
        setupContactButton()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
// for rounded image
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
//    }

    // MARK: - Set Up Views
    private func setupNameLabel() {
        nameLabel.text = name
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 1
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
        ])
    }
    
    private func setupTypeLabel() {
        typeLabel.text = "Pet Type: \(type)"
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = UIColor.gray
        typeLabel.numberOfLines = 1
        
        contentView.addSubview(typeLabel)
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width/2)
            // can also try contentView.Frame.Width
        ])
    }
    
    private func setupActivenessLabel() {
        activenessLabel.text = "Activeness: \(activeness)"
        activenessLabel.font = .systemFont(ofSize: 14)
        activenessLabel.textColor = UIColor.gray
        activenessLabel.numberOfLines = 1
        
        contentView.addSubview(activenessLabel)
        activenessLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activenessLabel.topAnchor.constraint(equalTo: typeLabel.topAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            typeLabel.widthAnchor.constraint(equalTo: typeLabel.widthAnchor)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.text = desc
        descriptionLabel.font = .italicSystemFont(ofSize: 12)
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.numberOfLines = 3
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    private func setupDateLabel() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "MMM d, h:mm a"
        let startTime = timeFormatter.string(from: startDate)
        let endTime = timeFormatter.string(from: endDate)
        
        petsitDateLabel.text = "\(startTime) - \(endTime)"
        petsitDateLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        petsitDateLabel.textColor = UIColor.gray
        petsitDateLabel.numberOfLines = 1
        
        contentView.addSubview(petsitDateLabel)
        petsitDateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            petsitDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            petsitDateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    private func setupLocationLabel() {
        locationLabel.text = location
        locationLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        locationLabel.textColor = UIColor.gray
        locationLabel.numberOfLines = 1
        
        contentView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: petsitDateLabel.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: petsitDateLabel.trailingAnchor)
        ])
    }
    
    private func setupContactButton() {
        contactButton.setTitle(contactButtonText, for: .normal)
        contactButton.setTitleColor(.systemBackground, for: .normal)
        contactButton.backgroundColor = UIColor(red: 202/255, green: 66/255, blue: 56/255, alpha: 1)
        contactButton.layer.cornerRadius = 16
        contactButton.addTarget(self, action: #selector(showContactInformation), for: .touchUpInside)
        
        contentView.addSubview(contactButton)
        contactButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contactButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contactButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            contactButton.widthAnchor.constraint(equalToConstant: 40),
            contactButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    // MARK: - Button Helpers
    @objc private func showContactInformation() {
        
    }
    
    func configure(pet:Pet) {
        name = pet.name
        type = pet.petType
        activeness = pet.activeness
        desc = pet.description
        location = pet.location
        contact = pet.emailContact
        startDate = pet.startDate
        endDate = pet.endDate
    }

}
