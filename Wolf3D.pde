float px = 50;
float py = 50;
float pa = radians(45);

float px2;
float py2;

float aHiz = 0.1f;

float[] d1x;
float[] d1y;
float[] d2x;
float[] d2y;

int d_max = 100;
int d_cizMax = 0;
int d_boyut = 0;

float c1x;
float c1y;
float c2x;
float c2y;

float duvarUzaklik[];
color renklerDuvar[];
color renkler[];

void setup() {
  size(1600, 800, P2D);

  d1x = new float[d_max];
  d1y = new float[d_max];
  d2x = new float[d_max];
  d2y = new float[d_max];
  renklerDuvar = new color[d_max];

  duvarUzaklik = new float[isinSayisi];
  renkler = new color[isinSayisi];
}

boolean basA, basS, basD, basW;

void keyPressed()
{
  if (key=='a')
    basA=true;
  if (key=='s')
    basS=true;
  if (key=='d')
    basD=true;
  if (key=='w')
    basW=true;
}

void keyReleased()
{
  if (key=='a')
    basA=false;
  if (key=='s')
    basS=false;
  if (key=='d')
    basD=false;
  if (key=='w')
    basW=false;
} 

void mousePressed() {
  c1x = mouseX;
  c1y = mouseY;
  c2x = mouseX;
  c2y = mouseY;
}

void mouseReleased() {
  c2x = mouseX;
  c2y = mouseY;

  d1x[d_boyut] = c1x;
  d1y[d_boyut] = c1y;
  d2x[d_boyut] = c2x;
  d2y[d_boyut] = c2y;
  renklerDuvar[d_boyut] = color( random(255), random(255), random(255), 255); 

  d_boyut = (d_boyut + 1) % d_max;

  d_cizMax = d_cizMax + 1;
  if (d_cizMax > d_max) d_cizMax = d_max;
}

int isinSayisi = 50;
float gorusAcisi = 50;
float gorusInc, gorusAcisiYari, ekranYarX, ekranYarY;

color enYakC;
float enYak, uzaklik, enRX, enRY;
boolean enVar;

float sahteW, sahteH;

void draw() {
  // kontrol mantığı
  if (keyPressed) {
    if (basA) {
      pa -= aHiz;
    } else if (basD) {
      pa += aHiz;
    }

    if (basW) {
      px += cos(pa);
      py += sin(pa);
    } else if (basS) {
      px -= cos(pa);
      py -= sin(pa);
    }

    if (key == '1') {
      isinSayisi -= 1;
      duvarUzaklik = new float[isinSayisi];
      renkler = new color[isinSayisi];
    } else if (key == '2') {
      isinSayisi += 1;
      duvarUzaklik = new float[isinSayisi];
      renkler = new color[isinSayisi];
    } else if (key == '3') {
      gorusAcisi -= 1;
    } else if (key == '4') {
      gorusAcisi += 1;
    }
  }

  // arkaplanı çiz
  background(255);
  stroke(0);
  // harita duvarları
  for (int i = 0; i < d_cizMax; i++) {
    stroke(renklerDuvar[i]);
    line(d1x[i], d1y[i], d2x[i], d2y[i]);
  }
  stroke(0);

  px2 = px + 10 * cos(pa);
  py2 = py + 10 * sin(pa);
  line(px, py, px2, py2);

  ekranYarX = (width / 2);
  ekranYarY = (height / 2);

  sahteW = ekranYarX / isinSayisi;
  gorusInc = gorusAcisi / isinSayisi;
  gorusAcisiYari = gorusAcisi / 2;

  for (int j = 0; j < isinSayisi; j++) {
    // isinin acisi hesapla
    px2 = px + 10 * cos(pa + radians(gorusInc * j - gorusAcisiYari));
    py2 = py + 10 * sin(pa + radians(gorusInc * j - gorusAcisiYari));

    // yakınları sıfırla
    enYak = 100000;
    enYakC = color(0, 0, 0, 255);
    enRX = 0;
    enRY = 0;
    enVar = false;

    for (int i = 0; i < d_cizMax; i++) {
      if (yolla(d1x[i], d1y[i], d2x[i], d2y[i], px, py, px2, py2)) {
        uzaklik = sqrt(pow(px-rx, 2)+pow(py-ry, 2));
        if (uzaklik <= enYak) {
          enYak = uzaklik;
          enRX = rx;
          enRY = ry;
          enVar = true;
          enYakC = renklerDuvar[i];
        }
      }
    }

    if (enVar) {
      // isini ciz
      stroke(enYakC);
      line(px, py, enRX, enRY);
    }

    // duvar uzakliğini kaydet
    duvarUzaklik[j] = enYak * cos(radians(gorusInc * j - gorusAcisiYari));
    renkler[j] = enYakC;
  }

  // sahte arka çiz
  noStroke();
  fill(#BAF0E9);
  rect(ekranYarX, 0, ekranYarX, ekranYarY);
  fill(#303C48);
  rect(ekranYarX, ekranYarY, ekranYarX, ekranYarY);

  // sahte 3d çiz
  for (int j = 0; j < isinSayisi; j++) {
    sahteH = 30000/duvarUzaklik[j];
    fill(lerpColor(renkler[j], color(0), 1-sahteH/400));
    rect(ekranYarX+j*sahteW, (height-sahteH)/2, sahteW, sahteH);
  }

  if (mousePressed) {
    line(c1x, c1y, mouseX, mouseY);
  }

  stroke(0);
  text("Işın Sayısı: " + isinSayisi, 20, 20);
  text("Görüş Açısı: " + gorusAcisi, 20, 40);
}

float rx, ry;
float bolen, t, u;
boolean yolla(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
  bolen = ((x1-x2) * (y3-y4)) - ((y1-y2)*(x3-x4));
  if (bolen == 0) {
    return false;
  }
  t = (((x1-x3)*(y3-y4))-((y1-y3)*(x3-x4)))/bolen;
  u = -(((x1-x2)*(y1-y3))-((y1-y2)*(x1-x3)))/bolen;
  if (0<=t && t<=1 && 0<=u) {
    rx = x1 + t * (x2-x1);
    ry = y1 + t * (y2-y1); 
    return true;
  } else {
    return false;
  }
}
