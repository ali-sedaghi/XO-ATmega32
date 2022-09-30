#include <mega32.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>

#define ROUNDS 3

#define gled1 PORTC.0
#define gled2 PORTC.1
#define gled3 PORTC.2
#define gled4 PORTC.3
#define gled5 PORTC.4
#define gled6 PORTC.5
#define gled7 PORTC.6
#define gled8 PORTC.7
#define gled9 PORTB.6

#define rled1 PORTD.0
#define rled2 PORTD.1
#define rled3 PORTD.2
#define rled4 PORTD.3
#define rled5 PORTD.4
#define rled6 PORTD.5
#define rled7 PORTD.6
#define rled8 PORTD.7
#define rled9 PORTB.7


int pressed[9];
int c=0;
bit player=0;


int read_key()
{
int i=0;
DDRB =0b11000111;
PORTB=(PORTB.7<<7)|(PORTB.6<<6)|(0b111111);

while(i==0)
 {
  PORTB.0=0;
  delay_ms(1);
       if(PINB.3==0){i=1;break;} 
  else if(PINB.4==0){i=4;break;}
  else if(PINB.5==0){i=7;break;} 
  PORTB.0=1; 
  PORTB.1=0;
  delay_ms(1);
       if(PINB.3==0){i=2;break;} 
  else if(PINB.4==0){i=5;break;}
  else if(PINB.5==0){i=8;break;} 
  PORTB.1=1;  
  PORTB.2=0;
  delay_ms(1);
       if(PINB.3==0){i=3;break;} 
  else if(PINB.4==0){i=6;break;}
  else if(PINB.5==0){i=9;break;} 
  PORTB.2=1;
 }             
 
delay_ms(50);
return i;
}

int check_key(int n)
{
int i=0;
for(i=0;i<9;i++)
 {
 if(n==pressed[i])
 return 0;
 }  
pressed[c]=n; 
c++; 
return n;
}

void clear()
{
int i=0;
gled9=0;
rled9=0;
delay_ms(100);
gled8=0;
rled8=0;
delay_ms(100);
gled7=0;
rled7=0;
delay_ms(100);
gled4=0;
rled4=0;
delay_ms(100);
gled5=0;
rled5=0;
delay_ms(100);
gled6=0;
rled6=0;
delay_ms(100);
gled3=0;
rled3=0;
delay_ms(100);
gled2=0;
rled2=0;
delay_ms(100);
gled1=0;
rled1=0;
c=0;
for(i=0;i<9;i++)
 {
  pressed[i]=0; 
 }
}

void main(void)
{
// Declare your local variables here
int key,i,p1=0,p2=0;
char lcd_b[32];
int hasAi = 0;

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);

hasAi = PINA & (1 << PINA3);
for(i=1;i<=ROUNDS;i++)
 {
                                 
 lcd_clear();
 sprintf(lcd_b,"Level %1d/%d    %d-%d",i,ROUNDS,p1,p2); 
 lcd_gotoxy(0,0);
 lcd_puts(lcd_b);
 while (1)
      {            
      lcd_gotoxy(0,1);

        if(player==1){
            lcd_puts("Player RED     ");
        } else{
            lcd_puts("Player GREEN     ");
        }

      if (player || !hasAi){
          key=check_key(read_key());
      } else {
          key = -1;
      }
      if(key!=0)
       {
       if(player==0)
        {
            if (hasAi){

                int shouldContinue = 1;
                key = ((rand() + 5) % 9) + 1;
                while(shouldContinue){
                    if (key==0){
                        key=9; 
                    }
                    switch(key)
                    { 
                      case 1:
                        if (gled1 || rled1){
                            key--;
                            break;
                        }
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled1=1;
                        break;
                      case 2:
                        if (gled2 || rled2){
                            key--;
                            break;
                        }
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled2=1;
                        break;
                      case 3:
                        if (gled3 || rled3){
                            key--;
                            break;
                        }             
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled3=1;
                        break;
                      case 4:
                        if (gled4 || rled4) {
                            key--;
                            break;
                        }             
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled4=1;
                        break;
                      case 5:
                        if (gled5 || rled5) {
                            key--;
                            break;
                        }              
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled5=1;
                        break;
                      case 6:
                        if (gled6 || rled6) {
                            key--;
                            break;
                        }              
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled6=1;
                        break;
                      case 7:
                        if (gled7 || rled7) {
                            key--;
                            break;
                        }
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled7=1;
                        break;
                      case 8:
                        if (gled8 || rled8) {
                            key--;
                            break;
                        }              
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled8=1;
                        break;
                      case 9:
                        if (gled9 || rled9) {
                            key--;
                            break;
                        }              
                        check_key(key);
                        shouldContinue = 0;
                        delay_ms(700);
                        gled9=1;
                        break;
                    }

                }

            } else {
                 switch(key)
                 {
                  case 1:gled1=1;break;
                  case 2:gled2=1;break;
                  case 3:gled3=1;break;
                  case 4:gled4=1;break;
                  case 5:gled5=1;break;
                  case 6:gled6=1;break;
                  case 7:gled7=1;break;
                  case 8:gled8=1;break;
                  case 9:gled9=1;break;
                 }
            }
        }
       else {
            switch(key)
             { 
              case 1:rled1=1;break;
              case 2:rled2=1;break;
              case 3:rled3=1;break;
              case 4:rled4=1;break;
              case 5:rled5=1;break;
              case 6:rled6=1;break;
              case 7:rled7=1;break;
              case 8:rled8=1;break;
              case 9:rled9=1;break;
             }
        }
       //--------------------------------- 
       if(gled1&&gled2&&gled3)
        { 
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!");  
         
        delay_ms(300);
        gled1=0;
        gled2=0;
        gled3=0;
        delay_ms(300);
        gled1=1;
        gled2=1;
        gled3=1;
        delay_ms(300);
        gled1=0;
        gled2=0;
        gled3=0;
        delay_ms(300);
        gled1=1;
        gled2=1;
        gled3=1;
        delay_ms(300); 
         
        clear();  
        break;
        }
       else if(gled4&&gled5&&gled6)
        { 
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!"); 
         
        delay_ms(300);
        gled4=0;
        gled5=0;
        gled6=0;
        delay_ms(300);
        gled4=1;
        gled5=1;
        gled6=1;
        delay_ms(300);
        gled4=0;
        gled5=0;
        gled6=0;
        delay_ms(300);
        gled4=1;
        gled5=1;
        gled6=1;
        delay_ms(300); 
         
        clear(); 
        break;
        }
       else if(gled7&&gled8&&gled9)
        { 
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!"); 
         
        delay_ms(300);
        gled7=0;
        gled8=0;
        gled9=0;
        delay_ms(300);
        gled7=1;
        gled8=1;
        gled9=1;
        delay_ms(300);
        gled7=0;
        gled8=0;
        gled9=0;
        delay_ms(300);
        gled7=1;
        gled8=1;
        gled9=1;
        delay_ms(300);
         
        clear();  
        break;
        }
       else if(gled1&&gled4&&gled7)
        { 
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!"); 
         
        delay_ms(300);
        gled1=0;
        gled4=0;
        gled7=0; 
        delay_ms(300);
        gled1=1;
        gled4=1;
        gled7=1;
        delay_ms(300);
        gled1=0;
        gled4=0;
        gled7=0;
        delay_ms(300);
        gled1=1;
        gled4=1;
        gled7=1;
        delay_ms(300);
         
        clear();  
        break;
        }
       else if(gled2&&gled5&&gled8)
        {   
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!"); 
         
        delay_ms(300);
        gled2=0;
        gled5=0;
        gled8=0;
        delay_ms(300);
        gled2=1;
        gled5=1;
        gled8=1;
        delay_ms(300);
        gled2=0;
        gled5=0;
        gled8=0;
        delay_ms(300);
        gled2=1;
        gled5=1;
        gled8=1;
        delay_ms(300);
          
        clear();  
        break;
        }
       else if(gled3&&gled6&&gled9)
        {  
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!"); 
         
        delay_ms(300);
        gled3=0;
        gled6=0;
        gled9=0; 
        delay_ms(300);
        gled3=1;
        gled6=1;
        gled9=1;
        delay_ms(300);
        gled3=0;
        gled6=0;
        gled9=0;
        delay_ms(300);
        gled3=1;
        gled6=1;
        gled9=1;
        delay_ms(300);
         
        clear(); 
        break;
        } 
        else if(gled1&&gled5&&gled9)
        {  
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!"); 
         
        delay_ms(300);
        gled1=0;
        gled5=0;
        gled9=0;
        delay_ms(300);
        gled1=1;
        gled5=1;
        gled9=1;
        delay_ms(300);
        gled1=0;
        gled5=0;
        gled9=0;
        delay_ms(300);
        gled1=1;
        gled5=1;
        gled9=1;
        delay_ms(300); 
         
        clear();  
        break;
        }
       else if(gled3&&gled5&&gled7)
        { 
        p1++; 
        lcd_clear();
        lcd_puts("Player GREEN Win..!"); 
         
        delay_ms(300);
        gled3=0;
        gled5=0;
        gled7=0;
        delay_ms(300);
        gled3=1;
        gled5=1;
        gled7=1;
        delay_ms(300);
        gled3=0;
        gled5=0;
        gled7=0;
        delay_ms(300);
        gled3=1;
        gled5=1;
        gled7=1;
        delay_ms(300);  
         
        clear();  
        break;
        }
       //-------------------------------------------------
       if(rled1&&rled2&&rled3)
        {
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
         
        delay_ms(300);
        rled1=0;
        rled2=0;
        rled3=0;
        delay_ms(300);
        rled1=1;
        rled2=1;
        rled3=1;
        delay_ms(300);
        rled1=0;
        rled2=0;
        rled3=0;
        delay_ms(300);
        rled1=1;
        rled2=1;
        rled3=1;
        delay_ms(300);
         
        clear(); 
        break;
        }
       else if(rled4&&rled5&&rled6)
        {
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
        delay_ms(300);
        rled4=0;
        rled5=0;
        rled6=0; 
        delay_ms(300);
        rled4=1;
        rled5=1;
        rled6=1;
        delay_ms(300);
        rled4=0;
        rled5=0;
        rled6=0;
        delay_ms(300);
        rled4=1;
        rled5=1;
        rled6=1;
        delay_ms(300);   

        clear(); 
        break;
        }
       else if(rled7&&rled8&&rled9)
        { 
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
        delay_ms(300);
        rled7=0;
        rled8=0;
        rled9=0;  
        delay_ms(300);
        rled7=1;
        rled8=1;
        rled9=1; 
        delay_ms(300);
        rled7=0;
        rled8=0;
        rled9=0; 
        delay_ms(300);
        rled7=1;
        rled8=1;
        rled9=1;
        delay_ms(300); 
         
        clear(); 
        break;
        }
       else if(rled1&&rled4&&rled7)
        {   
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
        delay_ms(300);
        rled1=0;
        rled4=0;
        rled7=0; 
        delay_ms(300);
        rled1=1;
        rled4=1;
        rled7=1;
        delay_ms(300);
        rled1=0;
        rled4=0;
        rled7=0;
        delay_ms(300);
        rled1=1;
        rled4=1;
        rled7=1;
        delay_ms(300);  
         
        clear(); 
        break;
        }
       else if(rled2&&rled5&&rled8)
        { 
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
        delay_ms(300);
        rled2=0;
        rled5=0;
        rled8=0; 
        delay_ms(300);
        rled2=1;
        rled5=1;
        rled8=1; 
        delay_ms(300);
        rled2=0;
        rled5=0;
        rled8=0; 
        delay_ms(300);
        rled2=1;
        rled5=1;
        rled8=1;
        delay_ms(300); 
         
        clear(); 
        break;
        }
       else if(rled3&&rled6&&rled9)
        {  
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
        delay_ms(300);
        rled3=0;
        rled6=0;
        rled9=0;  
        delay_ms(300);
        rled3=1;
        rled6=1;
        rled9=1;
        delay_ms(300);
        rled3=0;
        rled6=0;
        rled9=0;
        delay_ms(300);
        rled3=1;
        rled6=1;
        rled9=1;
        delay_ms(300);
         
        clear(); 
        break;
        }
       else if(rled1&&rled5&&rled9)
        {   
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
        delay_ms(300);
        rled1=0;
        rled5=0;
        rled9=0; 
        delay_ms(300);
        rled1=1;
        rled5=1;
        rled9=1;
        delay_ms(300);
        rled1=0;
        rled5=0;
        rled9=0;
        delay_ms(300);
        rled1=1;
        rled5=1;
        rled9=1;
        delay_ms(300);
         
        clear(); 
        break;
        }
       else if(rled7&&rled5&&rled3)
        {
        p2++; 
        lcd_clear();
        lcd_puts("Player RED Win..!"); 
         
        delay_ms(300);
        rled7=0;
        rled5=0;
        rled3=0;   
        delay_ms(300);
        rled7=1;
        rled5=1;
        rled3=1;
        delay_ms(300);
        rled7=0;
        rled5=0;
        rled3=0;
        delay_ms(300);
        rled7=1;
        rled5=1;
        rled3=1;
        delay_ms(300);
         
        clear(); 
        break;
        }
        
       //------------------------------------------------- 
        
       player=~player;
       if(c==9)
        {
        delay_ms(1000);
        lcd_gotoxy(0,1);
        lcd_puts("Reseting...");
        clear();
        }
       }

      } 
 player=~player;     
 }

lcd_clear();
sprintf(lcd_b,"Player GREEN: %d", p1);
lcd_gotoxy(0,0);
lcd_puts(lcd_b); 
sprintf(lcd_b, "Player RED: %d", p2);
lcd_gotoxy(0,1);
lcd_puts(lcd_b); 
 
}
