PImage webImg;
PGraphics pg;

ArrayList<Nokta> noktalar = new ArrayList<Nokta>();
final float YAVASLAMA = 0.01f;
final float BUYUME = 0.1f;
final int NOKTA_SACMA_MIKTARI = 7;

void setup() {
  size(1000, 1000, P2D);
  pg = createGraphics(1000, 1000);
  pg.beginDraw();
  pg.endDraw();

  String url = "https://images.e-flux-systems.com/283237_588943ecc546db7cc5168e868a7848e7.jpg,1920";
  webImg = loadImage(url, "png");
  webImg.resize(1000, 1000);

  webImg.loadPixels();
  rectMode(CENTER);
  ellipseMode(CENTER);
  noStroke();
}

void draw() {
  background(0);
  
  image(pg, 0, 0);
  fill(webImg.pixels[mouseX + mouseY * webImg.width]);
  rect(mouseX, mouseY, 20, 20);
  
  noktalarSac();

  for (int i = 0; i < noktalar.size(); i++) {
    if (noktalar.get(i).hareketEtVeSilelimMi()) {
      Nokta n = noktalar.remove(i);
      pg.beginDraw();
      pg.ellipseMode(CENTER);
      pg.noStroke();
      int ind = (int)(n.x) + (int)(n.y) * webImg.width;
      if (ind >= 0 && ind < webImg.width * webImg.height) {
        pg.fill(webImg.pixels[(int)(n.x) + (int)(n.y) * webImg.width]);
        pg.ellipse(n.x, n.y, n.boyut, n.boyut);
      }
      pg.endDraw();
      i--;
    }
  }

  for (int i = 0; i < noktalar.size(); i++) {
    Nokta n = noktalar.get(i);
    int ind = (int)(n.x) + (int)(n.y) * webImg.width;
    if (ind >= 0 && ind < webImg.width * webImg.height) {
      fill(webImg.pixels[(int)(n.x) + (int)(n.y) * webImg.width]);
      ellipse(n.x, n.y, n.boyut, n.boyut);
    }
  }
}

void noktalarSac() {
  for (int i = 0; i < NOKTA_SACMA_MIKTARI; i++) {
    noktalar.add(new Nokta(mouseX, mouseY));
  }
}

class Nokta {
  public float x, y;
  public float v;
  public float aci;
  public float boyut;

  public Nokta(int x, int y) {
    this.x = x;
    this.y = y;
    v = random(0.1f,4.2f);
    aci = random(6.28f);
    boyut = random(1f, 10f);
  }

  public boolean hareketEtVeSilelimMi() {
    x += v * cos(aci);
    y += v * sin(aci);
    v -= YAVASLAMA;
    boyut += BUYUME;
    if (v <= 0) {
      return true;
    } else {
      return false;
    }
  }
}
