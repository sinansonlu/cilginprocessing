// modlar
int mod = 0; // 1 - hareket ettir, 2 - cizim yapilmakta

int x;
int y;
PImage img;
PImage palet;

int mx;
int my;
float faktor = 1;

color c = color(0);

void setup() {
  size(700, 700, P2D);
  img = createImage(1920, 1080, RGB);
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    img.pixels[i] = #FFFFFF;
  }
  img.updatePixels();

  palet = createImage(250, 250, RGB);
  palet.loadPixels();
  for (int i = 0; i < palet.width; i++) {
    for (int j = 0; j < palet.height; j++) {
      color k = color(0, 0, 0);
      
      
      
      palet.set(i, j, hslToRgb(atan2(float(i)-125,float(j)-125)/6.28, 
        1, sqrt(pow(float(i)-125,2) + pow(float(j)-125,2)) / 125));
    }
  }
  palet.updatePixels();
}

void draw() {
  colorMode(HSB, 360, 100, 100);

  background(150);
  image(img, x, y, img.width*faktor, img.height*faktor);
  image(palet, width-palet.width, height-palet.height, palet.width, palet.height);
}

void mouseDragged() {
  if (mod == 1) {
    x += mouseX - mx;
    y += mouseY - my;
    mx = mouseX;
    my = mouseY;
  } else if (mod == 2) {
    img.loadPixels();
    for (int i = -10; i < 11; i++) {
      for (int j = -10; j < 11; j++) {
        img.set(int((mouseX-x)/faktor)+i, int((mouseY-y)/faktor)+j, c);
      }
    }
    img.updatePixels();
  }
}

void mousePressed() {
  if (mouseButton == LEFT && mouseX > width-palet.width && mouseY > height-palet.height) {
    c = palet.get(mouseX-(width-palet.width), mouseY-(height-palet.height));
  } else if (mouseButton == RIGHT) {
    mod = 1;
    mx = mouseX;
    my = mouseY;
  } else if (mouseButton == LEFT) {
    mod = 2;
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    mod = 0;
  } else if (mouseButton == LEFT) {
    mod = 0;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  faktor -= e / 20;
}

color hslToRgb(float h, float s, float l) {
  float r, g, b;

  if (s == 0f) {
    r = g = b = l; // achromatic
  } else {
    float q = l < 0.5f ? l * (1 + s) : l + s - l * s;
    float p = 2 * l - q;
    r = hueToRgb(p, q, h + 1f/3f);
    g = hueToRgb(p, q, h);
    b = hueToRgb(p, q, h - 1f/3f);
  }
  return color(to255(r), to255(g), to255(b));
}

int to255(float v) { 
  return (int)Math.min(255, 256*v);
}

float hueToRgb(float p, float q, float t) {
  if (t < 0f)
    t += 1f;
  if (t > 1f)
    t -= 1f;
  if (t < 1f/6f)
    return p + (q - p) * 6f * t;
  if (t < 1f/2f)
    return q;
  if (t < 2f/3f)
    return p + (q - p) * (2f/3f - t) * 6f;
  return p;
}
