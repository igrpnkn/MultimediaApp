//
//  APICaller.swift
//  MultimediaApp
//
//  Created by developer on 30.04.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum APIError: String, Error {
        case failedToGetDate = "Data from Spotify API was not downloaded or reached. Pealse debug APICaller class."
    }
    
    private init() {}
    
    // MARK: - Users Profile API
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        self.createRequest(with: URL(string: Constants.baseAPIURL + "/me"),
                           type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate ))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    // Logger.log(object: Self.self, method: #function, message: "Got user profile model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Albums API
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/albums/\(album.id)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    Logger.log(object: Self.self, method: #function, message: "ERROR:", body: error, clarification: nil)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Browse API
    
    public func getNewReleases(completion: @escaping (Result<NewReleasesRespone, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/new-releases?country=RU&offset=0&limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesRespone.self, from: data)
                    // Logger.log(object: Self.self, method: #function, message: "Got user profile model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getAllFeaturedPlaylists(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/featured-playlists?limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    //Logger.log(object: Self.self, method: #function, message: "Got All-Featured-Playlists model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getAllCategories(completion: @escaping (Result<[CategoryItem], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories?country=RU&limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
//                    Logger.log(object: Self.self, method: #function, message: "Got All-Categories model:", body: result, clarification: nil)
                    completion(.success(result.categories.items))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategory(category: CategoryItem, completion: @escaping (Result<CategoryItem, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CategoryItem.self, from: data)
                    completion(.success(result))
                } catch {
                    Logger.log(object: Self.self, method: #function, message: "API CALLER ERROR:", body: error, clarification: nil)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(for category: CategoryItem, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/browse/categories/\(category.id)/playlists?country=RU&limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
//                    Logger.log(object: Self.self, method: #function, message: "Got Category's-Playlists model:", body: result, clarification: nil)
                    completion(.success(result.playlists.items))
                } catch {
                    Logger.log(object: Self.self, method: #function, message: "API CALLER ERROR:", body: error, clarification: nil)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendations(genres: Set<String> , completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations?seed_genres=\(seeds)&limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    //Logger.log(object: Self.self, method: #function, message: "Got Recommendations model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/recommendations/available-genre-seeds"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
//                    Logger.log(object: Self.self, method: #function, message: "Got Recommended-Genres model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists API
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<Playlist, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/playlists/\(playlist.id)"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(Playlist.self, from: data)
                    Logger.log(object: Self.self, method: #function, message: "Playlist model has been parsed successfully.")
                    completion(.success(result))
                } catch {
                    Logger.log(object: Self.self, method: #function, message: "ERROR:", body: error, clarification: nil)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search API
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        let urlEncodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        createRequest(with: URL(string: Constants.baseAPIURL + "/search?q=\(urlEncodedQuery)&type=album,track,artist,playlist&limit=50"),
                      type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(SearchResultResponse.self, from: data)
                    
                    var searchResults: [SearchResult] = []
                    searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
                    searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
                    searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))
                    searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
                    
                    completion(.success(searchResults))
                } catch {
                    Logger.log(object: Self.self, method: #function, message: "ERROR:", body: error, clarification: nil)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Tracks API
    
    public func getSeveralTracks(with ids: Set<String>, completion: @escaping (Result<AudioTracks, Error>) -> Void) {
        let trackIDs = ids.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseAPIURL + "/tracks?ids=\(trackIDs)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AudioTracks.self, from: data)
//                    Logger.log(object: Self.self, method: #function, message: "Got Track model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getTrack(with id: String, completion: @escaping (Result<AudioTrack, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseAPIURL + "/tracks/\(id)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetDate))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AudioTrack.self, from: data)
//                    Logger.log(object: Self.self, method: #function, message: "Got Track model:", body: result, clarification: nil)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Creation common request
    
    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }

            var request = URLRequest(url: apiURL)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 20
            request.setValue("Bearer \(token)",
                             forHTTPHeaderField: "Authorization")
            completion(request)
        }
        
        
    }
    
}



