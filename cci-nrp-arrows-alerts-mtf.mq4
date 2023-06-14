//+------------------------------------------------------------------+
//|                                                      CCI nrp.mq4 |
//+------------------------------------------------------------------+
#property copyright "www,forex-station.com"
#property link      "www,forex-station.com"

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_color1  clrDimGray
#property indicator_width1  2
#property indicator_width2  2
#property indicator_width3  2
#property indicator_width4  2
#property indicator_width5  2
#property strict

//
//
//
//
//

enum enColorOn
{
   col_colorOnSlope,   // Change color on slope change
   col_colorOnObOs,    // Change color on ob/os cross
   col_colorOnMaCross  // Change color on ma cross
};

extern ENUM_TIMEFRAMES    TimeFrame         = PERIOD_CURRENT;    // Time frame to use
extern int                CCIPeriod         = 20;                // Cci period
extern ENUM_APPLIED_PRICE CCIPrice          = PRICE_TYPICAL;     // Cci price
extern int                MaPeriod          = 21;                // Cci ma period
extern ENUM_MA_METHOD     MaMethod          = MODE_EMA;          // Ma type
extern enColorOn          ColorChangeOn     = col_colorOnObOs;   // Color change
extern double             OverSold          = -100;              // Oversold level
extern double             OverBought        = 100;               // Overbought level
extern color              OverSoldColor     = clrBlue;           // Oversold color
extern color              OverBoughtColor   = clrRed;            // Overbought color
extern color              MaColor           = clrMediumOrchid;   // Cci ma color
extern bool               alertsOn          = true;              // Turn alerts on?
extern bool               alertsOnCurrent   = false;             // Alerts on current (still opened) bar?
extern bool               alertsMessage     = true;              // Alerts should display a message?
extern bool               alertsSound       = false;             // Alerts should play a sound?
extern bool               alertsNotify      = false;             // Alerts should send notification?
extern bool               alertsEmail       = false;             // Alerts should send an email?
extern string             soundFile         = "alert2.wav";      // Alerts sound file
extern bool               arrowsVisible     = true;              // Show arrows?
extern bool               arrowsOnFirst     = false;             // Show arrows on first mtf bar or the next?          
extern string             arrowsIdentifier  = "cci arrows1";     // Arrows id
extern double             arrowsUpperGap    = 0.5;               // Arrows upper Gap
extern double             arrowsLowerGap    = 0.5;               // Arrows lower gap
extern color              arrowsUpColor     = clrLimeGreen;      // Up arrow color
extern color              arrowsDnColor     = clrRed;            // Down arrows color
extern int                arrowsUpCode      = 241;               // Up arrow code
extern int                arrowsDnCode      = 242;               // Down arrow code
extern bool               arrowsUpSize      = 2;                 // Up arrow size
extern bool               arrowsDnSize      = 2;                 // Down arrow size
extern bool               Interpolate       = true;              // Interpolation used in mtf

//
//
//
//
//

double cci[];
double cciUpa[];
double cciUpb[];
double cciDna[];
double cciDnb[];
double cciMa[];
double prices[];
double trend[];
string indicatorFileName;
bool   returnBars;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//
//

int init()
{
   IndicatorBuffers(8);
      SetIndexBuffer(0,cci);
      SetIndexBuffer(1,cciUpa); SetIndexStyle(1,DRAW_LINE,EMPTY,EMPTY,OverSoldColor);
      SetIndexBuffer(2,cciUpb); SetIndexStyle(2,DRAW_LINE,EMPTY,EMPTY,OverSoldColor);
      SetIndexBuffer(3,cciDna); SetIndexStyle(3,DRAW_LINE,EMPTY,EMPTY,OverBoughtColor);
      SetIndexBuffer(4,cciDnb); SetIndexStyle(4,DRAW_LINE,EMPTY,EMPTY,OverBoughtColor);
      SetIndexBuffer(5,cciMa);  SetIndexStyle(5,DRAW_LINE,EMPTY,EMPTY,MaColor);
      SetIndexBuffer(6,prices);
      SetIndexBuffer(7,trend);
      SetLevelValue(0,OverBought);
      SetLevelValue(1,OverSold);

      //
      //
      //
      //
      //
   
      indicatorFileName = WindowExpertName();
      returnBars        = TimeFrame==-99;
      TimeFrame         = fmax(TimeFrame,_Period);
         
      //
      //
      //
      //
      //
         
   IndicatorShortName(timeFrameToString(TimeFrame)+" CCI ("+(string)CCIPeriod+")");
return(0);
}
int deinit()
{
   string lookFor       = arrowsIdentifier+":";
   int    lookForLength = StringLen(lookFor);
   for (int i=ObjectsTotal()-1; i>=0; i--)
   {
      string objectName = ObjectName(i);
         if (StringSubstr(objectName,0,lookForLength) == lookFor) ObjectDelete(objectName);
   }
return(0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//
//
//
//

int start()
{
    int i,counted_bars=IndicatorCounted();
      if(counted_bars<0) return(-1);
      if(counted_bars>0) counted_bars--;
           int limit=fmin(Bars-counted_bars,Bars-1); 
           if (returnBars) { cci[0] = fmin(limit+1,Bars-1); return(0); }

   //
   //
   //
   //
   //

   if (TimeFrame==Period())
   {
      if (trend[limit]== 1) CleanPoint(limit,cciUpa,cciUpb);
      if (trend[limit]==-1) CleanPoint(limit,cciDna,cciDnb);
      for(i=limit; i>=0; i--)
      {
         prices[i]  = iMA(NULL,0,1,0,MODE_SMA,CCIPrice,i);
         double avg = 0; for(int k=0; k<CCIPeriod && (i+k)<Bars; k++) avg +=      prices[i+k];      avg /= CCIPeriod;
         double dev = 0; for(int k=0; k<CCIPeriod && (i+k)<Bars; k++) dev += fabs(prices[i+k]-avg); dev /= CCIPeriod;
            if (dev!=0)
                  cci[i] = (prices[i]-avg)/(0.015*dev);
            else  cci[i] = 0;
       }
       for(i=limit; i>=0; i--)
       {
          cciMa[i]  = iMAOnArray(cci,0,MaPeriod,0,MaMethod,i);
          cciUpa[i] = EMPTY_VALUE;
          cciUpb[i] = EMPTY_VALUE;
          cciDna[i] = EMPTY_VALUE;
          cciDnb[i] = EMPTY_VALUE;
          if (i<Bars-1)
          {   
             trend[i] = trend[i+1];
             switch (ColorChangeOn)
             {
                 case col_colorOnSlope: 
                    if (cci[i]>cci[i+1])                      trend[i] =  1;
                    if (cci[i]<cci[i+1])                      trend[i] = -1;
                 break;
                 case col_colorOnMaCross: 
                    if (cci[i]>cciMa[i])                      trend[i] =  1;
                    if (cci[i]<cciMa[i])                      trend[i] = -1;
                 break;
                 default : 
                    if (cci[i]>OverBought)                    trend[i] = -1;
                    if (cci[i]<OverSold)                      trend[i] =  1;
                    if (cci[i]>OverSold && cci[i]<OverBought) trend[i] =  0;
                 break;
              }    
              if (trend[i] ==  1) PlotPoint(i,cciUpa,cciUpb,cci);
              if (trend[i] == -1) PlotPoint(i,cciDna,cciDnb,cci);
           }
           
           //
           //
           //
           //
           //
             
           if (arrowsVisible)
           {
             string lookFor = arrowsIdentifier+":"+(string)Time[i]; ObjectDelete(lookFor);            
             if (i<(Bars-1) && trend[i] != trend[i+1])
             {
               if (trend[i] == 1) drawArrow(i,arrowsUpColor,arrowsUpCode,arrowsUpSize,false);
               if (trend[i] ==-1) drawArrow(i,arrowsDnColor,arrowsDnCode,arrowsDnSize, true);
             }
           }
      }
      manageAlerts();
      return(0);
   }      
   
   //
   //
   //
   //
   //
   
   limit = (int)fmax(limit,fmin(Bars-1,iCustom(NULL,TimeFrame,indicatorFileName,-99,0,0)*TimeFrame/Period()));
   if (trend[limit]== 1) CleanPoint(limit,cciUpa,cciUpb);
   if (trend[limit]==-1) CleanPoint(limit,cciDna,cciDnb);
   for (i=limit;i>=0;i--)
   {
      int y = iBarShift(NULL,TimeFrame,Time[i]);
         cci[i]    = iCustom(NULL,TimeFrame,indicatorFileName,PERIOD_CURRENT,CCIPeriod,CCIPrice,MaPeriod,MaMethod,ColorChangeOn,OverSold,OverBought,OverSoldColor,OverBoughtColor,MaColor,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsNotify,alertsEmail,soundFile,arrowsVisible,arrowsOnFirst,arrowsIdentifier,arrowsUpperGap,arrowsLowerGap,arrowsUpColor,arrowsDnColor,arrowsUpCode,arrowsDnCode,arrowsUpSize,arrowsDnSize,0,y);
         cciMa[i]  = iCustom(NULL,TimeFrame,indicatorFileName,PERIOD_CURRENT,CCIPeriod,CCIPrice,MaPeriod,MaMethod,ColorChangeOn,OverSold,OverBought,OverSoldColor,OverBoughtColor,MaColor,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsNotify,alertsEmail,soundFile,arrowsVisible,arrowsOnFirst,arrowsIdentifier,arrowsUpperGap,arrowsLowerGap,arrowsUpColor,arrowsDnColor,arrowsUpCode,arrowsDnCode,arrowsUpSize,arrowsDnSize,5,y);
         trend[i]  = iCustom(NULL,TimeFrame,indicatorFileName,PERIOD_CURRENT,CCIPeriod,CCIPrice,MaPeriod,MaMethod,ColorChangeOn,OverSold,OverBought,OverSoldColor,OverBoughtColor,MaColor,alertsOn,alertsOnCurrent,alertsMessage,alertsSound,alertsNotify,alertsEmail,soundFile,arrowsVisible,arrowsOnFirst,arrowsIdentifier,arrowsUpperGap,arrowsLowerGap,arrowsUpColor,arrowsDnColor,arrowsUpCode,arrowsDnCode,arrowsUpSize,arrowsDnSize,7,y);
         cciUpa[i] = EMPTY_VALUE;
         cciUpb[i] = EMPTY_VALUE;
         cciDna[i] = EMPTY_VALUE;
         cciDnb[i] = EMPTY_VALUE;

         //
         //
         //
         //
         //
      
         if (!Interpolate || (i>0 && y==iBarShift(NULL,TimeFrame,Time[i-1]))) continue;

         //
         //
         //
         //
         //

         int n,j; datetime time = iTime(NULL,TimeFrame,y);
         for(n = 1; i+n < Bars && Time[i+n] >= time; n++) continue;
         for(j = 1; i+n < Bars && i+j < Bars && j < n; j++) 
         {
               cci[i+j]   = cci[i]   + (cci[i+n]  -cci[i])  *j/n;
               cciMa[i+j] = cciMa[i] + (cciMa[i+n]-cciMa[i])*j/n;
         }
    }
    for (i=limit;i>=0;i--)
    {
        if (trend[i]== 1) PlotPoint(i,cciUpa,cciUpb,cci);
        if (trend[i]==-1) PlotPoint(i,cciDna,cciDnb,cci);
    }
   return(0);   
}

//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

void CleanPoint(int i,double& first[],double& second[])
{
   if (i>=Bars-3) return;
   if ((second[i]  != EMPTY_VALUE) && (second[i+1] != EMPTY_VALUE))
        second[i+1] = EMPTY_VALUE;
   else
      if ((first[i] != EMPTY_VALUE) && (first[i+1] != EMPTY_VALUE) && (first[i+2] == EMPTY_VALUE))
          first[i+1] = EMPTY_VALUE;
}

void PlotPoint(int i,double& first[],double& second[],double& from[])
{
   if (i>=Bars-2) return;
   if (first[i+1] == EMPTY_VALUE)
      if (first[i+2] == EMPTY_VALUE) 
            { first[i]  = from[i]; first[i+1]  = from[i+1]; second[i] = EMPTY_VALUE; }
      else  { second[i] = from[i]; second[i+1] = from[i+1]; first[i]  = EMPTY_VALUE; }
   else     { first[i]  = from[i];                          second[i] = EMPTY_VALUE; }
}

//-------------------------------------------------------------------
//
//-------------------------------------------------------------------
//
//
//
//
//

string sTfTable[] = {"M1","M5","M15","M30","H1","H4","D1","W1","MN"};
int    iTfTable[] = {1,5,15,30,60,240,1440,10080,43200};

string timeFrameToString(int tf)
{
   for (int i=ArraySize(iTfTable)-1; i>=0; i--) 
         if (tf==iTfTable[i]) return(sTfTable[i]);
                              return("");
}

//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

void manageAlerts()
{
   if (alertsOn)
   {
      int whichBar = 1; if (alertsOnCurrent) whichBar = 0;
      if (trend[whichBar] != trend[whichBar+1])
      {
         switch (ColorChangeOn)
         {
            case col_colorOnSlope:
               if (trend[whichBar]== 1) doAlert(whichBar,"slope changed to up");
               if (trend[whichBar]==-1) doAlert(whichBar,"slope changed to down");
               break;
            case col_colorOnMaCross:
               if (trend[whichBar]== 1) doAlert(whichBar,"crossed Ma up");
               if (trend[whichBar]==-1) doAlert(whichBar,"crossed Ma down");
               break;
            default : 
               if (trend[whichBar]== 1) doAlert(whichBar,"entering OB level");
               if (trend[whichBar]==-1) doAlert(whichBar,"entering OS level");
         }    
      }
   }
}

//
//
//
//
//

void doAlert(int forBar, string doWhat)
{
   static string   previousAlert="nothing";
   static datetime previousTime;
   string message;
   
   if (previousAlert != doWhat || previousTime != Time[forBar]) {
       previousAlert  = doWhat;
       previousTime   = Time[forBar];

       //
       //
       //
       //
       //

       message =  StringConcatenate(Symbol()," at ",TimeToStr(TimeLocal(),TIME_SECONDS)," ",timeFrameToString(_Period)+" Cci ",doWhat);
          if (alertsMessage) Alert(message);
          if (alertsEmail)   SendMail(Symbol()+" Cci ",message);
          if (alertsNotify)  SendNotification(message);
          if (alertsSound)   PlaySound(soundFile);
   }
}

//-------------------------------------------------------------------
//                                                                  
//-------------------------------------------------------------------
//
//
//
//
//

void drawArrow(int i,color theColor,int theCode, int theSize, bool up)
{
   string name = arrowsIdentifier+":"+(string)Time[i];
   double gap  = iATR(NULL,0,20,i);   
   
      //
      //
      //
      //
      //

      datetime time = Time[i]; if (arrowsOnFirst) time += _Period*60-1;      
      ObjectCreate(name,OBJ_ARROW,0,time,0);
         ObjectSet(name,OBJPROP_ARROWCODE,theCode);
         ObjectSet(name,OBJPROP_WIDTH,theSize);
         ObjectSet(name,OBJPROP_COLOR,theColor);
         if (up)
               ObjectSet(name,OBJPROP_PRICE1,High[i] + arrowsUpperGap * gap);
         else  ObjectSet(name,OBJPROP_PRICE1,Low[i]  - arrowsLowerGap * gap);
}
