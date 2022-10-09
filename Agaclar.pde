Parca p;
float yesilLimit = 9;

int agacSayisi = 7;
ArrayList<PVector> agaclar = new ArrayList<PVector>();
ArrayList<Parca> parcalar = new ArrayList<Parca>();

void setup() {
  size(800, 600, P2D);

  for (int i = 0; i < agacSayisi; i++) {
    agaclar.add(new PVector(random(20, 780), 550));
    parcalar.add(new Parca(random(-PI * 0.55f, -PI * 0.45f), 0, 6));
  }
}

void draw() {
  background(#C8F3F5);
  noStroke();
  fill(#52231A);
  rect(0, 550, 800, 550);

  for (int i = 0; i < agacSayisi; i++) {
    parcalar.get(i).ciz(agaclar.get(i));
    parcalar.get(i).buyu(agaclar.get(i), 1f);
  }

  if (random(1f) >= 0.999f) {
    agaclar.add(new PVector(random(20, 780), 550));
    parcalar.add(new Parca(random(-PI * 0.45f, -PI * 0.55f), 0, 6));
    agacSayisi++;
  }
}

class Parca {
  float aci;
  float uzunluk;

  float kalinlik;

  int parcaTuru;

  int enFazlaDal;

  ArrayList<Parca> sonrakiler;

  Parca(float aci, int parcaTuru, int enFazlaDal) {
    this.aci = aci;
    this.parcaTuru = parcaTuru;
    this.enFazlaDal = enFazlaDal;

    if (parcaTuru == 0) {
      kalinlik = 3;
    } else if (parcaTuru == 1) {
      kalinlik = 2;
    } else if (parcaTuru == 2) {
      kalinlik = 2;
    }

    uzunluk = 0;

    sonrakiler = new ArrayList<Parca>();
  }

  Parca(float aci, float uzunluk, float kalinlik, int parcaTuru, int enFazlaDal, ArrayList<Parca> sonrakiler) {
    this.aci = aci;
    this.uzunluk = uzunluk;
    this.kalinlik = kalinlik;
    this.parcaTuru = parcaTuru;
    this.enFazlaDal = enFazlaDal;
    this.sonrakiler = sonrakiler;
  }

  void ciz(PVector bas) {
    if (bas.x <= width && bas.y <= height) {

      if (parcaTuru == 0) {
        stroke(#5D2D17);
      } else if (parcaTuru == 1) {
        stroke(#B47A4C);
      } else if (parcaTuru == 2) {
        stroke(#53BF59);
      }

      strokeWeight(kalinlik);
      line(bas.x, bas.y, bas.x + cos(aci) * uzunluk, bas.y + sin(aci) * uzunluk);

      for (int i = 0; i < sonrakiler.size(); i++) {
        sonrakiler.get(i).ciz(new PVector(bas.x + cos(aci) * uzunluk, bas.y + sin(aci) * uzunluk));
      }
    }
  }

  void buyu(PVector bas, float hiz) {
    if (bas.x <= width && bas.y <= height) {
      if (parcaTuru == 0) {
        uzunluk += 0.1f * hiz;
        kalinlik += 0.001f;

        if (enFazlaDal > sonrakiler.size()) {
          if (random(1f) >= 0.99f) {
            dallan();
          }
        }

        if (random(1f) >= 0.999f) {
          bolun();
        }
      } else if (parcaTuru == 1) {
        uzunluk += 0.01f * hiz;
        kalinlik += 0.0004f;

        if (enFazlaDal > sonrakiler.size()) {
          if (random(1f) >= 0.999f) {
            dallan();
          }
        }

        if (random(1f) >= 0.999f) {
          bolun();
        }
      } else if (parcaTuru == 2) {
        uzunluk += 0.02f * hiz;
        kalinlik += 0.0004f;

        if (uzunluk >= yesilLimit) {
          uzunluk = yesilLimit;
        }
      }

      for (int i = 0; i < sonrakiler.size(); i++) {
        sonrakiler.get(i).buyu(new PVector(bas.x + cos(aci) * uzunluk, bas.y + sin(aci) * uzunluk), hiz*0.99);
      }
    }
  }

  void dallan() {
    if (parcaTuru == 0) {
      if (random(1f) >= 0.9f) {
        sonrakiler.add(new Parca(random(-PI*0.8, -PI*0.2), 0, max(enFazlaDal - 1, 2)));
      } else if (random(1f) >= 0.4f) {
        sonrakiler.add(new Parca(random(-PI*0.8, -PI*0.2), 1, max(enFazlaDal - 1, 2)));
      } else {
        sonrakiler.add(new Parca(random(-PI*0.8, -PI*0.2), 2, max(enFazlaDal - 1, 2)));
      }
    } else if (parcaTuru == 1) {
      if (random(1f) >= 0.9f) {
        sonrakiler.add(new Parca(random(-PI*0.8, -PI*0.2), 1, max(enFazlaDal - 1, 2)));
      } else {
        sonrakiler.add(new Parca(random(-PI*0.8, -PI*0.2), 2, max(enFazlaDal - 1, 2)));
      }
    }
  }

  void bolun() {
    float bolunmeMesafesi = random(0, uzunluk);
    float yeniUzunluk = uzunluk - bolunmeMesafesi;
    uzunluk = bolunmeMesafesi;

    Parca yeniParca = new Parca(aci, yeniUzunluk, kalinlik, parcaTuru, enFazlaDal, (ArrayList<Parca>) sonrakiler.clone());
    sonrakiler.clear();
    sonrakiler.add(yeniParca);

    enFazlaDal += 5f;

    dallan();
  }
}
