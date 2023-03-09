class Pathfinder {
  private Grid grid;
  private ArrayList<Square> squares = new ArrayList<Square>();
  private ArrayList<Square> discoveredSquares = new ArrayList<Square>();
  private boolean done = false;
  private Square winnerSquare;
  
  Pathfinder(Grid grid) {
    this.grid = grid;
    squares.add(new Square(grid.startPos.x, grid.startPos.y, 0));
  }
  
  void next() {
    if (squares.size() <= 0 || done) {
      return;
    }
    
    ArrayList<Square> newSquares = new ArrayList<Square>();
      
      // Loop through all squares and finds adjacent squares
      for (Square square : squares) {
        discoveredSquares.add(square);
        for (Square newSquare : findAdjacentSquares(square)) {
          if (!isBlocked(square, newSquare)) {
            if (isNewSquare(newSquare, newSquares)) {
              newSquares.add(newSquare);
              if (newSquare.x > grid.finishPos.x - 5 && newSquare.x < grid.finishPos.x + 5 && newSquare.y > grid.finishPos.y - 5 && newSquare.y < grid.finishPos.y + 5) {
                done = true;
                winnerSquare = newSquare;
                grid.setAnimationFrame();
              }
            }
          }
        }
      }
      squares = newSquares;
  }
  
  ArrayList<Square> findAdjacentSquares(Square square) {
    ArrayList<Square> adjacentSquares = new ArrayList<Square>();
    
    float y1 = -grid.h, y2 = -grid.h, x1 = -grid.w, x2 = -grid.w;
    
    for (int i = 0; i < grid.DIM[0] + 1; i++) {
      final float y = grid.y + i * grid.h / grid.DIM[1];
      if (square.y > y - 5 && square.y < y + 5) {
        y1 = y - grid.h / grid.DIM[1];
        y2 = y + grid.h / grid.DIM[1];
      }
    }
    for (int i = 0; i < grid.DIM[1] + 1; i++) {
      final float x = grid.x + i * grid.w / grid.DIM[0];
      if (square.x > x - 5 && square.x < x + 5) {
        x1 = x - grid.w / grid.DIM[0];
        x2 = x + grid.w / grid.DIM[0];
      }
    }
    
    if (!(y1 < grid.y - 5 || y1 > grid.y + grid.h + 5 - grid.h / grid.DIM[1])) {
      adjacentSquares.add(new Square(square.x, y1, square.value + 1, square));
    }
    if (!(y2 < grid.y - 5 || y2 > grid.y + grid.h + 5 - grid.h / grid.DIM[1])) {
      adjacentSquares.add(new Square(square.x, y2, square.value + 1, square));
    }
    if (!(x1 < grid.x - 5 || x1 > grid.x + grid.w + 5 - grid.w / grid.DIM[0])) {
      adjacentSquares.add(new Square(x1, square.y, square.value + 1, square));
    }
    if (!(x2 < grid.x - 5 || x2 > grid.x + grid.w + 5 - grid.w / grid.DIM[0])) {
      adjacentSquares.add(new Square(x2, square.y, square.value + 1, square));
    }
    
    return adjacentSquares;
  }
  
  boolean isNewSquare(Square _square, ArrayList<Square> newSquares) {
    for (Square square : discoveredSquares) {
      if (square.x - _square.x < 5 && square.x - _square.x > -5 && square.y - _square.y < 5 && square.y - _square.y > -5) {
        return false;
      }
    }
    
    for (Square square : squares) {
      if (square.x - _square.x < 5 && square.x - _square.x > -5 && square.y - _square.y < 5 && square.y - _square.y > -5) {
        return false;
      }
    }
    
    for (Square square : newSquares) {
      if (square.x - _square.x < 5 && square.x - _square.x > -5 && square.y - _square.y < 5 && square.y - _square.y > -5) {
        return false;
      }
    }
    return true;
  }
  
  boolean isBlocked(Square square, Square newSquare) {
    if (square.x > newSquare.x + 5) {
      // Newsquare is left
      for (Wall wall : grid.walls) {
        if (wall.x - square.x < 5 && wall.x - square.x > -5) {
          // Wall top corner between squares (x) check y
          if (wall.y - square.y < 5 && wall.y - square.y > -5) {
            if (wall.h > 0) {
              return true;
            }
          }
        }
      }
    } else if (square.x < newSquare.x - 5) {
      // Newsquare is right
      for (Wall wall : grid.walls) {
        if (wall.x - newSquare.x < 5 && wall.x - newSquare.x > -5) {
          // Wall top corner between squares (x) check y
          if (wall.y - newSquare.y < 5 && wall.y - newSquare.y > -5) {
            if (wall.h > 0) {
              return true;
            }
          }
        }
      }
    } else if (square.y > newSquare.y + 5) {
      // Newsqaure is above
      for (Wall wall : grid.walls) {
        if (wall.x - square.x < 5 && wall.x - square.x > -5) {
          // Wall left corner between squares, check right corner
          if (wall.y - square.y < 5 && wall.y - square.y > -5) {
            if (wall.w > 0) {
              return true;
            }
          }
        }
      }
    } else {
      // Newsquare is below
      for (Wall wall : grid.walls) {
        if (wall.x - newSquare.x < 5 && wall.x - newSquare.x > -5) {
          // Wall left corner between squares, check right corner
          if (wall.y - newSquare.y < 5 && wall.y - newSquare.y > -5) {
            if (wall.w > 0) {
              return true;
            }
          }
        }
      }
    }
    
    return false;
  }
  
  ArrayList<Square> getDiscoveredSquares() {
    return discoveredSquares;
  }
  
  boolean isDone() {
    return done;
  }
  
  void reset() {
    discoveredSquares = new ArrayList<Square>();
    squares = new ArrayList<Square>();
  }
  
  ArrayList<Square> getShortestPath() {
    ArrayList<Square> shortestPath = new ArrayList<Square>();
    
    Square currentSquare = winnerSquare;
    while (currentSquare.value != 1) {
      currentSquare = currentSquare.papa;
      shortestPath.add(currentSquare);
    }
    
    return shortestPath;
  }
}
