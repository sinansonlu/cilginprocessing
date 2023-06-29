Tas[][] saha;
boolean[][] sahaHareket;
float carpan = 128;
float bolen;

ArrayList<Tas> beyazlar;
ArrayList<Tas> siyahlar;

int siyahPuan = 0;
int beyazPuan = 0;

int gezX = -1;
int gezY = -1;

int[] puanDegerleri = {1, 3, 3, 5, 9, 100, 1, 3, 3, 5, 9, 100};
String[] tasResimleri = {
  "w_pawn_png_shadow_128px.png", // 0
  "w_knight_png_shadow_128px.png", // 1
  "w_bishop_png_shadow_128px.png", // 2
  "w_rook_png_shadow_128px.png", // 3
  "w_queen_png_shadow_128px.png", // 4
  "w_king_png_shadow_128px.png", // 5
  "b_pawn_png_shadow_128px.png",
  "b_knight_png_shadow_128px.png",
  "b_bishop_png_shadow_128px.png",
  "b_rook_png_shadow_128px.png",
  "b_queen_png_shadow_128px.png",
  "b_king_png_shadow_128px.png"
};

Tas seciliTas;

void setup() {
  size(800, 800);

  bolen = carpan * 8 / 800;

  saha = new Tas[8][8];
  sahaHareket = new boolean[8][8];

  beyazlar = new ArrayList<Tas>();
  siyahlar = new ArrayList<Tas>();

  // beyazlar
  tasEkle(0, 7, 3);
  tasEkle(1, 7, 1);
  tasEkle(2, 7, 2);
  tasEkle(3, 7, 4);
  tasEkle(4, 7, 5);
  tasEkle(5, 7, 2);
  tasEkle(6, 7, 1);
  tasEkle(7, 7, 3);
  for (int i = 0; i < 8; i++) {
    tasEkle(i, 6, 0);
  }

  // siyahlar
  tasEkle(0, 0, 9);
  tasEkle(1, 0, 7);
  tasEkle(2, 0, 8);
  tasEkle(3, 0, 10);
  tasEkle(4, 0, 11);
  tasEkle(5, 0, 8);
  tasEkle(6, 0, 7);
  tasEkle(7, 0, 9);
  for (int i = 0; i < 8; i++) {
    tasEkle(i, 1, 6);
  }
}

void tasEkle(int x, int y, int tasTuru) {
  Tas t = new Tas(x, y, tasTuru);
  saha[x][y] = t;
  if (tasTuru < 6) {
    beyazlar.add(t);
  } else {
    siyahlar.add(t);
  }
}

boolean gidilebilirMi(int x, int y) {
  return sahaIciMi(x, y) && sahaHareket[x][y];
}

void mouseClicked() {
  boolean tasHareketEtti = false;

  if (seciliTas != null) {
    if (gezX != -1 && gezY != -1) {
      if (gidilebilirMi(gezX, gezY)) {
        seciliTas.hareketEt(gezX, gezY);
        tasHareketEtti = true;
      }
    }

    seciliTas.secili = false;
    seciliTas = null;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        sahaHareket[i][j] = false;
      }
    }
  }

  if (!tasHareketEtti && gezX != -1 && gezY != -1) {
    if (saha[gezX][gezY] != null) {
      seciliTas = saha[gezX][gezY];
      seciliTas.secili = true;
      seciliTas.hareketMatriksiOlustur();
    }
  }
}

boolean sahaIciMi(int x, int y) {
  return x >= 0 && x < 8 && y >= 0 & y < 8;
}

boolean bosMu(int x, int y) {
  return (sahaIciMi(x, y) && saha[x][y] == null);
}

void fareHareketi() {
  int x = (int) (mouseX / carpan * bolen);
  int y = (int) (mouseY / carpan * bolen);
  if (sahaIciMi(x, y)) {
    gezX = x;
    gezY = y;
  } else {
    gezX = -1;
    gezY = -1;
  }
}

void draw() {
  fareHareketi();

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (i == gezX && j == gezY) {
        fill(#54AF4C);
      } else if (sahaHareket[i][j]) {
        fill(#5AFFA8);
      } else if (i % 2 == j % 2) {
        fill(#7C4B46);
      } else {
        fill(#C5C682);
      }
      rect(i*carpan/bolen, j*carpan/bolen, carpan/bolen, carpan/bolen);

      if (saha[i][j] != null) {
        if (saha[i][j].secili) {
          fill(#239FDB);
          rect(i*carpan/bolen, j*carpan/bolen, carpan/bolen, carpan/bolen);
        }

        saha[i][j].ciz();
      }
    }
  }
}

public void sahadaIsaretle(int x, int y, boolean siyahMi) {
  if (sahaIciMi(x, y)) {
    if (!bosMu(x, y)) {
      sahaHareket[x][y] = saha[x][y].siyahMi != siyahMi;
    } else {
      sahaHareket[x][y] = true;
    }
  }
}

public void sahadaIsaretleYiyerek(int x, int y, boolean siyahMi) {
  if (sahaIciMi(x, y)) {
    if (!bosMu(x, y)) {
      sahaHareket[x][y] = saha[x][y].siyahMi != siyahMi;
    }
  }
}

class Tas {
  PImage img;
  int x, y;
  int puanDegeri;
  boolean secili;

  int tasTuru;
  boolean hicHareketEttiMi;
  boolean siyahMi;

  public Tas(int x, int y, int tasTuru) {
    this.x= x;
    this.y = y;
    puanDegeri = puanDegerleri[tasTuru];
    this.tasTuru = tasTuru;
    img = loadImage(tasResimleri[tasTuru]);
    siyahMi = tasTuru > 5;
  }

  public void ciz() {
    image(img, x * carpan / bolen, y * carpan / bolen, img.width / bolen, img.height / bolen);
  }

  public void hareketMatriksiOlustur() {
    if (tasTuru == 0) { // beyaz piyon
      if (bosMu(x, y-1)) {
        sahadaIsaretle(x, y-1, siyahMi);
      }
      if (!hicHareketEttiMi) {
        if (bosMu(x, y-2)) {
          sahadaIsaretle(x, y-2, siyahMi);
        }
      }
      sahadaIsaretleYiyerek(x-1, y-1, siyahMi);
      sahadaIsaretleYiyerek(x+1, y-1, siyahMi);
    }
    if (tasTuru == 6) { // siyah piyon
      if (bosMu(x, y+1)) {
        sahadaIsaretle(x, y+1, siyahMi);
      }
      if (!hicHareketEttiMi) {
        if (bosMu(x, y+2)) {
          sahadaIsaretle(x, y+2, siyahMi);
        }
      }
      sahadaIsaretleYiyerek(x-1, y+1, siyahMi);
      sahadaIsaretleYiyerek(x+1, y+1, siyahMi);
    }
    if (tasTuru == 1 || tasTuru == 7) {
      sahadaIsaretle(x+1, y+2, siyahMi);
      sahadaIsaretle(x+1, y-2, siyahMi);
      sahadaIsaretle(x-1, y-2, siyahMi);
      sahadaIsaretle(x-1, y+2, siyahMi);
      sahadaIsaretle(x+2, y+1, siyahMi);
      sahadaIsaretle(x+2, y-1, siyahMi);
      sahadaIsaretle(x-2, y-1, siyahMi);
      sahadaIsaretle(x-2, y+1, siyahMi);
    }
    if (tasTuru == 2 || tasTuru == 8 || tasTuru == 4 || tasTuru == 10) { // fil
      boolean henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x+i, y+i);
        sahadaIsaretle(x+i, y+i, siyahMi);
      }
      henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x-i, y+i);
        sahadaIsaretle(x-i, y+i, siyahMi);
      }
      henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x-i, y-i);
        sahadaIsaretle(x-i, y-i, siyahMi);
      }
      henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x+i, y-i);
        sahadaIsaretle(x+i, y-i, siyahMi);
      }
    }
    if (tasTuru == 3 || tasTuru == 9 || tasTuru == 4 || tasTuru == 10) { // kale
      boolean henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x+i, y);
        sahadaIsaretle(x+i, y, siyahMi);
      }
      henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x-i, y);
        sahadaIsaretle(x-i, y, siyahMi);
      }
      henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x, y-i);
        sahadaIsaretle(x, y-i, siyahMi);
      }
      henuzDegil = true;
      for (int i = 1; i < 8 && henuzDegil; i++) {
        henuzDegil = bosMu(x, y+i);
        sahadaIsaretle(x, y+i, siyahMi);
      }
    }
    if (tasTuru == 5 || tasTuru == 11) { // şah
      sahadaIsaretle(x, y+1, siyahMi);
      sahadaIsaretle(x, y-1, siyahMi);
      sahadaIsaretle(x+1, y, siyahMi);
      sahadaIsaretle(x-1, y, siyahMi);
      sahadaIsaretle(x-1, y-1, siyahMi);
      sahadaIsaretle(x+1, y-1, siyahMi);
      sahadaIsaretle(x-1, y+1, siyahMi);
      sahadaIsaretle(x+1, y+1, siyahMi);
    }
  }

  public void hareketEt(int hedefX, int hedefY) {
    hicHareketEttiMi = true;

    if (!bosMu(hedefX, hedefY)) {
      tasiYe(hedefX, hedefY);
    }

    saha[hedefX][hedefY] = saha[x][y];
    saha[x][y] = null;
    x = hedefX;
    y = hedefY;
  }

  public void tasiYe(int x, int y) {
    if (beyazlar.remove(saha[x][y])) {
      puanEkle(false, saha[x][y].puanDegeri);
    }
    if (siyahlar.remove(saha[x][y])) {
      puanEkle(true, saha[x][y].puanDegeri);
    }
    saha[x][y] = null;
  }

  public void puanEkle(boolean tarafSiyahMi, int puanDegeri) {
    if (tarafSiyahMi) {
      siyahPuan += puanDegeri;
    } else {
      beyazPuan += puanDegeri;
    }
  }
}
