int [][] ornek;
int ornek_gen = 10;
int ornek_yuk = 10;

Hane [][] cikti;
int cikti_gen = 40;
int cikti_yuk = 40;

int renkSayisi = 4;

int cikti_buyukluk = 15;

class Hane {
  public int belirlenmisSayi;

  public float [] olasiliklar;

  public Hane() {
    olasiliklar = new float[renkSayisi];
    belirlenmisSayi = -1;
  }

  public void OlasilikEkle(int i, int m) {
    if (olasiliklar[i] != -1) {
      olasiliklar[i] += m;
    }
  }

  public void OlasiliktanCikar(int i) {
    olasiliklar[i] = -1;
  }

  public void OlasilikHesapla() {
    float toplam = 0;
    for (int i = 0; i < renkSayisi; i++) {
      if (olasiliklar[i] != -1) {
        toplam += olasiliklar[i];
      }
    }

    for (int i = 0; i < renkSayisi; i++) {
      if (olasiliklar[i] != -1) {
        olasiliklar[i] = olasiliklar[i] / toplam;
      } else {
        olasiliklar[i] = 0;
      }
    }

    if (toplam == 0) {
      for (int i = 0; i < renkSayisi; i++) {
        olasiliklar[i] = 1f / float(renkSayisi);
      }
    }
  }

  public void RenkBelirle() {
    float r = random(1f);
    for (int i = 0; i < renkSayisi; i++) {
      r -= olasiliklar[i];
      if (r <= 0) {
        belirlenmisSayi = i;
        break;
      }
    }
  }
}

Kural [] kurallar;

class Kural {
  public int ana;
  public int [][] miktar;

  public Kural(int ana) {
    miktar = new int[8][renkSayisi];
    this.ana = ana;
  }

  public void Ekle(int yon, int renk) {
    miktar[yon][renk]++;
  }

  public int[] MiktarlariVer(int yon) {
    return miktar[yon];
  }
}

void setup() {
  size(800, 700);

  ornek = new int[ornek_gen][ornek_yuk];

  haneleriOlustur();
  kurallariHesapla();
  haneleriHesapla();
}

void ciz() {
  for (int i = 0; i < ornek_gen; i++) {
    for (int j = 0; j < ornek_yuk; j++) {
      int r = ornek[i][j];
      fill(sayidanRenk(r));
      rect(i*10, j*10, 10, 10);
    }
  }

  translate(ornek_gen*10+10, 0);

  for (int i = 0; i < cikti_gen; i++) {
    for (int j = 0; j < cikti_yuk; j++) {
      int r = cikti[i][j].belirlenmisSayi;
      fill(sayidanRenk(r));
      rect(i*cikti_buyukluk, j*cikti_buyukluk, cikti_buyukluk, cikti_buyukluk);
    }
  }
}

void draw() {
  ciz();

  if (keyPressed == true) {
    int x = mouseX / 10;
    int y = mouseY / 10;
    if (x >= 0 && x < ornek_gen && y >= 0 && y < ornek_yuk) {
      if (keyCode == UP) {
        ornek[x][y] = 0;
      }
      if (keyCode == LEFT) {
        ornek[x][y] = 1;
      }
      if (keyCode == DOWN) {
        ornek[x][y] = 2;
      }
      if (keyCode == RIGHT) {
        ornek[x][y] = 3;
      }
    }
  }

  if (mousePressed) {
    haneleriOlustur();
    kurallariHesapla();
    haneleriHesapla();
  }
}

void haneleriOlustur() {
  cikti = new Hane[cikti_gen][cikti_yuk];
  for (int i = 0; i < cikti_gen; i++) {
    for (int j = 0; j < cikti_yuk; j++) {
      cikti[i][j] = new Hane();
    }
  }
}

void kurallariHesapla() {
  // kuralları oluştur
  kurallar = new Kural[renkSayisi];
  for (int i = 0; i < renkSayisi; i++) {
    kurallar[i] = new Kural(i);
  }

  // örnek üzerinden kuralları belirleme
  for (int i = 0; i < ornek_gen; i++) {
    for (int j = 0; j < ornek_yuk; j++) {
      for (int ii = -1; ii < 2; ii++) {
        for (int jj = -1; jj < 2; jj++) {
          int x = i + ii;
          int y = j + jj;

          if (x >= 0 && x < ornek_gen && y >= 0 && y < ornek_yuk && !(ii == 0 && jj == 0)) {

            int yon = sayidanIndex(ii, jj);
            int ana_renk = ornek[i][j];
            int hedef_renk = ornek[x][y];

            kurallar[ana_renk].Ekle(yon, hedef_renk);

            // println(ana_renk + " " + yon + " " + hedef_renk);
          }
        }
      }
    }
  }
}

void haneleriHesapla() {
  for (int i = 0; i < cikti_gen; i++) {
    for (int j = 0; j < cikti_yuk; j++) {
      // kurallar üzerinden olasılık ekle

      // tüm komşular için
      for (int ii = -1; ii < 2; ii++) {
        for (int jj = -1; jj < 2; jj++) {


          int x = i + ii;
          int y = j + jj;

          if (x >= 0 && x < cikti_gen && y >= 0 && y < cikti_yuk && !(ii == 0 && jj == 0)) {
            if (cikti[x][y].belirlenmisSayi != -1) {
              // bakılan hanenin komşusu dolu
              int yon = sayidanIndex(ii, jj);
              int ana_renk = cikti[x][y].belirlenmisSayi;

              int[] renkler = kurallar[ana_renk].MiktarlariVer(yon);
              for (int k = 0; k < renkSayisi; k++) {
                //println(ana_renk + " : " + k + " " + renkler[k]);
                if (renkler[k] != 0) {
                  cikti[i][j].OlasilikEkle(k, renkler[k]);
                } else {
                  cikti[i][j].OlasiliktanCikar(k);
                }
              }
            }
          }
        }
      }

      cikti[i][j].OlasilikHesapla();
      cikti[i][j].RenkBelirle();
    }
  }
}

color sayidanRenk(int i) {
  switch(i) {
  case 0: 
    return color(255, 0, 0);
  case 1:
    return color(0, 255, 0);
  case 2:
    return color(255, 255, 0);
  case 3:
    return color(0, 0, 255);
  }
  return color(0, 0, 0);
}

int sayidanIndex(int ii, int jj) {
  if (ii == -1 && jj == -1) {
    return 0;
  } else if (ii == 0 && jj == -1) {
    return 1;
  } else if (ii == 1 && jj == -1) {
    return 2;
  } else if (ii == -1 && jj == 0) {
    return 3;
  } else if (ii == 1 && jj == 0) {
    return 4;
  } else if (ii == -1 && jj == 1) {
    return 5;
  } else if (ii == 0 && jj == 1) {
    return 6;
  } else if (ii == 1 && jj == 1) {
    return 7;
  } else {
    return -1;
  }
}
