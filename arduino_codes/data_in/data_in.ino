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
    int opcode, op_A, op_B, carry_in, borrow_in;
    opcode = Serial.parseInt();
    op_A = Serial.parseInt();
    op_B = Serial.parseInt();
    carry_in = Serial.parseInt();
    borrow_in = Serial.parseInt();
    /*Serial.println(opcode);
    Serial.println(op_A);
    Serial.println(op_B);
    Serial.println(carry_in);
    Serial.println(borrow_in);
    */
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
    
    bin_write(opcode);
    count++;
    if(count==10) count = 0;
    Serial.print("opcode : ");
    Serial.println(opcode);
    delay(1000);

        bin_write(op_A);
    count++;
    if(count==10) count = 0;
    Serial.print("op_A : ");
    Serial.println(op_A);
    delay(1000);

        bin_write(op_B);
    count++;
    if(count==10) count = 0;
    Serial.print("op_B : ");
    Serial.println(op_B);
    delay(1000);

        bin_write(carry_in);
    count++;
    if(count==10) count = 0;
    Serial.print("carry_in : ");
    Serial.println(carry_in);
    delay(1000);

        bin_write(borrow_in);
    count++;
    if(count==10) count = 0;
    Serial.print("borrow_in : ");
    Serial.println(borrow_in);
    Serial.println("*****************");
    delay(1000);
}
