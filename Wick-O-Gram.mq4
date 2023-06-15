//+------------------------------------------------------------------+

//| Wick.mq4 |

//| Seavo |

//| http://www.forexfactory.com/member.php?u=17692 |

//+------------------------------------------------------------------+

#property copyright "Seavo"

#property link "http://www.forexfactory.com/member.php?u=17692"

#property indicator_separate_window

#property indicator_buffers 2

#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_width1 8
#property indicator_width2 8
//---- buffers

double ExtMapBuffer1[];
double ExtMapBuffer2[];

int PipFactor = 1;
//+------------------------------------------------------------------+

//| Custom indicator initialization function |

//+------------------------------------------------------------------+

int init()

{

//---- indicators

SetIndexStyle(0,DRAW_HISTOGRAM);

SetIndexBuffer(0,ExtMapBuffer1);

SetIndexStyle(1,DRAW_HISTOGRAM);

SetIndexBuffer(1,ExtMapBuffer2);

string short_name = "Wick";

IndicatorShortName(short_name);
   IndicatorDigits(1);
   // Cater for fractional pips
   if (Digits == 3 || Digits == 5)
   {
      PipFactor = 10;
   }

//----

return(1);

}

//+------------------------------------------------------------------+

//| Custor indicator deinitialization function |

//+------------------------------------------------------------------+

int deinit()

{

//----

//----

return(0);

}

//+------------------------------------------------------------------+

//| Custom indicator iteration function |

//+------------------------------------------------------------------+

int start()

{

int counted_bars=IndicatorCounted();

//---- check for possible errors

if (counted_bars<0) return(-1);

//---- last counted bar will be recounted

if (counted_bars>0) counted_bars--;

int pos=Bars-counted_bars;



//---- main calculation loop
double dResult1;
double dResult2;
while(pos>=0)

{
if (iOpen(NULL, 0, pos) > iClose(NULL, 0, pos)){
   dResult1 = iHigh(NULL, 0, pos) - iOpen(NULL, 0, pos);
   }
if (iOpen(NULL, 0, pos) <= iClose(NULL, 0, pos)){
   dResult1 = iHigh(NULL, 0, pos) - iClose(NULL, 0, pos);
   }
if (iOpen(NULL, 0, pos) > iClose(NULL, 0, pos)){
   dResult2 = iLow(NULL, 0, pos) - iClose(NULL, 0, pos);
   }
if (iOpen(NULL, 0, pos) <= iClose(NULL, 0, pos)){
   dResult2 = iLow(NULL, 0, pos) - iOpen(NULL, 0, pos);
   }

ExtMapBuffer1[pos]= (dResult1/Point)/PipFactor ;
ExtMapBuffer2[pos]= (dResult2/Point)/PipFactor ;

pos--;

}

//----

return(0);

}

//+------------------------------------------------------------------+