void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(2, INPUT);  //next_in
  pinMode(3, OUTPUT); //data_in[0]
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);  //data_in[7]
  pinMode(11, OUTPUT); //rst
}

void bin_write(int num)
{
  int iter;
  int temp;
  int arr[8];
  if(num<0)
  {
    int temp = -num-1;
    for(iter = 0; iter<8; iter++)
    {
      arr[7-iter] = 1-(temp%2);
      temp = temp/2;
    }
    
  }
  else
  {
    temp = num;
    for(iter = 0; iter<8; iter++)
    {
      arr[7-iter] = temp%2;
      temp = temp/2;
    }
  }

  for(iter = 0; iter<8; iter++)
  {
    digitalWrite(3+iter, arr[7-iter]);
  }
}

int count;
int start = 0;
int start1 = 0;

void loop() {
    if(start1==0)
    {
      digitalWrite(11, 1);
      delay(15000);
      digitalWrite(11, 0);
      start1 = 1;
    }

    while(digitalRead(2)!=1);

    if(start==0)
    {
      delay(500);
      start = 1;
    }
    bin_write(count);
    count++;
    if(count==10) count = 0;
    Serial.println(count);
    delay(7000);
  // put your main code here, to run repeatedly:

}
