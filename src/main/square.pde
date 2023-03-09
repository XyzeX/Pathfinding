class Square {
  float x, y;
  int value;
  Square papa;
  
  Square(float x, float y, int value) {
    this.x = x;
    this.y = y;
    this.value = value;
  }
  
  Square(float x, float y, int value, Square papa) {
    this.x = x;
    this.y = y;
    this.value = value;
    this.papa = papa;
  }
  
  void draw(float w, float h, int[] DIM, color c) {
    if (value == 0) {
      return;
    }
    fill(c);
    rect(x, y, w / DIM[0], h / DIM[1]);
    
    fill(0);
    text(value, x + (w / DIM[0]) / 2, y + (h / DIM[1]) / 2);
  }
}
