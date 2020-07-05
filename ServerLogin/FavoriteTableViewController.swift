//
//  FavoriteTableViewController.swift
//  ServerLogin
//
//  Created by SWU mac on 2020/06/08.
//  Copyright © 2020 SWU mac. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTableViewController: UITableViewController {
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    let context = AppDelegate.managedObjectContext!
//    
    var fetchedArray: [FavoriteData] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        self.downloadDataFromServer()
    }
    func downloadDataFromServer() -> Void {
        let urlString: String = "http://condi.swu.ac.kr/student/T09/favorite/favoriteTable.php"
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (responseData, response, responseError) in guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return;
            }
            let response = response as! HTTPURLResponse
            
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,
                                                                    options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        var newData: FavoriteData = FavoriteData()
                        var jsonElement = jsonData[i]
                        newData.favoriteno = jsonElement["favoriteno"] as! String
                        newData.userid = jsonElement["id"] as! String
                        newData.name = jsonElement["name"] as! String
                        newData.descript = jsonElement["description"] as! String
                        newData.imageName = jsonElement["imageName"] as! String
                        newData.date = jsonElement["date"] as! String
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
            } catch { print("Error: Catch") }
        }
        task.resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? DetailViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    let data = fetchedArray[selectedIndex]
                    destination.selectedData = data
                    destination.title = data.name
                }
            }
        }
    }
    @IBAction func buttonLogout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let urlString: String = "http://condi.swu.ac.kr/student/T09/login/logout.php"
            guard let requestURL = URL(string: urlString) else { return
            }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return }
            }
            task.resume()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "loginView")
            loginView.modalPresentationStyle = .fullScreen
            self.present(loginView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Review Cell", for: indexPath)
        // Configure the cell...
        let item = fetchedArray[indexPath.row]
//
//        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: <#T##NSManagedObjectContext#>)
//        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        var error : NSError?
//        var fetchedResults = context.executeFetchRequest(fetchedRequest, error: &error) as? [NSManagedObject]
//        user.setValue(item.userid, forKey: "id")
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.userid + "님"
        
        return cell
    }
}
