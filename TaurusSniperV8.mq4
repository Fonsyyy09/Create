//============================================================================================================================================================
//+------------------------------------------------------------------+
//|            CHAVE SEGURANÇA TRAVA MENSAL PRO CLIENTE              |
//+------------------------------------------------------------------+
//============================================================================================================================================================
//demo DATA DA EXPIRAÇÃO                           // demo DATA DA EXPIRAÇÃO
bool use_demo= FALSE; // FALSE  // TRUE             // TRUE ATIVA / FALSE DESATIVA EXPIRAÇÃO
string expir_date= "11/06/2092";                   // DATA DA EXPIRAÇÃO
string expir_msg="TaurusSniperV8 Expirado ? Suporte Pelo Telegram @IndicadoresTaurus !!!"; // MENSAGEM DE AVISO QUANDO EXPIRAR
//============================================================================================================================================================
//NÚMERO DA CONTA MT4
bool use_acc_number= FALSE ; // FALSE  // TRUE     // TRUE ATIVA / FALSE DESATIVA NÚMERO DE CONTA
long acc_number= 78087208;                        // NÚMERO DA CONTA
string acc_numb_msg="TaurusSniperV8 Não Autorizado Pra Este Computador Chame @IndicadoresTaurus No Telegram!!!";                  // MENSAGEM DE AVISO NÚMERO DE CONTA INVÁLIDO
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                    TAURUS SNIPER |
//|                                         CRIADOR> IVONALDO FARIAS |
//|                             CONTATO INSTRAGAM>> @IVONALDO FARIAS |
//|                                   CONTATO WHATSAPP 21 97278-2759 |
//|                                  TELEGRAM E O MESMO NUMERO ACIMA |
//| INDICADOR TAURUS                                            2022 |
//+------------------------------------------------------------------+
//============================================================================================================================================================
#property copyright   "TaurusSniperV8.O.B"
#property description "Atualizado no dia 10/06/2022"
#property link        "https://t.me/IndicadoresTaurus"
#property description "Programado por Ivonaldo Farias !!!"
#property description "===================================="
#property description "Contato WhatsApp => +55 84 8103‑3879"
#property description "===================================="
#property description "Suporte Pelo Telegram @IndicadoresTaurus"
#property strict

//============================================================================================================================================================
#property indicator_chart_window
#property indicator_buffers 16
//============================================================================================================================================================
#include <WinUser32.mqh>
//============================================================================================================================================================
#import "user32.dll"
int PostMessageW(int hWnd,int Msg,int wParam,int lParam);
int RegisterWindowMessageW(string lpString);
#import
//============================================================================================================================================================
#import  "Wininet.dll"
int InternetOpenW(string, int, string, string, int);
int InternetConnectW(int, string, int, string, string, int, int, int);
int HttpOpenRequestW(int, string, string, int, string, int, string, int);
int InternetOpenUrlW(int, string, string, int, int, int);
int InternetReadFile(int, uchar & arr[], int, int& OneInt[]);
int InternetCloseHandle(int);
#import
//============================================================================================================================================================
#import "Kernel32.dll"
bool GetVolumeInformationW(string,string,uint,uint&[],uint,uint,string,uint);
#import
//============================================================================================================================================================
#define READURL_BUFFER_SIZE   100
#define INTERNET_FLAG_NO_CACHE_WRITE 0x04000000
#define PREFIX "TaurusSniperV8"
//============================================================================================================================================================
//CORRETORAS DISPONÍVEIS
enum corretora_price_pro
  {
   EmTodas = 1,    //Todas
   EmIQOption = 2, //IQ Option
   EmSpectre = 3,  //Spectre
   EmBinary = 4,   //Binary
   EmGC = 5,       //Grand Capital
   EmBinomo = 6,   //Binomo
   EmOlymp = 7     //Olymp Trade
  };
//============================================================================================================================================================
enum broker
  {
   Todos = 0,   //Todas
   IQOption = 1,
   Binary = 2,
   Spectre = 3,
   Alpari = 4,
   InstaBinary = 5
  };
//============================================================================================================================================================
enum corretora
  {
   All = 0,      //Todas
   IQ = 1,       //IQ Option
   Bin = 2,      //Binary
   Spectree = 3, //Spectre
   GC = 4,       //Grand Capital
   Binomo = 5,   //Binomo
   Olymp = 6,    //Olymp Trade
   Quotex = 7    //Quotex
  };
//============================================================================================================================================================
enum tipo_expiracao
  {
   TEMPO_FIXO = 0, //Tempo Fixo!
   RETRACAO = 1    //Tempo Do Time Frame!
  };
//============================================================================================================================================================
enum sinal
  {
   MESMA_VELA = 0,  //MESMA VELA
   PROXIMA_VELA = 1 //PROXIMA VELA
  };
//============================================================================================================================================================
enum signaltype
  {
   IntraBar = 0,          //Intrabar
   ClosedCandle = 1       //On new bar
  };
//============================================================================================================================================================
enum martintype
  {
   NoMartingale = 0,             // Sem Martingale (No Martingale)
   OnNextExpiry = 1,             // Próxima Expiração (Next Expiry)
   OnNextSignal = 2,             // Próximo Sinal (Next Signal)
   Anti_OnNextExpiry = 3,        // Anti-/ Próxima Expiração (Next Expiry)
   Anti_OnNextSignal = 4,        // Anti-/ Próximo Sinal (Next Signal)
   OnNextSignal_Global = 5,      // Próximo Sinal (Next Signal) (Global)
   Anti_OnNextSignal_Global = 6  // Anti-/ Próximo Sinal (Global)
  };
//============================================================================================================================================================
enum FiltroEma
  {
   EMA  = 1,  // EMA
   SMMA = 2,  // SMMA
   LWMA = 3,  // LWMA
   LSMA = 4   // LSMA SMA
  };
//============================================================================================================================================================
enum brokerm
  {
   IQOPTION = 0, //IQ OPTION
   BINOMO = 1,   //BINOMO
   QUOTEX= 2     // QUOTEX
  };
//============================================================================================================================================================
string SignalName ="TaurusSniperV8"; //Nome do Sinal para os Robos (Opcional)
//============================================================================================================================================================
int Velas = 188;                 // Catalogação Por Velas Do backtest ?
datetime timet;                  // timet ?
bool   AtivaPainel = true;       // Ativa Painel de Estatísticas?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|             DEFINIÇÃO FILTROS DE ANÁLISE!                        |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string  _________OPERACIONAL___________________ = "======= MODO OPERACIONAL! ================================================================================";//=================================================================================";
bool PriceAction  = true;            // Opera No PriceAction SR / LTA / LTB ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|             DEFINIÇÃO FILTROS DE ANÁLISE!                        |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string  __________DEFINIÇÃODOSTRADES1_______________________ = "======== PRE ALERTA FILTROS! ==================================================================================================";//=================================================================================";
bool   Mãofixa      = TRUE;                 // Filtro Mão Fixa Ativar ?
input double FiltroMãofixa = 65;            // Porcentagem % Mão fixa ?
input bool AlertsMessage    = false;        // Pré alerta Antes Dos Sinais ?
bool assinatura = false;                    // Ver sua expiração de assinatura ?
int   Intervalo = 2;                        // Intervalo ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|             DEFINIÇÃO FILTROS DE ANÁLISE!                        |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string  _________ANÁLISE___________________ = "======= FILTRO DE TENDENCIA! ================================================================================";//=================================================================================";
input bool FiltroDeTendência = false;       // Importa Filtro De Tendência ?
input int  MAPeriod=100;                    // Periodo Da EMA No Grafico ?
input FiltroEma   MAType = EMA;            // Desvio Da EMA Disponiveis ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                 CONCTOR  MT2  TAURUS                             |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string _____________ROBOS____________________ = "====== CONECTORES INTERNO! =================================================================================";//=================================================================================";
input int    ExpiryMinutes = 1;                         //Tempo De Expiração Pro Robos ?
input int    SecEnvio = 4;                              // Segundos Antes para Envio do Sinal ?
input bool OperarComMX2       = false;                  //Automatizar com MX2 TRADING ?
tipo_expiracao TipoExpiracao = TEMPO_FIXO;              //Tipo De Entrada No MX2 TRADING ?
input bool OperarComPricePro  = false;                  //Automatizar com PRICEPRO ?
input bool OperarComTOPWIN    = false;                  //Automatizar com TopWin ?
input bool OperarComMAMBA     = false;                  //Automatizar com MAMBA ?
extern brokerm Corretoram = IQOPTION;                   //Escolher Corretora Mamba ?
input bool OperarComMT2       = false;                  //Automatizar com MT2 ?
martintype MartingaleType = OnNextExpiry;               //Martingale  (para MT2) ?
double MartingaleCoef = 2.3;                            //Coeficiente do Martingale MT2 ?
int    MartingaleSteps = 0;                             //MartinGales Pro MT2 ?
input double TradeAmount = 2;                           //Valor do Trade  Pro MT2 ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                      CONCTOR  MX2                                |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string sinalNome = SignalName;                 //Nome do Sinal para MX2 TRADING ?
sinal SinalEntradaMX2 = MESMA_VELA;            //Entrar na ?
corretora CorretoraMx2 = All;                  //Corretora ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|               CONCTOR  PRICE PRO  TAURUS                         |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string ___________PRICEPRO_____________= "=== SIGNAL SETTINGS PRICE PRO ================================================================================="; //=================================================================================";
corretora_price_pro PriceProCorretora = EmTodas;       //Corretora ?
//============================================================================================================================================================
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                CONCTOR  SIGNAL SETTINGS TOPWIN                   |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string _____________TOP_WIN__________ = "===== CONFIGURAÇÕES TOP WIN =============================================================================================="; //=================================================================================";
string Nome_Sinal = SignalName;             // Nome do Sinal (Opcional)
sinal Momento_Entrada = MESMA_VELA;         // Vela de entrada
//============================================================================================================================================================
// Variables
string diretorio = "History\\EURUSD.txt";
string indicador = "";
string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);;
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                CONCTOR  SIGNAL SETTINGS MT2                      |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string _____________MT2_____________= "======= SIGNAL SETTINGS MT2 ================================================================================="; //=================================================================================";
broker Broker = Todos;        //Corretora
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                CONCTOR  SIGNAL SETTINGS MANBA                    |
//+------------------------------------------------------------------+
//============================================================================================================================================================
sinal tipoexpiracao = MESMA_VELA; // TIPO DE EXPIRAÇÃO
int porta;
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   CONFIGURAÇÕES_GERAIS                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string ___________CONFIGURAÇÕES_GERAIS_____________= "===== CONFIGURAÇÕES_GERAIS ======================================================================"; //=================================================================================";
bool   AlertsSound = false;                     //Alerta Sonoro?
string  SoundFileUp          = "alert2.wav";    //Som do alerta CALL
string  SoundFileDown        = "alert2.wav";    //Som do alerta PUT
string  AlertEmailSubject    = "";              //Assunto do E-mail (vazio = desabilita).
bool    SendPushNotification = false;           //Notificações por PUSH?
//============================================================================================================================================================
//---- buffers
double up[];
double down[];
double CrossUp[];
double CrossDown[];
double Resistencia[];
double Suporte[];
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
int x;
//============================================================================================================================================================
int   Sig_UpCall0 = 0;
int   Sig_DnPut0 = 0;
int   Sig_DnPut1 = 0;
int   Sig_Up0 = 0;
int   Sig_Dn0 = 0;
datetime LastSignal;
//============================================================================================================================================================
int MAMode;
string strMAType;
double MA_Cur, MA_Prev;
int candlesup,candlesdn;
//============================================================================================================================================================
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
//============================================================================================================================================================
#import "mt2trading_library.ex4"   // Please use only library version 13.52 or higher !!!
bool mt2trading(string symbol, string direction, double amount, int expiryMinutes);
bool mt2trading(string symbol, string direction, double amount, int expiryMinutes, string signalname);
bool mt2trading(string symbol, string direction, double amount, int expiryMinutes, martintype martingaleType, int martingaleSteps, double martingaleCoef, broker myBroker, string signalName, string signalid);
int  traderesult(string signalid);
int getlbnum();
bool chartInit(int mid);
int updateGUI(bool initialized, int lbnum, string indicatorName, broker Broker, bool auto, double amount, int expiryMinutes);
int processEvent(const int id, const string& sparam, bool auto, int lbnum);
void showErrorText(int lbnum, broker Broker, string errorText);
void remove(const int reason, int lbnum, int mid);
void cleanGUI();
#import
//============================================================================================================================================================
#import "MX2Trading_library.ex4"
bool mx2trading(string par, string direcao, int expiracao, string sinalNome, int Signaltipo, int TipoExpiracao, string TimeFrame, string mID, string Corretora);
#import
//============================================================================================================================================================
#import "PriceProLib.ex4"
void TradePricePro(string ativo, string direcao, int expiracao, string nomedosinal, int martingales, int martingale_em, int data_atual, int corretora);
#import
//============================================================================================================================================================
#import "MambaLib.ex4"
void mambabot(string ativo, string sentidoseta, int timeframe, string NomedoSina, int port);
#import
//============================================================================================================================================================
// Variables
int lbnum = 0;
datetime sendOnce;
int  Posicao = 0;
//============================================================================================================================================================
string asset;
string signalID;
input string nc_section2 = "======= TAURUS SNIPER V8!  ======================================================================================================="; // =========================================================================================
int mID = 0;      // ID (não altere)
//============================================================================================================================================================
double win[],loss[],wg[],ht[],wg2[],ht2[],wg1,ht1,WinRate1,WinRateGale1,WinRateGale22,ht22,wg22,mb;
double Barcurrentopen,Barcurrentclose,Barcurrentopen1,Barcurrentclose1,Barcurrentopen2,Barcurrentclose2,m1,m2,lbk,wbk;
string WinRate;
string WinRateGale;
string WinRateGale2;
datetime tvb1;
int tb,g;
//============================================================================================================================================================
datetime TimeBarEntradaUp;
datetime TimeBarEntradaDn;
datetime TimeBarUp;
datetime TimeBarDn;
bool initgui = false;
datetime data;
//============================================================================================================================================================
static int largura_tela = 0, altura_tela = 0;
//============================================================================================================================================================
//ATENÇÃO !!!
//CHAVE DE SEGURANÇA DO INDICADOR POR TRAVA CID NUNCA ESQUEÇA DE ATIVA QUANDO POR EM TESTE AOS CLIENTES!!!!
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
bool AtivaChaveDeSeguranca = TRUE; // Ativa Chave De Segurança !!!!
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//CHAVE DE SEGURANÇA DO INDICADOR POR TRAVA CID NUNCA ESQUEÇA DE ATIVA QUANDO POR EM TESTE AOS CLIENTES!!!!
//ATENÇÃO !!!
//============================================================================================================================================================
int OnInit()
  {
//============================================================================================================================================================
   
// FIM IDS DOS COMPRADORE
//============================================================================================================================================================
   if(assinatura)
     {
      data = StringToTime(expir_date);
      int expirc = int((data-Time[0])/86400);
      ObjectCreate("expiracao",OBJ_LABEL,0,0,0,0,0);
      ObjectSetText("expiracao","Sua licença expira em: "+IntegerToString(expirc)+" dias!...", 14,"Britannic Bold",clrWhite);
      ObjectSet("expiracao",OBJPROP_XDISTANCE,135*2);
      ObjectSet("expiracao",OBJPROP_YDISTANCE,1*10);
      ObjectSet("expiracao",OBJPROP_CORNER,4);
     }
//============================================================================================================================================================
   ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   ObjectCreate(0,"fundo",OBJ_BITMAP_LABEL,0,0,0);
   ObjectSetString(0,"fundo",OBJPROP_BMPFILE,0,"\\Images\\TaurusSniper.bmp");
   ObjectSetInteger(0,"fundo",OBJPROP_XDISTANCE,0,int(largura_tela/2.4));
   ObjectSetInteger(0,"fundo",OBJPROP_YDISTANCE,0,altura_tela/5);
   ObjectSetInteger(0,"fundo",OBJPROP_BACK,true);
   ObjectSetInteger(0,"fundo",OBJPROP_CORNER,0);
//============================================================================================================================================================
// Relogio
   ObjectCreate("Time_Remaining",OBJ_LABEL,0,0,0);
//============================================================================================================================================================
   terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
//============================================================================================================================================================
   if(ObjectType("Sniper4") != 55)
      ObjectDelete("Sniper4");
   if(ObjectFind("Sniper4") == -1)
      ObjectCreate("Sniper4", OBJ_LABEL, 0, Time[5], Close[5]);
   ObjectSetText("Sniper4", "TAURUS SNIPER V8 SEM MARTINGALE");
   ObjectSet("Sniper4", OBJPROP_CORNER, 3);
   ObjectSet("Sniper4", OBJPROP_FONTSIZE,12);
   ObjectSet("Sniper4", OBJPROP_XDISTANCE, 10);
   ObjectSet("Sniper4", OBJPROP_YDISTANCE, -3);
   ObjectSet("Sniper4", OBJPROP_COLOR,clrLavender);
   ObjectSetString(0,"Sniper4",OBJPROP_FONT,"Andalus");
   ObjectCreate("Sniper4",OBJ_RECTANGLE_LABEL,0,0,0,0,0,0);
//============================================================================================================================================================
   IndicatorShortName("TAURUS SNIPER V8");
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);
   ChartSetInteger(0,CHART_FOREGROUND,false);
   ChartSetInteger(0,CHART_SHIFT,true);
   ChartSetInteger(0,CHART_AUTOSCROLL,true);
   ChartSetInteger(0,CHART_SCALEFIX,false);
   ChartSetInteger(0,CHART_SCALEFIX_11,false);
   ChartSetInteger(0,CHART_SCALE_PT_PER_BAR,true);
   ChartSetInteger(0,CHART_SHOW_OHLC,false);
   ChartSetInteger(0,CHART_SCALE,3);
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
   ChartSetInteger(0,CHART_SHOW_LAST_LINE,false);
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,true);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
   ChartSetInteger(0,CHART_SHOW_OBJECT_DESCR,false);
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrWhiteSmoke);
   ChartSetInteger(0,CHART_COLOR_GRID,clrWhite);
   ChartSetInteger(0,CHART_COLOR_VOLUME,clrBlack);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrDimGray);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrWhite);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrGainsboro);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrDimGray);
   ChartSetInteger(0,CHART_COLOR_BID,clrIndigo);
   ChartSetInteger(0,CHART_COLOR_ASK,clrIndigo);
   ChartSetInteger(0,CHART_COLOR_LAST,clrIndigo);
   ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,clrIndigo);
   ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,false);
   ChartSetInteger(0,CHART_DRAG_TRADE_LEVELS,false);
   ChartSetInteger(0,CHART_SHOW_DATE_SCALE,false);
   ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,false);
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,false);
//============================================================================================================================================================
   if(!TerminalInfoInteger(TERMINAL_DLLS_ALLOWED))
     {
      Alert("Permita importar dlls Em Expert Advisors (ROBOS NO MT4)!");
      return(INIT_FAILED);
     }
//============================================================================================================================================================
   SetIndexStyle(0, DRAW_ARROW, EMPTY,1,clrLime);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, up);
   SetIndexLabel(0, "Seta Call Compra");
//============================================================================================================================================================
   SetIndexStyle(1, DRAW_ARROW, EMPTY,1,clrRed);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, down);
   SetIndexLabel(1, "Seta Put Venda");
//============================================================================================================================================================
   SetIndexStyle(2, DRAW_ARROW, EMPTY, 2,clrLime);
   SetIndexArrow(2, 139);
   SetIndexBuffer(2, win);
   SetIndexLabel(2, "Marcador De Win");
//============================================================================================================================================================
   SetIndexStyle(3, DRAW_ARROW, EMPTY, 2,clrRed);
   SetIndexArrow(3, 77);
   SetIndexBuffer(3, loss);
   SetIndexLabel(3, "Marcador De Loss");
//============================================================================================================================================================
   SetIndexStyle(4, DRAW_ARROW, EMPTY,4,clrYellow);
   SetIndexArrow(4, 177);
   SetIndexBuffer(4, CrossUp);
   SetIndexLabel(4, "Pré alerta Call");
//============================================================================================================================================================
   SetIndexStyle(5, DRAW_ARROW, EMPTY,4,clrYellow);
   SetIndexArrow(5, 177);
   SetIndexBuffer(5, CrossDown);
   SetIndexLabel(5, "Pré alerta Put");
//============================================================================================================================================================
   SetIndexStyle(6, DRAW_ARROW, EMPTY,0,clrNONE);
   SetIndexArrow(6, 140);
   SetIndexBuffer(6, wg);
   SetIndexLabel(6, "Marcador De Win Gale");
//============================================================================================================================================================
   SetIndexStyle(7, DRAW_ARROW, EMPTY, 0,clrNONE);
   SetIndexArrow(7, 77);
   SetIndexBuffer(7, ht);
   SetIndexLabel(7, "Marcador De Hit Gale");
//============================================================================================================================================================
   SetIndexBuffer(8, Resistencia);
   SetIndexStyle(8, DRAW_ARROW, STYLE_DOT, 0, clrNONE);
   SetIndexArrow(8, 171);
   SetIndexDrawBegin(8, x - 1);
   SetIndexLabel(8, "Resistencia");
   SetIndexBuffer(9, Suporte);
   SetIndexArrow(9, 171);
   SetIndexStyle(9, DRAW_ARROW, STYLE_DOT, 0, clrNONE);
   SetIndexDrawBegin(9, x - 1);
   SetIndexLabel(9, "Suporte");
//===========================================================================================================================================================
   SetIndexBuffer(10,ExtMapBuffer3);
   SetIndexStyle(10,DRAW_LINE,STYLE_SOLID,0,clrGreen);
   SetIndexLabel(10, "Linha Ema");
//============================================================================================================================================================
   SetIndexBuffer(11,ExtMapBuffer1);
   SetIndexStyle(11,DRAW_LINE,STYLE_SOLID,0,clrNONE);
   SetIndexLabel(11, "Linha Ema");
//============================================================================================================================================================
   SetIndexBuffer(12,ExtMapBuffer2);
   SetIndexStyle(12,DRAW_LINE,STYLE_SOLID,0,clrNONE);
   SetIndexLabel(12, "Linha Ema");
//============================================================================================================================================================
   switch(MAType)
     {
      case 1:
         strMAType="EMA";
         MAMode=MODE_EMA;
         break;
      case 2:
         strMAType="SMMA";
         MAMode=MODE_SMMA;
         break;
      case 3:
         strMAType="LWMA";
         MAMode=MODE_LWMA;
         break;
      case 4:
         strMAType="LSMA";
         break;
      default:
         strMAType="SMA";
         MAMode=MODE_SMA;
         break;
     }
//============================================================================================================================================================
   if(OperarComMX2)
     {
      string carregando = "Conectado... Enviando Sinal Pro MX2 TRADING...!";
      CreateTextLable("carregando1",carregando,10,"Verdana",clrWhiteSmoke,2,10,5);
     }
//============================================================================================================================================================
   if(OperarComPricePro)
     {
      string carregando = "Conectado... Enviando Sinal Pro PRICEPRO...";
      CreateTextLable("carregando1",carregando,10,"Verdana",clrWhiteSmoke,2,10,5);
     }
//============================================================================================================================================================
   if(OperarComMT2)
     {
      string carregando = "Conectado... Enviando Sinal Pro MT2...";
      CreateTextLable("carregando1",carregando,10,"Verdana",clrWhiteSmoke,2,10,5);
     }
//============================================================================================================================================================
   if(OperarComTOPWIN)
     {
      string carregando = "Conectado... Enviando Sinal Pro TOPWIN...";
      CreateTextLable("carregando1",carregando,10,"Verdana",clrWhiteSmoke,2,10,5);
     }
//============================================================================================================================================================
   if(OperarComMAMBA)
     {
      string carregando = "Enviando Sinal Pro MAMBA...";
      CreateTextLable("carregando1",carregando,10,"Verdana",clrLavender,2,10,5);
     }
//============================================================================================================================================================
//SEGURANCA CHAVE---//
   if(!demo_f())
      return(INIT_FAILED);
   if(!acc_number_f())
      return(INIT_FAILED);
//============================================================================================================================================================
   EventSetTimer(1);
   chartInit(mID);  // Chart Initialization
   lbnum = getlbnum(); // Generating Special Connector ID

// Initialize the time flag
   sendOnce = TimeCurrent();
// Generate a unique signal id for MT2IQ signals management (based on timestamp, chart id and some random number)
   MathSrand(GetTickCount());
   if(MartingaleType == OnNextExpiry)
      signalID = IntegerToString(GetTickCount()) + IntegerToString(MathRand()) + " OnNextExpiry";   // For OnNextSignal martingale will be indicator-wide unique id generated
   else
      if(MartingaleType == Anti_OnNextExpiry)
         signalID = IntegerToString(GetTickCount()) + IntegerToString(MathRand()) + " AntiOnNextExpiry";   // For OnNextSignal martingale will be indicator-wide unique id generated
      else
         if(MartingaleType == OnNextSignal)
            signalID = IntegerToString(ChartID()) + IntegerToString(AccountNumber()) + IntegerToString(mID) + " OnNextSignal";   // For OnNextSignal martingale will be indicator-wide unique id generated
         else
            if(MartingaleType == Anti_OnNextSignal)
               signalID = IntegerToString(ChartID()) + IntegerToString(AccountNumber()) + IntegerToString(mID) + " AntiOnNextSignal";   // For OnNextSignal martingale will be indicator-wide unique id generated
            else
               if(MartingaleType == OnNextSignal_Global)
                  signalID = "MARTINGALE GLOBAL On Next Signal";   // For global martingale will be terminal-wide unique id generated
               else
                  if(MartingaleType == Anti_OnNextSignal_Global)
                     signalID = "MARTINGALE GLOBAL Anti On Next Signal";   // For global martingale will be terminal-wide unique id generated
//============================================================================================================================================================
// Symbol name should consists of 6 first letters
   if(StringLen(Symbol()) >= 6)
      asset = StringSubstr(Symbol(),0,6);
   else
      asset = Symbol();
//============================================================================================================================================================
   if(Corretoram == IQOPTION)
     {
      porta = 5000;
     }
   if(Corretoram == BINOMO)
     {
      porta= 5001;
     }
   if(Corretoram == QUOTEX)
     {
      porta= 5002;
     }
//============================================================================================================================================================
   if(StringLen(Symbol()) > 6)
     {
      sendOnce = TimeGMT();
     }
   else
     {
      sendOnce = TimeCurrent();
     }
   return(INIT_SUCCEEDED);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectsDeleteAll(0,"Text*");
   ObjectsDeleteAll(0,"fundo*");
   ObjectsDeleteAll(0,"Linha_*");
   ObjectsDeleteAll(0, "FrameLabel*");
   ObjectsDeleteAll(0, "label*");
   ObjectDelete(0,"zexa");
   ObjectDelete(0,"Sniper");
   ObjectDelete(0,"Sniper1");
   ObjectDelete(0,"Sniper2");
   ObjectDelete(0,"Sniper3");
   ObjectDelete(0,"expiracao");
   ObjectDelete(0,"Sniper4");
   ObjectDelete(0,"Time_Remaining");
   ObjectDelete(0,"carregando");
   ObjectDelete(0,"carregando1");
   ObjectDelete(0,"renovar");
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//============================================================================================================================================================
//SEGURANCA CHAVE---//
   if(!demo_f())
      return(INIT_FAILED);
   if(!acc_number_f())
      return(INIT_FAILED);
//============================================================================================================================================================
   if(isNewBar())
     {
     }
   bool ativa = false;
   ResetLastError();

   if(MartingaleType == NoMartingale || MartingaleType == OnNextExpiry || MartingaleType == Anti_OnNextExpiry)
      signalID = IntegerToString(GetTickCount()) + IntegerToString(MathRand());   // For NoMartingale or OnNextExpiry martingale will be candle-wide unique id generated
//============================================================================================================================================================
   for(int i=Velas; i>=0; i--)
     {
        {
         //============================================================================================================================================================
         bool  up_taurus, dn_taurus;
         //============================================================================================================================================================
         if(MAType==0)
           {
            MA_Cur=LSMA(MAPeriod,i);
            MA_Prev=LSMA(MAPeriod,i+1);
           }
         else
           {
            MA_Cur=iMA(NULL,0,MAPeriod,0,MAMode,PRICE_CLOSE,i);
            MA_Prev=iMA(NULL,0,MAPeriod,0,MAMode,PRICE_CLOSE,i+1);
           }
         //---- COLOR CODING
         ExtMapBuffer3[i]=MA_Cur; //red
         ExtMapBuffer2[i]=MA_Cur; //green
         ExtMapBuffer1[i]=MA_Cur; //yello
         //============================================================================================================================================================
         double ema1 = iMA(NULL, 0, 9, 1, MODE_EMA, PRICE_HIGH,i);
         double ema2 = iMA(NULL, 0, 9, 1, MODE_EMA, PRICE_LOW,i);
         double velas = (Open[i] + High[i] + Low[i] + Close[i]) / 4.0;
         double fractal1 = iFractals(NULL, 0, MODE_UPPER, i);
         if(fractal1 > 0.0 && velas > ema1)
            Resistencia[i] = High[i];
         else
            Resistencia[i] = Resistencia[i+1];
         double fractal2 = iFractals(NULL, 0, MODE_LOWER, i);
         if(fractal2 > 0.0 && velas < ema2)
            Suporte[i] = Low[i];
         else
            Suporte[i] = Suporte[i+1];
         //===========================================================================================================================================================
         if(PriceAction)
           {
            //============================================================================================================================================================
            if((High[i+0] >= Suporte[i+0]) &&(Low[i+0] <=Suporte[i+0]))
               //============================================================================================================================================================
               up_taurus = true;
            else
               up_taurus = false;
            //============================================================================================================================================================
            if((Low[i+0] <=Resistencia[i+0]) &&(High[i+0] >= Resistencia[i+0]))
               //============================================================================================================================================================
               dn_taurus = true;
            else
               dn_taurus = false;
            //============================================================================================================================================================
           }
         else
           {
            up_taurus = true;
            dn_taurus = true;
           }
         //============================================================================================================================================================
         // BAFFES DAS SETAS
         //============================================================================================================================================================
         if(up_taurus
            && up[i] == EMPTY_VALUE
            && down[i] == EMPTY_VALUE
            && (!FiltroDeTendência || (FiltroDeTendência && MA_Prev < MA_Cur))
            && (_Period == 1 || _Period == 5 || _Period == 15)
            //============================================================================================================================================================
            // PRE ALERTA
            //============================================================================================================================================================
           )
           {
            if(Time[i] > LastSignal + (Period()*Intervalo)*60)
              {
               CrossUp[i] = iLow(_Symbol,PERIOD_CURRENT,i)-2*Point();
               Sig_Up0=1;
              }
           }
         else
           {
            CrossUp[i] = EMPTY_VALUE;
            Sig_Up0=0;
           }
         //============================================================================================================================================================
         // BAFFES DAS SETAS
         //============================================================================================================================================================
         if(dn_taurus
            && up[i] == EMPTY_VALUE
            && down[i] == EMPTY_VALUE
            && (!FiltroDeTendência || (FiltroDeTendência && MA_Prev > MA_Cur))
            && (_Period == 1 || _Period == 5 || _Period == 15)
            //============================================================================================================================================================            //Original Mercado Aberto
            // PRE ALERTA
            //============================================================================================================================================================
           )
           {
            if(Time[i] > LastSignal + (Period()*Intervalo)*60)
              {
               CrossDown[i] = iHigh(_Symbol,PERIOD_CURRENT,i)+2*Point();
               Sig_Dn0=1;
              }
           }
         else
           {
            CrossDown[i] = EMPTY_VALUE;
            Sig_Dn0=0;
           }
         //============================================================================================================================================================
         if(sinal_buffer(CrossUp[i+1]) && !sinal_buffer(up[i+1]))
           {
            LastSignal = Time[i];
            up[i] = iLow(_Symbol,PERIOD_CURRENT,i)-8*Point();
            Sig_UpCall0=1;
           }
         else
           {
            Sig_UpCall0=0;
           }
         //============================================================================================================================================================
         if(sinal_buffer(CrossDown[i+1]) && !sinal_buffer(down[i+1]))
           {
            LastSignal = Time[i];
            down[i] = iHigh(_Symbol,PERIOD_CURRENT,i)+8*Point();
            Sig_DnPut0=1;
           }
         else
           {
            Sig_DnPut0=0;
           }
        }
     }
//============================================================================================================================================================
//SEGURANCA CHAVE---//
   if(!demo_f())
      return(INIT_FAILED);
   if(!acc_number_f())
      return(INIT_FAILED);
//============================================================================================================================================================
//Original Mercado Aberto E De OTC Conectores Tendencia !!
//============================================================================================================================================================
   if(Time[0] > sendOnce && sinal_buffer(CrossUp[0]))  //Ante Delay
     {
      //============================================================================================================================================================
      //  Comment(WinRate1," % ",WinRate1);              // FILTRO MAO FIXA
      if(!Mãofixa
         || (FiltroMãofixa && ((!Mãofixa && FiltroMãofixa <= WinRate1) || (Mãofixa && FiltroMãofixa <= WinRate1)))
        )
        {
         //============================================================================================================================================================
         if(SecToEnd() <= SecEnvio)
           {
            //============================================================================================================================================================
            if(OperarComMT2)
              {
               mt2trading(asset, "CALL", TradeAmount, ExpiryMinutes, MartingaleType, MartingaleSteps, MartingaleCoef, Broker, SignalName, signalID);
               Print("CALL - Sinal enviado para MT2!");
              }
            if(OperarComMX2)
              {
               mx2trading(Symbol(), "CALL", ExpiryMinutes, SignalName, SinalEntradaMX2, TipoExpiracao, PeriodString(), IntegerToString(mID), IntegerToString(CorretoraMx2));
               Print("CALL - Sinal enviado para MX2!");
              }
            if(OperarComPricePro)
              {
               TradePricePro(asset, "CALL", ExpiryMinutes, SignalName, 3, 1, int(TimeLocal()), PriceProCorretora);
               Print("CALL - Sinal enviado para PricePro!");
              }
            if(OperarComMAMBA)
              {

               mambabot(Symbol(),"CALL",ExpiryMinutes,SignalName,porta);
               Print("CALL - Sinal enviado para MAMBA!");
              }
            if(OperarComTOPWIN)
              {
               string texto = ReadFile(diretorio);
               datetime hora_entrada =  TimeLocal();
               string entrada = asset+",call,"+string(ExpiryMinutes)+","+string(Momento_Entrada)+","+string(SignalName)+","+string(hora_entrada)+","+string(Period());
               texto = texto +"\n"+ entrada;
               WriteFile(diretorio,texto);
              }
            sendOnce = Time[0];
           }
        }
     }
//============================================================================================================================================================
//Original Mercado Aberto E De OTC Conectores Tendencia !!
//============================================================================================================================================================
   if(Time[0] > sendOnce && sinal_buffer(CrossDown[0]))  //Ante Delay
     {
      //============================================================================================================================================================
      //  Comment(WinRate1," % ",WinRate1);              // FILTRO MAO FIXA
      if(!Mãofixa
         || (FiltroMãofixa && ((!Mãofixa && FiltroMãofixa <= WinRate1) || (Mãofixa && FiltroMãofixa <= WinRate1)))
        )
        {
         //============================================================================================================================================================
         if(SecToEnd() <= SecEnvio)
           {
            //============================================================================================================================================================
            if(OperarComMT2)
              {
               mt2trading(asset, "PUT", TradeAmount, ExpiryMinutes, MartingaleType, MartingaleSteps, MartingaleCoef, Broker, SignalName, signalID);
               Print("PUT - Sinal enviado para MT2!");
              }
            if(OperarComMX2)
              {
               mx2trading(Symbol(), "PUT", ExpiryMinutes, SignalName, SinalEntradaMX2, TipoExpiracao, PeriodString(), IntegerToString(mID), IntegerToString(CorretoraMx2));
               Print("PUT - Sinal enviado para MX2!");
              }
            if(OperarComPricePro)
              {
               TradePricePro(asset, "PUT", ExpiryMinutes,SignalName, 3, 1, int(TimeLocal()), PriceProCorretora);
               Print("PUT - Sinal enviado para PricePro!");
              }
            if(OperarComMAMBA)
              {
               mambabot(Symbol(),"PUT",ExpiryMinutes, SignalName,porta);
               Print("PUT - Sinal enviado para MAMBA!");
              }
            if(OperarComTOPWIN)
              {
               string texto = ReadFile(diretorio);
               datetime hora_entrada =  TimeLocal();
               string entrada = asset+",put,"+string(ExpiryMinutes)+","+string(Momento_Entrada)+","+string(SignalName)+","+string(hora_entrada)+","+string(Period());
               texto = texto +"\n"+ entrada;
               WriteFile(diretorio,texto);
              }
            sendOnce = Time[0];
           }
        }
     }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                         ALERTAS                                  |
//+------------------------------------------------------------------+
   if(AlertsMessage || AlertsSound)
     {
      string message1 = (SignalName+" - "+Symbol()+" : ALVO NA MIRA PRA CALL "+PeriodString());
      string message2 = (SignalName+" - "+Symbol()+" : ALVO NA MIRA PRA PUT  "+PeriodString());

      if(TimeBarUp!=Time[0] && Sig_Up0==1)
        {
         if(AlertsMessage)
            Alert(message1);

         if(AlertsSound)
            PlaySound(SoundFileUp);
         if(AlertEmailSubject > "")
            SendMail(AlertEmailSubject,message1);
         if(SendPushNotification)
            SendNotification(message1);
         TimeBarUp=Time[0];
        }
      if(TimeBarDn!=Time[0] && Sig_Dn0==1)
        {
         if(AlertsMessage)
            Alert(message2);

         if(AlertsSound)
            PlaySound(SoundFileDown);
         if(AlertEmailSubject > "")
            SendMail(AlertEmailSubject,message2);
         if(SendPushNotification)
            SendNotification(message2);
         TimeBarDn=Time[0];
        }
     }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                         ALERTAS                                  |
//+------------------------------------------------------------------+
   if(AlertsMessage || AlertsSound)
     {
      string messageEntrada1 = (SignalName+" - "+Symbol()+" ENTRA CALL "+PeriodString());
      string messageEntrada2 = (SignalName+" - "+Symbol()+" ENTRA PUT "+PeriodString());

      if(TimeBarEntradaUp!=Time[0] && Sig_UpCall0==1)
        {
         if(AlertsMessage)
            Alert(messageEntrada1);
         if(AlertsSound)
            PlaySound("alert2.wav");
         TimeBarEntradaUp=Time[0];
        }
      if(TimeBarEntradaDn!=Time[0] && Sig_DnPut0==1)
        {
         if(AlertsMessage)
            Alert(messageEntrada2);
         if(AlertsSound)
            PlaySound("alert2.wav");
         TimeBarEntradaDn=Time[0];
         TimeBarEntradaDn=Time[0];
        }
     }
//============================================================================================================================================================
   backteste();
   return (prev_calculated);
  }
//============================================================================================================================================================
void WriteFile(string path, string escrita)
  {
   int filehandle = FileOpen(path,FILE_WRITE|FILE_TXT);
   FileWriteString(filehandle,escrita);
   FileClose(filehandle);
  }
//============================================================================================================================================================
string ReadFile(string path)
  {
   int handle;
   string str,word;
   handle=FileOpen(path,FILE_READ);
   while(!FileIsEnding(handle))
     {
      str=FileReadString(handle);
      word = word +"\n"+ str;
     }
   FileClose(handle);
   return word;
  }
//============================================================================================================================================================
bool sinal_buffer(double value)
  {
   if(value != 0 && value != EMPTY_VALUE)
      return true;
   else
      return false;
  }
//============================================================================================================================================================
void CreateTextLable
(string TextLableName, string Text, int TextSize, string FontName, color TextColor, int TextCorner, int X, int Y)
  {
//---
   ObjectCreate(TextLableName, OBJ_LABEL, 0, 0, 0);
   ObjectSet(TextLableName, OBJPROP_CORNER, TextCorner);
   ObjectSet(TextLableName, OBJPROP_XDISTANCE, X);
   ObjectSet(TextLableName, OBJPROP_YDISTANCE, Y);
   ObjectSetText(TextLableName,Text,TextSize,FontName,TextColor);
   ObjectSetInteger(0,TextLableName,OBJPROP_HIDDEN,true);
  }
//============================================================================================================================================================
void OnTimer()
  {
   int thisbarminutes = Period();

   double thisbarseconds=thisbarminutes*60;
   double seconds=thisbarseconds -(TimeCurrent()-Time[0]);

   double minutes= MathFloor(seconds/60);
   double hours  = MathFloor(seconds/3600);

   minutes = minutes -  hours*60;
   seconds = seconds - minutes*60 - hours*3600;

   string sText=DoubleToStr(seconds,0);
   if(StringLen(sText)<2)
      sText="0"+sText;
   string mText=DoubleToStr(minutes,0);
   if(StringLen(mText)<2)
      mText="0"+mText;
   string hText=DoubleToStr(hours,0);
   if(StringLen(hText)<2)
      hText="0"+hText;

   ObjectSetText("Time_Remaining", "Tempo Da Vela  "+mText+":"+sText, 13, "@Batang", StrToInteger(mText+sText) >= 0010 ? clrWhiteSmoke : clrRed);

   ObjectSet("Time_Remaining",OBJPROP_CORNER,1);
   ObjectSet("Time_Remaining",OBJPROP_XDISTANCE,10);
   ObjectSet("Time_Remaining",OBJPROP_YDISTANCE,3);
   ObjectSet("Time_Remaining",OBJPROP_BACK,false);
   if(!initgui)
     {
      ObjectsDeleteAll(0,"Obj_*");
      initgui = true;
     }
  }
//============================================================================================================================================================
int SecToEnd()
  {
   int sec = int((Time[0]+PeriodSeconds()) - TimeCurrent());
   return(sec);
  }
//============================================================================================================================================================
double LSMA(int Rperiod, int shift)
  {
   int i;
   double sum;
   int length;
   double lengthvar;
   double tmp;
   double wt;
//----
   length=Rperiod;
//----
   sum=0;
   for(i=length; i>=1 ; i--)
     {
      lengthvar=length + 1;
      lengthvar/=3;
      tmp=0;
      tmp =(i - lengthvar)*Close[length-i+shift];
      sum+=tmp;
     }
   wt=sum*6/(length*(length+1));
//----
   return(wt);
  }
//============================================================================================================================================================
string PeriodString()
  {
   switch(_Period)
     {
      case PERIOD_M1:
         return("M1");
      case PERIOD_M5:
         return("M5");
      case PERIOD_M15:
         return("M15");
      case PERIOD_M30:
         return("M30");
      case PERIOD_H1:
         return("H1");
      case PERIOD_H4:
         return("H4");
      case PERIOD_D1:
         return("D1");
      case PERIOD_W1:
         return("W1");
      case PERIOD_MN1:
         return("MN1");
     }
   return("M" + string(_Period));
  }
//============================================================================================================================================================
bool isNewBar()
  {
   static datetime time=0;
   if(time==0)
     {
      time=Time[0];
      return false;
     }
   if(time!=Time[0])
     {
      time=Time[0];
      return true;
     }
   return false;
  }
//============================================================================================================================================================
void backteste()
  {
     {
      for(int fcr=Velas; fcr>=0; fcr--)
        {
         //Sem Gale
         if(sinal_buffer(down[fcr]) && Close[fcr]<Open[fcr])
           {
            win[fcr] = High[fcr] + 30*Point;
            loss[fcr] = EMPTY_VALUE;
            continue;
           }
         if(sinal_buffer(down[fcr]) && Close[fcr]>=Open[fcr])
           {
            loss[fcr] = High[fcr] + 30*Point;
            win[fcr] = EMPTY_VALUE;
            continue;
           }
         if(sinal_buffer(up[fcr]) && Close[fcr]>Open[fcr])
           {
            win[fcr] = Low[fcr] - 30*Point;
            loss[fcr] = EMPTY_VALUE;
            continue;
           }
         if(sinal_buffer(up[fcr]) && Close[fcr]<=Open[fcr])
           {
            loss[fcr] = Low[fcr] - 30*Point;
            win[fcr] = EMPTY_VALUE;
            continue;
           }
         //============================================================================================================================================================
         //G1
         if(sinal_buffer(down[fcr+1]) && sinal_buffer(loss[fcr+1]) && Close[fcr]<Open[fcr])
           {
            wg[fcr] = High[fcr] + 30*Point;
            ht[fcr] = EMPTY_VALUE;
            continue;
           }
         if(sinal_buffer(down[fcr+1]) && sinal_buffer(loss[fcr+1]) && Close[fcr]>=Open[fcr])
           {
            ht[fcr] = High[fcr] + 30*Point;
            wg[fcr] = EMPTY_VALUE;
            continue;
           }
         if(sinal_buffer(up[fcr+1]) && sinal_buffer(loss[fcr+1]) && Close[fcr]>Open[fcr])
           {
            wg[fcr] = Low[fcr] - 30*Point;
            ht[fcr] = EMPTY_VALUE;
            continue;
           }
         if(sinal_buffer(up[fcr+1]) && sinal_buffer(loss[fcr+1]) && Close[fcr]<=Open[fcr])
           {
            ht[fcr] = Low[fcr] - 30*Point;
            wg[fcr] = EMPTY_VALUE;
            continue;
           }
        }
     }
//============================================================================================================================================================
   if(Time[0]>tvb1)
     {
      g = 0;
      wbk = 0;
      lbk = 0;
      wg1 = 0;
      ht1 = 0;
     }
//============================================================================================================================================================
   if(AtivaPainel==true && g==0)
     {
      tvb1 = Time[0];
      g=g+1;

      for(int v=Velas; v>0; v--)
        {
         if(win[v]!=EMPTY_VALUE)
           {
            wbk = wbk+1;
           }
         if(loss[v]!=EMPTY_VALUE)
           {
            lbk=lbk+1;
           }
         if(wg[v]!=EMPTY_VALUE)
           {
            wg1=wg1+1;
           }
         if(ht[v]!=EMPTY_VALUE)
           {
            ht1=ht1+1;
           }
        }
      //============================================================================================================================================================
      wg1 = wg1 +wbk;

      if((wbk + lbk)!=0)
        {
         WinRate1 = ((lbk/(wbk + lbk))-1)*(-100);
        }
      else
        {
         WinRate1=100;
        }

      if((wg1 + ht1)>0)
        {
         WinRateGale1 = ((ht1/(wg1 + ht1)) - 1)*(-100);
        }
      else
        {
         WinRateGale1=100;
        }
      //============================================================================================================================================================
      ObjectCreate("zexa",OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSet("zexa",OBJPROP_BGCOLOR,clrBlack);
      ObjectSet("zexa",OBJPROP_CORNER,0);
      ObjectSet("zexa",OBJPROP_BACK,false);
      ObjectSet("zexa",OBJPROP_XDISTANCE,0);
      ObjectSet("zexa",OBJPROP_YDISTANCE,0);
      ObjectSet("zexa",OBJPROP_XSIZE,260); //190
      ObjectSet("zexa",OBJPROP_YSIZE,85);
      ObjectSet("zexa",OBJPROP_ZORDER,0);
      ObjectSet("zexa",OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSet("zexa",OBJPROP_COLOR,clrNONE);
      ObjectSet("zexa",OBJPROP_WIDTH,0);
      //============================================================================================================================================================
      ObjectCreate("Sniper",OBJ_LABEL,0,0,0,0,0);
      ObjectSetText("Sniper","TAURUS SNIPER V8", 10, "Arial Black",clrWhiteSmoke);
      ObjectSet("Sniper",OBJPROP_XDISTANCE,40);
      ObjectSet("Sniper",OBJPROP_ZORDER,9);
      ObjectSet("Sniper",OBJPROP_BACK,false);
      ObjectSet("Sniper",OBJPROP_YDISTANCE,6);
      ObjectSet("Sniper",OBJPROP_CORNER,0);
      //============================================================================================================================================================
      ObjectCreate("Sniper1",OBJ_LABEL,0,0,0,0,0,0);
      ObjectSetText("Sniper1","[  MÃO FIXA  "+DoubleToString(wbk,0)+"x"+DoubleToString(lbk,0)+"  "+DoubleToString(WinRate1,2)+"%  ]",13, "Andalus",clrWhiteSmoke);
      ObjectSet("Sniper1",OBJPROP_XDISTANCE,10);
      ObjectSet("Sniper1",OBJPROP_ZORDER,9);
      ObjectSet("Sniper1",OBJPROP_BACK,false);
      ObjectSet("Sniper1",OBJPROP_YDISTANCE,25);
      ObjectSet("Sniper1",OBJPROP_CORNER,0);
     }
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//SEG AVANCADA
//+------------------------------------------------------------------+
//============================================================================================================================================================
#import "mll.dll"
string MLVersion();
int MLRand(int min,int max);        // Para obter um número aleatório entre mínimo e máximo
bool MLFileExists(string filename); // A verificação FileExists pode verificar o disco rígido inteiro, não está preso dentro dos arquivos /
string MLComputerID();              // ComputerID Determination, Computer ID
string MLMACID();                   // MACID Determination, Network Card ID
int MLMt4ToFront();                 // This will bring MT4 Terminal to front, use it to display alerts etc
int MLOpenBrowser(string url);      // Open url in browser
int MLChartToFront(int hwnd);       // Bring chart to front
int MLStartTicker(int hwnd, int period);  // Start automatic ticker, returns a handle
int MLStopTicker(int hwnd, int handle);   // Stop ticker from given handle

// Link Functions
int MLLinkAdd(int hwnd, int parent, string text, string link);
int MLLinkRemoveAll(int root);

// Windows Path Functions
string MLGetWinDir();                  // returns %windir%
string MLGetTempDir();                 // returns %temp%
string MLGetAppdataDir();              // returns %appdata%
string MLGetHomeDir();                 // returns %homedir%
string MLGetSystemDrive();             // returns %systemdrive%
string MLGetProgramFilesDir();         // returns %programfiles%

// Shell Commands
int MLShellExecute(string command, bool hidden);// Execute o comando, o estado oculto funciona apenas para comandos DOS// Sempre oculto = verdadeiro por aplicativos do Windows!
#import
//============================================================================================================================================================
//FIM
//============================================================================================================================================================
bool demo_f()
  {
//demo
   if(use_demo)
     {
      if(Time[0]>=StringToTime(expir_date))
        {
         Alert(expir_msg);
         return(false);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
bool acc_number_f()
  {
//acc_number
   if(use_acc_number)
     {
      if(AccountNumber()!=acc_number && AccountNumber()!=0)
        {
         Alert(acc_numb_msg);
         return(false);
        }
     }
   return(true);
  }
//============================================================================================================================================================
//FIM

//+------------------------------------------------------------------+
