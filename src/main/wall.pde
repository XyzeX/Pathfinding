class Wall {
  private float x, y, w, h;
  
  Wall(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void draw() {
    line(x, y, x + w, y + h);
  }
  
  boolean compare(float x, float y, float w, float h) {
    if (this.x - x < 5 && this.x - x > -5 && this.y - y < 5 && this.y - y > -5) {
      return this.w - w < 5 && this.w - w > -5 && this.h - h < 5 && this.h - h > -5;
    }
    return false;
  }
}
