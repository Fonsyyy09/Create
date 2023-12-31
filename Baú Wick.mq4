//+------------------------------------------------------------------+
//|                                 WickPercentage_arrow_options.mq4 |
//|                                                              cja |
//+------------------------------------------------------------------+

#property copyright   "Baú de Tesouro"
#property description "GRATUITO! SE VENDEREM A VOCÊ, PEÇA DINHEIRO DE VOLTA, TRATA-SE DE UM GOLPISTA DESOCUPADO E PREGUIÇOSO"
#property description "APENAS PARA M5 E 15, NÃO SEREI RESPONSÁVEL POR SUA TEIMOSIA SE PÔR NO M1"
#property strict


#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Red
#property indicator_color2 Lime
#property indicator_color3 clrNONE //Gold
#property indicator_color4 clrNONE // Aqua
#property indicator_width1 1
#property indicator_width2 1
#property indicator_width3 0
#property indicator_width4 0

extern double percentage            = 10;
extern bool  ShowHiLowPercentage    = true;
extern int    ArrowsHiLoUpCode      = 233;
extern int    ArrowsHiLoDownCode    = 234;
extern double ArrowHiLoOffset       = 0.50;

extern bool  ShowHighPercentage     = false;
extern int   ArrowsHighPercentage   = 233;
extern double ArrowHighOffset       = 1.25;
extern bool  ShowLowPercentage      = false;
extern int   ArrowsLowPercentage    = 234;
extern double ArrowLowOffset        = 1.25;

double buffer1[];
double buffer2[];
double buffer3[];
double buffer4[];


double myPoint;
   double SetPoint() 
   { double mPoint; 
   if (Digits < 4) 
   mPoint = 0.01; 
   else
   mPoint = 0.0001; 
   return(mPoint); 
   } 

int init() {
   myPoint = SetPoint();
   IndicatorBuffers(4);
   
   SetIndexBuffer(0, buffer1);     
   if(ShowHiLowPercentage){SetIndexStyle(0, DRAW_ARROW);}
   else{SetIndexStyle(0, DRAW_NONE);}
   SetIndexArrow(0, ArrowsHiLoDownCode);
   SetIndexLabel(0,"High Low down percentage");
   
   SetIndexBuffer(1, buffer2);     
   if(ShowHiLowPercentage){SetIndexStyle(1, DRAW_ARROW);}
   else{SetIndexStyle(1, DRAW_NONE);}
   SetIndexArrow(1, ArrowsHiLoUpCode);
   SetIndexLabel(1,"High Low up percentage");
   
   SetIndexBuffer(2, buffer3);     
   if(ShowHighPercentage){SetIndexStyle(2, DRAW_ARROW);}
   else{SetIndexStyle(2, DRAW_NONE);}
   SetIndexArrow(2, ArrowsLowPercentage);
   SetIndexLabel(2,"Low Percentage");
   
   SetIndexBuffer(3, buffer4);     
   if(ShowLowPercentage){SetIndexStyle(3, DRAW_ARROW);}
   else{SetIndexStyle(3, DRAW_NONE);}
   SetIndexArrow(3, ArrowsHighPercentage);
   SetIndexLabel(3,"High Percentage");
   
   
   
   IndicatorShortName("WickPercentage arrow options");
   
         
   return(0);
}
  
int deinit() { return(0);}
     
int start() {
    
   int counted_bars=IndicatorCounted();
  
   if(counted_bars < 0) 
       return(-1);
   if(counted_bars > 0) 
       counted_bars--;
       
   int limit = Bars - counted_bars;     
      
   for(int i = limit; i >= 0; i--) {

      int shift = iBarShift(Symbol(), 0, Time[i], true);     
          
      buffer1[i] = 0;
      buffer2[i] = 0;  
      buffer3[i] = 0;
      buffer4[i] = 0;      
          
      double close = iClose(Symbol(),0,shift);
      double open  = iOpen(Symbol(),0,shift);
      double high  = iHigh(Symbol(),0,shift);
      double low   = iLow(Symbol(),0,shift);
 
      double bodysize = MathAbs(open-close)/myPoint; 
      double percent = (bodysize/100)*percentage;
            
      if(open>close && ((high-open)/myPoint < percent) && ((close-low)/myPoint < percent) ){  
         buffer1[i] = high+ArrowHiLoOffset*myPoint;      
         
      }
      if(open<close && ((high-close)/myPoint < percent) && ((open-low)/myPoint < percent) ){  
         buffer2[i] = low-ArrowHiLoOffset*myPoint;   
           
      }
      
       if((open>close && ((high-open)/myPoint < percent)) || (open<close && ((high-close)/myPoint < percent))){  
         buffer3[i] = high+ArrowHighOffset*myPoint;      
         
      }
      
       if((open<close && ((open-low)/myPoint < percent)) || (open>close && ((close-low)/myPoint < percent))){  
         buffer4[i] = low-ArrowLowOffset*myPoint;      
         
      }
    } 
   return(0);
 }

