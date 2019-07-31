import processing.video.*;

Capture kamera;

float[][] grid;
color[][] cgrid;

int f = 1;
int ff;
int gx = 320/f;
int gy = 240/f;
int kxm = 640;
int kym = 480;
float d = 6;

float der = 100;

boolean ort = true;

void setup() {
  size(1600, 900, P3D);
  grid = new float[gx][gy];
  cgrid = new color[gx][gy];

  kamera = new Capture(this, 640, 480);
  kamera.start();
}

void draw() {
  background(0);
  camera(width/4.0, (height/8.0), (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  pointLight(255, 255, 255, width/2, -20, height/2);
  ff = f * f;

  if (kamera.available()) {
    kamera.read();
    kamera.loadPixels();
    for (int i = 0; i < gx-1; i++) {
      for (int j = 0; j < gy-1; j++) {
        int kx = int(i * f * 2);
        int ky = int(j * f * 2);
        if (ort) {
          float v = 0;
          float _r = 0;
          float _g = 0;
          float _b = 0;
          for (int ki = 0; ki < f; ki++) {
            for (int kj = 0; kj < f; kj++) {
              v += brightness(kamera.pixels[kx + ki + (ky + kj) * kxm]);
              color c = kamera.pixels[kx + ky * kxm];
              _r += red(c);
              _g += green(c);
              _b += blue(c);
            }
          }
          v /= ff;
          _r /= ff;
          _g /= ff;
          _b /= ff;
          grid[i][j] = map(v, 0, 255, 0, der);
          cgrid[i][j] = color(_r,_g,_b);
        } else {
          grid[i][j] = map(brightness(kamera.pixels[kx + ky * kxm]), 0, 255, 0, der);
          cgrid[i][j] = kamera.pixels[kx + ky * kxm];
        }
      }
    }
  }

  noStroke();
  translate(width/2 - (gx * d) / 2, height/2 - (gy * d) / 2, 0);

  for (int i = 0; i < gx-1; i++) {
    for (int j = 0; j < gy-1; j++) {
      // ilk üçgen
      beginShape();
      fill(cgrid[i+1][j]);
      vertex(d * (i+1), d * j, grid[i+1][j]);
      fill(cgrid[i][j]);
      vertex(d * i, d * j, grid[i][j]);
      fill(cgrid[i][j+1]);
      vertex(d * i, d * (j + 1), grid[i][j+1]);
      endShape();

      // ikinci üçgen
      beginShape();
      fill(cgrid[i][j+1]);
      vertex(d * i, d * (j + 1), grid[i][j+1]);
      fill(cgrid[i+1][j+1]);
      vertex(d * (i + 1), d * (j + 1), grid[i+1][j+1]);
      fill(cgrid[i+1][j]);
      vertex(d * (i+1), d * j, grid[i+1][j]);
      endShape();
    }
  }
}

void keyPressed() {
  ort = !ort;
  println(ort);
}
