//
//  ViewController.swift
//  TableViewInStoryboard
//
//  Created by zaehorang on 2023/08/14.
//

import UIKit

class ViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MVC패턴을 위한 데이터 매니저 (배열 관리 - 데이터)
    var movieDataManager = DataManager()
    
    // 테이블뷰의 데이터를 표시하기 위한 배열
    var movieDataArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "영화목록"
        
        setupTableView()
        setupDatas()
    }
    
    func setupTableView() {
        // 델리게이트 패턴의 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        // 셀의 높이 설정
        tableView.rowHeight = 120
    }
    
    func setupDatas() {
        movieDataManager.makeMovieData() // 일반적으로는 서버에 요청
        movieDataArray = movieDataManager.getMovieData()  // 데이터 받아서 뷰컨의 배열에 저장
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        movieDataManager.updateMovieData()  // 일반적으로는 서버에 요청 (데이터 업데이트)
        movieDataArray = movieDataManager.getMovieData()  // 다시 데이터 받아서 뷰컨의 배열에 저장
        tableView.reloadData()   // 테이블뷰를 다시 불러오기
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    // 1) 테이블뷰에 몇개의 데이터를 표시할 것인지(셀이 몇개인지)를 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDataArray.count
    }
    
    // 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // (힙에 올라간)재사용 가능한 셀을 꺼내서 사용하는 메서드 (애플이 미리 잘 만들어 놓음)
        // (스토리보드로 구현 -> 사전에 셀을 등록하는 과정이 내부 메커니즘에 존재)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.mainImageView.image = movieDataArray[indexPath.row].movieImage
        cell.movieNameLabel.text = movieDataArray[indexPath.row].movieName
        cell.descriptionLabel.text = movieDataArray[indexPath.row].movieDescription
        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    // 셀이 선택이 되었을때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 세그웨이를 실행
        performSegue(withIdentifier: "toDetail", sender: indexPath)   // sender를 통해 indexPath를 보냈기 때문에 아래 함수에서 sender를 통해 indexPath 사용
    }
    
    // prepare세그웨이(데이터 전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailVC = segue.destination as! DetailViewController
            let index = sender as! IndexPath
            
            let moviesArray = movieDataManager.getMovieData()
            
            // 배열에서 아이템을 꺼내서, 다음화면으로 전달 -> movieData는 다른 뷰컨에서 미리 선언해둬야 한다.
            detailVC.movieData = moviesArray[index.row]
        }
        
    }
    
}
