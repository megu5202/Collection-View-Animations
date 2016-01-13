//
//  FirstViewController.swift
//  Collection View Animations
//
//  Created by jesse calkin on 1/12/16.
//  Copyright © 2016 jesse calkin. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var items: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 1...10 {
            items.append(UIColor.randomColor())
        }
    }
}

extension FirstViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = items[indexPath.item]

        return cell
    }
}

extension FirstViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let nextValue = UIColor.randomColor()
        let nextIndexPath = NSIndexPath(forItem: indexPath.item + 1, inSection: 0)


        items.insert(nextValue, atIndex: nextIndexPath.item)
        collectionView.insertItemsAtIndexPaths([nextIndexPath])
    }
}


