void setup() {
  // put your setup code here, to run once:
  Serial.begin(56700);
  pinMode(2, INPUT);  //next_in
  pinMode(3, OUTPUT); //data_in[0]
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);  //data_in[7]
}

void bin_write(int num)
{
  int iter;
  int arr[8];
  if(num<0)
  {
    int temp = -num+1;
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

void loop() {

    while(digitalRead(2)!=1);

    if(start==0)
    {
      wait(500);
      start = 1;
    }
    bin_write(count);
    if(count==10) count = 0;
    Serial.println(count);
    wait(1000);
  // put your main code here, to run repeatedly:

}
