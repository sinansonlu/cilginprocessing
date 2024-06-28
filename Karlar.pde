ArrayList<KarTanesi> karlar = new ArrayList<KarTanesi>();
PImage img = createImage(264, 264, ARGB);

void setup() {
  size(1200, 900, P3D);

  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++) {
    img.pixels[i] = color(random(0, 20), random(50, 110), random(20, 60));
  }
  img.updatePixels();

  for (int i = 0; i < 5000; i++) {
    karlar.add(new KarTanesi());
  }
}

int ara = 65;
int hizUst = 7;

int sinir = 600;

void draw() {
  background(0);
  camera(0, 140, 350, 0, 0, 0, 0, -1, 0);

  img.loadPixels();

  for (int i = 0; i < karlar.size(); i++) {
    karlar.get(i).kendiniCiz();
  }

  noStroke();

  img.updatePixels();
  textureMode(NORMAL);
  beginShape();
  texture(img);
  vertex(-sinir, 0, -sinir, 0, 0);
  vertex(sinir, 0, -sinir, 1, 0);
  vertex(sinir, 0, sinir, 1, 1);
  vertex(-sinir, 0, sinir, 0, 1);
  endShape();
}

class KarTanesi {
  public int x, y, z;
  public int vx, vy, vz;
  public KarTanesi() {
    x = (int) random(-sinir, sinir);
    y = (int) random(height);
    z = (int) random(-sinir, sinir);

    vx = (int) random(-hizUst, hizUst);
    vy = (int) random(-hizUst, 0);
    vz = (int) random(-hizUst, hizUst);
  }

  public void kendiniCiz() {
    strokeWeight((((float)z)/sinir + 1.2) * 5);
    stroke(255);
    point(x, y, z);

    x += vx;
    y += vy;
    z += vz;

    if (z < -sinir || z > sinir || x < -sinir || x > sinir) {
      x = (int) random(-ara*15, ara*15);
      y = (int) random(height);
      z = (int) random(-ara*15, ara*15);

      vx = (int) random(-hizUst, hizUst);
      vy = (int) random(-hizUst, -hizUst/2);
      vz = (int) random(-hizUst, hizUst);
    }

    if (y < 0) {
      int i = (int) ((((float)x/sinir) + 1) * (img.width / 2));
      int j = (int) ((((float)z/sinir) + 1) * (img.height / 2));

      if (i >= img.width) {
        i = img.width - 1;
      }

      if (j >= img.height) {
        j = img.height - 1;
      }

      img.pixels[j * img.width + i] = lerpColor(img.pixels[j * img.width + i], color(255), .1);

      y = (int) random(15*ara);
    }
  }
}
