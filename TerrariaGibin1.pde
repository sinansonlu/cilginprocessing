class Blok {
  int tur;
  int can;

  public Blok(int tur) {
    this.tur = tur;
  }

  void ciz(int x, int y) {
    fill(#554534);
    noStroke();
    rect(x, y, BLOK_BOYUTU, BLOK_BOYUTU);
  }
}

class Karakter {
  int can;

  int x, y;

  public Karakter(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void ciz(int dx, int dy) {
    fill(#1054FF);
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

  // dünya oluşturma safhası
  for (int i = 0; i < DUNYA_X; i++) {
    for (int j = 0; j < DUNYA_Y; j++) {
      if (random(1f) < 0.3) {
        dunya[i][j] = new Blok(0);
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
  }

  // karakter köşe hesabı
  // sol üst
  int n0_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
  int n0_j = (oyuncu1.y + 1) / BLOK_BOYUTU;

  // sağ üst
  int n1_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
  int n1_j = (oyuncu1.y + 1) / BLOK_BOYUTU;

  // sol alt
  int n2_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
  int n2_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;

  // sağ alt
  int n3_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
  int n3_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;

  // oyuncunun yeni koordinatı üzerinden hesapla
  n0_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
  n0_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
  n1_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
  n1_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
  n2_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
  n2_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;
  n3_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
  n3_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;

  if (girdi_sol && dunya[n0_i][n0_j] == null && dunya[n2_i][n2_j] == null) {
    oyuncu1.ilerleX(-2);
    n0_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
    n0_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
    n2_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
    n2_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;
    
    if (dunya[n0_i][n0_j] != null || dunya[n2_i][n2_j] != null) {
      oyuncu1.duzenleXSol();
      n0_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
      n0_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
      n1_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
      n1_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
      n2_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
      n2_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;
      n3_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
      n3_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;
    }
  }

  if (girdi_sag && dunya[n1_i][n1_j] == null && dunya[n3_i][n3_j] == null) {
    oyuncu1.ilerleX(2);
    n1_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
    n1_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
    n3_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
    n3_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;
    if (dunya[n1_i][n1_j] != null || dunya[n3_i][n3_j] != null) {
      oyuncu1.duzenleXSag();
      n0_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
      n0_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
      n1_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
      n1_j = (oyuncu1.y + 1) / BLOK_BOYUTU;
      n2_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
      n2_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;
      n3_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
      n3_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;
    }
  }

  // düşme kısmı
  if (dunya[n2_i][n2_j] == null && dunya[n3_i][n3_j] == null) {
    oyuncu1.dus();

    n2_i = (oyuncu1.x + 1) / BLOK_BOYUTU;
    n2_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;

    n3_i = ((oyuncu1.x - 1) + KARAKTER_BOYUTU_X) / BLOK_BOYUTU;
    n3_j = ((oyuncu1.y - 1) + KARAKTER_BOYUTU_Y) / BLOK_BOYUTU;

    if (dunya[n2_i][n2_j] != null || dunya[n3_i][n3_j] != null) {
      oyuncu1.duzenleY();
    }
  }
}
