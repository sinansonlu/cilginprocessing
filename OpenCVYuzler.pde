import gab.opencv.*;
import java.awt.Rectangle;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;

OpenCV opencv;

ArrayList<PImage> resimler = new ArrayList<PImage>();
ArrayList<Rectangle[]> yuzler = new ArrayList<Rectangle[]>();

// görsel araması için kullandığımız terimler
String searchTerm = "portrait photo";

int offset = 0;
String fileSize = "10mp";
String source = null;  

void setup() {
  size(400, 400);

  getImages();

  // her seferinde 20 görsel alabildiğimiz için offset'e 20 ekleyerek getImages fonksiyonunu tekrar çağrıyoruz
  offset = 20;
  getImages();

  offset = 40;
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

        // bu resim üzerinden OpenCV objesi tanımla
        opencv = new OpenCV(this, img);

        // öne bakan yüzleri tespit etmek için kullanılan sistemi yükle
        opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

        // yüzleri tespit et, her yüz bir Rectangle objesi olarak belirlenir
        // eğer yüz tespit edilemezse bu array boş olacaktır
        Rectangle[] faces = opencv.detect();

        // bu array'i de yüzler listesine ekliyoruz
        yuzler.add(faces);
      }
    }
  }
}

// ekrana çizdiğimiz resim bu indekste yer alan
int indeks = 0;

void draw() {
  // arka alanı tekrar çizmezsek resim değiştirirken eskilerinin izi kalabilir
  background(0, 0, 0);

  // kaçıncı resimde olduğumuzu göstermek için
  textSize(20);
  fill(255);
  text(""+ indeks + "/" + resimler.size(), 260, 30);

  // resmin kendisini çiz
  image(resimler.get(indeks), 0, 0);

  // ve içinde tespit edilen yüzleri çiz, bunun için içi boş çizgi seçiyoruz
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);

  // mevcut resim için bulunan yüzler array'ini al
  Rectangle[] faces = yuzler.get(indeks);

  // bu array'deki her dikdörtgen için, ekrana bir çerçeve çiz
  for (int i = 0; i < faces.length; i++) {

    // çerçeveyi bu kod çiziyor
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    // burada ise yüze ait piksellerden yeni bir görsel tanımlıyoruz
    PImage subimg = resimler.get(indeks).get(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    // ve bu görseli büyütülmüş şekilde ekrana çiziyoruz
    image(subimg, i * 100, 200, subimg.width * 2, subimg.height * 2);
  }
}

// bu kısım resimler arasında geçişi sağlamak için
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      indeks = (indeks + 1) % resimler.size();
    } else if (keyCode == DOWN) {
      indeks = max(0, (indeks - 1));
    }
  }
}
