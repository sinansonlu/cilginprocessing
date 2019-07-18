import processing.video.*;

Capture kamera;
PImage goruntu;

color[] gbRenk = { color(15, 56, 15), color(48, 98, 48), color(139, 172, 15), color(155, 188, 15)};

void setup() {
  size(1024, 1024);

  kamera = new Capture(this, 320, 240);
  kamera.start();

  goruntu = createImage(128, 128, RGB);
}

void draw() {
  if (kamera.available()) {
    kamera.read();
    kamera.loadPixels();

    for (int x = 0; x < 128; x++) {
      for (int y = 0; y < 128; y++) {
        int i = x + y * 128;
        int kx = int(x * 1.875f);
        int ky = int(y * 1.875f);
        int ki = 40 + kx + ky * 320;
        color renk = kamera.pixels[ki];
        float b = brightness(renk);
        b += random(10);
        renk = color(gbRenk[int(b / 67)]);
        goruntu.pixels[i] = renk;
      }
    }
    //int i = x + y * kamera.width;
    // kamera.pixels[]

    goruntu.updatePixels();
  }
  image(goruntu, 0, 0, 1024, 1024);
}

int kayitSayisi = 2;

void mousePressed() {
  goruntu.save("G" + kayitSayisi + ".jpg");
  kayitSayisi++;
}
