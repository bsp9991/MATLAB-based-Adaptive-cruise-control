#include <LiquidCrystal.h>// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(7,6,5,4,3,2);
#define trigPin 13
#define echoPin 12

int max_speed=100;
int initial_speed=0;
int current_speed;
int ACC_speed;

void setup() 
{
  pinMode(A4,INPUT);
  pinMode(A3,INPUT);
  pinMode(A2,INPUT);
  pinMode(A1,INPUT);
  pinMode(A0,INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  current_speed=initial_speed;
  lcd.begin(32, 2);  
  lcd.setCursor (0,0);
  lcd.print("ADAPTIVE CRUISE ");
  lcd.setCursor (0,1);
  lcd.print("CONTROL SYSTEM ");
  delay (2000);
  lcd.clear();
}


void display_lcd(int str2)
{
lcd.begin(32, 2);  
lcd.setCursor (0,0);
lcd.print(" Mode = CRUISE");
lcd.setCursor (0,1);
lcd.print(" Speed= ");
lcd.print(str2);
}


void decay_speed(int str2)
{
  if(current_speed>0&&current_speed<=100)
      {
        current_speed=current_speed-1;
      }
  lcd_display_normal(current_speed);
  delay(1000);
}
void lcd_display_normal(int str2)
{
  lcd.begin(32, 2);  
  lcd.setCursor (0,0);
  lcd.print(" Mode = NORMAL");
  lcd.setCursor (0,1);
  lcd.print(" Speed= ");
  lcd.print(current_speed);
}
void lcd_display_ACC(int str2)
{
  lcd.begin(32, 2);  
  lcd.setCursor (0,0);
  lcd.print("Mode=ADAPTIVE CRUISE");
  lcd.setCursor (0,1);
  lcd.print("Speed= ");
  lcd.print(current_speed);
}
void loop() 
{
  while(digitalRead(A1)==LOW)
  {
    if(current_speed>=0&&current_speed<=100)
      {
        current_speed=current_speed+1;
        delay(500);
        lcd_display_normal(current_speed);
      }
  }
  while(digitalRead(A0)==LOW)
  {
    if(current_speed>=0&&current_speed<=100)
      {
        current_speed=current_speed-1;
        delay(500);
        lcd_display_normal(current_speed);
      }
  }
  if(digitalRead(A4)==LOW)
  {
    while(digitalRead(A2)!=LOW)
    {
      display_lcd(current_speed);
      delay(500);
      while(digitalRead(A1)==LOW)
      {
        if(current_speed>=0&&current_speed<=100)
        {
          current_speed=current_speed+1;
          delay(500);
          display_lcd(current_speed);
        }
      }
      while(digitalRead(A0)==LOW)
      {
        if(current_speed>0&&current_speed<=100)
        {
          current_speed=current_speed-1;
          delay(500);
          display_lcd(current_speed);
        }
      }
    }
 }
 if(digitalRead(A3)==LOW)
 {
  ACC_speed=current_speed;
  while(digitalRead(A2)!=LOW)
  {
    long duration, distance;
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2); 
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    duration = pulseIn(echoPin, HIGH);
    distance = (duration/2) / 29;
    if (distance<30)
    {
      if(current_speed>0&&current_speed<=100)
      {
        current_speed=current_speed-1;
      }
      lcd_display_ACC(current_speed);
      delay(500);
    }
    if (distance>30 && current_speed!=ACC_speed)
    {
      if(current_speed>=0&&current_speed<=ACC_speed)
      {
        current_speed=current_speed+1;
        delay(500);
        lcd_display_ACC(current_speed);
      }
    }
    delay(500);
    lcd_display_ACC(current_speed);
  }
 }
  if(digitalRead(A1)!=LOW || digitalRead(A0)!=LOW)
  {
    decay_speed(current_speed);
  }
 
}
