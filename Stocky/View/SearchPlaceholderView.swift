//
//  SearchPlaceholderView.swift
//  Stocky
//
//  Created by Jun suk Bang on 2021/01/17.
//
import UIKit
///Placeholder view for welcome stage of app (before the user touches search)
class WelcomeView: UIView {
    /// Image view for app logo
    private let appLogo: UIImageView = {
        let image = UIImage(named: "stocky")
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    /// UILabel to accompany app logo
    private let greeting: UILabel = {
        let label = UILabel()
        label.text = "원하는 종목의 수익성을 계산해보세요!"
        label.font = UIFont(name: "AvenirNext-Medium", size: 20)!
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    /// Stack view is used to stack appLogo image and greeting label
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [appLogo, greeting])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    ///override init Is used instead of viewDidLoad when View is created programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// Setup views
    private func setupViews() {
        addSubview(stackView)
        ///Constraints for stackview
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            appLogo.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
}
