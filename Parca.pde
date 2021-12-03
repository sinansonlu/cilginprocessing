int maksimumParcaSayisi = 1000;
int aktifParcaSayisi = 0;

float[] veri;
int veriBoyutu;

final int parcaBasiVeriSayisi = 8;
final int X = 0;
final int Y = 1;
final int VX = 2;
final int VY = 3;
final int R = 4;
final int CR = 5;
final int CG = 6;
final int CB = 7;

private int tmp, tmpx, tmpy, tmpi;

final int EX = 500;
final int EY = 500;

// grid sabitleri
int gridBasiVeriSayisi = 5;

final int G_VX = 0;
final int G_VY = 1;
final int G_CR = 2;
final int G_CG = 3;
final int G_CB = 4;

float[] grid;

int grid_x = 9;
int grid_y = 9;

float grid_w;
float grid_h;

float gucEtkiKatSayisi = 0.05;
float renkEtkiKatSayisi = 0.02;

void setup() {
  grid_w = float(EX) / float(grid_x);
  grid_h = float(EY) / float(grid_y);
  
  grid = new float[grid_x*grid_y*gridBasiVeriSayisi];
  
  for(int i = 0; i < grid_x*grid_y; i++) {
    grid[i*gridBasiVeriSayisi+G_VX] = random(-1,1);
    grid[i*gridBasiVeriSayisi+G_VY] = random(-1,1);
    grid[i*gridBasiVeriSayisi+G_CR] = random(0,255);
    grid[i*gridBasiVeriSayisi+G_CG] = random(0,255);
    grid[i*gridBasiVeriSayisi+G_CB] = random(0,255);
  }
  
  veriBoyutu = maksimumParcaSayisi * parcaBasiVeriSayisi;
  veri = new float[veriBoyutu];
  
  int eklenecekParcaSayisi = maksimumParcaSayisi;
  
  for(int i = 0; i < eklenecekParcaSayisi; i++) {
    tmp = aktifParcaSayisi * parcaBasiVeriSayisi;
    veri[tmp+X] = (random(0,500));
    veri[tmp+Y] = (random(0,500));
    veri[tmp+VX] = (random(-3,3));
    veri[tmp+VY] = (random(-3,3));
    veri[tmp+R] = (random(4,12));
    veri[tmp+CR] = (random(10,255));
    veri[tmp+CG] = (random(10,255));
    veri[tmp+CB] = (random(10,255));
    
    aktifParcaSayisi++;
  }
  
  
  size(500, 500,P2D);
  background(0);
  noStroke();
  fill(200);
}

void draw() {
  // zemini çiz
  // background(0);
  // yarı saydam bir zemin kullanarak parçacıkların arkasından iz bırakmak için:
  fill(0,10);
  rect(0,0,EX,EY);
  
  // grid bilgileri
  strokeWeight(1);
  noFill();
  stroke(150);
  for(int i = 0; i < grid_y; i++) {
    line(0,grid_h*i,EX,grid_h*i);
  }
  
  for(int i = 0; i < grid_x; i++) {
    line(grid_w*i,0,grid_w*i,EY);
  }

  strokeWeight(3);
  for(int i = 0; i < grid_x*grid_y; i++) {
    tmpx = i % grid_x;
    tmpy = i / grid_x;
    
    stroke(grid[i*gridBasiVeriSayisi+G_CR],grid[i*gridBasiVeriSayisi+G_CG],grid[i*gridBasiVeriSayisi+G_CB]);
    
    tmpx = int(tmpx*grid_w+grid_w/2);
    tmpy = int(tmpy* grid_h+grid_h/2);
    line(tmpx, tmpy, tmpx+grid[i*gridBasiVeriSayisi+G_VX]*20, tmpy+grid[i*gridBasiVeriSayisi+G_VY]*20);
  }
  noStroke();
  
  // parçacıklar
  for(int i = 0; i < aktifParcaSayisi; i++) {
    tmp = i*parcaBasiVeriSayisi;
    
    // kuvvet değişiklikleri
    // kuvvet azalması
    veri[tmp+VX] = veri[tmp+VX] * 0.99;
    veri[tmp+VY] = veri[tmp+VY] * 0.99;
    
    // kuvvet ekleme
    // hangi hücrede olduğunu bul
    tmpx = int(veri[tmp+X] / grid_w);
    tmpy = int(veri[tmp+Y] / grid_h);
    
    // hücre dışına taşmalarla ilgili
    if(tmpx < 0) tmpx = 0;
    if(tmpy < 0) tmpy = 0;
    if(tmpx >= grid_x) tmpx = grid_x - 1;
    if(tmpy >= grid_y) tmpy = grid_y - 1;
    
    // hücreye göre kuvvet değiştir
    tmpi = (grid_x * tmpy + tmpx) * gridBasiVeriSayisi;
    veri[tmp+VX] += grid[tmpi+G_VX] * gucEtkiKatSayisi;
    veri[tmp+VY] += grid[tmpi+G_VY] * gucEtkiKatSayisi;
    
    // hücreye göre renk değişimi
    veri[tmp+CR] = lerp(veri[tmp+CR], grid[tmpi+G_CR], renkEtkiKatSayisi);
    veri[tmp+CG] = lerp(veri[tmp+CG], grid[tmpi+G_CG], renkEtkiKatSayisi);
    veri[tmp+CB] = lerp(veri[tmp+CB], grid[tmpi+G_CB], renkEtkiKatSayisi);
    
    // hareket ettir
    veri[tmp+X] = veri[tmp+X] + veri[tmp+VX];
    veri[tmp+Y] = veri[tmp+Y] + veri[tmp+VY];
    
    // ekran dışına çıkma mantığı
    if(veri[tmp+X] + veri[tmp+R] < 0) veri[tmp+X] = EX;
    if(veri[tmp+Y] + veri[tmp+R] < 0) veri[tmp+Y] = EY;
    if(veri[tmp+X] - veri[tmp+R] > EX) veri[tmp+X] = 0;
    if(veri[tmp+Y] - veri[tmp+R] > EY) veri[tmp+Y] = 0;
    
    // ekrana çiz
    fill(veri[tmp+CR], veri[tmp+CG], veri[tmp+CB]);
    circle(veri[tmp+X], veri[tmp+Y], veri[tmp+R]); 
  }
  
}
