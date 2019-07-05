//
//  NewsListImageViewCell.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/5.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class NewsListImageViewCell: NewsListCell {

    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconView)

        iconView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(padding)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.height.equalTo(200)
        }

        sourceLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.bottom.equalToSuperview().offset(-padding)
        }

        dateLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(padding)
            make.left.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-padding)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateWith(_ item: NewsItem) {
        super.updateWith(item)
        if item.havePic {
            let image = item.images.first!
            iconView.kf.setImage(with: URL.init(string: image.url))
        }
    }
    

}
