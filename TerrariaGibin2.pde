PImage tex_toprak, tex_kaya, tex_kirik_kaya, tex_odun;

class Blok {
  PImage img;
  int tur;
  int can;

  public Blok(int tur) {
    this.tur = tur;
    switch(tur) {
    case 0:
      img = tex_toprak;
      can = 10;
      break;
    case 1:
      img = tex_kaya;
      can = 30;
      break;
    case 2:
      img = tex_odun;
      can = 20;
      break;
    }
  }

  boolean vurVeKirdiMi(int hasar) {
    can -= hasar;
    if (tur == 1 && can <= 20) {
      img = tex_kirik_kaya;
    }
    return (can <= 0);
  }

  void ciz(int x, int y) {
    image(img, x, y, BLOK_BOYUTU, BLOK_BOYUTU);
  }
}

class Karakter {
  int can;
  int aksiyon_araligi = 0;
  int aksiyon_max = 10;
  int seciliBlok = 0;

  int[] bloklar;

  int x, y;

  public Karakter(int x, int y) {
    this.x = x;
    this.y = y;
    bloklar = new int[3];
  }

  void aksiyonSayaci() {
    if (aksiyon_araligi > 0) {
      aksiyon_araligi--;
    }
  }

  boolean aksiyon() {
    if (aksiyon_araligi <= 0) {
      aksiyon_araligi = aksiyon_max;
      return true;
    }
    return false;
  }

  void blokAl(int tur) {
    bloklar[tur]++;
  }

  boolean blokVer(int tur) {
    if (bloklar[tur] > 0) {
      bloklar[tur]--;
      return true;
    }
    return false;
  }

  void ciz(int dx, int dy) {
    if (aksiyon_araligi <= 0) {
      fill(#1054FF);
    } else {
      fill(#EE58AF);
    }
    noStroke();
    rect(x - dx, y - dy, KARAKTER_BOYUTU_X, KARAKTER_BOYUTU_Y);
  }

  void dus() {
    y += 3;
  }

  void duzenleY() {
    y = round(y / BLOK_BOYUTU) * BLOK_BOYUTU;
  }

  void duzenleXSol() {
    x = (ceil(x / BLOK_BOYUTU) + 1) * BLOK_BOYUTU;
  }

  void duzenleXSag() {
    x = floor(x / BLOK_BOYUTU) * BLOK_BOYUTU;
  }

  void ilerleX(int dx) {
    x += dx;
  }
}

final int DUNYA_X = 400;
final int DUNYA_Y = 200;
final int BLOK_BOYUTU = 20;
final int KARAKTER_BOYUTU_X = BLOK_BOYUTU;
final int KARAKTER_BOYUTU_Y = BLOK_BOYUTU * 2;

Blok[][] dunya = new Blok[DUNYA_X][DUNYA_Y];

Karakter oyuncu1 = new Karakter(DUNYA_X*BLOK_BOYUTU/2, DUNYA_Y*BLOK_BOYUTU/2);

boolean girdi_sol = false;
boolean girdi_sag = false;

void setup() {
  size(600, 400, P2D);

  // görselleri yükleme aşaması
  PImage tex0 = loadImage("d7aem.png");
  tex_toprak = tex0.get(2*16, 0, 16, 16);
  tex_kaya = tex0.get(5*16, 3*16, 16, 16);
  tex_kirik_kaya = tex0.get(4*16, 3*16, 16, 16);
  tex_odun = tex0.get(6*16, 5*16, 16, 16);

  // dünya oluşturma safhası
  for (int i = 0; i < DUNYA_X; i++) {
    for (int j = 0; j < DUNYA_Y; j++) {
      if (random(1f) < 0.3) {
        if (random(1f) < 0.2) {
          dunya[i][j] = new Blok(1);
        } else if (random(1f) < 0.2) {
          dunya[i][j] = new Blok(2);
        } else {
          dunya[i][j] = new Blok(0);
        }
      }
    }
  }

  int karakter_i = oyuncu1.x / BLOK_BOYUTU;
  int karakter_j = oyuncu1.y / BLOK_BOYUTU;

  for (int i = karakter_i - 5; i < karakter_i + 5; i++) {
    for (int j = karakter_j - 5; j < karakter_j + 5; j++) {
      dunya[i][j] = null;
    }
  }
}

void draw() {
  // çizim mantığı
  background(50);

  int blok_sayisi_x = width / BLOK_BOYUTU;
  int blok_sayisi_y = height / BLOK_BOYUTU;

  int karakter_i = (oyuncu1.x / BLOK_BOYUTU);
  int karakter_j = oyuncu1.y / BLOK_BOYUTU;

  int kaydir_i = karakter_i  - (blok_sayisi_x/2);
  int kaydir_j = karakter_j  - (blok_sayisi_y/2);

  int ekran_kay_x = oyuncu1.x % BLOK_BOYUTU;
  int ekran_kay_y = oyuncu1.y % BLOK_BOYUTU;

  for (int i = 0; i < blok_sayisi_x+1; i++) {
    for (int j = 0; j < blok_sayisi_y+1; j++) {
      if (dunya[i+kaydir_i][j+kaydir_j] != null) {
        dunya[i+kaydir_i][j+kaydir_j].ciz(i*BLOK_BOYUTU-ekran_kay_x, j*BLOK_BOYUTU-ekran_kay_y);
      }
    }
  }

  oyuncu1.ciz(kaydir_i*BLOK_BOYUTU+ekran_kay_x, kaydir_j*BLOK_BOYUTU+ekran_kay_y);

  // arayüzü çiz
  stroke(#B1B7BF);
  noFill();

  image(tex_toprak, 10, 12, 10, 10);
  image(tex_kaya, 10, 24, 10, 10);
  image(tex_odun, 10, 36, 10, 10);

  rect(10, 12, 10, 10);
  rect(10, 24, 10, 10);
  rect(10, 36, 10, 10);

  stroke(#E4E83B);
  rect(10, 12 + oyuncu1.seciliBlok * 12, 10, 10);

  textSize(10);
  fill(#B1B7BF);
  text(oyuncu1.bloklar[0], 24, 21);
  text(oyuncu1.bloklar[1], 24, 33);
  text(oyuncu1.bloklar[2], 24, 45);

  // hareket mantığı
  girdi_sol = false;
  girdi_sag = false;

  // karakter ilerleme mantığı
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        girdi_sol = true;
      }
      if (keyCode == RIGHT) {
        girdi_sag = true;
      }
    }

    if (key == '1') {
      oyuncu1.seciliBlok = 0;
    }
    if (key == '2') {
      oyuncu1.seciliBlok = 1;
    }
    if (key == '3') {
      oyuncu1.seciliBlok = 2;
    }
  }

  oyuncu1.aksiyonSayaci();

  if (mousePressed == true) {
    if (mouseButton == LEFT) {
      if (oyuncu1.aksiyon()) {
        int hedef_i = ((mouseX + ekran_kay_x) / BLOK_BOYUTU) + kaydir_i;
        int hedef_j = ((mouseY + ekran_kay_y )/ BLOK_BOYUTU) + kaydir_j;

        if (abs(hedef_i - karakter_i) < 6 && abs(hedef_j - karakter_j) < 5) {
          if (dunya[hedef_i][hedef_j] != null && dunya[hedef_i][hedef_j].vurVeKirdiMi(10)) {
            oyuncu1.blokAl(dunya[hedef_i][hedef_j].tur);
            dunya[hedef_i][hedef_j] = null;
          }
        }
      }
    } else if (mouseButton == RIGHT) {
      int hedef_i = ((mouseX + ekran_kay_x) / BLOK_BOYUTU) + kaydir_i;
      int hedef_j = ((mouseY + ekran_kay_y )/ BLOK_BOYUTU) + kaydir_j;

      if (abs(hedef_i - karakter_i) < 6 && abs(hedef_j - karakter_j) < 5) {
        if (dunya[hedef_i][hedef_j] == null) {
          if (oyuncu1.blokVer(oyuncu1.seciliBlok)) {
            dunya[hedef_i][hedef_j] = new Blok(oyuncu1.seciliBlok);
          }
        }
      }
    }
  }

  // karakter köşe hesabı
  // sol üst n0, sağ üst n1, sol alt n2, sağ alt n3
  int n02_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
  int n01_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
  int n13_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
  int n23_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;

  if (girdi_sol) {
    boolean solaGidilebilirMi = true;

    for (int n_j = n01_j; n_j <= n23_j; n_j++) {
      if (dunya[n02_i][n_j] != null) {
        solaGidilebilirMi = false;
      }
    }

    if (solaGidilebilirMi) {
      oyuncu1.ilerleX(-2);
      n02_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
      n13_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;

      boolean soldanCarptikMi = false;

      for (int n_j = n01_j; n_j <= n23_j; n_j++) {
        if (dunya[n02_i][n_j] != null) {
          soldanCarptikMi = true;
        }
      }

      if (soldanCarptikMi) {
        oyuncu1.duzenleXSol();
        n02_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
        n13_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
      }
    }
  }

  if (girdi_sag) {
    boolean sagaGidilebilirMi = true;

    for (int n_j = n01_j; n_j <= n23_j; n_j++) {
      if (dunya[n13_i][n_j] != null) {
        sagaGidilebilirMi = false;
      }
    }

    if (sagaGidilebilirMi) {
      oyuncu1.ilerleX(2);
      n02_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
      n13_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;

      boolean sagaCarptikMi = false;

      for (int n_j = n01_j; n_j <= n23_j; n_j++) {
        if (dunya[n13_i][n_j] != null) {
          sagaCarptikMi = true;
        }
      }
      if (sagaCarptikMi) {
        oyuncu1.duzenleXSag();
        n02_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
        n13_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
      }
    }
  }

  boolean asagiGidilebilirMi = true;

  for (int n_i = n02_i; n_i <= n13_i; n_i++) {
    if (dunya[n_i][n23_j] != null) {
      asagiGidilebilirMi = false;
    }
  }

  // düşme kısmı
  if (asagiGidilebilirMi) {
    oyuncu1.dus();

    n01_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
    n23_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;

    boolean asagiCarptikMi = false;

    for (int n_i = n02_i; n_i <= n13_i; n_i++) {
      if (dunya[n_i][n23_j] != null) {
        asagiCarptikMi = true;
      }
    }

    if (asagiCarptikMi) {
      oyuncu1.duzenleY();
    }
  }
}
