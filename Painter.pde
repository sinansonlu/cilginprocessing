PImage img; // girdi resim için kullanılacak
PImage yeni; // çıktı resim için kullanılacak

float kat; // resimlerin ekrana sığması için kaç kat küçültüleceğini belirleyecek
int bosluk; // resmin dikey olarak ortalanması için ne kadar kaydırılması gerektiğini belirleyecek

float sure = 0f;

float k_sure = 0f;

void setup() {
  size(1200, 600, P2D); // size metodu değişken ile çağrılamadığı için ekran boyutunu doğrudan giriyoruz
  img = loadImage("in.jpg"); // girdi resim proje klasöründe in.jpg olarak bulunacak

  // girdi resim üzerinden kat ve boşluk hesabı
  kat = float(600) / float(img.width);
  bosluk = int((600 - (float(img.height) * kat)) / 2);

  // yeni resim girdi ile aynı boyutta olacak
  yeni = createImage(img.width, img.height, RGB);

  // girdi resmin pikselleri pixels[] array'ine taşınır, pikselleri okumak için kullanacağız
  // img'nin piksel değerleri program sırasında değiştirilmeyecek
  img.loadPixels();
}

void draw() {
  if (keyPressed) {
    if (key == 'd' || key == 'D') {
      boyut += 1;
    } else if (key == 'a' || key == 'A') {
      boyut -= 1;
      if (boyut < 0) boyut = 0;
    } else if (key == 'w' || key == 'W') {
      mesafe += 1;
    } else if (key == 's' || key == 's') {
      mesafe -= 1;
      if (mesafe < 0) mesafe = 0;
    }
  }

  // sayı kadar çiz metodunu çağır, bu metod yeni resmi güncelleyecek
  switch(mod) {
  case 1:
    for (int i = 0; i < sayi; i++) {
      ciz1();
    }
    break;
  case 2:
    sure += 1/frameRate;
    belirle2();
    for (int i = 0; i < sayi; i++) {
      ciz2();
    }
    break;
  case 3:
    sure += 1/frameRate;
    belirle3();
    for (int i = 0; i < sayi; i++) {
      ciz2();
    }
    break;
  }

  // yeni resmin piksellerini pixels[] arrayinden güncelle
  yeni.updatePixels();

  background(0);

  // resimleri doğru boyutta dikey ortalanmış olarak çiziyoruz, resmin yatay olduğunu varsaydık
  image(img, 0, bosluk, img.width * kat, img.height * kat);
  image(yeni, 600, bosluk, img.width * kat, img.height * kat);

  text("Mod : " + mod + " - Sayı: " + sayi + " - Boyut: " + boyut + " - Mesafe: " + mesafe + " - Süre: " + sure, 10, 20);
  if (k_sure > 0) {
    text("kayit_" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".jpg", 10, 36);
    k_sure -=  1/frameRate;
  }
}

int sayi = 1; // bir frame'de kaç defa çizeceğimizi belirleyecek

void ciz1() {
  int k = int(random(img.pixels.length));
  yeni.pixels[k] = img.pixels[k];
}

int w, h, s;
int[] firca;

void belirle3() {
  w = boyut;
  h = boyut;
  s = mesafe;

  int yc = w;
  if (yc > h) yc = h;
  yc /= 2;

  firca = new int[w*h];

  for (int i = 0; i < firca.length; i++) {
    int x = i % w;
    int y = i / w;

    float d = sqrt(pow(w/2 - x, 2) + pow(h/2 - y, 2)); 

    float m = sqrt(pow(w/2, 2) + pow(h/2, 2));

    float r = 1 - (random(d) / m);

    if (r > 0.8 && d <= yc) {
      firca[i] = 1;
    } else {
      firca[i] = 0;
    }
  }
}

void belirle2() {
  s = int(int(30 - sure) * 2f);
  if (s <= 1) s = 1;

  w = s + int(random(s/5));
  h = s + int(random(s/5));

  int yc = w;
  if (yc > h) yc = h;
  yc /= 2;

  firca = new int[w*h];

  for (int i = 0; i < firca.length; i++) {
    int x = i % w;
    int y = i / w;

    float d = sqrt(pow(w/2 - x, 2) + pow(h/2 - y, 2)); 

    float m = sqrt(pow(w/2, 2) + pow(h/2, 2));

    float r = 1 - (random(d) / m);

    if (r > 0.8 && d <= yc) {
      firca[i] = 1;
    } else {
      firca[i] = 0;
    }
  }
}

void ciz2() {
  int ss = s * 3;

  int x1 = int(random(img.width));
  int y1 = int(random(img.height));

  int dx = int(random(ss * 2)) - ss;
  int dy = int(random(ss * 2)) - ss;

  int x2 = x1 + dx;
  int y2 = y1 + dy;

  if (x2 < 0) x2 = 0;
  if (y2 < 0) y2 = 0;
  if (x2 >= img.width) x2 = img.width - 1;
  if (y2 >= img.height) y2 = img.height - 1;

  color c1 = img.pixels[y1 * img.width + x1];
  color c2 = img.pixels[y2 * img.width + x2];

  for (float t = 0; t <= 1; t += 0.01f) {
    int x = int(lerp(x1, x2, t));
    int y = int(lerp(y1, y2, t));

    color c = lerpColor(c1, c2, t);

    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        int ii = x + i - w/2; 
        int jj = y + j - h/2; 
        if ( (ii > 0 && ii < img.width && jj > 0 && jj < img.height) && firca[j * w + i] == 1) {
          yeni.pixels[jj * img.width + ii] = c;
        }
      }
    }
  }
}

int mod = 3; 
int boyut = 50;
int mesafe = 50;

void keyPressed() {
  if (keyCode == LEFT) {
    mod--;
  } else if (keyCode == RIGHT) {
    mod++;
  } else if (keyCode == UP) {
    sayi += 10;
  } else if (keyCode == DOWN) {
    sayi -= 10;
  } else if (keyCode == ENTER) {
    yeni.save("kayit_" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + ".jpg");
    k_sure = 2f;
  }
}
