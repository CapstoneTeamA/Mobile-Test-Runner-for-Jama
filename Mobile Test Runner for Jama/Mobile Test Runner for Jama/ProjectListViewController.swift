//
//  ProjectListViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class ProjectListViewController: UIViewController {

    var currentUser: UserModel = UserModel()
    var projectList: ProjectListModel = ProjectListModel()
    var username = ""
    var password = ""
    var instance = ""
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var endpointString = RestHelper.getEndpointString(method: "Get", endpoint: "Projects")
        endpointString = "https://" + instance + "." + endpointString
        RestHelper.hitEndpoint(atEndpointString: endpointString, withDelegate: self, username: username, password: password)
        
        let layout = buildCollectionLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create the layout for the collection view to set the size of objects and sets the cells spacing.
    func buildCollectionLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 60)
        layout.minimumInteritemSpacing = 1000
        layout.minimumLineSpacing = 6
        return layout
    }
    
    //Comparator function to be used by the sort method on arrays
    func compareProjectNames(lhs: ProjectModel, rhs: ProjectModel) -> Bool {
        return lhs.name.uppercased() < rhs.name.uppercased()
    }
    
//  Useful to make sure that giant project lists are handled okay.
//    func debugHugeProjectList(){
//        for ndx in 0...1000 {
//            let tmpProject = ProjectModel()
//            tmpProject.name = "project \(ndx)"
//            self.projectList.projectList.append(tmpProject)
//        }
//    }
}

extension ProjectListViewController: EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?) {
        guard let unwrappedData = data else {
            return
        }
        DispatchQueue.main.async {
            self.projectList.extractProjectList(fromData: unwrappedData)
            
            //It looks like the API returns the list sorted but it seems like we should make sure
            self.projectList.projectList.sort(by: self.compareProjectNames(lhs:rhs:))
//            self.debugHugeProjectList()
            self.collectionView.reloadData() //After async call, reload the collection data
        }
    }
}


extension ProjectListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //How many cells will the collection view have
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectList.projectList.count
    }
    
    //Makes a cell for the collection. This is called for each of the projects in the list.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return buildCell(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let testRunViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestRunList") as! TestRunListViewController
        
        testRunViewController.projectName = projectList.projectList[indexPath.row].name
        testRunViewController.projectKey = projectList.projectList[indexPath.row].projectKey
        self.navigationController?.pushViewController(testRunViewController, animated: true)
    }
    
    func buildCell(indexPath: IndexPath) -> ProjectCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProjectCollectionViewCell
        cell.projectCellLabel.text = projectList.projectList[indexPath.row].name
        prepCell(forCell: cell)
        return cell
    }
    
    //Make the cell all pretty
    func prepCell(forCell: ProjectCollectionViewCell) {
        forCell.layer.cornerRadius = 5.0
        forCell.layer.shadowColor = UIColor.lightGray.cgColor
        forCell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        forCell.layer.shadowRadius = 2.0
        forCell.layer.shadowOpacity = 1.0
        forCell.layer.masksToBounds = false
        forCell.layer.shadowPath = UIBezierPath(roundedRect: forCell.bounds, cornerRadius: forCell.contentView.layer.cornerRadius).cgPath
    }

}
