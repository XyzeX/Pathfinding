class Grid {
  private boolean clicked = false, started = false;
  private int state = 0;
  private int x, y, w, h;
  private int animation;
  private final int[] DIM;
  private ArrayList<Wall> walls = new ArrayList<Wall>();
  private PImage startImg, finishImg, NPCImage;
  private PVector startPos = new PVector(-2000, -2000), finishPos = new PVector(-2000, -2000);
  private Pathfinder pathfinder;
  private int startFrame, animationFrame = -1;
  
  Grid (int x, int y, int w, int h, int[] DIM) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.DIM = DIM;
  }
  
  void draw() {
    stroke(0);
    strokeWeight(16);
    rect(x - 8, y - 8, w + 16, h + 16);
    text(state, width / 2, 50);
    
    image(startImg, startPos.x, startPos.y);
    image(finishImg, finishPos.x, finishPos.y);
    
    strokeWeight(1);
    for (int i = 0; i < DIM[0] + 1; i++) {
      final float _y = y + i * h / DIM[1];
      line(x, _y, x + w, _y);
    }
    for (int i = 0; i < DIM[1] + 1; i++) {
      final float _x = x + i * w / DIM[0];
      line(_x, y, _x, y + h);
    }
    
    if (started) {
      if (pathfinder.isDone()) {
        started = false;
      } else if ((frameCount - startFrame) % 10 == 0) {
        pathfinder.next();
      }
      for (Square square : pathfinder.getDiscoveredSquares()) {
        square.draw(w, h, DIM, #00FF00);
      }
      fill(255);
    } else if (pathfinder != null) {
      if (pathfinder.isDone()) {
        for (Square square : pathfinder.getDiscoveredSquares()) {
          square.draw(w, h, DIM, #FF0000);
        }
        
        if ((frameCount - animationFrame) % 20 == 0) {
          animation--;
        }
        
        ArrayList<Square> shortestPath = pathfinder.getShortestPath();
        
        if (animation < 0) {
          animation = shortestPath.size() + 1;
        }
        
        for (int i = shortestPath.size() - 1; i >= 0; i--) {
          Square square = shortestPath.get(i);
          square.draw(w, h, DIM, #00FF00);
          if (i == animation) {
            image(NPCImage, square.x, square.y);
          }
        }
        fill(255);
      }
    }
    
    strokeWeight(4);
    stroke(0, 0, 255);
    for (Wall wall : walls) {
      wall.draw();
    }
    stroke(0);
    
    if (started) {
      return;
    }
    
    if (state == 1) {
      makeLine();
    } else if (state == 2) {
      removeLine();
    } else if (state == 3) {
      makeStart();
    } else if (state == 4) {
      makeFinish();
    }
    clicked = false;
  }
  
  void start() {
    startFrame = frameCount;
    started = true;
    state = 0;
    pathfinder = new Pathfinder(this);
  }
  
  void clicked() {
    clicked = true;
  }
  
  void makeLine() {
    float[] line = findClosestLine();
    final float lineX = line[0];
    final float lineY = line[1];
    final float _w = line[2];
    final float _h = line[3];
    
    line(lineX, lineY, lineX + _w, lineY + _h);
    
    if (clicked) {
      final Wall wall = new Wall(lineX, lineY, _w, _h);
      for (int i = 0; i < walls.size(); i++) {
        if (walls.get(i).compare(wall.x, wall.y, wall.w, wall.h)) {
          break;
        } else if (i == walls.size() - 1) {
          walls.add(wall);
        }
      }
      if (walls.size() == 0) {
        walls.add(wall);
      }
    }
  }
  
  void removeLine() {
    float[] line = findClosestLine();
    final float lineX = line[0];
    final float lineY = line[1];
    final float _w = line[2];
    final float _h = line[3];
    
    for (int i = 0; i < walls.size(); i++) {
      if (walls.get(i).compare(lineX, lineY, _w, _h)) {
        if (clicked) {
          walls.remove(i);
          return;
        }
        stroke(255, 0, 0);
        line(lineX, lineY, lineX + _w, lineY + _h);
        stroke(0);
      }
    }
  }
  
  void makeStart() {
    final float[] corner = findClosestCorner();
    final float cornerX = corner[0];
    final float cornerY = corner[1];
    
    image(startImg, cornerX + 1, cornerY + 1);
    if (clicked) {
      startPos.x = cornerX + 1;
      startPos.y = cornerY + 1;
    }
  }
  
  void makeFinish() {
    final float[] corner = findClosestCorner();
    final float cornerX = corner[0];
    final float cornerY = corner[1];
    
    image(finishImg, cornerX + 1, cornerY + 1);
    if (clicked) {
      finishPos.x = cornerX + 1;
      finishPos.y = cornerY + 1;
    }
  }
  
  float[] findClosestCorner() {
    float cornerY = -y;
    float cornerX = -x;
    
    for (int i = 0; i < DIM[0] + 1; i++) {
      final float _y = y + i * h / DIM[1];
      
      if (cornerY == -y && mouseX >= x && mouseX <= x + w && mouseY > y && mouseY < _y) {
        cornerY = _y - h / DIM[1];
      }
    }
    for (int i = 0; i < DIM[1] + 1; i++) {
      final float _x = x + i * w / DIM[0];
      
      if (cornerX == -x && cornerY != -y && mouseX > x && mouseX < _x) {
        cornerX = _x - w / DIM[0];
      }
    }
    float[] result = new float[2];
    result[0] = cornerX;
    result[1] = cornerY;
    return result;
  }
  
  float[] findClosestLine() {
    float lineY = -y;
    float lineX = -x;
    float yToWall = 0;
    float xToWall = 0;
    
    for (int i = 0; i < DIM[0] + 1; i++) {
      final float _y = y + i * h / DIM[1];
      
      if (lineY == -y && mouseX >= x && mouseX <= x + w && mouseY > y && mouseY < _y + (h / DIM[1]) / 2) {
        lineY = _y;
        yToWall = mouseY - _y;
      }
    }
    for (int i = 0; i < DIM[1] + 1; i++) {
      final float _x = x + i * w / DIM[0];
      
      if (lineX == -x && lineY != -y && mouseX > x && mouseX < _x) {
        lineX = _x - w / DIM[0];
        xToWall = mouseX - (_x - w / DIM[0]);
      }
    }
    
    if (yToWall < 0) {
      yToWall *= -1;
      if (yToWall >= xToWall) {
        lineY -= h / DIM[1];
      }
    }
    if (xToWall > (w / DIM[0]) / 2) {
      xToWall -= (w / DIM[0]) / 2;
      xToWall = (w / DIM[0]) / 2 - xToWall;
      if (xToWall <= yToWall) {
        lineX += w / DIM[0];
        if (mouseY - lineY < 0) {
          lineY -= h / DIM[1];
        }
      }
    }
    
    float _w = 0;
    float _h = 0;
    if (yToWall < xToWall) {
      _w = w / DIM[0];
    } else {
      _h = h / DIM[1];
    }
    
    final float[] result = new float[4];
    result[0] = lineX;
    result[1] = lineY;
    result[2] = _w;
    result[3] = _h;
    return result;
  }
  
  void setState(int newState) {
    state = newState;
  }
  
  int getState() {
    return state;
  }
  
  void setFinishImg(PImage img) {
    finishImg = img.copy();
    finishImg.resize(w / DIM[0] - 1, h / DIM[1] - 1);
  }
  
  void setStartImg(PImage img) {
    startImg = img.copy();
    startImg.resize(w / DIM[0] - 1, h / DIM[1] - 1);
  }
  
  void setNPC(PImage img) {
    NPCImage = img;
    NPCImage.resize(w / DIM[0] - 50, h / DIM[1] - 1);
  }
  
  boolean isReady() {
    if (startPos.x >= x && startPos.y >= y && finishPos.x >= x && finishPos.y >= y) {
      return !(startPos.x == finishPos.x && startPos.y == finishPos.y);
    }
    return false;
  }
  
  void resetPath() {
    started = false;
    pathfinder.reset();
  }
  
  void setAnimationFrame() {
    animationFrame = frameCount;
    animation = -1;
  }
}
