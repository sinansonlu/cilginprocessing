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

boolean siraSiyahtaMi = false;

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

ArrayList<Hamle> hamleler = new ArrayList<Hamle>();

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

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      geriAl();
    }
  }
}

void geriAl() {
  if (hamleler.size() > 0) {
    Hamle sonHamle = hamleler.get(hamleler.size()-1);
    hamleler.remove(hamleler.size()-1);

    int ex = sonHamle.mevcutTas.x;
    int ey = sonHamle.mevcutTas.y;

    sonHamle.mevcutTas.x = sonHamle.ox;
    sonHamle.mevcutTas.y = sonHamle.oy;

    saha[ex][ey] = sonHamle.yenilenTas;
    saha[sonHamle.ox][sonHamle.oy] = sonHamle.mevcutTas;

    if (sonHamle.yenilenTas != null) {
      if (sonHamle.yenilenTas.siyahMi) {
        siyahlar.add(sonHamle.yenilenTas);
      } else {
        beyazlar.add(sonHamle.yenilenTas);
      }
    }

    siraSiyahtaMi = !siraSiyahtaMi;
  }
}

void siyahOynasin() {
  ArrayList<Hamle> olasiHamleler = new ArrayList<Hamle>();
  for (int i = 0; i < siyahlar.size(); i++) {
    siyahlar.get(i).hamleleriVer(olasiHamleler);
  }

  for (int i = 0; i < olasiHamleler.size(); i++) {
    olasiHamleler.get(i).sahaDegerlendirmesiYap();
  }

  int max = -999999;

  for (int i = 0; i < olasiHamleler.size(); i++) {
    if (olasiHamleler.get(i).sahaDegerlendirmesi > max) {
      max = olasiHamleler.get(i).sahaDegerlendirmesi;
    }
  }

  for (int i = 0; i < olasiHamleler.size(); i++) {
    if (olasiHamleler.get(i).sahaDegerlendirmesi != max) {
      olasiHamleler.remove(i);
      if (olasiHamleler.size() != 0) {
        i--;
      }
    }
  }

  // rastgele bir hamle seç
  Hamle secilenHamle = olasiHamleler.get((int)random(olasiHamleler.size()));
  secilenHamle.mevcutTas.hareketEt(secilenHamle.hx, secilenHamle.hy);
}

void hareketMatriksiniSifirla() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      sahaHareket[i][j] = false;
    }
  }
}

void mouseClicked() {
  boolean tasHareketEtti = false;

  if (seciliTas != null) {
    if (gezX != -1 && gezY != -1) {
      if (gidilebilirMi(gezX, gezY)) {
        seciliTas.hareketEt(gezX, gezY);
        tasHareketEtti = true;
        siyahOynasin();
      }
    }

    seciliTas.secili = false;
    seciliTas = null;
    hareketMatriksiniSifirla();
  }

  if (!tasHareketEtti && gezX != -1 && gezY != -1) {
    if (saha[gezX][gezY] != null && saha[gezX][gezY].siyahMi == siraSiyahtaMi) {
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

int puanDegerlendirmesi(boolean siyahMi) {
  int toplam = 0;

  // ulaşılabilir noktaları sıfırla
  hareketMatriksiniSifirla();

  if (siyahMi) {
    for (int i = 0; i < siyahlar.size(); i++) {
      siyahlar.get(i).hareketMatriksiOlustur();
      toplam += siyahlar.get(i).puanDegeri;
    }
    for (int i = 0; i < beyazlar.size(); i++) {
      toplam -= beyazlar.get(i).puanDegeri;
    }
  } else {
    for (int i = 0; i < beyazlar.size(); i++) {
      beyazlar.get(i).hareketMatriksiOlustur();
      toplam += beyazlar.get(i).puanDegeri;
    }
    for (int i = 0; i < siyahlar.size(); i++) {
      toplam -= siyahlar.get(i).puanDegeri;
    }
  }

  toplam = toplam * 10;

  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (sahaHareket[i][j]) {
        toplam += 1;
        if (saha[i][j] != null) {
          toplam += saha[i][j].puanDegeri;
        }
      }
    }
  }

  return toplam;
}

class Hamle {
  Tas mevcutTas;
  int ox, oy;
  int hx, hy;
  int sahaDegerlendirmesi;

  Tas yenilenTas;

  public Hamle(Tas mevcutTas, int hx, int hy) {
    this.mevcutTas = mevcutTas;
    ox = mevcutTas.x;
    oy = mevcutTas.y;

    this.hx = hx;
    this.hy = hy;

    yenilenTas = saha[hx][hy];
  }

  public void sahaDegerlendirmesiYap() {
    mevcutTas.hareketEt(hx, hy);
    sahaDegerlendirmesi = puanDegerlendirmesi(!siraSiyahtaMi) - puanDegerlendirmesi(siraSiyahtaMi);
    geriAl();
  }
}

class Tas {
  PImage img;
  int x, y;
  int puanDegeri;
  boolean secili;

  int tasTuru;
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
        if (y == 6) {
          if (bosMu(x, y-2)) {
            sahadaIsaretle(x, y-2, siyahMi);
          }
        }
      }

      sahadaIsaretleYiyerek(x-1, y-1, siyahMi);
      sahadaIsaretleYiyerek(x+1, y-1, siyahMi);
    }
    if (tasTuru == 6) { // siyah piyon
      if (bosMu(x, y+1)) {
        sahadaIsaretle(x, y+1, siyahMi);
        if (y == 1) {
          if (bosMu(x, y+2)) {
            sahadaIsaretle(x, y+2, siyahMi);
          }
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
    hamleler.add(new Hamle(this, hedefX, hedefY));

    if (!bosMu(hedefX, hedefY)) {
      tasiYe(hedefX, hedefY);
    }

    saha[hedefX][hedefY] = saha[x][y];
    saha[x][y] = null;
    x = hedefX;
    y = hedefY;

    siraSiyahtaMi = !siraSiyahtaMi;
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

  public void hamleleriVer(ArrayList<Hamle> olasiHamleler) {
    hareketMatriksiniSifirla();
    hareketMatriksiOlustur();
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (sahaHareket[i][j]) {
          olasiHamleler.add(new Hamle(this, i, j));
        }
      }
    }
  }
}
