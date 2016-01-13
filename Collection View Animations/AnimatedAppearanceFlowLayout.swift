//
//  AnimatedAppearanceFlowLayout.swift
//  Collection View Animations
//
//  Created by jesse calkin on 1/12/16.
//  Copyright © 2016 jesse calkin. All rights reserved.
//

import UIKit

class AnimatedAppearanceFlowLayout: UICollectionViewFlowLayout {

    var animator = UIDynamicAnimator()

    var indexPathsToAnimate = [NSIndexPath]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        animator = UIDynamicAnimator(collectionViewLayout: self)
    }

    //MARK: - Overrides

//    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else { return nil }
//
//        if indexPathsToAnimate.contains(itemIndexPath) {
//            let center = CGPoint(x: attributes.center.x - 50, y: attributes.center.y)
//
//            attributes.alpha = 1.0
//            attributes.center = center
//        }
//
//        return attributes
//    }

    override func prepareLayout() {
        super.prepareLayout()

        setupAttachmentBehaviors()
    }

    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        var indexPaths = [NSIndexPath]()

        for item in updateItems {
            if item.updateAction == UICollectionUpdateAction.Insert || item.updateAction == UICollectionUpdateAction.Move {
                if let indexPath = item.indexPathAfterUpdate {
                    indexPaths.append(indexPath)
                }
            }
        }

        indexPathsToAnimate = indexPaths

        resetLayout()

        //animator.behaviors.forEach { item in
        indexPathsToAnimate.forEach { indexPath in
            let item = animator.behaviors[indexPath.item]
            let behavior = item as? UIAttachmentBehavior
            if let attributes = behavior?.items.first {
            attributes.center = CGPoint(x: attributes.center.x - 50, y: attributes.center.y)
            animator.updateItemUsingCurrentState(attributes)
            }
        }
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = animator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]

        return attributes
    }

    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = animator.layoutAttributesForCellAtIndexPath(indexPath) {
            return attributes
        } else {
            return super.layoutAttributesForItemAtIndexPath(indexPath)!.copy() as? UICollectionViewLayoutAttributes
        }
    }

    //MARK: - Utility

    func resetLayout() {
        animator.removeAllBehaviors()
        prepareLayout()
    }


    func setupAttachmentBehaviors() {
        guard let contentSize = collectionView?.contentSize else {return}
        guard let attributes = super.layoutAttributesForElementsInRect(CGRect(x: 0.0, y: 0.0, width: contentSize.width, height: contentSize.height)) else { return }

        if animator.behaviors.count == 0 {
            attributes.forEach {
                let attachment = UIAttachmentBehavior(item: $0, attachedToAnchor: $0.center)
                attachment.length = 0.0
                attachment.damping = 0.8
                attachment.frequency = 1.0

                self.animator.addBehavior(attachment)
            }
        }
    }
}
