Button[] buttons = new Button[4];
Grid grid;
boolean pathfinding = false;

PImage[] img = new PImage[4];

void setup() {
  fullScreen();
  textSize(32);
  img[0] = loadImage("data/line.png");
  img[1] = loadImage("data/eraser.png");
  img[2] = loadImage("data/start.png");
  img[3] = loadImage("data/end.png");
  
  int[] DIM = {10, 10};
  grid = new Grid(width / 10, height / 10, width - width / 5, height - height / 5, DIM);
  grid.setStartImg(img[2]);
  grid.setFinishImg(img[3]);
  for (int i = 0; i < buttons.length; i++) {
    buttons[i] = new Button(width / 20, height / 10 + width / 15 * i, width / 20, width / 20, img[i]);
  }
}

void draw() {
  background(69);
  text(pathfinding ? "Pathfinding" : "Waiting", width / 2 + 100, 50);
  
  grid.draw();
  for (Button button : buttons) {
    button.draw();
  }
}

void mouseClicked() {
  grid.clicked();
  
  for (int i = 0; i < buttons.length; i++) {
    if (buttons[i].isHovering()) {
      if (grid.getState() == i + 1) {
        grid.setState(0);
      } else {
        grid.setState(i + 1);
      }
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    if (grid.isReady()) {
      pathfinding = !pathfinding;
      grid.start();
    }
  }
}
