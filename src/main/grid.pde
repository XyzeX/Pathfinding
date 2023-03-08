class Grid {
  private boolean saveWall = false;
  private int x, y, w, h;
  private final int[] DIM;
  private ArrayList<PVector> walls = new ArrayList<PVector>();
  
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
    
    float lineY = -y;
    float lineX = -x;
    float yToWall = 0;
    float xToWall = 0;
    
    strokeWeight(1);
    for (int i = 0; i < DIM[0]; i++) {
      final float y_ = y + i * h / DIM[1];
      line(x, y_, x + w, y_);
      
      if (lineY == -y && mouseX >= x && mouseX <= x + w && mouseY > y && mouseY < y_ + (h / DIM[1]) / 2) {
        lineY = y_;
        yToWall = mouseY - y_;
      }
    }
    for (int i = 0; i < DIM[1]; i++) {
      final float x_ = x + i * w / DIM[0];
      line(x_, y, x_, y + h);
      
      if (lineX == -x && lineY != -y && mouseX > x && mouseX < x_) {
        lineX = x_ - w / DIM[0];
        xToWall = mouseX - (x_ - w / DIM[0]);
      }
    }
    
    strokeWeight(4);
    for (PVector wall : walls) {
      line(wall.x, wall.y, wall.x + w / DIM[0], wall.y);
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
        text("LINE MOVED RIGHT", 10, 200);
        lineX += w / DIM[0];
        if (yToWall > h / DIM[1]) {
          lineY -= h / DIM[1];
        }
      }
    }
    
    if (yToWall < xToWall) {
      line(lineX, lineY, lineX + w / DIM[0], lineY);
    } else {
      line(lineX, lineY, lineX, lineY + h / DIM[1]);
    }
    
    if (saveWall) {
      saveWall = false;
      final PVector wall = new PVector(lineX, lineY);
      walls.add(wall);
    }
    
    text(xToWall, 10, 10);
    text(yToWall, 10, 100);
  }
  
  void drawWall() {
    saveWall = true;
  }
}
