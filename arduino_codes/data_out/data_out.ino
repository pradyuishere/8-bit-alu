#include<LiquidCrystal.h>

LiquidCrystal lcd(16, 15, 14, 13, 12, 11);

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  lcd.begin(16, 2);
  pinMode(2, INPUT);  //data_out
  pinMode(3, INPUT); //data_out[0]
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  pinMode(6, INPUT);
  pinMode(7, INPUT);
  pinMode(8, INPUT);
  pinMode(9, INPUT);
  pinMode(10, INPUT);  //data_out[7]
}

int arr[8];

int get_int()
{
  int sum=0;
  int neg = 0;
  for(int iter=0; iter<8; iter++)
  {
    arr[7-iter] = digitalRead(iter+3);
    //Serial.print(arr[7-iter]);
  }
  //Serial.println();
    
  if(arr[0] == 1)
  {
    neg = 1;
    for(int iter = 0; iter<8; iter++)
    {
      arr[7-iter] = 1-arr[7-iter];
    }
  }

  for(int iter = 0; iter<8; iter++)
  {
    sum+=(1<<iter)*arr[7-iter];
  }

  if(neg==1)
  {
    return -sum-1;
  }
  return sum;
}

void loop() {
  while(digitalRead(2)!=0);
  int num;
  
  num = get_int();
  Serial.print("result_out : ");
  Serial.println(num);
  lcd.print("result : ");
  lcd.print(num);
  delay(990);
  lcd.clear();
  delay(10);


  num = get_int();
  Serial.print("borrow_out: ");
  Serial.println(num);
  lcd.print("borrow_out : ");
  lcd.print(num);
  delay(990);
  lcd.clear();
  delay(10);


  num = get_int();
  Serial.print("carry_out : ");
  Serial.println(num);
  lcd.print("carry_out : ");
  lcd.print(num);
  delay(990);
  lcd.clear();
  delay(10);


  num = get_int();
  Serial.print("zero : ");
  Serial.println(num);
  lcd.print("zero : ");
  lcd.print(num);
  delay(990);
  lcd.clear();
  delay(10);


  num = get_int();
  Serial.print("negative : ");
  Serial.println(num);
  lcd.print("negative : ");
  lcd.print(num);
  delay(990);
  lcd.clear();
  delay(10);


  num = get_int();
  Serial.print("overflow : ");
  Serial.println(num);
  lcd.print("overflow : ");
  lcd.print(num);
  delay(990);
  lcd.clear();
  delay(10);


  num = get_int();
  Serial.println("*********");
  lcd.print("**********");
  delay(500);
  lcd.clear();
  delay(10);

}
