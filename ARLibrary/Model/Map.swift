//
//  Map.swift
//  ARLibrary
//
//  Created by 吕丁阳 on 2020/4/5.
//  Copyright © 2020 吕丁阳. All rights reserved.
//

struct Point {
    var x: Int = 0
    var y: Int = 0
}

class Map {
    var name: String = "五楼阅览室"  // 阅览室ID
    var row: Int = 0    // 地图行数
    var col: Int = 0    // 地图列数
    var array: [[Int]] = []    // 地图矩阵
    var length: Float
    
    
    init(row: Int, col: Int, obstacle: [Point]) {
        self.length = 0.0;
       
        self.row = row
        self.col = col
        for _ in 1...row {
            var Row = [Int]()
            for _ in 1...col {
                Row.append(0)
            }
            self.array.append(Row)
        }
        
        for point in obstacle {
            self.array[point.x][point.y] = 1
        }
        
        for i in 0..<self.row {
            self.array[i][0] = 1
            self.array[i][self.col - 1] = 1
        }
        for i in 0..<self.col {
            self.array[0][i] = 1
            self.array[self.row - 1][i] = 1
        }
    }
    
    func findPath(start startPoint: Point, end endPoint: Point) -> [Point] {
        var havePassed: [[Int]] = []
        for _ in 1...row {
            var Row = [Int]()
            for _ in 1...col {
                Row.append(0)
            }
            havePassed.append(Row)
        }
        
        var pointQueue = [Point]()
        var tempQueue = [Point]()
        
        pointQueue.append(startPoint)
        havePassed[1][1] = 1
        var end = false
        
        while !(pointQueue.isEmpty) {
            let coord = pointQueue.removeFirst()
            let neighbours: [Point] = searchNeighbours(point: coord, map: self, havePassed: &havePassed)
            for neighbour in neighbours {
                pointQueue.append(neighbour)
                if !end {
                    tempQueue.append(neighbour)
                    tempQueue.append(coord)
                }
                if neighbour.x == endPoint.x && neighbour.y == endPoint.y {
                    end = true
                }
            }
            if coord.x == endPoint.x && coord.y == endPoint.y {
                break
            }
        }
        var path = [Point]()
        // path.append(endPoint)
        path.append(Point(x: endPoint.x - startPoint.x, y: endPoint.y - startPoint.y))
        var temp = tempQueue[tempQueue.count - 1]
        while temp.x != startPoint.x || temp.y != startPoint.y {
            path.insert(Point(x: temp.x - startPoint.x, y: temp.y - startPoint.y), at: 0)
            for i in stride(from: 0, to: tempQueue.count, by: 2) {
                if tempQueue[i].x == temp.x && tempQueue[i].y == temp.y {
                    temp = tempQueue[i + 1]
                    break
                }
            }
        }
        path.insert(Point(x: startPoint.x - startPoint.x, y: startPoint.y - startPoint.y), at: 0)
        
        return path
    }
}
func searchNeighbours(point: Point, map: Map, havePassed: inout [[Int]]) -> [Point] {
    
    var neighbours = [Point]()
    let x = point.x
    let y = point.y
    if havePassed[x][y + 1] == 0 && map.array[x][y + 1] == 0 {
        neighbours.append(Point(x: x, y: y + 1))
        havePassed[x][y + 1] = 1
    }
    if havePassed[x + 1][y] == 0 && map.array[x + 1][y] == 0 {
        neighbours.append(Point(x: x + 1, y: y))
        havePassed[x + 1][y] = 1
    }
    if havePassed[x - 1][y] == 0 && map.array[x - 1][y] == 0 {
        neighbours.append(Point(x: x - 1, y: y))
        havePassed[x - 1][y] = 1
    }
    if havePassed[x][y - 1] == 0 && map.array[x][y - 1] == 0 {
        neighbours.append(Point(x: x, y: y - 1))
        havePassed[x][y - 1] = 1
    }
    return neighbours
}


func setMap() -> Map {
    var obstacle = [Point]()
    for i in 1...199 {
        obstacle.append(Point(x: i, y: 492))
    }
    for i in 1...492 {
        obstacle.append(Point(x: 138, y: i))
    }
    for i in 1...135 {
        obstacle.append(Point(x: i, y: 487))
    }
    for i in 199...487 {
        obstacle.append(Point(x: 135, y: i))
    }
    for i in 103...135 {
        obstacle.append(Point(x: i, y: 199))
    }
    for i in 199...238 {
        obstacle.append(Point(x: 103, y: i))
    }
    for i in 1...103 {
        obstacle.append(Point(x: i, y: 238))
    }
    for i in 1...97 {
        obstacle.append(Point(x: i, y: 232))
    }
    let map = Map(row: 200, col: 500, obstacle: obstacle)
    return map
}

func simplifyPath(path: [Point]) -> [Point]{
    var simplifiedPath = [Point]()
    simplifiedPath.append(path[0])
    for i in 0...path.count - 3 {
        if path[i].x != path[i + 2].x && path[i].y != path[i + 2].y {
            simplifiedPath.append(path[i + 1])
        }
    }
    simplifiedPath.append(path[path.count - 1])
    return simplifiedPath
}

