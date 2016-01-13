//
//  AnimatedAppearanceFlowLayout.swift
//  Collection View Animations
//
//  Created by jesse calkin on 1/12/16.
//  Copyright © 2016 jesse calkin. All rights reserved.
//

import UIKit

class AnimatedAppearanceFlowLayout: UICollectionViewFlowLayout {

    var dynamicAnimator = UIDynamicAnimator()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        
        scrollDirection = UICollectionViewScrollDirection.Vertical
        minimumInteritemSpacing = 10.0
        sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        itemSize = CGSizeMake(100.0, 100.0)     // this will vary based on the card
    }
    
    //MARK: - Overrides
    
    override func prepareLayout() {
        super.prepareLayout()
        
        guard let contentSize = collectionView?.contentSize else {return}
        guard let attributes = super.layoutAttributesForElementsInRect(CGRect(x: 0.0, y: 0.0, width: contentSize.width, height: contentSize.height)) else { return }
        
        if dynamicAnimator.behaviors.count == 0 {
            attributes.forEach {
                let attachment = UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center)
                attachment.length = 0.0
                attachment.damping = 0.8
                attachment.frequency = 1.0
                
                dynamicAnimator.addBehavior(attachment)
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return dynamicAnimator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }

    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        var newIndexPaths = [NSIndexPath]()
        
        for item in updateItems {
            if item.updateAction == UICollectionUpdateAction.Insert {
                if let indexPath = item.indexPathAfterUpdate {
                    newIndexPaths.append(indexPath)
                }
            }
        }
        
        for indexPath in newIndexPaths {
            addBehaviorAndLayoutAttributesToItemAtIndexPath(indexPath)
        }
    }
    
    func addBehaviorAndLayoutAttributesToItemAtIndexPath(indexPath: NSIndexPath) {
        guard let newItemLayoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath) else { return }
        
        let attachmentBehavior = UIAttachmentBehavior(item: newItemLayoutAttributes, attachedToAnchor: newItemLayoutAttributes.center)
        attachmentBehavior.length = 0.0
        attachmentBehavior.damping = 0.75
        attachmentBehavior.frequency = 1.0
        
        dynamicAnimator.addBehavior(attachmentBehavior)
        
        let offScreenX: CGFloat = collectionView!.bounds.width/2.0
        let offScreenY: CGFloat = collectionView!.frame.height + 50.0 //50 is half of the card width right now
        
        newItemLayoutAttributes.center = CGPoint(x: offScreenX, y: offScreenY)
        newItemLayoutAttributes.alpha = 1.0
        
        dynamicAnimator.updateItemUsingCurrentState(newItemLayoutAttributes)
    }

}
