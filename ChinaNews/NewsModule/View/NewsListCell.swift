//
//  NewsListCell.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/5.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit
import Kingfisher

extension UITableViewCell {
    static var Identifiter: String {
        get {
            return self.description()
        }
    }
}

class NewsListCell: UITableViewCell {

    let space = 20
    let padding = 10

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.black
        return label
    }()

    lazy var separater: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separater)

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(space)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
        }

        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(padding)
            make.left.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-padding)
        }

        sourceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(padding)
            make.right.equalToSuperview().offset(-padding)
            make.bottom.equalToSuperview().offset(-space)
        }

        separater.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
        }
    }


    func updateWith(_ item: NewsItem) {
        titleLabel.text = item.title
        let text = item.description.count > 0 ? item.description : item.content
        descriptionLabel.text = text
        sourceLabel.text = item.source
        dateLabel.text = item.pubDate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
