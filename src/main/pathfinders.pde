class Pathfinder {
  private Grid grid;
  private ArrayList<PVector> squares = new ArrayList<PVector>();
  private ArrayList<PVector> discoveredSquares = new ArrayList<PVector>();
  private boolean done = false;
  
  Pathfinder(Grid grid) {
    this.grid = grid;
  }
  
  void start() {
    squares.add(grid.startPos);
    
    // Loop while not all squares have been covered or breaking out by finding finish
    while (squares.size() > 0) {
      ArrayList<PVector> newSquares = new ArrayList<PVector>();
      
      // Loop through all squares and finds adjacent squares
      for (PVector square : squares) {
        for (PVector newSquare : findAdjacentSquares(square)) {
          if (newSquare == grid.finishPos) {
            done = true;
            break;
          }
          if (isNewSquare(newSquare)) {
            newSquares.add(newSquare);
          }
        }
      }
    }
    // findAdjacentSquares() for all uncovered squares
    // Add them to list of uncovered squares
    // Check for finish
    // Add 1 and write it on them
  }
  
  ArrayList<PVector> findAdjacentSquares(PVector Square) {
    ArrayList<PVector> adjacentSquares = new ArrayList<PVector>();
    
    for (int i = 0; i < grid.DIM[0] + 1; i++) {
      final float y = grid.y + i * grid.h / grid.DIM[1];
    }
    for (int i = 0; i < grid.DIM[1] + 1; i++) {
      final float x = grid.x + i * grid.w / grid.DIM[0];
    }
    
    return adjacentSquares;
  }
  
  boolean isNewSquare(PVector _square) {
    for (PVector square : discoveredSquares) {
      if (square == _square) {
        return false;
      }
    }
    
    for (PVector square : squares) {
      if (square == _square) {
        return false;
      }
    }
    return true;
  }
}
