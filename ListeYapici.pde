import java.awt.Rectangle;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;

ArrayList<PImage> resimler = new ArrayList<PImage>();
ArrayList<Rectangle[]> yuzler = new ArrayList<Rectangle[]>();

// görsel araması için kullandığımız terimler
String searchTerm = "crash bandicoot ps1 cover";

int offset = 0;
String fileSize = "10mp";
String source = null;

ArrayList<EklenenOge> siralama = new ArrayList<EklenenOge>();

class EklenenOge {
  public String ad;
  public PImage resim;

  public EklenenOge(PImage resim, String ad) {
    this.ad = ad;
    this.resim = resim;
  }
}

void setup() {
  size(900, 900);
}

void gorselYukle(String aramaSozcugu, int offset) {
  this.offset = offset;
  searchTerm = aramaSozcugu;
  getImages();
}

// web sayfasının kaynak kodunu elde etmek için kullandığımız fonksiyon
void getImages() {

  // web üzerinden bilgi almanın detaylarına girmedik, ayrıntılar için şu koda bakabilirsiniz:
  // https://github.com/jeffThompson/ProcessingTeachingSketches/blob/master/AdvancedTopics/GetGoogleImageSearchURLs/GetGoogleImageSearchURLs.pde

  // terimlerin arasındaki boşluk karakteri web adresinde %20 olarak değiştirilmeli
  searchTerm = searchTerm.replaceAll(" ", "%20");

  try {
    // google resim araması yapmak için kullanacağımız url formatı
    // bu google'ın belirlediği bir format, ileride değişirse ona göre güncellemek gerekir
    URL query = new URL("http://images.google.com/images?gbv=1&start="
      + offset + "&q=" + searchTerm + "&tbs=isz:lt,islt:" + fileSize);

    HttpURLConnection urlc = (HttpURLConnection) query.openConnection();
    urlc.setInstanceFollowRedirects(true);
    urlc.setRequestProperty("User-Agent", "");
    urlc.connect();

    BufferedReader in = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
    StringBuffer response = new StringBuffer();
    char[] buffer = new char[1024];

    while (true) {

      int charsRead = in.read(buffer);
      if (charsRead == -1) {
        break;
      }
      response.append(buffer, 0, charsRead);
    }
    in.close();
    source = response.toString();
  }
  catch (Exception e) {
    e.printStackTrace();
  }

  // kaynak kodu boş değilse
  if (source != null) {

    // resim linkleri için kullanacağımız başlangıç ve bitiş indeksleri
    int start = 0;
    int end = 0;

    resimler.clear();

    // başlangıç indeksi negatif değilken devam ediyoruz
    while (start >= 0) {

      // linkin başında src=" ibaresi bulunacak
      start = source.indexOf("src=\"");

      // linkin başındaki src=" kısmını atmak için 5 karakter daha kesiyoruz
      source = source.substring(start+5);

      // linkin bitişinde " sembolü var
      end = source.indexOf("\"");

      // tırnak sembolüne kadar olan kısmı bir link olarak alıyoruz
      String imgLink = source.substring(0, end);

      // bu link üzerinden görseli yüklüyoruz
      PImage img = loadImage(imgLink+".jpg");

      // yüklenen resim boş değilse
      if (img != null) {

        // resimler listesine ekle
        resimler.add(img);
      }
    }

    resimSecimi = true;
    yukleniyorMu = false;
  }
}

// ekrana çizdiğimiz resim bu indekste yer alan
int indeks = 0;

String mevcutKelime = "";
boolean kelimeGirisi = true;
boolean resimSecimi = false;

float cizimBaslangic = 20;
float kaydirmaHizi = 25;

int potansiyelBasilmisOyunIndeksi = -1;
int basilmisOyunIndeksi = -1;
boolean oyunaBasilmisMi = false;

float sayac = 20;
boolean imlecGoster = false;
boolean yukleniyorMu = false;
boolean yuklemeEmri = false;

float maxCizimOffset = cizimBaslangic;
float aralik = 30;

void draw() {
  // arka alanı tekrar çizmezsek resim değiştirirken eskilerinin izi kalabilir
  background(0, 0, 0);

  float cizimOffset = cizimBaslangic;
  float cizimOffsetSol = 0;
  for (int i = 0; i < siralama.size(); i++) {
    image(siralama.get(i).resim, cizimOffset, 100);

    cizimOffsetSol = cizimOffset;
    cizimOffset += siralama.get(i).resim.width + aralik;
    if (oyunaBasilmisMi && basilmisOyunIndeksi == i) {
      fill(0, 255, 0);
    } else {
      if (mouseX <= cizimOffset && mouseX >= cizimOffsetSol) {
        potansiyelBasilmisOyunIndeksi = i;
        fill(255, 0, 0);
      } else {
        fill(255, 255, 255);
      }
    }

    textSize(18);
    text(""+ i + "." + siralama.get(i).ad, cizimOffsetSol, 300);
  }

  fill(255, 255, 255);
  textSize(54);
  String ekrandakiMevcutKelime = mevcutKelime;
  if (imlecGoster && kelimeGirisi) {
    ekrandakiMevcutKelime += '_';
  }
  text(ekrandakiMevcutKelime, width / 2 - 200, height / 10 * 9);

  // resmin kendisini çiz
  if (resimSecimi) {
    textSize(20);
    text(""+ indeks + "/" + resimler.size(), width / 2 - ((resimler.get(indeks)).width / 2), height / 10 * 6 + ((resimler.get(indeks)).height + 100));
    image(resimler.get(indeks), width / 2 - ((resimler.get(indeks)).width / 2), height / 10 * 6 + ((resimler.get(indeks)).height / 2));
  }

  if (yukleniyorMu) {
    textSize(56);
    text("YÜKLENİYOR...", width / 2 - 350, height / 10 * 5);
  }

  textSize(20);
  text("F1: Kaydet, F2: Yükle", width - 200, height - 26);

  sayac--;
  if (sayac < 0) {
    imlecGoster = !imlecGoster;
    sayac = 20;
  }

  if (yuklemeEmri) {
    gorselYukle(mevcutKelime, 0);
    yuklemeEmri = false;
  }
}

// bu kısım resimler arasında geçişi sağlamak için
void keyPressed() {
  if (kelimeGirisi) {
    if ((key >= '0' & key <= '9')
      || (key >= 'a' && key <= 'z')
      || (key >= 'A' && key <= 'Z') || key == ' ' || key == '-' || key == '!')
      mevcutKelime += key;
  }

  if (keyCode == ENTER) {
    if (kelimeGirisi) {
      if (!mevcutKelime.equals("")) {
        yukleniyorMu = true;
        kelimeGirisi = false;
        yuklemeEmri = true;
        indeks = 0;
        textSize(56);
        text("YÜKLENİYOR...", width / 2 - 100, height / 10 * 7);
      }
    } else {
      if (resimSecimi) {
        EklenenOge eg = new EklenenOge(resimler.get(indeks), mevcutKelime);
        siralama.add(eg);
        kelimeGirisi = true;
        mevcutKelime = "";
        resimSecimi = false;

        float cizimOffset = cizimBaslangic;
        for (int i = 0; i < siralama.size(); i++) {
          cizimOffset += siralama.get(i).resim.width + aralik;
        }
        maxCizimOffset = cizimOffset;
      }
    }
  } else if (keyCode == BACKSPACE) {
    if (mevcutKelime.length() > 0) {
      mevcutKelime = mevcutKelime.substring(0, mevcutKelime.length()-1);
    }
  } else if (keyCode == LEFT) {
    cizimBaslangic += kaydirmaHizi;
    if (cizimBaslangic > 20) {
      cizimBaslangic = 20;
    }
  } else if (keyCode == RIGHT) {
    cizimBaslangic -= kaydirmaHizi;
    if (cizimBaslangic < -maxCizimOffset + width) {
      cizimBaslangic = -maxCizimOffset + width;
    }
  } else if (keyCode == java.awt.event.KeyEvent.VK_F1) {
    kaydet();
  } else if (keyCode == java.awt.event.KeyEvent.VK_F2) {
    yukle();
  }

  if (resimSecimi) {
    if (keyCode == UP) {
      indeks = (indeks + 1) % resimler.size();
    } else if (keyCode == DOWN) {
      indeks--;
      if (indeks < 0) {
        indeks += resimler.size();
      }
    }
  }
}

void mousePressed() {
  if (oyunaBasilmisMi) {
    EklenenOge eo = siralama.get(basilmisOyunIndeksi);

    siralama.remove(basilmisOyunIndeksi);
    siralama.add(potansiyelBasilmisOyunIndeksi, eo);

    oyunaBasilmisMi = false;
  } else {
    if (potansiyelBasilmisOyunIndeksi >= 0) {
      basilmisOyunIndeksi = potansiyelBasilmisOyunIndeksi;
      oyunaBasilmisMi = true;
    }
  }
}

void kaydet() {
  ArrayList<String> stringler = new ArrayList<String>();

  for (int i = 0; i < siralama.size(); i++) {
    stringler.add(siralama.get(i).ad);
    siralama.get(i).resim.save(siralama.get(i).ad + ".jpg");
  }

  String[] strs = new String[stringler.size()];
  for (int i = 0; i < stringler.size(); i++) {
    strs[i] = stringler.get(i);
  }
  saveStrings("kayitlar.txt", strs);
  background(0, 0, 0);
}

void yukle() {
  siralama.clear();

  String[] lines = loadStrings("kayitlar.txt");
  for (int i = 0; i < lines.length; i++) {
    siralama.add(new EklenenOge(loadImage(lines[i] + ".jpg"), lines[i]));
  }

  float cizimOffset = cizimBaslangic;
  for (int i = 0; i < siralama.size(); i++) {
    cizimOffset += siralama.get(i).resim.width + aralik;
  }
  maxCizimOffset = cizimOffset;
}
