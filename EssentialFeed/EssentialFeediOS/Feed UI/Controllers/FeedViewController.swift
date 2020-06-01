//  Created by William Peregoy on 9/19/23

import UIKit
import EssentialFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController,
                                        UITableViewDataSourcePrefetching,
                                       FeedLoadingView, FeedErrorView {
    
    public var delegate: FeedViewControllerDelegate?
    private var loadingControllers = [IndexPath: FeedImageCellController]()
    
    private var viewAppeared = false
    
    public var tableModel = [FeedImageCellController]() {
        didSet {
            loadingControllers = [:]
            tableView.reloadData()
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        triggerInitialLoadIfNeeded()
    }
    
    private func triggerInitialLoadIfNeeded() {
        guard !viewAppeared else { return }
        viewAppeared = true
        refresh()
    }
    
    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    public func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    public func display(_ viewModel: FeedErrorViewModel) {
        // TODO: Error message displaying not yet implemented in this version of iOS project
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        requestCellImage(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
    
    private func requestCellImage(forRowAt indexPath: IndexPath){
        cellController(forRowAt: indexPath).requestImage()
    }
}
