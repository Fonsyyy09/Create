//+------------------------------------------------------------------+
//|                            Symphonie Extreme Indicator v2 RF.mq4 |
//|             Based on Cycle Identifier --> repaints last few bars |
//+------------------------------------------------------------------+
// seashore: add alert for disappearance of recent major extreme spike, as well as track history of spikes (to faciliate reentry). done
// seashore: add major tweaks for alerting on minor and major (extreme) peaks. done
/*
Modified by Zen to add alert when top or bottom is detected on previous candle.
add alert option for buy or sell or both options by mtuppers
Modified by MaryJane to plot only at bar close and refresh whole chart so no TF switching is necessary
Modified by MyxoMop to plot minor and major cycles history dots (to see where it was repainted).
*/

#property copyright ""
#property link      ""

#property indicator_separate_window
#property indicator_buffers 10             // set this to 6 if you dont want to plot history
#property indicator_color1 Lavender
#property indicator_color2 Blue     //major bottom
#property indicator_color3 Red            //major top
#property indicator_color4 Black          //minor bottom
#property indicator_color5 Black          //minor top
#property indicator_color6 Black
#property indicator_color7 Blue           // history of major top
#property indicator_color8 Red           // history of major bottom
#property indicator_color9 White           // history of minor top
#property indicator_color10 Yellow           // history of minor bottom

#property indicator_width1 0
#property indicator_width2 4
#property indicator_width3 4
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 0
#property indicator_width7 2
#property indicator_width8 2
#property indicator_width9 0
#property indicator_width10 0

#property indicator_minimum -1.1
#property indicator_maximum 1.1

extern int        PriceActionFilter=1;
extern int        Length=3;
extern int        MajorCycleStrength=4;
extern bool       UseCycleFilter=false;
extern int        UseFilterSMAorRSI=1;
extern int        FilterStrengthSMA=12;
extern int        FilterStrengthRSI=21;
extern bool       MinorAlert = true;
extern bool       MajorAlert = true;
extern bool       MajorGoneAlert = true; // alerts if a recent major extreme peaks disappears. this is to facilitate fast reentry
extern bool       SoundAlert = true;
extern bool       EmailAlert = false;
extern bool       TrackMajorCycleHistory = true;
extern bool       WaitForClose = true;
extern int        MajorGoneLookBackBars = 40; // max amount of lookback bars to check if a recent spike disappears
extern string     note1 = "alert all = 0, none = 4", //eh added comment for 4. but leave on 0
                  note2 = "buy only = 1, sell only = 2";
extern int        alertsOption = 0;
string            IndicatorName = "Cycle Identifier"; // for email messages

double LineBuffer[];
double MajorCycleBuy[];
double MajorCycleSell[];
double MajorCycleBuyHistory[]; // to track history, we just shadow MajorCycleBuy assignments but wont reset any of the vector cells to zero...
double MajorCycleSellHistory[]; // ...note that things may get cluttered on the chart if the extreme peaks bounce around to much
double MinorCycleBuy[];
double MinorCycleSell[];
double MinorCycleBuyHistory[];
double MinorCycleSellHistory[];
double ZL1[];

double CyclePrice = 0.0, Strength =0.0, SweepA = 0.0, SweepB = 0.0;
int Switch = 0, Switch2 = 0,	SwitchA = 0, SwitchB = 0, SwitchC = 0, SwitchD = 0, SwitchE = 0, SwitchAA = 0, SwitchBB = 0;
double Price1BuyA = 0.0, Price2BuyA = 0.0;
int Price1BuyB = 1.0, Price2BuyB = 1.0;
double Price1SellA = 0.0, Price2SellA = 0.0;
int Price1SellB = 0.0, Price2SellB = 0.0;
bool ActiveSwitch = True, BuySwitchA = FALSE, BuySwitchB = FALSE, SellSwitchA = FALSE, SellSwitchB = FALSE;
int BuySellFac = 01;
bool Condition1, Condition2, Condition3, Condition6, firsttime;

datetime MinorTopAlertTime, MinorBottomAlertTime, MajorTopAlertTime, MajorBottomAlertTime;
datetime LastRecentMajor_Time; // track open time of bar
datetime PrevOpposingMajor_Time; // track open time of opposing extreme before last recent major extreme
int LastRecentMajor_Type; // 0=buy, 1=sell
bool LastRecentMajorGone = false; // true if the peak has disappeared (may need 3 states?)

string TimePeriod;
int SignalIndex = 0;

int init()  {
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID);
   SetIndexBuffer(0,LineBuffer);
   
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(1,MajorCycleBuy);
   SetIndexLabel(1, "MajorCycleBuy");
   
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(2,MajorCycleSell);
   SetIndexLabel(2, "MajorCycleSell");
   
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(3,MinorCycleBuy);
   SetIndexLabel(3, "MinorCycleBuy");
   
   SetIndexStyle(4,DRAW_HISTOGRAM,STYLE_SOLID);
   SetIndexBuffer(4,MinorCycleSell);
   SetIndexLabel(4, "MinorCycleSell");
   
   SetIndexStyle(5,DRAW_NONE);
   SetIndexBuffer(5,ZL1);
   SetIndexLabel(5, "ZL1");

   if (TrackMajorCycleHistory) SetIndexStyle(6, DRAW_ARROW, STYLE_SOLID, indicator_width7, indicator_color7); else SetIndexStyle(6,DRAW_NONE);
   SetIndexBuffer(6, MajorCycleBuyHistory);
   SetIndexLabel(6, "MajorCycleBuyHistory");
   SetIndexArrow(6, 108); // dot
   SetIndexDrawBegin(6, 0);

   if (TrackMajorCycleHistory) SetIndexStyle(7, DRAW_ARROW, STYLE_SOLID, indicator_width8, indicator_color8); else SetIndexStyle(7,DRAW_NONE);
   SetIndexBuffer(7, MajorCycleSellHistory);
   SetIndexLabel(7, "MajorCycleSellHistory");
   SetIndexArrow(7, 108); // dot
   SetIndexDrawBegin(7, 0);

   if (TrackMajorCycleHistory) SetIndexStyle(8, DRAW_ARROW, STYLE_DOT, indicator_width6, indicator_color9); else SetIndexStyle(8,DRAW_NONE);
   SetIndexBuffer(8, MinorCycleBuyHistory);
   SetIndexLabel(8, "MinorCycleBuyHistory");
   SetIndexArrow(8, 108); // dot
   SetIndexDrawBegin(8, 0);

   if (TrackMajorCycleHistory) SetIndexStyle(9, DRAW_ARROW, STYLE_DOT, indicator_width6, indicator_color10); else SetIndexStyle(9,DRAW_NONE);
   SetIndexBuffer(9, MinorCycleSellHistory);
   SetIndexLabel(9, "MinorCycleSellHistory");
   SetIndexArrow(9, 108); // dot
   SetIndexDrawBegin(9, 0);    
   
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexEmptyValue(4,0.0);
   SetIndexEmptyValue(5,0.0);  
   SetIndexEmptyValue(6,0.0);  
   SetIndexEmptyValue(7,0.0);  
   SetIndexEmptyValue(8,0.0);  
   SetIndexEmptyValue(9,0.0);    
   
   MinorTopAlertTime = 0;
   MinorBottomAlertTime = 0;
   MajorTopAlertTime = 0;
   MajorBottomAlertTime = 0;
   if (WaitForClose) {
      SignalIndex = 1;
   } else {
      SignalIndex = 0;
   }
   firsttime=true;
   return(0);
}

int deinit() {return(0);}

int start() {
   int k, temp; // index vars
   //int counted_bars=IndicatorCounted();
   //if(counted_bars<0) return(-1);
   // if(counted_bars>0) counted_bars--;
   // int position=Bars-1;
   int position=Bars;
   if (position<0) position=0;
   static int NewBar; 
   if (NewBar == 0) NewBar = Time[0];
   if (NewBar != Time[0] || firsttime)
     {
     firsttime = false;
     NewBar = Time[0];

   int rnglength = 250;
   double range = 0.0, srange = 0.0;
   for (int pos = position; pos >=0; pos--) {
      srange = 0.0;
      int j = 0;
      for (int i=0;i<rnglength;i++) {
         j++;
         int posr = pos + i;
         if (posr >= Bars)
            break;
            
         srange = srange + (High[posr] - Low[posr]);
      }
      range = srange / j * Length;
      int BarNumber = Bars-pos; //??????????
      if (BarNumber < 0) BarNumber = 0;
 
      CyclePrice = iMA(NULL, 0, PriceActionFilter, 0, MODE_SMMA, PRICE_CLOSE, pos);
      
      if (UseFilterSMAorRSI == 1) ZL1[pos] = ZeroLag(CyclePrice,FilterStrengthSMA, pos);
      if (UseFilterSMAorRSI == 2) ZL1[pos] = ZeroLag( iRSI(NULL, 0, 14, CyclePrice, FilterStrengthRSI ), FilterStrengthRSI, pos);

      if (ZL1[pos] > ZL1[pos+1]) SwitchC = 1;
      if (ZL1[pos] < ZL1[pos+1]) SwitchC = 2;
          
      if (BarNumber <= 1) {
         if (Strength == 0) SweepA  = range;	else SweepA = Strength;
         Price1BuyA  = CyclePrice;
         Price1SellA  = CyclePrice;
      }
      
      /* ***************************************************************** */
      
      if (BarNumber > 1) {
         if (Switch > -1) {
            if (CyclePrice < Price1BuyA) {
               
               if (UseCycleFilter && (SwitchC == 2) && BuySwitchA ) {
			         MinorCycleBuy[pos + BarNumber - Price1BuyB] = 0; //MinorBuySell
//			         LineBuffer[pos + BarNumber - Price1BuyB ] = 0; //line
		         }
		      
		         if (!UseCycleFilter && BuySwitchA) {
			         MinorCycleBuy[pos +BarNumber - Price1BuyB] = 0;
//			         LineBuffer[pos +BarNumber - Price1BuyB] = 0;
		         }
		         Price1BuyA = CyclePrice;
               Price1BuyB = BarNumber;
               BuySwitchA = TRUE;
            } else if (CyclePrice > Price1BuyA) {
               SwitchA = BarNumber - Price1BuyB;
         
	            if (!UseCycleFilter) {
		           MinorCycleBuy[pos +SwitchA] = -1;//MinorBuySell - DarkGreen
		           MinorCycleBuyHistory [pos +SwitchA] = -1; //MajorBuySell green
//		           LineBuffer[pos +SwitchA] = -1;//line
	            }
	      
	            if (UseCycleFilter && SwitchC  == 1) {
		           MinorCycleBuy[pos +SwitchA] = -1;  //MinorBuySell
		           MinorCycleBuyHistory [pos +SwitchA] = -1; //MajorBuySell green
//		           LineBuffer[pos +SwitchA] = -1; //line
		           SwitchD = 1; 
	            } else {
		           SwitchD = 0;
		         }
		   
               BuySwitchA = TRUE;
	
	            double cyclePrice1 = iMA(NULL, 0, PriceActionFilter, 0, MODE_SMMA, PRICE_CLOSE, pos + SwitchA);
               if (ActiveSwitch) {  
                  Condition1 = CyclePrice - cyclePrice1 >= SweepA; 
               }  else {
                  Condition1 = CyclePrice >= cyclePrice1 * (1 + SweepA / 1000);
               }
               if (Condition1 && SwitchA >= BuySellFac) {
                  Switch =  - 1;
                  Price1SellA = CyclePrice;
                  Price1SellB = BarNumber;
                  SellSwitchA = FALSE;
                  BuySwitchA = FALSE;
               }            
            }
         }
         if(Switch < 1) {
            if (CyclePrice > Price1SellA) {
               if (UseCycleFilter && SwitchC == 1 && SellSwitchA ) {
                  MinorCycleSell[pos +BarNumber - Price1SellB] = 0; //MinorBuySell
//                  LineBuffer[pos +BarNumber - Price1SellB ] = 0; //line
               }
               if (!UseCycleFilter && SellSwitchA )  {
                  MinorCycleSell[pos +BarNumber - Price1SellB] = 0;//MinorBuySell
//                  LineBuffer[pos +BarNumber - Price1SellB] = 0;//line
               }
               Price1SellA = CyclePrice;
               Price1SellB = BarNumber;
               SellSwitchA = TRUE;   
               } else if (CyclePrice < Price1SellA) {
               SwitchA = BarNumber - Price1SellB;
                  if (!UseCycleFilter) {
                     MinorCycleSell[pos +SwitchA] = 1; // MinorBuySell darkRed
                     MinorCycleSellHistory [pos + SwitchA] = 1; //"MajorBuySell",red
//                     LineBuffer[pos +SwitchA] = 1; //"CycleLine"
			         }
                  if (UseCycleFilter && (SwitchC == 2)) {
                     MinorCycleSell[pos +SwitchA] = 1;//MinorBuySell darkRed
                     MinorCycleSellHistory [pos + SwitchA] = 1; //"MajorBuySell",red
//                     LineBuffer[pos +SwitchA] = 1;//CycleLine
                     SwitchD  = 2;
                  } else {
                     SwitchD  = 0;
                  }

                  SellSwitchA = TRUE;
                  double cyclePrice2 = iMA(NULL, 0, PriceActionFilter, 0, MODE_SMMA, PRICE_CLOSE, pos + SwitchA);

                  if (ActiveSwitch) {
                     Condition1 = (cyclePrice2 - CyclePrice) >= SweepA;
                  } else {
                     Condition1 = CyclePrice <= (cyclePrice2 * (1 - SweepA / 1000));
                  }

                  if (Condition1 && SwitchA >= BuySellFac) {
                     Switch = 1;
                     Price1BuyA = CyclePrice;
                     Price1BuyB = BarNumber;
                     SellSwitchA = FALSE;
                     BuySwitchA = FALSE;
                  }
               } 
            }
         }
      
         LineBuffer[pos] = 0;
         MinorCycleBuy[pos] = 0;
         MinorCycleSell[pos] = 0;

         if (BarNumber == 1) {
            if (Strength == 0) {
               SweepB  = range *  MajorCycleStrength;
            } else {
               SweepB = Strength * MajorCycleStrength;
            }
            
            Price2BuyA = CyclePrice;
            Price2SellA = CyclePrice;
         } 
            
         if (BarNumber > 1) {
            if (Switch2  >  - 1) {
               if (CyclePrice < Price2BuyA) {
                  if (UseCycleFilter && SwitchC == 2 && BuySwitchB ) {
                     MajorCycleBuy [pos +BarNumber - Price2BuyB] = 0; //MajorBuySell,green
		   //		      LineBuffer[pos + BarNumber - Price2BuyB ] = 0; //line -----
                  }
                  if (!UseCycleFilter && BuySwitchB ) {
                     MajorCycleBuy [pos +BarNumber - Price2BuyB] = 0;//MajorBuySell,green
  	   //			      LineBuffer[pos + BarNumber - Price2BuyB ] = 0; //line-----------
                  }
			         Price2BuyA = CyclePrice;
                  Price2BuyB = BarNumber;
                  BuySwitchB = TRUE;
               } else if (CyclePrice > Price2BuyA) {
			         SwitchB = BarNumber - Price2BuyB;

                  if (!UseCycleFilter) {  
                     MajorCycleBuy [pos +SwitchB] = -1; //MajorBuySell green
                     MajorCycleBuyHistory [pos +SwitchB] = -1; //MajorBuySell green
         //          LineBuffer[pos + SwitchB] = -1; //line--------------
                  }
                  if (UseCycleFilter && SwitchC  == 1) {
                     MajorCycleBuy [pos +SwitchB] = -1; //MajorBuySell green
                     MajorCycleBuyHistory [pos +SwitchB] = -1; //MajorBuySell green
        //           LineBuffer[pos + SwitchB] = -1; //line-----------------
                     SwitchE  = 1;
                  }  else {
                     SwitchE  = 0;
                  }

                  BuySwitchB = TRUE;
                  double cyclePrice3 = iMA(NULL, 0, PriceActionFilter, 0, MODE_SMMA, PRICE_CLOSE, pos + SwitchB);
                  if (ActiveSwitch) {
                     Condition6 = CyclePrice - cyclePrice3 >= SweepB;
                  } else {
                     Condition6 = CyclePrice >= cyclePrice3 * (1 + SweepB / 1000);
                  }

                  if (Condition6 && SwitchB >= BuySellFac) {
                     Switch2 =  - 1;
                     Price2SellA = CyclePrice;
                     Price2SellB = BarNumber;
                     SellSwitchB = FALSE;
                     BuySwitchB = FALSE;
                  }
               }
            }

            if (Switch2  < 1) {
               if (CyclePrice  > Price2SellA ) {
                  if (UseCycleFilter && SwitchC  == 1 && SellSwitchB ) { 
                     MajorCycleSell [pos +BarNumber - Price2SellB] = 0; //"MajorBuySell",red 
         //			   LineBuffer[pos + BarNumber - Price2SellB ] = 0; //line -----
                  }
                  if (!UseCycleFilter && SellSwitchB ) {
                     MajorCycleSell [pos +BarNumber - Price2SellB] = 0;//"MajorBuySell",red 
        //           LineBuffer[pos + BarNumber - Price2SellB ] = 0; //line -----
                  }
                  Price2SellA = CyclePrice;
                  Price2SellB = BarNumber;
                  SellSwitchB = TRUE;
               } else if (CyclePrice < Price2SellA) {
                  SwitchB = BarNumber - Price2SellB ;

               if (!UseCycleFilter) {
                  MajorCycleSell[pos + SwitchB] = 1; //"MajorBuySell",red 
                  MajorCycleSellHistory[pos + SwitchB] = 1; //"MajorBuySell",red 
        //        LineBuffer[pos + SwitchB ] = 1; //line -----
               }
               if (UseCycleFilter && SwitchC  == 2) {
                  MajorCycleSell [pos + SwitchB] = 1; //"MajorBuySell",red 
                  MajorCycleSellHistory [pos + SwitchB] = 1; //"MajorBuySell",red 
         //       LineBuffer[pos + SwitchB ] = 1; //line -----
                  SwitchE  = 2;
               } else {
                  SwitchE  = 0;
               }

               SellSwitchB = TRUE;
               double cyclePrice4 = iMA(NULL, 0, PriceActionFilter, 0, MODE_SMMA, PRICE_CLOSE, pos + SwitchB);
               if (ActiveSwitch) {
                  Condition6 = cyclePrice4 - CyclePrice >= SweepB;
               } else {
                  Condition6 = CyclePrice <= cyclePrice4 * (1.0 - SweepB / 1000.0);
               }

               if (Condition6 && SwitchB >= BuySellFac) {
                  Switch2 = 1;
                  Price2BuyA = CyclePrice;
                  Price2BuyB = BarNumber;
                  SellSwitchB = FALSE;
                  BuySwitchB = FALSE;
               }
            }
         }
      }
      LineBuffer[pos] = 0;
      MajorCycleSell[pos] = 0;
      MajorCycleBuy[pos] = 0;
   }
   
   if (MinorAlert&&(SoundAlert||EmailAlert)) {
      TimePeriod = StringConcatenate("M", Period()); // eh to allow for odd-period chart identification
      if (Period()== 1)       TimePeriod = "M1";
      if (Period()== 5)       TimePeriod = "M5";
      if (Period()== 15)      TimePeriod = "M15";
      if (Period()== 30)      TimePeriod = "M30";
      if (Period()== 60)      TimePeriod = "H1";
      if (Period()== 240)     TimePeriod = "H4";
      if (Period()== 1440)    TimePeriod = "D1";
      if (Period()== 10080)   TimePeriod = "W1";
      if (Period()== 43200)   TimePeriod = "MN";
     
      if (alertsOption == 0) {
         if (MinorCycleSell[SignalIndex] == 1 && MinorTopAlertTime < Time[SignalIndex]) {
            if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": Minor Cycle Top Detected");
            if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": Minor Cycle Top Detected");
            MinorTopAlertTime = Time[SignalIndex];
            //Alert (TimePeriod, Symbol(), " Cycle Top Detected at ",TimeToStr(Time[SignalIndex],TIME_DATE|TIME_MINUTES));
         }
         if (MinorCycleBuy[SignalIndex] == -1 && MinorBottomAlertTime < Time[SignalIndex]) {
            if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": Minor Cycle Bottom Detected");
            if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": Minor Cycle Bottom Detected");
            MinorBottomAlertTime = Time[SignalIndex];
         }
      }
      if (alertsOption == 1) {  //buy
         if (MinorCycleBuy[SignalIndex] == -1 && MinorBottomAlertTime < Time[SignalIndex]) {
            if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": Minor Cycle Bottom Detected");
            if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": Minor Cycle Bottom Detected");
            MinorBottomAlertTime = Time[SignalIndex];
         }
      }
      if (alertsOption == 2) {  //sell
          if (MinorCycleSell[SignalIndex] == 1 && MinorTopAlertTime < Time[SignalIndex]) {
             if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": Minor Cycle Top Detected");
             if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": Minor Cycle Top Detected");
             MinorTopAlertTime = Time[SignalIndex];
          }
       }
   }
   
   if (MajorAlert&&(SoundAlert||EmailAlert)) {
      TimePeriod = StringConcatenate("M", Period()); // eh to allow for odd-period chart identification
      if (Period()== 1)       TimePeriod = "M1";
      if (Period()== 5)       TimePeriod = "M5";
      if (Period()== 15)      TimePeriod = "M15";
      if (Period()== 30)      TimePeriod = "M30";
      if (Period()== 60)      TimePeriod = "H1";
      if (Period()== 240)     TimePeriod = "H4";
      if (Period()== 1440)    TimePeriod = "D1";
      if (Period()== 10080)   TimePeriod = "W1";
      if (Period()== 43200)   TimePeriod = "MN";
      
      if (alertsOption == 0) {
         if (MajorCycleSell[SignalIndex] == 1 && MajorTopAlertTime < Time[SignalIndex]) {
            if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Top Detected");
            if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Top Detected");
            MajorTopAlertTime = Time[SignalIndex];
            //Alert (TimePeriod, Symbol(), " Cycle Top Detected at ",TimeToStr(Time[SignalIndex],TIME_DATE|TIME_MINUTES));
         }
         if (MajorCycleBuy[SignalIndex] == -1 && MajorBottomAlertTime < Time[SignalIndex]) {
            if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Bottom Detected");
            if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Bottom Detected");
            MajorBottomAlertTime = Time[SignalIndex];
         }
      }
      if (alertsOption == 1) {  //buy
         if (MajorCycleBuy[SignalIndex] == -1 && MajorBottomAlertTime < Time[SignalIndex]) {
            if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Bottom Detected");
            if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Bottom Detected");
            MajorBottomAlertTime = Time[SignalIndex];
         }
      }
      if (alertsOption == 2) {  //sell
         if (MajorCycleSell[SignalIndex] == 1 && MajorTopAlertTime < Time[SignalIndex]) {
            if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Top Detected");
            if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Top Detected");
            MajorTopAlertTime = Time[SignalIndex];
         }
      }
      
      // check if major peak disappears
      if (MajorGoneAlert) {
         if (LastRecentMajor_Time<=0) { // go find last recent peak
            for (j=SignalIndex;j<MajorGoneLookBackBars;j++) { // starts looking at bar 0 or 1
               if (MajorCycleBuy[j]==-1) { // found buy signal
                  LastRecentMajor_Time = Time[j];
                  LastRecentMajor_Type=OP_BUY;
                  for (k=j+1;k<1000;k++) { // look for prev opposing signal
                     if (MajorCycleSell[k]==1) { // found previous opposing sell signal
                        PrevOpposingMajor_Time = Time[k];
                        break;
                     } // end if
                  } // end for
                  break;
               } // end if
               if (MajorCycleSell[j]==1) { // found sell signal
                  LastRecentMajor_Time = Time[j];
                  LastRecentMajor_Type=OP_SELL;
                  for (k=j+1;k<1000;k++) { // look for prev opposing signal
                     if (MajorCycleBuy[k]==-1) { // found previous opposing buy signal
                        PrevOpposingMajor_Time = Time[k];
                        break;
                     } // end if
                  } // end for
                  break;
               } // end if
            } // end for
            if (LastRecentMajor_Time<=0) { // if no signal found
               // do nothing
            } // end if
         } else { // check if previously found major peak has disappeared
            if (LastRecentMajor_Type==OP_BUY) {
               if (MajorCycleBuy[iBarShift(NULL,0,LastRecentMajor_Time,true)]!=-1) { // quick check. else peak is where it's supposed to be
                  LastRecentMajorGone = true; // presumed true to facilitate for loop
                  temp = MathMin(MajorGoneLookBackBars,iBarShift(NULL,0,PrevOpposingMajor_Time,true));
                  for (j=SignalIndex;j<temp;j++) {
                     if (MajorCycleBuy[j]==-1) { // found recent extreme bar but shifted
                        LastRecentMajorGone = false; // reset to false
                        LastRecentMajor_Time = Time[j]; // track bar at new, shifted time location
                        for (k=j+1;k<1000;k++) { // look for prev opposing signal, in case it shifted too
                           if (MajorCycleSell[k]==1) { // found previous opposing sell signal
                              PrevOpposingMajor_Time = Time[k];
                              break;
                           } // end if
                        } // end for
                        break;
                     } // end if
                  } // end for
                  if (LastRecentMajorGone) { // bar is gone, so trigger alerts
                     LastRecentMajorGone = false; // reset
                     if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Bottom Disappeared at "
                      +TimeToStr(LastRecentMajor_Time,TIME_MINUTES));
                     if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Bottom Disappeared at "
                      +TimeToStr(LastRecentMajor_Time,TIME_MINUTES));
                     LastRecentMajor_Time = 0; // reset since gone
                     PrevOpposingMajor_Time = 0; // reset
                  } // end if
               } // end if
               
               // note if LastRecentMajor_Time<=0 (ie recent spike disappeared), routine will look on next tick if a more recent, opposite spike appeared
               
               // check if a new opposite major peak has been formed (before "current" recent spike)
               if (LastRecentMajor_Time>0&&iBarShift(NULL,0,LastRecentMajor_Time,true)>SignalIndex) {
                  temp = MathMin(MajorGoneLookBackBars,iBarShift(NULL,0,LastRecentMajor_Time,true));
                  for (j=SignalIndex;j<temp;j++) { // starts looking at bar 0 or 1
                     if (MajorCycleSell[j]==1) { // found more recent, opposite sell signal. else do nothing (keep old set)
                        LastRecentMajor_Time = Time[j];
                        LastRecentMajor_Type=OP_SELL;
                        for (k=j+1;k<1000;k++) { // look for prev opposing signal (don't presume you already know where it is)
                           if (MajorCycleBuy[k]==-1) { // found previous opposing buy signal
                              PrevOpposingMajor_Time = Time[k];
                              break;
                           } // end if
                        } // end for
                        break;
                     } // end if
                  } // end for
               } // end if
            } // end if
            
            if (LastRecentMajor_Type==OP_SELL) {
               if (MajorCycleSell[iBarShift(NULL,0,LastRecentMajor_Time,true)]!=1) { // quick check. else peak is where it's supposed to be
                  LastRecentMajorGone = true; // presumed true to facilitate for loop
                  temp = MathMin(MajorGoneLookBackBars,iBarShift(NULL,0,PrevOpposingMajor_Time,true));
                  for (j=SignalIndex;j<temp;j++) {
                     if (MajorCycleSell[j]==1) { // found recent extreme bar but shifted
                        LastRecentMajorGone = false; // reset to false
                        LastRecentMajor_Time = Time[j]; // track bar at new, shifted time location
                        for (k=j+1;k<1000;k++) { // look for prev opposing signal, in case it shifted too
                           if (MajorCycleBuy[k]==-1) { // found previous opposing buy signal
                              PrevOpposingMajor_Time = Time[k];
                              break;
                           } // end if
                        } // end for
                        break;
                     } // end if
                  } // end for
                  if (LastRecentMajorGone) { // bar is gone, so trigger alerts
                     LastRecentMajorGone = false; // reset
                     if (SoundAlert) Alert (Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Top Disappeared at "
                      +TimeToStr(LastRecentMajor_Time,TIME_MINUTES));
                     if (EmailAlert) SendMail (IndicatorName, Symbol()+ " "+ TimePeriod+ ": MAJOR Cycle Top Disappeared at "
                      +TimeToStr(LastRecentMajor_Time,TIME_MINUTES));
                     LastRecentMajor_Time = 0; // reset since gone
                     PrevOpposingMajor_Time = 0; // reset
                  } // end if
               } // end if
               
               // note if LastRecentMajor_Time<=0 (ie recent spike disappeared), routine will look on next tick if a more recent, opposite spike appeared
               
               // check if a new opposite major peak has been formed (before "current" recent spike)
               if (LastRecentMajor_Time>0&&iBarShift(NULL,0,LastRecentMajor_Time,true)>SignalIndex) {
                  temp = MathMin(MajorGoneLookBackBars,iBarShift(NULL,0,LastRecentMajor_Time,true));
                  for (j=SignalIndex;j<temp;j++) { // starts looking at bar 0 or 1
                     if (MajorCycleBuy[j]==-1) { // found more recent, opposite buy signal. else do nothing (keep old set)
                        LastRecentMajor_Time = Time[j];
                        LastRecentMajor_Type=OP_SELL;
                        for (k=j+1;k<1000;k++) { // look for prev opposing signal (don't presume you already know where it is)
                           if (MajorCycleSell[k]==1) { // found previous opposing sell signal
                              PrevOpposingMajor_Time = Time[k];
                              break;
                           } // end if
                        } // end for
                        break;
                     } // end if
                  } // end for
               } // end if
            } // end if

         } // end if


      } // end if
   } // end if
   }
   return(0);
} // end function start()


double ZeroLag(double price, int length, int pos) {   
   if (length < 3) {
      return(price);
   }
   double aa = MathExp(-1.414*3.14159 / length);
   double bb = 2*aa*MathCos(1.414*180 / length);
   double CB = bb;
   double CC = -aa*aa;
   double CA = 1 - CB - CC;
   double CD = CA*price + CB*ZL1[pos+1] + CC*ZL1[pos+2];
   return(CD);
} // end function ZeroLag()


