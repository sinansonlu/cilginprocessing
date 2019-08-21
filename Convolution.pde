PImage res_o;
PImage res_d1, res_d2, res_d3;

boolean sbKullan = false;

float[][] ker1 = {{-1, -1, -1}, {2, 2, 2}, {-1, -1, -1}};
float[][] ker2 = {{0.0625f, 0.125f, 0.0625f}, {0.125f, 0.25f, 0.125f}, {0.0625f, 0.125f, 0.0625f}};
float[][] ker3 = {{1f/273f, 4f/273f, 7f/273f, 4f/273f, 1f/273f}, 
  {4f/273f, 16f/273f, 26f/273f, 16f/273f, 4f/273f}, 
  {7f/273f, 26f/273f, 41f/273f, 26f/273f, 7f/273f}, 
  {4f/273f, 16f/273f, 26f/273f, 16f/273f, 4f/273f}, 
  {1f/273f, 4f/273f, 7f/273f, 4f/273f, 1f/273f}};

void setup() {
  size(1600, 533, P2D);
  res_o = loadImage("res.jpg", "jpg");

  res_d1 = createImage(res_o.width, res_o.height, RGB);
  res_d2 = createImage(res_o.width, res_o.height, RGB);
  res_d3 = createImage(res_o.width, res_o.height, RGB);

  isle();
}

void draw() {
  background(0);
  image(res_o, 0, 0);

  // sağdaki resmi çiz
  if (secim == 0) {
    image(res_o, res_o.width, 0);
  } else if (secim == 1) {
    image(res_d1, res_o.width, 0);
  } else if (secim == 2) {
    image(res_d2, res_o.width, 0);
  } else if (secim == 3) {
    image(res_d3, res_o.width, 0);
  }
}

void isle() {
  conv(ker1, 3, res_d1);
  conv(ker2, 3, res_d2);
  conv(ker3, 5, res_d3);
}

int secim = 0;

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      secim = 0;
    } else if (keyCode == RIGHT) {
      secim = 1;
    } else if (keyCode == DOWN) {
      secim = 2;
    } else if (keyCode == LEFT) {
      secim = 3;
    }
  }

  if (keyCode == ENTER) {      
    sbKullan = !sbKullan;
    isle();
  }
}

void conv(float[][] ker, int kx, PImage res_d) {
  res_o.loadPixels();
  res_d.loadPixels();
  for (int i = 0; i < res_o.width; i++) {
    for (int j = 0; j < res_o.height; j++) {
      if (i - kx/2 > 0 && i + kx/2 < res_o.width && j - kx/2 > 0 && j + kx/2 < res_o.height) {
        // bu conv için uygun bir piksel (komşuları sınır dışı değil)
        res_d.pixels[pixIn(i, j, res_d.width)] = komsu(i, j, ker, kx);
      } else {
        // sınır dışıysa siyah yap
        res_d.pixels[pixIn(i, j, res_d.width)] = color(0);
      }
    }
  }
  res_d.updatePixels();
}

color komsu(int x, int y, float[][] ker, int kx) {
  float toplamR = 0;
  float toplamG = 0;
  float toplamB = 0;

  for (int i = -kx/2; i <= kx/2; i++) {
    for (int j = -kx/2; j <= kx/2; j++) {
      if (sbKullan) {
        toplamR += brightness(res_o.pixels[pixIn(x + i, y + j, res_o.width)]) * ker[j+kx/2][i+kx/2];
      } else {
        toplamR += red(res_o.pixels[pixIn(x + i, y + j, res_o.width)]) * ker[j+kx/2][i+kx/2];
        toplamG += green(res_o.pixels[pixIn(x + i, y + j, res_o.width)]) * ker[j+kx/2][i+kx/2];
        toplamB += blue(res_o.pixels[pixIn(x + i, y + j, res_o.width)]) * ker[j+kx/2][i+kx/2];
      }
    }
  }
  if (sbKullan) {
    return color(toplamR);
  } else {
    return color(toplamR, toplamG, toplamB);
  }
}

int pixIn(int x, int y, int w) {
  return (y * w) + x;
}
