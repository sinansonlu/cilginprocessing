int[][] saha;
int boyutX = 10;
int boyutY = 10;
int tas = 30;

int cesit = 5;

color[] renkler;

boolean[][] ziyaret;

ArrayList<ArrayList<Tas>> dizgiler;

void setup() {
  size(301, 301);

  saha = new int[boyutX][boyutY];
  ziyaret = new boolean[boyutX][boyutY];

  for (int x = 0; x < boyutX; x++) {
    for (int y = 0; y < boyutY; y++) {
      saha[x][y] = int(random(cesit));
    }
  }

  renkler = new color[cesit];
  for (int i = 0; i < cesit; i++) {
    renkler[i] = color(random(255), random(255), random(255));
  }

  dizgiler = new ArrayList<ArrayList<Tas>>();
}

void keyPressed() {
  if (keyCode == ENTER) {
    eslesmeBul();
  }
}

void draw() {
  for (int x = 0; x < boyutX; x++) {
    for (int y = 0; y < boyutY; y++) {
      if (saha[x][y] != -1) {
        fill(renkler[saha[x][y]]);
        rect(x * tas, y * tas, tas, tas);
      } else {
        fill(#000000);
        rect(x * tas, y * tas, tas, tas);
      }
    }
  }

  for (ArrayList<Tas> dizi : dizgiler) {
    if (dizi.size() >= 3) {
      for (Tas tektas : dizi) {
        fill(color(255, 0, 0));
        rect(tektas.x * tas + tas/4, tektas.y * tas + tas/4, tas/2, tas/2);
      }
    }
  }
}

void eslesmeBul() {
  // ziyaret kayıtlarını sıfırla
  for (int x = 0; x < boyutX; x++) {
    for (int y = 0; y < boyutY; y++) {
      ziyaret[x][y] = false;
    }
  }

  // zincirleri sıfırla
  dizgiler = new ArrayList<ArrayList<Tas>>();

  // ziyaret edilmemiş her taştan başlıyarak komşuları ziyaret et
  for (int x = 0; x < boyutX; x++) {
    for (int y = 0; y < boyutY; y++) {
      if (saha[x][y] != -1 && !ziyaret[x][y]) {
        // bu taş boş değil ve ziyaret edilmemiş
        // yeni bir zincire başla
        ArrayList<Tas> yeniZincir = new ArrayList<Tas>();
        ziyaretEt(x, y, saha[x][y], yeniZincir);
        dizgiler.add(yeniZincir);
      }
    }
  }

  // zincirler hazır, gerekli taşları yok et
  yokEt();
}

void ziyaretEt(int x, int y, int sayi, ArrayList<Tas> yeniZincir) {
  // önce kendisini ziyaret et ve zincire ekle
  ziyaret[x][y] = true;
  yeniZincir.add(new Tas(x, y));

  // sonra da var olan ziyaret edilmemiş komşuları ziyaret et
  if (x+1 < boyutX && !ziyaret[x+1][y] && saha[x+1][y] == sayi) {
    ziyaretEt(x+1, y, sayi, yeniZincir);
  }
  if (x-1 >= 0 && !ziyaret[x-1][y] && saha[x-1][y] == sayi) {
    ziyaretEt(x-1, y, sayi, yeniZincir);
  }
  if (y+1 < boyutY && !ziyaret[x][y+1] && saha[x][y+1] == sayi) {
    ziyaretEt(x, y+1, sayi, yeniZincir);
  }
  if (y-1 >= 0 && !ziyaret[x][y-1] && saha[x][y-1] == sayi) {
    ziyaretEt(x, y-1, sayi, yeniZincir);
  }
}

boolean enAzBirTaneYokEdildi;

void yokEt() {
  enAzBirTaneYokEdildi = false;

  // üçten fazla elemanlı dizgiler için, o dizgideki tasları yoket
  for (ArrayList<Tas> dizi : dizgiler) {
    if (dizi.size() >= 3) {
      enAzBirTaneYokEdildi = true;
      for (Tas tektas : dizi) {
        saha[tektas.x][tektas.y] = -1;
      }
    }
  }

  if (enAzBirTaneYokEdildi) {
    taslariKaydir();
    eslesmeBul();
  }
}

boolean enAzBirKaydiMi;

void taslariKaydir() {
  enAzBirKaydiMi = false;

  for (int x = boyutX - 1; x >= 0; x--) {
    for (int y = boyutY - 1; y > 0; y--) {
      if (saha[x][y] == -1 && saha[x][y-1] != -1) {
        // bu hane boş ve üstteki dolu, bir üsttekini buraya al
        enAzBirKaydiMi = true;
        saha[x][y] = saha[x][y-1];
        saha[x][y-1] = -1;
      }
    }
  }

  // üstten yeni taş gelmesi için
  for (int x = boyutX - 1; x >= 0; x--) {
    if (saha[x][0] == -1) {
      enAzBirKaydiMi = true;
      saha[x][0] = int(random(cesit));
    }
  }

  if (enAzBirKaydiMi) {
    taslariKaydir();
  }
}

class Tas {
  public int x;
  public int y;

  public Tas(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
