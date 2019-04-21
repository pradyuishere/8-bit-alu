void setup() {
  // put your setup code here, to run once:
  Serial.begin(56700);
  pinMode(2, INPUT);  //data_out
  pinMode(3, OUTPUT); //data_out[0]
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);  //data_out[7]
}

int arr[8];

int get_int()
{
  int sum=0;
  int neg = 0;
  for(int iter=0; iter<8; iter++)
  {
    arr[7-iter] = digitalRead(iter+3);
  }
  if(arr[10] == 1)
  {
    neg = 1;
    for(int iter = 0; iter<8; iter++)
    {
      arr[7-iter] = 1-arr[7-iter];
    }
  }

  for(int iter = 0; iter<8; iter++)
  {
    sum+=2<<iter*arr[7-iter];
  }

  if(neg==1)
  {
    return -sum-1;
  }
  return sum;
}

void loop() {
  while(digitalRead(2)!=0);
  Serial.println(str(get_int()));
  delay(1000);
  // put your main code here, to run repeatedly:

}
