//
//  LevelOfDifficultyOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/16.
//

import UIKit

class LevelOfDifficultyOnFeedDetail: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!

    @IBOutlet weak var firstLevelOfDifficultyButton: UIButton!
    @IBOutlet weak var secondLevelOfDifficultyButton: UIButton!
    @IBOutlet weak var thirdLevelOfDifficultyButton: UIButton!
    @IBOutlet weak var fourthLevelOfDifficultyButton: UIButton!
    @IBOutlet weak var fifthLevelOfDifficultyButton: UIButton!
    @IBOutlet weak var levelOfDifficultyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.borderView.applySketchShadow(color: .colorGrayGray08, alpha: 0.15, x: 0, y: 0, blur: 5, spread: 0)
    }

    func configure(levelOfDifficulty: Int) {
        setButtonImage(levelOfDifficulty)
        setLevelOfDifficultyLabel(levelOfDifficulty)
    }

    private func setButtonImage(_ levelOfDifficulty: Int) {
        self.secondLevelOfDifficultyButton.setImage(UIImage(named: levelOfDifficulty >= 2 ? "hardFilled20px" : "hardDisabled20px"), for: .normal)
        self.thirdLevelOfDifficultyButton.setImage(UIImage(named: levelOfDifficulty >= 3 ? "hardFilled20px" : "hardDisabled20px"), for: .normal)
        self.fourthLevelOfDifficultyButton.setImage(UIImage(named: levelOfDifficulty >= 4 ? "hardFilled20px" : "hardDisabled20px"), for: .normal)
        self.fifthLevelOfDifficultyButton.setImage(UIImage(named: levelOfDifficulty >= 5 ? "hardFilled20px" : "hardDisabled20px"), for: .normal)
    }

    private func setLevelOfDifficultyLabel(_ levelOfDifficulty: Int) {
        switch levelOfDifficulty {
        case 1: self.levelOfDifficultyLabel.text = "쉬워요"
        case 2: self.levelOfDifficultyLabel.text = "할 만 해요"
        case 3: self.levelOfDifficultyLabel.text = "보통이에요"
        case 4: self.levelOfDifficultyLabel.text = "까다로워요"
        case 5: self.levelOfDifficultyLabel.text = "많이 어려워요"
        default: self.levelOfDifficultyLabel.text = "쉬워요"
        }
    }
}
