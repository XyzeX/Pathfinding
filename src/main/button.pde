class Button {
  private int x, y, w, h;
  private PImage img, resizedImg;
  private int animation = 0, lastAnimation = 0;
  
  Button(int x, int y, int w, int h, PImage img) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.img = img;
    this.img.resize(w, h);
    this.resizedImg = this.img.copy();
  }
  
  void draw() {
    rect(x - w / 2 - animation / 2, y - h / 2 - animation / 2, w + animation, h + animation);
    
    if (isHovering()) {
      if (animation < 10) {
        animation += 1;
      }
    } else {
      if (animation > 0) {
        animation -= 1;
      }
    }
    
    if (animation != lastAnimation) {
      resizedImg = img.copy();
      resizedImg.resize(w + animation, h + animation);
    }
    
    image(resizedImg, x - w / 2 - animation / 2, y - h / 2 - animation / 2);
  }
  
  boolean isHovering() {
    return mouseX >= x - w / 2 && mouseX <= x + w / 2 && mouseY >= y - h / 2 && mouseY <= y + h / 2;
  }
}
