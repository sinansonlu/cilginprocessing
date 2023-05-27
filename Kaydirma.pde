class Oyun {
  int[][] saha;
  public int x;
  public int y;

  public int boyut;

  public Oyun(int n, boolean bitmisMi) {
    boyut = n;
    saha = new int[boyut][boyut];
    if (bitmisMi) {
      int sayi = 1;
      for (int i = 0; i < boyut; i++) {
        for (int j = 0; j < boyut; j++) {
          saha[i][j] = sayi;
          sayi++;
        }
      }
      saha[boyut-1][boyut-1] = 0;
      x = boyut-1;
      y = boyut-1;
    } else {
      int[] sayilar = new int[boyut*boyut];
      for (int i = 0; i < sayilar.length; i++) {
        sayilar[i] = i;
      }

      for (int i = 0; i < sayilar.length; i++) {
        int tmp = sayilar[i];
        int r = (int) random(sayilar.length);
        sayilar[i] = sayilar[r];
        sayilar[r] = tmp;
      }

      int indeks = 0;
      for (int i = 0; i < boyut; i++) {
        for (int j = 0; j < boyut; j++) {
          saha[i][j] = sayilar[indeks];
          if (saha[i][j] == 0) {
            x = i;
            y = j;
          }
          indeks++;
        }
      }
    }
  }

  void karistir(int k) {
    for (int i = 0; i < k; i++) {
      hamleYap(rastgeleGecerliHamle());
    }
  }

  void yazdir() {
    for (int i = 0; i < boyut; i++) {
      for (int j = 0; j < boyut; j++) {
        print("" + saha[i][j] + " ");
      }
      println();
    }
  }

  boolean oyunBittiMi() {
    int sayi = 1;
    for (int i = 0; i < boyut; i++) {
      for (int j = 0; j < boyut; j++) {
        if (saha[i][j] == sayi || (i == boyut - 1 && j == boyut - 1)) {
          sayi++;
        } else {
          return false;
        }
      }
    }
    return true;
  }

  // hamlenin geçerli olduğu varsayılıyor
  void hamleYap(int h) {
    if (h == 0) {
      degistir(x, y, x-1, y);
      x--;
    } else if (h == 1) {
      degistir(x, y, x, y-1);
      y--;
    } else if (h == 2) {
      degistir(x, y, x+1, y);
      x++;
    } else if (h == 3) {
      degistir(x, y, x, y+1);
      y++;
    }
  }

  // h = 0 -> yukarı, x--
  // h = 1 -> sol, y--
  // h = 2 -> aşağı, x++
  // h = 3 -> sağ, y++
  boolean gecerliHamleMi(int h) {
    if (h == 0) {
      return x > 0;
    } else if (h == 1) {
      return y > 0;
    } else if (h == 2) {
      return x < boyut - 1;
    } else if (h == 3) {
      return y < boyut - 1;
    } else {
      return false;
    }
  }

  public int rastgeleGecerliHamle() {
    int[] sayilar = new int[4];
    for (int i = 0; i < sayilar.length; i++) {
      sayilar[i] = i;
    }

    for (int i = 0; i < sayilar.length; i++) {
      int tmp = sayilar[i];
      int r = (int) random(sayilar.length);
      sayilar[i] = sayilar[r];
      sayilar[r] = tmp;
    }

    for (int i = 0; i < sayilar.length; i++) {
      if (gecerliHamleMi(sayilar[i])) {
        return sayilar[i];
      }
    }

    return -1;
  }

  public String kodla() {
    String k = "";
    for (int i = 0; i < boyut; i++) {
      for (int j = 0; j < boyut; j++) {
        if (i == boyut - 1 && j == boyut - 1) {
          k += saha[i][j];
        } else {
          k += saha[i][j] + "-";
        }
      }
    }
    return k;
  }

  private void degistir(int i1, int j1, int i2, int j2) {
    int tmp = saha[i1][j1];
    saha[i1][j1] = saha[i2][j2];
    saha[i2][j2] = tmp;
  }
}

class Zeka {
  HashMap<String, Durum> defter = new HashMap<String, Durum>();
  Oyun o;

  public Zeka(Oyun o) {
    this.o = o;
  }

  public void verilenOyundaHamleYap(Oyun o) {
    String s = o.kodla();
    Durum d = defter.get(s);
    int rh = -1;

    if (d != null) {
      int h = d.enIyiHamleNe();
      if (h == -1) {
        rh = o.rastgeleGecerliHamle();
      } else {
        rh = h;
      }
    } else {
      d = new Durum();
      defter.put(s, d);
      rh = o.rastgeleGecerliHamle();
    }

    println("Hamle : " + rh);
    o.hamleYap(rh);
  }

  public void oyna(int k, int jmax, int kardmax) {
    for (int kard = 0; kard < kardmax; kard++) {
      for (int i = 0; i < k; i++) {
        o = new Oyun(o.boyut, true);
        o.karistir(kard);
        for (int j = 0; j < jmax; j++) {
          hamleYap();
          //o.yazdir();
          //println();
          if (o.oyunBittiMi()) {
            o = new Oyun(o.boyut, true);
            o.karistir(kard);
          }
        }
      }
    }
  }

  public void hamleYap() {
    String s = o.kodla();
    Durum d = defter.get(s);
    int rh = -1;

    //println(s);

    if (d != null) {
      int h = d.enIyiHamleNe();
      if (h == -1) {
        rh = o.rastgeleGecerliHamle();
      } else {
        rh = h;
      }
    } else {
      d = new Durum();
      defter.put(s, d);
      rh = o.rastgeleGecerliHamle();
    }

    o.hamleYap(rh);

    String s2 = o.kodla();
    Durum d2 = defter.get(s2);

    if (d2 != null) {
      int deger = d2.degeriNe();
      if (deger != Integer.MAX_VALUE) {
        d.guncelle(rh, deger+1);
      }
    }
    if (o.oyunBittiMi()) {
      d.guncelle(rh, 1);
    }
  }
}

class Durum {
  // public int[][] saha;
  public int[] hamleler;

  public Durum() {
    hamleler = new int[4];
    for (int i = 0; i < 4; i++) {
      hamleler[i] = Integer.MAX_VALUE;
    }
  }

  public void guncelle(int h, int d) {
    if (hamleler[h] > d) {
      hamleler[h] = d;
    }
  }

  public int degeriNe() {
    int min = Integer.MAX_VALUE;
    for (int i = 0; i < 4; i++) {
      if (min > hamleler[i]) {
        min = hamleler[i];
      }
    }
    return min;
  }

  public int enIyiHamleNe() {
    int min = Integer.MAX_VALUE;
    int in = -1;
    for (int i = 0; i < 4; i++) {
      if (min > hamleler[i]) {
        min = hamleler[i];
        in = i;
      }
    }
    return in;
  }
}

void setup() {
  Oyun o1 = new Oyun(3, true);
  Zeka z = new Zeka(o1);
  
  println("zeka eğitiliyor...");
  z.oyna(100, 500, 50);

  o1 = new Oyun(3, true);
  o1.karistir(50);
  while (!o1.oyunBittiMi()) {
    z.verilenOyundaHamleYap(o1);
    o1.yazdir();
  }

  println("son");
}
