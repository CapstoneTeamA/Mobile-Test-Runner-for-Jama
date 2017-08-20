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
    @IBOutlet weak var noProjectsMargin: UIView!
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
        
        RestHelper.hitEndpoint(atEndpointString: endpointString, withDelegate: self, username: username, password: password, timestamp: RestHelper.getCurrentTimestampString())
        
        let layout = buildCollectionLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        noProjectsLabel.isHidden = true
        noProjectsImage.isHidden = true
        noProjectsMargin.isHidden = true
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
        //If there's nothing in the list
        if (self.projectList.projectList.isEmpty) {
            //Show the image and the words
            noProjectsLabel.isHidden = false
            noProjectsImage.isHidden = false
            noProjectsLabel.text = noProjectsMessage
            noProjectsMargin.isHidden = false
            formatEmptyProjectMessage()
        }
        else {
            //Set both image and label to invisible
            noProjectsLabel.isHidden = true
            noProjectsImage.isHidden = true
            noProjectsMargin.isHidden = true
        }
    }
    
    func formatEmptyProjectMessage() {
        view.bringSubview(toFront: noProjectsLabel)
        view.bringSubview(toFront: noProjectsImage)
        view.bringSubview(toFront: noProjectsMargin)
        collectionView.backgroundColor = UIColor.white
    }
    
    //Comparator function to be used by the sort method on arrays
    func compareProjectNames(lhs: ProjectModel, rhs: ProjectModel) -> Bool {
        return lhs.name.uppercased() < rhs.name.uppercased()
    }
    
    func endpointErrorOccured(){
        serverErrorLabel.isHidden = false
    }
}

extension ProjectListViewController: EndpointDelegate {
    func didLoadEndpoint(data: [[String : AnyObject]]?, totalItems: Int, timestamp: String) {
        
        guard let unwrappedData = data else {
            endpointErrorOccured()
            return
        }
        DispatchQueue.main.async {
            self.noProjectsImage.isHidden = true
            self.noProjectsLabel.isHidden = true
            self.noProjectsMargin.isHidden = true
   
            let tmpList = ProjectListModel()
            tmpList.extractProjectList(fromData: unwrappedData)
            self.projectList.projectList.append(contentsOf: tmpList.projectList)
            self.projectList.projectList.sort(by: self.compareProjectNames(lhs:rhs:))
            
            //After async call, reload the collection data
            self.collectionView.reloadData()
            
            //As long as there are more Projects that we need to get from the API keep calling for them.
            if self.collectionView.numberOfItems(inSection: 0) < totalItems {
                RestHelper.hitEndpoint(atEndpointString: self.endpointString + "?startAt=\(self.projectList.projectList.count)", withDelegate: self, username: self.username, password: self.password, timestamp: timestamp)
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
        testViewController.currentUser = currentUser
        self.navigationController?.pushViewController(testViewController, animated: true)
    }
    
    func buildCell(indexPath: IndexPath) -> ProjectCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProjectCollectionViewCell
        cell.projectCellLabel.text = projectList.projectList[indexPath.row].name
        prepCell(forCell: cell)
        return cell
    }
    
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
