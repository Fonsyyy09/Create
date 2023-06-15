//+------------------------------------------------------------------+
//|                                           rainbow oscillator.mq4 |
//|                                                           mladen |
//+------------------------------------------------------------------+
#property copyright "www.forex-station.com"
#property link      "www.forex-station.com"

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1  DimGray
#property indicator_color2  DimGray
#property indicator_color3  DeepSkyBlue
#property indicator_color4  DarkOrange
#property indicator_width3  2
#property indicator_width4  2
#property indicator_color5  Yellow
#property indicator_color6  Red

//
//
//
//
//

extern string                TimeFrame    = "Current time frame";
extern int                   RmaPeriod    = 2;
extern int                   RmaDepth     = 10;
extern ENUM_APPLIED_PRICE    RmaPrice     = PRICE_CLOSE;
input bool                   ArrowOnFirst = true;             // Arrow on first mtf bar
extern bool                  Interpolate  = true;

//
//
//
//
//

#define MAX_depth 50
double  rbUp[];
double  rbDn[];
double  rhUp[];
double  rhDn[];
double  pBuffer[][MAX_depth];
double upArr[];
double dnArr[];
double vala[];
//
//
//
//
//

int    timeFrame;
string indicatorFileName;
bool   returnBars;
bool   calculateValue;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

int init()
{
   IndicatorBuffers(7);
   SetIndexBuffer(0,rbUp);
   SetIndexBuffer(1,rbDn);
   SetIndexBuffer(2,rhUp);  SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(3,rhDn);  SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(4,upArr); SetIndexStyle(4,DRAW_ARROW); SetIndexArrow(4,233);
   SetIndexBuffer(5,dnArr); SetIndexStyle(5,DRAW_ARROW); SetIndexArrow(5,234);
   SetIndexBuffer(6,vala);
   
      //
      //
      //
      //
      //
               
         RmaPeriod         = MathMax(RmaPeriod,2);
         RmaDepth          = MathMax(MathMin(RmaDepth,MAX_depth),5);
         indicatorFileName = WindowExpertName();
         
         calculateValue    = (TimeFrame=="calculateValue"); if (calculateValue) return(0);
         returnBars        = (TimeFrame=="returnBars");     if (returnBars)     return(0);
         timeFrame         = stringToTimeFrame(TimeFrame);

      //
      //
      //
      //
      //
               
   IndicatorShortName(timeFrameToString(timeFrame)+" rainbow oscillator ("+RmaPeriod+","+RmaDepth+")");
   return(0);
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

#define initialMin  EMPTY_VALUE
#define initialMax -EMPTY_VALUE

int start()
{
   int counted_bars=IndicatorCounted();
   int i,k,l,n,r,limit;

   if(counted_bars<0) return(-1);
   if(counted_bars>0) counted_bars--;
           limit=MathMin(Bars-counted_bars,Bars-1);
           if (returnBars) { rbUp[0] = limit+1; return(0); }

   //
   //
   //
   //
   //
   
   if (calculateValue || timeFrame == Period())
   {
      if (ArrayRange(pBuffer,0) != Bars) ArrayResize(pBuffer,Bars);
      
      //
      //
      //
      //
      //
      
      for(i=limit, r=Bars-limit-1; i>=0; i--,r++)
      {
         double price = iMA(NULL,0,1,0,MODE_SMA,RmaPrice,i);
         double mina  = initialMin;
         double maxa  = initialMax;
         double minp  = initialMin;
         double maxp  = initialMax;
         double sum   = 0;

            for (k=0; k<RmaDepth; k++)
            {
               pBuffer[r][k] = price;
               if (r>RmaPeriod)
               {
                  for (l=0, price=0; l<RmaPeriod; l++) price += pBuffer[r-l][k];
                                                       price /= RmaPeriod;
               }
               sum  += price;
               mina = MathMin(mina,price);
               maxa = MathMax(maxa,price);
               minp = MathMin(minp,pBuffer[r-k][0]);
               maxp = MathMax(maxp,pBuffer[r-k][0]);
            }
            double rma = sum/RmaDepth;
            
            //
            //
            //
            //
            //
            
            double rangea = maxa-mina;
            double rangep = maxp-minp;
            if (rangep !=0)
            {
               rbUp[i] =  100.0*rangea/rangep;
               rbDn[i] = -100.0*rangea/rangep;
               rhUp[i] = EMPTY_VALUE;
               rhDn[i] = EMPTY_VALUE;
               upArr[i] = EMPTY_VALUE;
               dnArr[i] = EMPTY_VALUE;
                  double rangeo = 100*(pBuffer[r][0]-rma)/rangep;            
                     if (rangeo > 0) rhUp[i] = rangeo;
                     if (rangeo < 0) rhDn[i] = rangeo;
                     vala[i] = (i<Bars-1) ? (rangeo>rbUp[i]) ? -1 : (rangeo<rbDn[i]) ? 1 : vala[i+1] : 0;
                     if (vala[i] != vala[i+1])
                     if (vala[i] == 1)
                            upArr[i] = rhDn[i];
                     else   dnArr[i] = rhUp[i]; 
                     
            }                  
      }
   return(0);
   }
   
   
   //
   //
   //
   //
   //

   limit = MathMax(limit,MathMin(Bars-1,iCustom(NULL,timeFrame,indicatorFileName,"returnBars",0,0)*timeFrame/Period()));
   for(i=limit; i>=0; i--)
   {
      int y = iBarShift(NULL,timeFrame,Time[i]);
      int x = y;
      if (ArrowOnFirst)
            {  if (i<Bars-1) x = iBarShift(NULL,TimeFrame,Time[i+1]);               }
      else  {  if (i>0)      x = iBarShift(NULL,TimeFrame,Time[i-1]); else x = -1;  }
         rbUp[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",RmaPeriod,RmaDepth,RmaPrice,0,y);
         rbDn[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",RmaPeriod,RmaDepth,RmaPrice,1,y);
         rhUp[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",RmaPeriod,RmaDepth,RmaPrice,2,y);
         rhDn[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",RmaPeriod,RmaDepth,RmaPrice,3,y);
         upArr[i] = EMPTY_VALUE;
         dnArr[i] = EMPTY_VALUE;
         if (x!=y)
         {
            upArr[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",RmaPeriod,RmaDepth,RmaPrice,4,y);
            dnArr[i] = iCustom(NULL,timeFrame,indicatorFileName,"calculateValue",RmaPeriod,RmaDepth,RmaPrice,5,y);
         }
            
         //
         //
         //
         //
         //
      
         if (!Interpolate || y==iBarShift(NULL,timeFrame,Time[i-1])) continue;

         //
         //
         //
         //
         //

         datetime time = iTime(NULL,timeFrame,y);
            for(n = 1; i+n < Bars && Time[i+n] >= time; n++) continue;	
            for(k = 1; k < n; k++)
            {
               rbUp[i+k] = rbUp[i] + (rbUp[i+n]-rbUp[i])*k/n;
               rbDn[i+k] = rbDn[i] + (rbDn[i+n]-rbDn[i])*k/n;
               if (rhUp[i] != EMPTY_VALUE && rhUp[i+n] != EMPTY_VALUE) rhUp[i+k] = rhUp[i] + (rhUp[i+n]-rhUp[i])*k/n;
               if (rhDn[i] != EMPTY_VALUE && rhDn[i+n] != EMPTY_VALUE) rhDn[i+k] = rhDn[i] + (rhDn[i+n]-rhDn[i])*k/n;
            }               
   }
   
   //
   //
   //
   //
   //
   
   return(0);
}

//+-------------------------------------------------------------------
//|                                                                  
//+-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

//
//
//
//
//

int stringToTimeFrame(string tfs)
{
   tfs = stringUpperCase(tfs);
   for (int i=ArraySize(iTfTable)-1; i>=0; i--)
         if (tfs==sTfTable[i] || tfs==""+iTfTable[i]) return(MathMax(iTfTable[i],Period()));
                                                      return(Period());
}
string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//
//
//
//
//

string stringUpperCase(string str)
{
   string   s = str;

   for (int length=StringLen(str)-1; length>=0; length--)
   {
      int tchar = StringGetChar(s, length);
         if((tchar > 96 && tchar < 123) || (tchar > 223 && tchar < 256))
                     s = StringSetChar(s, length, tchar - 32);
         else if(tchar > -33 && tchar < 0)
                     s = StringSetChar(s, length, tchar + 224);
   }
   return(s);
}