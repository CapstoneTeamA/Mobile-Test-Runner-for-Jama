//
//  ProjectListViewController.swift
//  Mobile Test Runner for Jama
//
//  Created by PSU2 on 6/28/17.
//  Copyright © 2017 Jaca. All rights reserved.
//

import UIKit

class ProjectListViewController: UIViewController {

    @IBOutlet weak var serverErrorLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noProjectsLabel: UILabel!
    @IBOutlet weak var noProjectsImage: UIImageView!
    var currentUser: UserModel = UserModel()
    var projectList: ProjectListModel = ProjectListModel()
    var username = ""
    var password = ""
    var instance = ""
    var endpointString = ""
    
    
    let noProjectsMessage = "No projects found. Please contact your administrator."
    let serverErrorMessage = "Server Error"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverErrorLabel.isHidden = true
        serverErrorLabel.text = serverErrorMessage
        endpointString = RestHelper.getEndpointString(method: "Get", endpoint: "Projects")
        endpointString = "https://" + instance + "." + endpointString
        RestHelper.hitEndpoint(atEndpointString: endpointString, withDelegate: self, username: username, password: password)
        
        let layout = buildCollectionLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        noProjectsLabel.isHidden = true
        noProjectsImage.isHidden = true
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
    
    func checkProjectListEmpty() {
        //if there's nothing in the list
        if (self.projectList.projectList.isEmpty) {
            //show the image and the words
            noProjectsLabel.isHidden = false
            noProjectsImage.isHidden = false
            noProjectsLabel.text = noProjectsMessage
            formatEmptyProjectMessage()
        }
        else {
            //set both image and label to invisible
            noProjectsLabel.isHidden = true
            noProjectsImage.isHidden = true
        }
    }
    
    func formatEmptyProjectMessage() {
        view.bringSubview(toFront: noProjectsLabel)
        view.bringSubview(toFront: noProjectsImage)
        collectionView.backgroundColor = UIColor.white
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
    func endpointErrorOccured(){
        serverErrorLabel.isHidden = false
    }
}



extension ProjectListViewController: EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?, totalItems: Int) {
        //set image to invisible ASAP
        
        guard let unwrappedData = data else {
            endpointErrorOccured()
            return
        }
        DispatchQueue.main.async {
            self.noProjectsImage.isHidden = true
            self.noProjectsLabel.isHidden = true
            //Boolean that will determine if we should load the data into the view automatically if 
            //"scroll to bottom" lazy loading is enabled.
//            let isInitialAPICall = self.projectList.projectList.count == 0
            
            let tmpList = ProjectListModel()
            tmpList.extractProjectList(fromData: unwrappedData)
            self.projectList.projectList.append(contentsOf: tmpList.projectList)
            
            //It looks like the API returns the list sorted but it seems like we should make sure
            self.projectList.projectList.sort(by: self.compareProjectNames(lhs:rhs:))
//            self.debugHugeProjectList()
            
            //Since we are lazy loading the list only load the data into the view if it is the initial data
            //This if statement is commented out so the collection will continuously reloaded as the API returns a page
//            if isInitialAPICall {
            self.collectionView.reloadData() //After async call, reload the collection data
//            }
            
            //As long as there are more Projects that we need to get from the API keep calling for them.
            if self.collectionView.numberOfItems(inSection: 0) < totalItems {
                RestHelper.hitEndpoint(atEndpointString: self.endpointString + "?startAt=\(self.projectList.projectList.count)", withDelegate: self, username: self.username, password: self.password)
            }
            //if no projects were returned, display image and text
            self.checkProjectListEmpty()
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
        let testViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TestList") as! TestListViewController

        testViewController.projectId = projectList.projectList[indexPath.row].id
        testViewController.username = username
        testViewController.password = password
        testViewController.instance = instance
        self.navigationController?.pushViewController(testViewController, animated: true)
    }
    
    //This is to be used if we want to detect the user has scrolled to the bottom of the list and reload the data then.
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollHeight = scrollView.frame.size.height
//        let scrollViewContentHeight = scrollView.contentSize.height
//        let scrollOffset = scrollView.contentOffset.y
//        
//        if scrollHeight + scrollOffset == scrollViewContentHeight {
//            if collectionView.numberOfItems(inSection: 0) < projectList.projectList.count {
//                collectionView.reloadData()
//            }
//        }
//    }
    
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
