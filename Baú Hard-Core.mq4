//+------------------------------------------------------------------+
//|                                            Bau Hard Core.mq4     |
//|                                Copyright 2022, Cairo Junior.     |
//|                                     https://t.me/Cairo_Junior    |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022 Cairo Júnior"
#property link      "https://t.me/Cairo_Junior"
#property version   "1.2"
#property strict
#property indicator_chart_window
#property indicator_buffers 12

#import "Kernel32.dll"
   bool GetVolumeInformationW(string,string,uint,uint&[],uint,uint,string,uint);
#import

#import  "Wininet.dll"
   int InternetOpenW(string, int, string, string, int);
   int InternetConnectW(int, string, int, string, string, int, int, int); 
   int HttpOpenRequestW(int, string, string, int, string, int, string, int); 
   int InternetOpenUrlW(int, string, string, int, int, int);
   int InternetReadFile(int, uchar & arr[], int, int& OneInt[]);
   int InternetCloseHandle(int); 
#import
#define READURL_BUFFER_SIZE   100
#define INTERNET_FLAG_NO_CACHE_WRITE 0x04000000

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
enum sinal
  {
   MESMA_VELA = 0, //Mesma vela
   PROXIMA_VELA = 1 //Proxima vela
  };
   
enum simnao 
  {
   NAO = 0, //Não
   SIM = 1  //Sim
  };

enum retrev
  {
   RevSr =0,      //REVERTE = Suporte/Resistência
   RetSr =1,      //RETRAI: Suporte/Resistência
   RevLt =2,      //REVERTE = LTA/LTB
   RetLt =3,      //RETRAI: LTA/LTB
   RevSrouLt =4,  //REVERTE = Suporte/Resistência ou LTA/LTB
   RetSrouLt =5,  //RETRAI: Suporte/Resistência ou LTA/LTB
   RevSreLt  =6,  //REVERTE = Suporte/Resistência e LTA/LTB
   RetSreLt  =7   //RETRAI: Suporte/Resistência e LTA/LTB   
  };

enum entra_gale
  {
   Desativado = 0,   //Desativado
   Gale1=1,          //Gale 1 
   Gale2=2,          //Gale 2
   Gale3=3,          //Gale 3
   Gale4=4,          //Gale 4
   Gale5=5           //Gale 5
  };
    
enum fechamento 
  {
   TOQ = 0, // No toque
   FECH = 1 // Fecha rompido
  };
    
//CORRETORAS DISPONÍVEIS
enum corretora_price_pro
  {
   EmTodas = 1, //Todas
   EmIQOption = 2, //IQ Option
   EmSpectre = 3, //Spectre
   EmBinary = 4, //Binary
   EmGC = 5, //Grand Capital
   EmBinomo = 6, //Binomo
   EmOlymp = 7, //Olymp Trade
   EmQuotex = 8, //Quotex
   EmAlpari = 9, //Alpari
   EmPocket = 10, //Pocket Option
   EmPrice = 11, //Price Tester
   EmBitness = 12, //Bitness
   EmCapitalBear = 13 //Capital Bear
  };

enum tool
  {
   Selecionar_Ferramenta, //Selecionar Automatizador
   FSOCIETY,
   FRANKENSTEIN,
   MX2,
   BotPro,
   PricePro,
   MT2,
   B2IQ,
   Mamba,
   TopWin
  };

//---- Parâmetros de entrada - B2IQ
enum modo 
  {
   MELHOR_PAYOUT = 'M',
   BINARIAS = 'B',
   DIGITAIS = 'D'
  };
//---- Parâmetros de entrada - MX2
enum tipoexpericao
  {
   tempo_fixo = 0, //Tempo fixo
   retracao = 1 //Retração na mesma vela
  };
//---- Parâmetros de entrada - BotPro
enum instrument 
  {
   DoBotPro=3,
   Binaria=0,
   Digital=1,
   MaiorPay=2
  };
enum mg_botpro
  {
   nao = 0, //Não
   sim = 1  //Sim
  };
//---- Parâmetros de entrada - MT2
enum broker
  {
   All = 0,
   IQOption = 1,
   Binary = 2,
   Spectre = 3,
   Alpari = 4
  };
enum martingale
  {
   NoMartingale = 0,
   OnNextExpiry = 1,
   OnNextSignal = 2,
   Anti_OnNextExpiry = 3,
   Anti_OnNextSignal = 4,
   OnNextSignal_Global = 5,
   Anti_OnNextSignal_Global = 6
  };
//---- Parâmetros de entrada - Mamba
enum brokerm
  {
   IQOPTION = 5000, //IQ Option
   BINOMO = 5001,  //Binomo
   QUOTEX = 5002   // Quotex
  };
  
enum auto_sinal
  {
   Desligado = 0,
   Auto      = 1,
   Manual    = 2
  };
      
input string s01 ="======= Backtest ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
bool AtivaPainel = true;                // Ativa Painel de Estatísticas? 
extern int QuantidadeVelas = 288;       // Quantidade de velas para Backtest
extern int Intervalo   = 2;             // Intervalo de velas entre ordens
extern sinal Entrada = MESMA_VELA; // Entrar na:
//-------------------------------------------------------------------------------------+
input string s02 =""; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s03  ="======= Horário de Backtest ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao  FiltroHora = NAO;    // Filtrar horários?
extern int HoraInicio     = 0;      // Início das operações
extern int HoraFim        = 15;     // Fim das operações
extern int Coeficiente    = 5;      // Diferença do horario local com a corretora
//+------------------------------------------------------------------+
input string s04 =""; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s05 ="======= Config. AntiLoss ==============================================================="; //===================================================================
extern entra_gale Antiloss = Desativado; // Ativar AntiLoss(Entrada no gale)
int TotalGalesMinimo = Antiloss;         // Mínimo de barras contra? 0=Desabilita

input string s06 =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao AntiDelay     = NAO; //Ativar AntiDelay
input int antidelay = 2; // Delay em segundos

input string s07 =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s08 ="======= Filtros ==============================================================="; //===================================================================

//-------------------------------------------------------------------------------------+
input string s09         ="======= Rsi ===================================================================";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao             RSI_Enabled = NAO; //Ativar Rsi
extern int                RSI_Period=9; // RSI: Period
extern ENUM_APPLIED_PRICE RSI_Price=PRICE_CLOSE; //RSI: Price
extern int                RSI_MAX=70; // RSI: Overbought Level
extern int                RSI_MIN=30; // RSI: Oversold Level
extern ENUM_TIMEFRAMES    RSITimeFrame = PERIOD_CURRENT; //TimeFrame
//-------------------------------------------------------------------------------------+
input string s10         =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s11         ="======= Stochastic Oscillator ===================================================================";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao             SO_Enabled = NAO; //Ativar Stochastic Oscillator
extern int                SO_KPeriod=5; // SO: K Period
extern int                SO_DPeriod=3; // SO: D Period
extern int                SO_Slowing=3; // SO: Slowing
extern ENUM_MA_METHOD     SO_Mode=MODE_SMA; //SO: Mode
extern ENUM_STO_PRICE     SO_Price=STO_CLOSECLOSE; //SO: Price
extern int                SO_MAX=80; // SO: Overbought Level
extern int                SO_MIN=20; // SO: Oversold Level
extern ENUM_TIMEFRAMES    STCTimeFrame = PERIOD_CURRENT; //TimeFrame
//-------------------------------------------------------------------------------------+
input string s12        =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s13        ="======= CCI ===================================================================" ; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao             CCI_Enabled = NAO;       //Ativar Cci
input int                 CCI_Period = 6;             // Cci: Periodo
input ENUM_APPLIED_PRICE  Apply_to = PRICE_TYPICAL;   // Cci: Price
input int                 CCI_Overbought_Level = 160; // Cci: Nivel De Venda
input int                 CCI_Oversold_Level  = -160; // Cci: Nivel De Compra
//-------------------------------------------------------------------------------------+
input string s14         =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s15         ="======= Bandas de Bollinger ===================================================================";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao             BB1_Enabled = NAO; //Ativar Bollinger Bands
extern int                BB1_Period=20;// BB: Period
extern double             BB1_Deviations=2.0;//BB: Deviation
extern int                BB1_Shift=1;//BB: Shift
input ENUM_APPLIED_PRICE  BB1_Price =PRICE_CLOSE;//Type of the price
extern ENUM_TIMEFRAMES    BBTimeFrame = PERIOD_CURRENT; //TimeFrame
//-------------------------------------------------------------------------------------+
input string s16        =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s17        ="======= Canal de Donchian ===================================================================";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao             DC_Enabled   = NAO; //Ativar Canal de DonChian
extern int                DC_Period    = 20;  // Canal Period
extern int                Margins      =-2;
extern fechamento         Fechamento   = 1;   //Sinal no Toque no canal ou Fechar Rompido
int                       Extremes     = 3;
//-------------------------------------------------------------------------------------+
input string s18        =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s19        ="======= Média movel ===================================================================" ; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao             SMA_Enabled = NAO; // Ativar média
input int                 MA_Period = 20;  // MA PERIODO
input int                 MA_Shift = 0; // MA Shift 
input ENUM_MA_METHOD      MA_Method = MODE_SMMA;// MA MODO 
input ENUM_APPLIED_PRICE  MA_Applied_Price = PRICE_CLOSE;  // MA PREÇO
input int                 FilterShift = 1;   // MA Filtro Shift
//-------------------------------------------------------------------------------------+
input string s20          =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s21          ="======= Rsi Arrows (Hill) ===================================================================";        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao AtivarRsi   = NAO;         // Ativar Rsi Arrows?
extern int    RsiLength1  = 9;
extern int    RsiPrice1   = PRICE_CLOSE;
extern int    HalfLength1 = 5;
extern int    DevPeriod1  = 70;
extern double Deviations1 = 0.8;

input string s22 =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s23 ="======= Value Chart ===================================================================";        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao AtivarVc    = NAO;          // Ativar Value Chart?
extern double value1      = 9.2;          // Nivel Value Chart

input string s24 =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s25 ="======= Trend Force ===================================================================";         /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao AtivarTrend = NAO;          // Trend Force?
extern int    trendPeriod = 2;            // Periodo Trend Force

input string s26 =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s27 ="======= Leituras de Sup/Resist - LTAs E LTBs ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s1111 ="======= OBS: Backtest não funciona em gráfico passado aqui! ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern simnao AtivarLeitura  = NAO;      // Ativar Leitura de Linhas Graficas?
extern retrev RevRet         = RevSr;    // Escolha o tipo de leitura?
string s1000 =":::::::: LINHAS DONFOREX ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar31   = NAO;                    // Ativar Linhas Suporte E Resistencia?
string NomeIndicador31= "X18";                     // NOME Suporte E Resistencia
int BufferCall31 = 0;                              // Buffer de Call
int BufferPut31 = 0 ;                              // Buffer de Put
sinal TipoSinal31 = 0;                             // Tipo de sinal

string s1001 =":::::::: LINHAS LTA E LTB ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar32   = NAO;              // Ativar Linhas LTA e LTB?
string NomeIndicador32 = "X19";              // Zones Trend Line
int BufferCall32 = 0;                        // Buffer de Call
int BufferPut32 = 0;                         // Buffer de Put
sinal TipoSinal32 = 0;                       // Tipo de sinal
// Zones Trend Line

input string s140 =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s141 = "======= Porcentagem de corpo da vela ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern double rollback     = 0; // Proporção min do corpo da vela para os pavios (%, se 0, então não use.)

//+------------------------------------------------------------------+
input string s28 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s29 =":::::::: INDICADORES PRÉ COMBINADOS ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
string s30 =":::::::: Indicador 1 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar1   = NAO;     // Ativar E09 Conservador?
string NomeIndicador1 = "X1";      // Nome do indicador 1
int    BufferCall1 = 1;            // Buffer de Call
int    BufferPut1 = 2;             // Buffer de Put
extern sinal  TipoSinal1 = PROXIMA_VELA;    // Tipo de sinal
ENUM_TIMEFRAMES ICT1TimeFrame = PERIOD_CURRENT; //TimeFrame
//INDICADOR E09
//+------------------------------------------------------------------+
input string s31 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s32 =":::::::: Indicador 2 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar2   = NAO;     // Ativar E09 Média Agressividade?
string NomeIndicador2 = "X1";     // Nome do indicador 2
int    BufferCall2 = 6;            // Buffer de Call
int    BufferPut2 = 7;             // Buffer de Put
extern sinal  TipoSinal2 = PROXIMA_VELA;    // Tipo de sinal 
 ENUM_TIMEFRAMES ICT2TimeFrame = PERIOD_CURRENT; //TimeFrame
 //INDICADOR E09
//+------------------------------------------------------------------+
input string s33 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s34 =":::::::: Indicador 3 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar3   = NAO;       // Ativar E09 Muito Agressivo?
string NomeIndicador3 = "X1";       // Nome do indicador 3
int BufferCall3 = 8;                 // Buffer de Call
int BufferPut3 = 9;                  // Buffer de Put
extern sinal TipoSinal3 = PROXIMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT3TimeFrame = PERIOD_CURRENT; //TimeFrame
 //INDICADOR E09
//+------------------------------------------------------------------+
input string s35 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s36 =":::::::: Indicador 4 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar4   = NAO;     // Ativar RSI 20 - Baú de Tesouro OPEN?
string NomeIndicador4 = "X2";      // Nome do indicador 4
int BufferCall4 = 4;               // Buffer de Call
int BufferPut4 = 5;                // Buffer de Put
extern sinal TipoSinal4 = MESMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT4TimeFrame = PERIOD_CURRENT; //TimeFrame
//RSI 20 - Baú de Tesouro OPEN

input string s37 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s38 =":::::::: Indicador 5 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar5   = NAO;     // Ativar BAÚ RSI SCALPER?
string NomeIndicador5 = "X3";      // Nome do indicador 5
int BufferCall5 = 4;               // Buffer de Call
int BufferPut5 = 5;                // Buffer de Put
extern sinal TipoSinal5 = PROXIMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT5TimeFrame = PERIOD_CURRENT; //TimeFrame
// BAÚ RSI SCALPER PROXIMA VELA

input string s39 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s40 =":::::::: Indicador 6 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar6   = NAO;                     // Ativar BAÚ RSI SCALPER OPEN?
string NomeIndicador6 = "X4";                      // Nome do indicador 6
int BufferCall6 = 4;                               // Buffer de Call
int BufferPut6 = 5;                                // Buffer de Put
extern sinal TipoSinal6 = MESMA_VELA;              // Tipo de sinal
 ENUM_TIMEFRAMES ICT6TimeFrame = PERIOD_CURRENT;   // TimeFrame
// BAÚ RSI SCALPER OPEN = MESMA VELA

input string s41 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s42 =":::::::: Indicador 7 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar7   = NAO;                     // Ativar Value Chart Scalper?
string NomeIndicador7 = "X5";                      // Nome do indicador 7
int BufferCall7 = 0;                               // Buffer de Call
int BufferPut7 = 1;                                // Buffer de Put
extern sinal TipoSinal7 = PROXIMA_VELA;            // Tipo de sinal
 ENUM_TIMEFRAMES ICT7TimeFrame = PERIOD_CURRENT;   // TimeFrame
// Baú Scalper Value

input string s43 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s44 =":::::::: Indicador 8 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar8   = NAO;                     // Ativar Value Chart Nível 6?
string NomeIndicador8 = "X6";                      // Nome do indicador 8
int BufferCall8 = 4;                               // Buffer de Call
int BufferPut8 = 5;                                // Buffer de Put
extern sinal TipoSinal8 = MESMA_VELA;            // Tipo de sinal
 ENUM_TIMEFRAMES ICT8TimeFrame = PERIOD_CURRENT;   // TimeFrame
// Baú Value Chart - Nivel 6

input string s45 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s46 =":::::::: Indicador 9 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar9   = NAO;                     // Ativar Value Chart Nível 7?
string NomeIndicador9 = "X7";                      // Nome do indicador 9
int BufferCall9 = 4;                               // Buffer de Call
int BufferPut9 = 5;                                // Buffer de Put
extern sinal TipoSinal9 = MESMA_VELA;            // Tipo de sinal
 ENUM_TIMEFRAMES ICT9TimeFrame = PERIOD_CURRENT;   // TimeFrame
// Baú Value Chart - Nivel 7

input string s47 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s48 =":::::::: Indicador 10 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar10   = NAO;                     // Ativar Baú SR?
string NomeIndicador10 = "X8";                      // Nome do indicador 10
int BufferCall10 = 1;                               // Buffer de Call
int BufferPut10 = 0;                                // Buffer de Put
extern sinal TipoSinal10 = PROXIMA_VELA;            // Tipo de sinal
 ENUM_TIMEFRAMES ICT10TimeFrame = PERIOD_CURRENT;   // TimeFrame
// BÁU SR

//+------------------------------------------------------------------+
input string s49 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s50 =":::::::: Indicador 11 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar11   = NAO;     // RSI Divergence v.2?
string NomeIndicador11 = "X9";      // Nome do indicador 11
int BufferCall11 = 0;               // Buffer de Call
int BufferPut11 = 1;                // Buffer de Put
extern sinal TipoSinal11 = PROXIMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT11TimeFrame = PERIOD_CURRENT; //TimeFrame
 //RSI_Divergence_v2
//+------------------------------------------------------------------+
input string s51 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s52 =":::::::: Indicador 12 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar12   = NAO;     // Ativar ZUP?
string NomeIndicador12 = "X10";      // Nome do indicador 12
int BufferCall12 = 0;               // Buffer de Call
int BufferPut12 = 0;                // Buffer de Put
extern sinal TipoSinal12 = MESMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT12TimeFrame = PERIOD_CURRENT; //TimeFrame
 //ZUP
//+------------------------------------------------------------------+
input string s53 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s54 =":::::::: Indicador 13 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar13   = NAO;     // Ativar CCI - nrp?
string NomeIndicador13 = "X11";      // Nome do indicador 13
int BufferCall13 = 1;               // Buffer de Call
int BufferPut13 = 3;                // Buffer de Put
extern sinal TipoSinal13 = PROXIMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT13TimeFrame = PERIOD_CURRENT; //TimeFrame
//CCI - nrp
//+------------------------------------------------------------------+
input string s55 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s56 =":::::::: Indicador 14 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
extern simnao Ativar14   = NAO;     // Ativar One Minute Profit-Signal?
string NomeIndicador14 = "X12";      // Nome do indicador 14
int BufferCall14 = 0;               // Buffer de Call
int BufferPut14 = 1;                // Buffer de Put
extern sinal TipoSinal14 = PROXIMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT14TimeFrame = PERIOD_CURRENT; //TimeFrame
//One Minute Profit-Signal
//+------------------------------------------------------------------+
input string s57 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s58 =":::::::: Indicador 15 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar15   = NAO;     // Ativar DonForex ARROW (OTC funcional)?
string NomeIndicador15 = "X13";     // Nome do indicador 15
int BufferCall15 = 0;               // Buffer de Call
int BufferPut15 = 1;                // Buffer de Put
extern sinal TipoSinal15 = PROXIMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT15TimeFrame = PERIOD_CURRENT; //TimeFrame
//DonForex_ARROW
//+------------------------------------------------------------------+
input string s59 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s60 =":::::::: Indicador 16 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar16   = NAO;     // Ativar filter Radio 2?
string NomeIndicador16 = "X14";     // Nome do indicador 16
int BufferCall16 = 1;               // Buffer de Call
int BufferPut16 = 2;                // Buffer de Put
extern sinal TipoSinal16 = MESMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT16TimeFrame = PERIOD_CURRENT; //TimeFrame
//+------------------------------------------------------------------+
input string s61 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s62 =":::::::: Indicador 17 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar17   = NAO;     // Estratégia Para OTC?
string NomeIndicador17 = "X15-OTC"; // Nome do indicador 17
int BufferCall17 = 0;               // Buffer de Call
int BufferPut17 = 1;                // Buffer de Put
extern sinal TipoSinal17 = PROXIMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT17TimeFrame = PERIOD_CURRENT; //TimeFrame
 //TAURUS OTC
//+------------------------------------------------------------------+
input string s63 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s64 =":::::::: Indicador 18 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar18   = NAO;              // Ativar Zones Trend Line?
string NomeIndicador18 = "X16";              // Nome do indicador 18
int BufferCall18 = 0;                        // Buffer de Call
int BufferPut18 = 1;                         // Buffer de Put
extern sinal TipoSinal18 = PROXIMA_VELA;              // Tipo de sinal
 ENUM_TIMEFRAMES ICT18TimeFrame = PERIOD_CURRENT; //TimeFrame
// Zones Trend Line
//+------------------------------------------------------------------+
input string s65 = ""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s66 =":::::::: Indicador 19 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar19   = NAO;              // Ativar Estratégia PullBack?
string NomeIndicador19 = "X17";              // Nome do indicador 19
int BufferCall19 = 3;                        // Buffer de Call
int BufferPut19 = 1;                         // Buffer de Put
extern sinal TipoSinal19 = PROXIMA_VELA;              // Tipo de sinal
 ENUM_TIMEFRAMES ICT19TimeFrame = PERIOD_CURRENT; //TimeFrame
//PullBack? 
//+------------------------------------------------------------------+
input string s100 = ":::::::: [INDICADORES À COMBINAR] ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s101 ="======= Indicador 1 ===================================================================";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s102 =":::::::: Indicador 1 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar20   = NAO;            // Ativar este indicador?
extern string NomeIndicador20 = "";        // Nome do indicador 1
extern int BufferCall20 = "";               // Buffer de Call
extern int BufferPut20 = "";                // Buffer de Put
extern sinal TipoSinal20 = MESMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT20TimeFrame = PERIOD_CURRENT; //TimeFrame
//+------------------------------------------------------------------+
input string s103 = "======= Indicador 2 ==================================================================="; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s104 =":::::::: Indicador 2 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar21   = NAO;             // Ativar este indicador?
extern string NomeIndicador21 = "";         // Nome do indicador 2
extern int    BufferCall21 = "";             // Buffer de Call
extern int    BufferPut21 = "";              // Buffer de Put
extern sinal  TipoSinal21 = MESMA_VELA;     // Tipo de sinal
ENUM_TIMEFRAMES ICT21TimeFrame = PERIOD_CURRENT; //TimeFrame 
//+------------------------------------------------------------------+
input string s105 = "======= Indicador 3 ==================================================================="; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s106 =":::::::: Indicador 3 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
extern simnao Ativar22   = NAO;             // Ativar este indicador?
extern string NomeIndicador22 = "";         // Nome do indicador 3
extern int    BufferCall22 = "";             // Buffer de Call
extern int    BufferPut22 = "";              // Buffer de Put
extern sinal  TipoSinal22 = MESMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT22TimeFrame = PERIOD_CURRENT; //TimeFrame
//+------------------------------------------------------------------+
input string s107 = "======= Indicador 4 ==================================================================="; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s108 =":::::::: Indicador 4 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar23   = NAO;             // Ativar este indicador?
extern string NomeIndicador23 = "";         // Nome do indicador 4
extern int    BufferCall23 = "";             // Buffer de Call
extern int    BufferPut23 = "";              // Buffer de Put
extern sinal  TipoSinal23 = MESMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT23TimeFrame = PERIOD_CURRENT; //TimeFrame
//+------------------------------------------------------------------+
input string s109 = "======= Indicador 5 ==================================================================="; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
string s110 =":::::::: Indicador 5 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::";  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
extern simnao Ativar24   = NAO;             // Ativar este indicador?
extern string NomeIndicador24 = "";         // Nome do indicador 5
extern int    BufferCall24 = "";             // Buffer de Call
extern int    BufferPut24 = "";              // Buffer de Put
extern sinal  TipoSinal24 = MESMA_VELA;     // Tipo de sinal
 ENUM_TIMEFRAMES ICT24TimeFrame = PERIOD_CURRENT; //TimeFrame
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

input string s111 =""; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string s112 = "======= Alertas ==================================================================="; ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern bool   Alertas     = false;

double rollback_bar;

//value
double vcHigh[];
double vcLow[];
double vcOpen[];
double vcClose[];
//fim value

double RS1[];
double ChMid1[];
double ChUp1[];
double ChDn1[];

double preup[];
double predn[];
double up[];
double dn[];

//Trend
double TrendBuffer[];
double TriggBuffera[];
double TriggBufferb[];
double TriggBufferU[];
double TriggBufferD[];
double trend[];
double uptrend[];
double dntrend[];

double win[];
double loss[];
double wg[];
double ht[];
double wg2[];
double ht2[];
double wg1;
double ht1;
bool Painel = TRUE;
string WinRate;
string WinRateGale;
double WinRate1;
double WinRateGale1;
double WinRateGale22;
double ht22;
double wg22;
string WinRateGale2;
double mb;
datetime tvb1;
double Barcurrentopen;
double Barcurrentclose;
double m1;
double m2;
string nome = "teste";
double Barcurrentopen1;
double Barcurrentclose1;
double Barcurrentopen2;
double Barcurrentclose2;
int tb;
double wbk;
double lbk;
int g;

int fechamentominutos;
int fechamentosegundos;
int delay;

double antilossup[];
double antilossdn[];

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
input string S41      = ""; ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern string         Connector = "======= AUTOMATIZADOR (ROBO DE EXECUTAR ORDENS) ==================================================================="; //__
extern auto_sinal     autotrading = Desligado;                            // Ativa Auto Trade
extern tool           select_tool = Selecionar_Ferramenta;                // Trading Automático - Ferramenta
string nome_sinal = "Baú Hard Core";
extern string         sep9="///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////";//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
extern string         sep10="======= Config. FSOCIETY/FRANKENSTEIN ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////
extern string          LocalArqRetorno  = "";                              // Local onde deve salvar o Arquivo de Retorno
extern int TempoDeOperacao_ = 0 ;                                          // Tempo de Expiração em Minuto (0 = Automático)
extern string         sep17="======= Config. MX2 ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////
extern int            expiraca_mx2    = 0;                                //Tempo de Expiração em Minuto (0 = Automático)
extern tipoexpericao  tipo_expiracao_mx2 = tempo_fixo;                    //Tipo Expiração
extern sinal sinal_tipo_mx2  = MESMA_VELA;                                //Entrar na
extern string         sep11="======= Config. BotPro ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////
extern mg_botpro      ativar_mg_botpro = nao;                             //Ativar Martingale
extern int            expiraca_botpro    = 0;                             //Tempo de Expiração em Minuto (0 = Automático)
extern string         trade_amount_botpro = "2%";                         //Investimento (Real ou em Porcentagem)
extern instrument     tipo_ativo_botpro = MaiorPay;                       //Modalidade
extern string         sep12="======= Config. MT2 ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////
extern int            ExpiryMinutes   = 0;                                //Tempo de Expiração em Minuto (0 = Automático)
extern double         TradeAmount     = 25;                               //Investimento
extern martingale     MartingaleType  = NoMartingale;                     //Martingale
extern int            MartingaleSteps = 1;                                //Passos do martingale
extern double         MartingaleCoef  = 2.3;                              //Coeficiente do martingale
extern broker         Broker          = All;                              //Corretora
extern string         sep13="======= Config. B2IQ ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////
extern modo           Modalidade = MELHOR_PAYOUT;                         //Modalidade
extern sinal SinalEntrada = MESMA_VELA;                                   //Entrar na
extern string         vps = "";                                           //IP:PORTA da VPS (caso utilize)
extern string         sep15="====== Config. PricePro ==================================================================="; /////////////////////////////////////////////////////////////////////////////////////////////
extern corretora_price_pro Corretora = EmTodas;                           //Corretora
extern int            TempoDeOperacao = 0;  // Tempo de Expiração em Minuto (0 = Automático)
extern string         sep16="====== Config. Mamba ===================================================================";  /////////////////////////////////////////////////////////////////////////////////////////////
input brokerm Corretoram = 5000;                                         //Corretora




// VARIAVEIS
datetime limitador;
int velasentresinais = 3;
string   terminal_data_;
string   date;
string   tempo_f;

//variaveis frank
datetime tempoEnviado;
string nomearquivo;
string data_patch;
int fileHandle;
int tempo_expiracao;
bool alta;

datetime dfrom;
static int largura_tela = 0, altura_tela = 0;





#import "Connector_Lib.ex4"
   void put(const string ativo, const int periodo, const char modalidade, const int sinal_entrada, const string vps);
   void call(const string ativo, const int periodo, const char modalidade, const int sinal_entrada, const string vps);
#import

#import "MX2Trading_library.ex4"
   bool mx2trading(string par, string direcao, int expiracao, string sinalNome, int Signaltipo, int TipoExpiracao, string TimeFrame, string mID, string Corretora);
#import

#import "botpro_lib.ex4"
   int botpro(string direction, int expiration, int martingale, string symbol, string value, string name, int bindig);
#import

#import "PriceProLib.ex4"
   void TradePricePro(string ativo, string direcao, int expiracao, string nomedosinal, int martingales, int martingale_em, int data_atual, int corretora);
#import

#import "mt2trading_library.ex4"   // Please use only library version 12.4 or higher !!!
   bool mt2trading(string symbol, string direction, double amount, int expiryMinutes);
   bool mt2trading(string symbol, string direction, double amount, int expiryMinutes, string nome_sinal);
   bool mt2trading(string symbol, string direction, double amount, int expiryMinutes, martingale martingaleType, int martingaleSteps, double martingaleCoef, broker myBroker, string nome_sinal, string signalid);
   int  traderesult(string signalid);
#import

#import "MambaLib.ex4"
   void mambabot(string ativo , string sentidoseta , int timeframe , string NomedoSina, int port);
#import

string diretorio = "History\\EURUSD.txt";
string indicador = "";
string terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH);

#define READURL_BUFFER_SIZE   100
#define INTERNET_FLAG_NO_CACHE_WRITE 0x04000000

string timeframe = "M"+IntegerToString(_Period);  
string mID = IntegerToString(ChartID());
static datetime befTime_signal, befTime_const;
string signalID;

int OnInit()
  {
      if(select_tool==FRANKENSTEIN)
     {

      tempoEnviado = TimeCurrent();
      terminal_data_path = TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files\\";
      MqlDateTime time;
      datetime tempo_f = TimeToStruct(TimeLocal(),time);
      string hoje = StringFormat("%d%02d%02d",time.year,time.mon,time.day);
      nomearquivo = hoje+"_retorno.csv";
      data_patch = LocalArqRetorno;
      tempo_expiracao = ExpiryMinutes;
      if(tempo_expiracao == 0)
        {
         tempo_expiracao = Period();
        }

      if(data_patch == "")
        {
         data_patch = terminal_data_path;
        }

      if(FileIsExist(nomearquivo,0))
        {
         Print("Local do Arquivo: "+data_patch+nomearquivo);
         fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
         string data = "tempo,ativo,acao,expiracao";
         FileWrite(fileHandle,data);
         FileClose(fileHandle);

        }
      else
        {
         Print("Criando Arquivo de Retorno...");
         Print("Local do Arquivo: "+data_patch+nomearquivo);
         fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
         string data = "tempo,ativo,acao,expiracao";
         FileWrite(fileHandle,data);
         FileClose(fileHandle);
        }

     }
         
   //FSOCIETY    
   if(select_tool==FSOCIETY)
   {
      tempoEnviado = TimeCurrent();
      terminal_data_ = TerminalInfoString(TERMINAL_DATA_PATH)+"\\MQL4\\Files\\";
      MqlDateTime time;
      tempo_f = TimeToStruct(TimeLocal(),time);
      nomearquivo = "fsociety.csv";
      data_patch = LocalArqRetorno;
      tempo_expiracao = TempoDeOperacao_;
      if(tempo_expiracao == 0)
      {
       tempo_expiracao = Period();
      }
      if(data_patch == "")
        {
         data_patch = terminal_data_;
        }
      if(FileIsExist(nomearquivo,0))
        {
         fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
         date = "tempo;ativo;acao;expiracao;sinal";
         FileWrite(fileHandle,date);
         FileClose(fileHandle);
        }
      else
        {
         fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
         date = "tempo;ativo;acao;expiracao;sinal";
         FileWrite(fileHandle,date);
         FileClose(fileHandle);
        }
    }
 
  
   //IndicatorShortName("Antiloss");
   //--- indicator buffers mapping
   IndicatorSetString(INDICATOR_SHORTNAME,"Baú Hard Core");
/*
   chave = VolumeSerialNumber();

   if ((ExpiryDate == "" || TimeGMT()-10800 < StrToTime(ExpiryDate))
    && (UniqueID == "" || UniqueID == chave))
     {
      //if(ExpiryDate != "") Alert("Sua licença irá expirar em: "+ExpiryDate);
      
	   LIBERAR_ACESSO=true;
     }
   else   
     {
      Alert("Acesso não autorizado.");
      ChartIndicatorDelete(0, 0, "Antiloss");
     }
*/
   terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);

   if(expiraca_mx2==5) expiraca_mx2=Period();
   if(expiraca_botpro==5) expiraca_botpro=Period();
   if(ExpiryMinutes==5) ExpiryMinutes=Period();
   if(TempoDeOperacao==5) TempoDeOperacao=Period();
   if(TempoDeOperacao_==5) TempoDeOperacao_=Period();

   IndicatorBuffers(32);
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_ARROW, EMPTY, 1, clrLime);
   SetIndexArrow(0, 233);
   SetIndexBuffer(0, up);

   SetIndexStyle(1, DRAW_ARROW, EMPTY, 1, clrRed);
   SetIndexArrow(1, 234);
   SetIndexBuffer(1, dn);

   SetIndexStyle(2, DRAW_ARROW, EMPTY, 1, clrLime);
   SetIndexArrow(2, 163);
   SetIndexBuffer(2, preup);

   SetIndexStyle(3, DRAW_ARROW, EMPTY, 1, clrRed);
   SetIndexArrow(3, 163);
   SetIndexBuffer(3, predn);

   SetIndexStyle(4, DRAW_ARROW, EMPTY,2, clrLime);
   SetIndexArrow(4, 78);
   SetIndexBuffer(4, antilossup);
   SetIndexStyle(5, DRAW_ARROW, EMPTY,2, clrRed);
   SetIndexArrow(5, 78);
   SetIndexBuffer(5, antilossdn);   

   SetIndexStyle(6, DRAW_ARROW, EMPTY, 2,clrLime);
   SetIndexArrow(6, 252);
   SetIndexBuffer(6, win);
   SetIndexStyle(7, DRAW_ARROW, EMPTY, 2,clrRed);
   SetIndexArrow(7, 251);
   SetIndexBuffer(7, loss);

   SetIndexStyle(8, DRAW_ARROW, EMPTY, 2,clrYellow);
   SetIndexArrow(8, 252);
   SetIndexBuffer(8, wg);

   SetIndexStyle(9, DRAW_ARROW, EMPTY, 2,clrYellow);
   SetIndexArrow(9, 251);
   SetIndexBuffer(9, ht);

   SetIndexStyle(10, DRAW_ARROW, EMPTY, 2,clrPink);
   SetIndexArrow(10, 252);
   SetIndexBuffer(10, wg2);

   SetIndexStyle(11, DRAW_ARROW, EMPTY, 2,clrPink);
   SetIndexArrow(11, 251);
   SetIndexBuffer(11, ht2);
   
   HalfLength1=MathMax(HalfLength1,1);

   SetIndexBuffer(12,RS1); 
   SetIndexBuffer(13,ChMid1);
   SetIndexBuffer(14,ChUp1); 
   SetIndexBuffer(15,ChDn1);
   
   SetIndexBuffer(18, vcHigh);
   SetIndexBuffer(19, vcLow);
   SetIndexBuffer(20, vcOpen);
   SetIndexBuffer(21, vcClose);

   SetIndexBuffer(22, TriggBuffera);
   SetIndexBuffer(23, TriggBufferb);
   SetIndexBuffer(24, TrendBuffer);
   SetIndexBuffer(25, TriggBufferU);
   SetIndexBuffer(26, TriggBufferD);
   SetIndexBuffer(27, trend);
   SetIndexBuffer(28, uptrend);
   SetIndexBuffer(29, dntrend);
//---

   ObjectCreate(0,"button_call", OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,"button_call",OBJPROP_CORNER,2);
   ObjectSetInteger(0,"button_call",OBJPROP_XSIZE,100);
   ObjectSetInteger(0,"button_call",OBJPROP_YSIZE,40);
   ObjectSetInteger(0,"button_call",OBJPROP_XDISTANCE,700);
   ObjectSetInteger(0,"button_call",OBJPROP_YDISTANCE,1*50);
   ObjectSetInteger(0,"button_call",OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,"button_call",OBJPROP_BGCOLOR,clrGreen);
   ObjectSetString(0,"button_call",OBJPROP_TEXT,"COMPRA");
   
   ObjectCreate(0,"button_put", OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,"button_put",OBJPROP_CORNER,2);
   ObjectSetInteger(0,"button_put",OBJPROP_XSIZE,100);
   ObjectSetInteger(0,"button_put",OBJPROP_YSIZE,40);
   ObjectSetInteger(0,"button_put",OBJPROP_XDISTANCE,820);
   ObjectSetInteger(0,"button_put",OBJPROP_YDISTANCE,1*50);
   ObjectSetInteger(0,"button_put",OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,"button_put",OBJPROP_BGCOLOR,clrTomato);
   ObjectSetString(0,"button_put",OBJPROP_TEXT,"VENDA");
   
   return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason)
  {
   ResetLastError();
   ObjectDelete(0,"zexa");
   ObjectDelete(0,"5twf");
   ObjectDelete(0,"5twf1");
   ObjectDelete(0,"5twf2");
   ObjectDelete(0,"5twf3");
   ObjectDelete(0,"button_call");
   ObjectDelete(0,"button_put");

   //if(LIBERAR_ACESSO==false) ChartIndicatorDelete(0,0,"Antiloss");
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if (id == CHARTEVENT_OBJECT_CLICK) 
     {
      if (ObjectType (sparam) == OBJ_BUTTON) 
        {
         ButtonPressed (0, sparam);
        }
     }
  }

void ButtonPressed (const long chartID, const string sparam) 
  {  
   if (sparam == "button_call") button_call (sparam);
   if (sparam == "button_put") button_put (sparam);
   Sleep (10);
  }

//+------------------------------------------------------------------+
int button_call (const string sparam) 
  {
   if(autotrading==2)
     {
      if(select_tool==MX2) mx2trading(Symbol(), "CALL", expiraca_mx2, nome_sinal, sinal_tipo_mx2, tipo_expiracao_mx2, timeframe, mID, "0");
      else if(select_tool==FSOCIETY)
              {
               fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
               FileSeek(fileHandle, 0, SEEK_END); 
               string data = IntegerToString((long)TimeGMT())+";"+Symbol()+";call;"+IntegerToString(TempoDeOperacao_)+";"+nome_sinal;
               FileWrite(fileHandle,data);
               FileClose(fileHandle);
              }                        
      else if(select_tool==FRANKENSTEIN)
             {
              Print(Symbol(), ",", ExpiryMinutes, ",CALL,", Time[0]);
              fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
              FileSeek(fileHandle, 0, SEEK_END);
              string data = IntegerToString((long)TimeGMT())+","+Symbol()+",call,"+IntegerToString(ExpiryMinutes);
              FileWrite(fileHandle,data);
              FileClose(fileHandle);
             }     
      else if(select_tool==BotPro) botpro("CALL", expiraca_botpro, ativar_mg_botpro, Symbol(), trade_amount_botpro, nome_sinal, tipo_ativo_botpro);
      else if(select_tool==PricePro) TradePricePro(Symbol(), "CALL", TempoDeOperacao, nome_sinal, 3, 1, TimeLocal(), Corretora);
      else if(select_tool==MT2) mt2trading(Symbol(), "CALL", TradeAmount, ExpiryMinutes, MartingaleType, MartingaleSteps, MartingaleCoef, Broker, nome_sinal, signalID);
      else if(select_tool==B2IQ) call(Symbol(), Period(), Modalidade, SinalEntrada, vps);
      else if(select_tool==Mamba) mambabot(_Symbol,"CALL",_Period, nome_sinal, Corretoram);
      else if(select_tool==TopWin)         
        {
         string texto = ReadFile(diretorio);
         datetime hora_entrada =  TimeLocal();
         string entrada = Symbol()+",call,"+string(Period())+","+string(0)+","+string(nome_sinal)+","+string(hora_entrada)+","+string(Period());
         texto = texto +"\n"+ entrada;
         WriteFile(diretorio,texto);
        }
      Print("CALL - Sinal enviado para o Automatizador!");
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int button_put (const string sparam) 
  {
   if(autotrading==2)
     {
      if(select_tool==MX2) mx2trading(Symbol(), "PUT", expiraca_mx2, nome_sinal, sinal_tipo_mx2, tipo_expiracao_mx2, timeframe, mID, "0");
      else if(select_tool==FSOCIETY)
              {
               fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
               FileSeek(fileHandle, 0, SEEK_END); 
               string data = IntegerToString((long)TimeGMT())+";"+Symbol()+";put;"+IntegerToString(TempoDeOperacao_)+";"+nome_sinal;
               FileWrite(fileHandle,data);
               FileClose(fileHandle);
              }                    
      else if(select_tool==FRANKENSTEIN)
             {
              Print(Symbol(), ",", ExpiryMinutes,",PUT,", Time[0]);
              fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
              FileSeek(fileHandle, 0, SEEK_END);
              string data = IntegerToString((long)TimeGMT())+","+Symbol()+",put,"+IntegerToString(ExpiryMinutes);
              FileWrite(fileHandle,data);
              FileClose(fileHandle);
             }            
      else if(select_tool==BotPro) botpro("PUT", expiraca_botpro, ativar_mg_botpro, Symbol(), trade_amount_botpro, nome_sinal, tipo_ativo_botpro);
      else if(select_tool==PricePro) TradePricePro(Symbol(), "PUT", TempoDeOperacao, nome_sinal, 3, 1, TimeLocal(), Corretora);
      else if(select_tool==MT2) mt2trading(Symbol(), "PUT", TradeAmount, ExpiryMinutes, MartingaleType, MartingaleSteps, MartingaleCoef, Broker, nome_sinal, signalID);
      else if(select_tool==B2IQ) put(Symbol(), Period(), Modalidade, SinalEntrada, vps);
      else if(select_tool==Mamba) mambabot(_Symbol,"PUT",_Period, nome_sinal, Corretoram);
      else if(select_tool==TopWin) 
        {
         string texto = ReadFile(diretorio);
         datetime hora_entrada =  TimeLocal();
         string entrada = Symbol()+",put,"+string(Period())+","+string(0)+","+string(nome_sinal)+","+string(hora_entrada)+","+string(Period());
         texto = texto +"\n"+ entrada;
         WriteFile(diretorio,texto);
        }
      Print("PUT - Sinal enviado para o Automatizador!");
     }   
   return(0);
  }
  
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
//---
/*
   if((TimeCurrent() > StringToTime("2022.10.31 18:00:00")))
     {
      ChartIndicatorDelete(0, 0, "Antiloss");
      Alert("Licenca vencida");
      return(1);
     }
*/     
   bool   upvc=false, dnvc=false, hora=false, uprh=false, dnrh=false, ema_up=false, ema_dn=false;
   bool   up_bb1=false, dn_bb1=false, up_dc=false, dn_dc=false, up_rsi=false,dn_rsi=false;
   bool   up_cci=false, dn_cci=false, up_so=false,dn_so=false, uptf=false, dntf=false;
   double up1 = 0, dn1 = 0;
   double up2 = 0, dn2 = 0;
   double up3 = 0, dn3 = 0;
   double up4 = 0, dn4 = 0;
   double up5 = 0, dn5 = 0;
   double up6 = 0, dn6 = 0;
   double up7 = 0, dn7 = 0;
   double up8 = 0, dn8 = 0;
   double up9 = 0, dn9 = 0;
   double up10 = 0, dn10 = 0;
   double up11 = 0, dn11 = 0;
   double up12 = 0, dn12 = 0;
   double up13 = 0, dn13 = 0;
   double up14 = 0, dn14 = 0;
   double up15 = 0, dn15 = 0;
   double up16 = 0, dn16 = 0;
   double up17 = 0, dn17 = 0;
   double up18 = 0, dn18 = 0;
   double up19 = 0, dn19 = 0;
   double up20 = 0, dn20 = 0;
   double up21 = 0, dn21 = 0;
   double up22 = 0, dn22 = 0;
   double up23 = 0, dn23 = 0;
   double up31 = 0, dn31 = 0;
   double up32 = 0, dn32 = 0;
   
   
   //int limit;
/*   
   if(Bars < QuantidadeVelas)   
     {
      limit = Bars-10;
     }
   else
     {
      limit = QuantidadeVelas-10;
     }
*/
   int limit = (rates_total-prev_calculated) > 0 ? QuantidadeVelas : 0;
        
   vl(limit,_Period); 
   rsi1(limit);
   Trend(limit);
   
   for(int i = limit; i >=0; i--)
     {
     
      if(rollback>0)
        {
         rollback_bar = 100;
         if((High[i]-Low[i])==0) rollback_bar  = 0;
         else
           {
            if(Close[i]>=Open[i]) rollback_bar  = ((Close[i]-Open[i])/(High[i]-Low[i]))*100;
            if(Close[i]<=Open[i]) rollback_bar  = ((Open[i]-Close[i])/(High[i]-Low[i]))*100;
           }
        }
     
      //primeiro indicador
      if(Ativar1) 
        {         
         up1 = iCustom(Symbol(),Period(), NomeIndicador1, BufferCall1, i+TipoSinal1);
         dn1 = iCustom(Symbol(),Period(), NomeIndicador1, BufferPut1, i+TipoSinal1);
         up1 = ativar(up1);
         dn1 = ativar(dn1);
        }
      else
        {
         up1 = true;
         dn1 = true;
        }
      //segundo indicador
      if(Ativar2) 
        {
         up2 = iCustom(Symbol(),Period(), NomeIndicador2, BufferCall2, i+TipoSinal2);
         dn2 = iCustom(Symbol(),Period(), NomeIndicador2, BufferPut2, i+TipoSinal2);
         up2 = ativar(up2);
         dn2 = ativar(dn2);
        } else {
         up2 = true;
         dn2 = true;
        }
      //terceiro indicador
      if(Ativar3) 
        {
         up3 = iCustom(Symbol(),Period(), NomeIndicador3, BufferCall3, i+TipoSinal3);
         dn3 = iCustom(Symbol(),Period(), NomeIndicador3, BufferPut3, i+TipoSinal3);
         up3 = ativar(up3);
         dn3 = ativar(dn3);
        } else {
         up3 = true;
         dn3 = true;
        }
      //quarto indicador
      if(Ativar4) 
        {
         up4 = iCustom(Symbol(),Period(), NomeIndicador4, BufferCall4, i+TipoSinal4);
         dn4 = iCustom(Symbol(),Period(), NomeIndicador4, BufferPut4, i+TipoSinal4);
         up4 = ativar(up4);
         dn4 = ativar(dn4);
        } else {
         up4 = true;
         dn4 = true;
        }
        
      //quinto indicador
      if(Ativar5) 
        {
         up5 = iCustom(Symbol(),Period(), NomeIndicador5, BufferCall5, i+TipoSinal5);
         dn5 = iCustom(Symbol(),Period(), NomeIndicador5, BufferPut5, i+TipoSinal5);
         up5 = ativar(up5);
         dn5 = ativar(dn5);
        } else {
         up5 = true;
         dn5 = true;
        } 
        
      //SEXTO indicador
      if(Ativar6) 
        {
         up6 = iCustom(Symbol(),Period(), NomeIndicador6, BufferCall6, i+TipoSinal6);
         dn6 = iCustom(Symbol(),Period(), NomeIndicador6, BufferPut6, i+TipoSinal6);
         up6 = ativar(up6);
         dn6 = ativar(dn6);
        } else {
         up6 = true;
         dn6 = true;
        }
        
      //SÉTIMO indicador
      if(Ativar7) 
        {
         up7 = iCustom(Symbol(),Period(), NomeIndicador7, BufferCall7, i+TipoSinal7);
         dn7 = iCustom(Symbol(),Period(), NomeIndicador7, BufferPut7, i+TipoSinal7);
         up7 = ativar(up7);
         dn7 = ativar(dn7);
        } else {
         up7 = true;
         dn7 = true;
        }
      //OITAVO indicador
      if(Ativar8) 
        {
         up8 = iCustom(Symbol(),Period(), NomeIndicador8, BufferCall8, i+TipoSinal8);
         dn8 = iCustom(Symbol(),Period(), NomeIndicador8, BufferPut8, i+TipoSinal8);
         up8 = ativar(up8);
         dn8 = ativar(dn8);
        } else {
         up8 = true;
         dn8 = true;
        }
      
      //NONO indicador
      if(Ativar9) 
        {
         up9 = iCustom(Symbol(),Period(), NomeIndicador9, BufferCall9, i+TipoSinal9);
         dn9 = iCustom(Symbol(),Period(), NomeIndicador9, BufferPut9, i+TipoSinal9);
         up9 = ativar(up9);
         dn9 = ativar(dn9);
        } else {
         up9 = true;
         dn9 = true;
        }
      //DÉCIMO indicador
      if(Ativar10) 
        {
         up10 = iCustom(Symbol(),Period(), NomeIndicador10, BufferCall10, i+TipoSinal10);
         dn10 = iCustom(Symbol(),Period(), NomeIndicador10, BufferPut10, i+TipoSinal10);
         up10 = ativar(up10);
         dn10 = ativar(dn10);
        } else {
         up10 = true;
         dn10 = true;
        }
      
      //DÉCIMO PRIMEIRO indicador
      if(Ativar11) 
        {
         up11 = iCustom(Symbol(),Period(), NomeIndicador11, BufferCall11, i+TipoSinal11);
         dn11 = iCustom(Symbol(),Period(), NomeIndicador11, BufferPut11, i+TipoSinal11);
         up11 = ativar(up11);
         dn11 = ativar(dn11);
        } else {
         up11 = true;
         dn11 = true;
        }
      //DÉCIMO SEGUNDO indicador
      if(Ativar12) 
        {
         up12 = iCustom(Symbol(),Period(), NomeIndicador12, BufferCall12, i+TipoSinal12);
         dn12 = iCustom(Symbol(),Period(), NomeIndicador12, BufferPut12, i+TipoSinal12);
         up12 = ativar(up12);
         dn12 = ativar(dn12);
        } else {
         up12 = true;
         dn12 = true;
        }
      //DÉCIMO TERCEIRO indicador
      if(Ativar13) 
        {
         up13 = iCustom(Symbol(),Period(), NomeIndicador13, BufferCall13, i+TipoSinal13);
         dn13 = iCustom(Symbol(),Period(), NomeIndicador13, BufferPut13, i+TipoSinal13);
         up13 = ativar(up13);
         dn13 = ativar(dn13);
        } else {
         up13 = true;
         dn13 = true;
        }              
      //DÉCIMO QUARTO indicador
      if(Ativar14) 
        {
         up14 = iCustom(Symbol(),Period(), NomeIndicador14, BufferCall14, i+TipoSinal14);
         dn14 = iCustom(Symbol(),Period(), NomeIndicador14, BufferPut14, i+TipoSinal14);
         up14 = ativar(up14);
         dn14 = ativar(dn14);
        } else {
         up14 = true;
         dn14 = true;
        }
      //DÉCIMO QUINTO indicador
      if(Ativar15) 
        {
         up15 = iCustom(Symbol(),Period(), NomeIndicador15, BufferCall15, i+TipoSinal15);
         dn15 = iCustom(Symbol(),Period(), NomeIndicador15, BufferPut15, i+TipoSinal15);
         up15 = ativar(up15);
         dn15 = ativar(dn15);
        } else {
         up15 = true;
         dn15 = true;
        }       
      //DÉCIMO SEXTO indicador
      if(Ativar16) 
        {
         up16 = iCustom(Symbol(),Period(), NomeIndicador16, BufferCall16, i+TipoSinal16);
         dn16 = iCustom(Symbol(),Period(), NomeIndicador16, BufferPut16, i+TipoSinal16);
         up16 = ativar(up16);
         dn16 = ativar(dn16);
        } else {
         up16 = true;
         dn16 = true;
        }
      //DÉCIMO SÉTIMO indicador
      if(Ativar17) 
        {
         up17 = iCustom(Symbol(),Period(), NomeIndicador17, BufferCall17, i+TipoSinal17);
         dn17 = iCustom(Symbol(),Period(), NomeIndicador17, BufferPut17, i+TipoSinal17);
         up17 = ativar(up17);
         dn17 = ativar(dn17);
        } else {
         up17 = true;
         dn17 = true;
        }
      //DÉCIMO OITAVO indicador
      if(Ativar18) 
        {
         up18 = iCustom(Symbol(),Period(), NomeIndicador18, BufferCall18, i+TipoSinal18);
         dn18 = iCustom(Symbol(),Period(), NomeIndicador18, BufferPut18, i+TipoSinal18);
         up18 = ativar(up18);
         dn18 = ativar(dn18);
        } else {
         up18 = true;
         dn18 = true;
        }
        
      //19 INDICADOR
      if(Ativar19) 
        {
         up19 = iCustom(Symbol(),Period(), NomeIndicador19, BufferCall19, i+TipoSinal19);
         dn19 = iCustom(Symbol(),Period(), NomeIndicador19, BufferPut19, i+TipoSinal19);
         up19 = ativar(up19);
         dn19 = ativar(dn19);
        } else {
         up19 = true;
         dn19 = true;
        }
       //20 INDICADOR
      if(Ativar20) 
        {
         up20 = iCustom(Symbol(),Period(), NomeIndicador20, BufferCall20, i+TipoSinal20);
         dn20 = iCustom(Symbol(),Period(), NomeIndicador20, BufferPut20, i+TipoSinal20);
         up20 = ativar(up20);
         dn20 = ativar(dn20);
        } else {
         up20 = true;
         dn20 = true;
        }
        
      //21 INDICADOR
      if(Ativar21) 
        {
         up21 = iCustom(Symbol(),Period(), NomeIndicador21, BufferCall21, i+TipoSinal21);
         dn21 = iCustom(Symbol(),Period(), NomeIndicador21, BufferPut21, i+TipoSinal21);
         up21 = ativar(up21);
         dn21 = ativar(dn21);
        } else {
         up21 = true;
         dn21 = true;
        }
      
      
      //22 INDICADOR
      if(Ativar22) 
        {
         up22 = iCustom(Symbol(),Period(), NomeIndicador22, BufferCall22, i+TipoSinal22);
         dn22 = iCustom(Symbol(),Period(), NomeIndicador22, BufferPut22, i+TipoSinal22);
         up22 = ativar(up22);
         dn22 = ativar(dn22);
        } else {
         up22 = true;
         dn22 = true;
        }
       
      //23 INDICADOR
      if(Ativar23) 
        {
         up23 = iCustom(Symbol(),Period(), NomeIndicador23, BufferCall23, i+TipoSinal23);
         dn23 = iCustom(Symbol(),Period(), NomeIndicador23, BufferPut23, i+TipoSinal23);
         up23 = ativar(up23);
         dn23 = ativar(dn23);
        } else {
         up23 = true;
         dn23 = true;
        }
      
      
      //DÉCIMO NONO indicador = DONFOREX LINHAS
      if(Ativar31) 
        {
         up31 = iCustom(Symbol(),Period(), NomeIndicador31, BufferCall31, i+TipoSinal31);
         dn31 = iCustom(Symbol(),Period(), NomeIndicador31, BufferPut31, i+TipoSinal31);
        }
      //VIGÉSIMO Indicador = Linhas LTA/LTB Trend line
      if(Ativar32) 
        {
         up32 = iCustom(Symbol(),Period(), NomeIndicador32, BufferCall32, i+TipoSinal32);
         dn32 = iCustom(Symbol(),Period(), NomeIndicador32, BufferPut32, i+TipoSinal32);
        }                 
      if(BB1_Enabled)
        {
         up_bb1 = Close[i] < iBands(NULL, BBTimeFrame, BB1_Period, BB1_Deviations, BB1_Shift, BB1_Price, MODE_LOWER, i);
         dn_bb1 = Close[i] > iBands(NULL, BBTimeFrame, BB1_Period, BB1_Deviations, BB1_Shift, BB1_Price, MODE_UPPER, i);
        }
      else 
        {
         up_bb1 = true;
         dn_bb1 = true;
        }
         
      if(DC_Enabled)
        {
         double DC_max      = EMPTY_VALUE;
         double DC_min      = EMPTY_VALUE;
         double dc_min      = EMPTY_VALUE;
         double dc_max      = EMPTY_VALUE;
      
         dc_max = (Open[Highest(NULL,0,MODE_OPEN,DC_Period,i)]+High[Highest(NULL,0,MODE_HIGH,DC_Period,i)])/2;
	      dc_min = (Open[Lowest (NULL,0,MODE_OPEN,DC_Period,i)]+Low [Lowest (NULL,0,MODE_LOW, DC_Period,i)])/2;
      
         DC_min = dc_min+(dc_max-dc_min)*Margins/100;
         DC_max = dc_max-(dc_max-dc_min)*Margins/100;
         
         if(Fechamento)
           {
            up_dc = Close[i] < DC_min;
            dn_dc = Close[i] > DC_max;    
           }
         else
           {
            up_dc = Low  [i] < DC_min ;
            dn_dc = High [i] > DC_max ;
           }
        }
      else 
        {
         up_dc = true;
         dn_dc = true;
        }
         
      if(RSI_Enabled)
        {
         up_rsi = iRSI(NULL, RSITimeFrame, RSI_Period, RSI_Price, i) < RSI_MIN;
         dn_rsi = iRSI(NULL, RSITimeFrame, RSI_Period, RSI_Price, i) > RSI_MAX;
        } 
      else 
        {
         up_rsi = true;
         dn_rsi = true;
        }

      if(SO_Enabled) 
        {
         up_so = iStochastic(NULL, STCTimeFrame, SO_KPeriod, SO_DPeriod, SO_Slowing, SO_Mode, SO_Price, MODE_SIGNAL, i) < SO_MIN;
         dn_so = iStochastic(NULL, STCTimeFrame, SO_KPeriod, SO_DPeriod, SO_Slowing, SO_Mode, SO_Price, MODE_SIGNAL, i) > SO_MAX;
        } 
      else 
        {
         up_so = true;
         dn_so = true;
        }
      
      if(CCI_Enabled) 
        {
         up_cci = iCCI(NULL,_Period,CCI_Period,Apply_to,i) < CCI_Oversold_Level;
         dn_cci = iCCI(NULL,_Period,CCI_Period,Apply_to,i) > CCI_Overbought_Level;
        } 
      else 
        {
         up_cci = true;
         dn_cci = true;
        }
        
      if(SMA_Enabled) 
        {
         double MA  =  iMA(NULL,PERIOD_CURRENT,MA_Period,MA_Shift,MA_Method,MA_Applied_Price,i+1);
         ema_up = Close[i+FilterShift] > iMA(NULL,PERIOD_CURRENT,MA_Period,MA_Shift,MA_Method,MA_Applied_Price,i+1);
         ema_dn = Close[i+FilterShift] < iMA(NULL,PERIOD_CURRENT,MA_Period,MA_Shift,MA_Method,MA_Applied_Price,i+1);
        }
      else 
        {
         ema_up = true;
         ema_dn = true;
        }
                                   
      //
      if(AtivarRsi) 
        {
         uprh = RS1[i] < ChDn1[i] && RS1[i+1] > ChDn1[i+1];
         dnrh = RS1[i] > ChUp1[i] && RS1[i+1] < ChUp1[i+1];
        } else {
         uprh = true;
         dnrh = true;
        } 

      //
      if(AtivarTrend) 
        {
         uptf = ativar(uptrend[i]);
         dntf = ativar(dntrend[i]);
        } else {
         uptf = true;
         dntf = true;
        } 
                   
      if(AtivarVc)
        {
         dnvc = vcClose[i]>= value1;
         upvc = vcClose[i]<=-value1;
        }
      else
        {
         dnvc = EMPTY_VALUE;
         upvc = EMPTY_VALUE;
        }
 
      if(FiltroHora)
        {
         int Inicio = HoraInicio + Coeficiente;
         int Fim = HoraFim + Coeficiente;
         hora = TimeHour(Time[i]) >= Inicio && TimeHour(Time[i]) <= Fim;           
        }
      else 
        {
         hora = true;
        }

      if(!AtivarLeitura)
        {
         if(Entrada==0)
           {
            if( 
               BlockCandles(i, Intervalo) && dn1 && dn2 && dn3 && dn4 && dn5 && dn6 && dn7 && dn8 && dn9 && dn10 && dn11 && dn12 && dn13 && dn14 && dn15 && dn16 && dn17 && dn18 && dn19 && dn20 && dn21 && dn22 && dn23 && dnvc && dntf && dnrh && hora &&
               dn_bb1 && dn_dc && dn_rsi && dn_so && dn_cci && ema_dn && !ativar(preup[i+1])&& !ativar(predn[i+1]) &&
               (rollback==0 || rollback_bar>=rollback))
              {
               predn[i] = iHigh(NULL,0,i)+5*Point();
              }
            else
              {
               predn[i] = EMPTY_VALUE;
              }
            if( 
               BlockCandles(i, Intervalo) && up1 && up2 && up3 && up4 && up5 && up6 && up7 && up8 && up9 && up10 && up11 && up12 && up13 && up14 && up15 && up16 && up17 && up18  && up19 && up20 && up21 && up22 && up23 && upvc && uptf && uprh && hora &&
               up_bb1 && up_dc && up_rsi && up_so && up_cci && ema_up && !ativar(preup[i+1])&& !ativar(predn[i+1]) &&
               (rollback==0 || rollback_bar>=rollback))
              {
               preup[i] = iLow(NULL,0,i)-5*Point();
              }
            else
              {
               preup[i] = EMPTY_VALUE;
              }
              
            if(ativar(predn[i+1]) && !ativar(dn[i+1]) && !ativar(up[i+1]))
              {
               dn[i] = iHigh(NULL,0,i)+5*Point();
              }
            if(ativar(preup[i+1]) && !ativar(up[i+1]) && !ativar(dn[i+1]))
              {
               up[i] = iLow(NULL,0,i)-5*Point();
              }           
           }
         if(Entrada==1)
           {
            if( 
               BlockCandles(i, Intervalo) && dn1 && dn2 && dn3 && dn4 && dn5 && dn6 && dn7 && dn8 && dn9 && dn10 && dn11 && dn12 && dn13 && dn14 && dn15 && dn16 && dn17 && dn18 && dn19 && dn20 && dn21 && dn22 && dn23 && dnvc && dntf && dnrh && hora &&
               dn_bb1 && dn_dc && dn_rsi && dn_so && dn_cci && ema_dn && !ativar(dn[i]) && (rollback==0 || rollback_bar>=rollback))
              {
               dn[i] = iHigh(NULL,0,i)+5*Point();
              }
            if( 
               BlockCandles(i, Intervalo) && up1 && up2 && up3 && up4 && up5 && up6 && up7 && up8 && up9 && up10 && up11 && up12 && up13 && up14 && up15 && up16 && up17 && up18 && up19 && up20 && up21 && up22 && up23 && upvc && uptf && uprh && hora &&
               up_bb1 && up_dc && up_rsi && up_so && up_cci && ema_up && !ativar(up[i]) && (rollback==0 || rollback_bar>=rollback))
              {
               up[i] = iLow(NULL,0,i)-5*Point();
              }
           }
        }
      //ANTILOSS
      if(Antiloss !=0)
        { 
         if(ativar(up[i+TotalGalesMinimo]) && !ativar(antilossup[i+TotalGalesMinimo]) && sequencia_gale("call", i)) 
           {
            antilossup[i] = iLow(_Symbol,PERIOD_CURRENT,i)-15*Point();    
           }
         if(ativar(dn[i+TotalGalesMinimo]) && !ativar(antilossdn[i+TotalGalesMinimo]) && sequencia_gale("put", i)) 
           {
            antilossdn[i] = iHigh(_Symbol,PERIOD_CURRENT,i)+15*Point();
           }
        }
     }
   
   //RevSr =0,      //Reversao S&R
   //RetSr =1,      //Retração S&R
   //RevLt =2,      //Reversao LTs
   //RetLt =3,      //Retração Lts
   //RevSrouLt =4,  //Reversao S&R ou LTs
   //RetSrouLt =5,  //Retração S&R ou LTs
   //RevSreLt  =6,  //Reversao S&R e LTs
   //RetSreLt  =7   //Retração S&R e LTs  
    
   if(AtivarLeitura)
     {
      //Retração          
      if( 
         BlockCandles(0, Intervalo) && dn1 && dn2 && dn3 && dn4 && dn5 && dn6 && dn7 && dn8 && dn9 && dn10 && dn11 && dn12 && dn13 && dn14 && dn15 && dn16 && dn17 && dn18 && dn19 && dn20 && dn21 && dn22 && dn23 && dnvc && dntf && dnrh && hora &&
         dn_bb1 && dn_dc && dn_rsi && dn_so && dn_cci && ema_dn && (rollback==0 || rollback_bar>=rollback)
         &&((RevRet==1 && calcSR_retracaop())
         || (RevRet==3 && calcltb_retracao())
         || (RevRet==5 && (calcSR_retracaop() || calcltb_retracao()))
         || (RevRet==7 && (calcSR_retracaop() && calcltb_retracao())))
         )
        {
         dn[0] = Close[0];
        }
     
      if( 
         BlockCandles(0, Intervalo) && up1 && up2 && up3 && up4 && up5 && up6 && up7 && up8 && up9 && up10 && up11 && up12 && up13 && up14 && up15 && up16 && up17 && up18 && up19 && up20 && up21 && up22 && up23 && upvc && uptf && uprh && hora &&
         up_bb1 && up_dc && up_rsi && up_so && up_cci && ema_up && (rollback==0 || rollback_bar>=rollback)
         &&((RevRet==1 && calcSR_retracaoc())
         || (RevRet==3 && calclta_retracao())
         || (RevRet==5 && (calcSR_retracaoc() || calclta_retracao()))
         || (RevRet==7 && (calcSR_retracaoc() && calclta_retracao())))
         )
        {
         up[0] = Close[0];
        }
        
      //Reversão
      if( 
         BlockCandles(0, Intervalo) && dn1 && dn2 && dn3 && dn4 && dn5 && dn6 && dn7 && dn8 && dn9 && dn10 && dn11 && dn12 && dn13 && dn14 && dn15 && dn16 && dn17 && dn18 && dn19 && dn20 && dn21 && dn22 && dn23 && dnvc && dntf && dnrh && hora &&
         dn_bb1 && dn_dc && dn_rsi && dn_so && dn_cci && ema_dn && (rollback==0 || rollback_bar>=rollback)
         &&((RevRet==0 && calcSR_retracaop())
         || (RevRet==2 && calcltb_retracao())
         || (RevRet==4 && (calcSR_retracaop() || calcltb_retracao()))
         || (RevRet==6 && (calcSR_retracaop() && calcltb_retracao())))
         )
        {
         predn[0] = iHigh(NULL,0,0)+5*Point();
        }
     
      if( 
         BlockCandles(0, Intervalo) && up1 && up2 && up3 && up4 && up5 && up6 && up7 && up8 && up9 && up10 && up11 && up12 && up13 && up14 && up15 && up16 && up17 && up18 && up19 && up20 && up21 && up22 && up23 && upvc && uptf && uprh && hora &&
         up_bb1 && up_dc && up_rsi && up_so && up_cci && ema_up && (rollback==0 || rollback_bar>=rollback)
         &&((RevRet==0 && calcSR_retracaoc())
         || (RevRet==2 && calclta_retracao())
         || (RevRet==4 && (calcSR_retracaoc() || calclta_retracao()))
         || (RevRet==6 && (calcSR_retracaoc() && calclta_retracao())))
         )
        {
         preup[0] = iLow(NULL,0,0)-5*Point();
        }

      if(ativar(predn[1]) && !ativar(dn[1]))
        {
         dn[0] = iHigh(NULL,0,0)+5*Point();
        }
        
      if(ativar(preup[1]) && !ativar(up[1]))
        {
         up[0] = iLow(NULL,0,0)-5*Point();
        }
      //ANTILOSS
      if(Antiloss !=0)
        { 
         if(ativar(up[TotalGalesMinimo]) && !ativar(antilossup[TotalGalesMinimo]) && sequencia_gale("call", 0)) 
           {
            antilossup[0] = iLow(_Symbol,PERIOD_CURRENT,0)-15*Point();    
           }
         if(ativar(dn[TotalGalesMinimo]) && !ativar(antilossdn[TotalGalesMinimo]) && sequencia_gale("put", 0)) 
           {
            antilossdn[0] = iHigh(_Symbol,PERIOD_CURRENT,0)+15*Point();
           }
        }        
     }                     
   robos();
   backteste(limit);
   if(Alertas)
     {
      alertar();
     }
     
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
bool BlockCandles(int k, int quantia_block_candles)
  { 
   int contador=0;
   int max = k+quantia_block_candles;
   for(int i=k; i<max; i++)
     {
      if(up[i]==EMPTY_VALUE && dn[i]==EMPTY_VALUE
         && antilossup[i]==EMPTY_VALUE && antilossdn[i]==EMPTY_VALUE) 
        {
         contador++;
        }
     }
   if(contador==quantia_block_candles)
     {
      return true;
     } 
   return false;
  }

bool ativar(double valor)
  {
   if(valor!=0 && valor!=EMPTY_VALUE)
     {
      return(true);
     }
   else
     {
      return(false);
     }
   return(false);
  }

void vl(int bars, int period)
  {
   ArrayResize(vcHigh,bars);
   ArrayResize(vcLow,bars);
   ArrayResize(vcClose,bars);
   ArrayResize(vcOpen,bars);

   double sum;
   double floatingAxis;
   double volatilityUnit = 0;
   int VC_NumBars = 5;
     
   for(int i = bars-1; i >= 0; i--)
     {    
      datetime t = Time[i];
      int y = iBarShift(NULL, period, t);
      int z = iBarShift(NULL, 0, iTime(NULL, period, y));
      /* Determination of the floating axis */
      sum = 0;        
      int N = VC_NumBars; //vcnumbars
      for (int k = y; k < y+N; k++)
        {
         sum += (iHigh(NULL, period, k) + iLow(NULL, period, k)) / 2.0;
        }
      floatingAxis = sum / VC_NumBars;
      /* Determination of the volatility unit */
      N = VC_NumBars;
      sum = 0;
      for (int kv = y; kv < N + y; kv++)
        {
         sum += iHigh(NULL, period, kv) - iLow(NULL, period, kv);
        }
      if ( sum!= 0){       
      volatilityUnit = 0.2 * (sum / VC_NumBars);
      if (volatilityUnit == 0){
      volatilityUnit = 1;}
      }
      
      /* Determination of relative high, low, open and close values */
      vcHigh[i] = (iHigh(NULL, period, y) - floatingAxis) / volatilityUnit;
      vcLow[i] = (iLow(NULL, period, y) - floatingAxis) / volatilityUnit;
      vcOpen[i] = (iOpen(NULL, period, y) - floatingAxis) / volatilityUnit;
      vcClose[i] = (iClose(NULL, period, y) - floatingAxis) / volatilityUnit;
    }  
}

//+------------------------------------------------------------------+
void rsi1(int limit)
  {
   ArrayResize(RS1,limit);
   ArrayResize(ChMid1,limit);
   ArrayResize(ChUp1,limit);
   ArrayResize(ChDn1,limit);

   int i,j,k;
   //
   static datetime timeLastAlert = NULL;
   
   for (i=limit; i>=0; i--) RS1[i] = iRSI(NULL,0,RsiLength1,RsiPrice1,i);
   for (i=limit; i>=0; i--)
   {
      double dev  = iStdDevOnArray(RS1,0,DevPeriod1,0,MODE_SMA,i);
      double sum  = (HalfLength1+1)*RS1[i];
      double sumw = (HalfLength1+1);
      for(j=1, k=HalfLength1; j<=HalfLength1; j++, k--)
      {
         sum  += k*RS1[i+j];
         sumw += k;
         if (j<=i)
         {
            sum  += k*RS1[i-j];
            sumw += k;
         }
      }
      ChMid1[i] = sum/sumw;
      ChUp1[i] = ChMid1[i]+dev*Deviations1;
      ChDn1[i] = ChMid1[i]-dev*Deviations1;
   }
  }
  
bool calcSR_retracaop()
  {
   int obj_total=ObjectsTotal();
   for(int A=0; A<obj_total; A++) 
     {
      string name=ObjectName(A);
      int objectType = ObjectType(name);
      if((objectType == OBJ_HLINE || objectType == OBJ_RECTANGLE))
        {
         string namesr = name;
         double GV0 = ObjectGetDouble(0,namesr,OBJPROP_PRICE,0);
         if(GV0!=0 && Open[0]<GV0 && High[0]>=GV0)
           {
            return(true);
           }
        }
     }
   return(false);
  }

bool calcSR_retracaoc()
  {
   int obj_total=ObjectsTotal();
   for(int A=0; A<obj_total; A++) 
     {
      string name=ObjectName(A);
      int objectType = ObjectType(name);
      if(objectType == OBJ_HLINE || objectType == OBJ_RECTANGLE)
        {
         string namesr = name;
         double GV0 = ObjectGetDouble(0,namesr,OBJPROP_PRICE,0);
         if(GV0!=0 && Open[0]>GV0 && Low[0]<=GV0)
           {
            return(true);
           }
        }
     }
   return(false);
  }

bool calcSR_reversaop()
  {
   int obj_total=ObjectsTotal();
   for(int A=0; A<obj_total; A++) 
     {
      string name=ObjectName(A);
      int objectType = ObjectType(name);
      if(objectType == OBJ_HLINE || objectType == OBJ_RECTANGLE) 
        {
         string namesr = name;
         double GV0 = ObjectGetDouble(0,namesr,OBJPROP_PRICE,0);
         if(Close[1]>Open[1] && GV0!=0 && Open[1]<GV0 && High[1]>=GV0)
           {
            return(true);
           }
        }
     }
   return(false);
  }

bool calcSR_reversaoc()
  {
   int obj_total=ObjectsTotal();
   for(int A=0; A<obj_total; A++) 
     {
      string name=ObjectName(A);
      int objectType = ObjectType(name);
      if(objectType == OBJ_HLINE || objectType == OBJ_RECTANGLE) 
        {
         string namesr = name;
         double GV0 = ObjectGetDouble(0,namesr,OBJPROP_PRICE,0);
         if(Close[1]<Open[1] && GV0!=0 && Open[1]>GV0 && Low[1]<=GV0)
           {
            return(true);
           }
        }
     }
   return(false);
  }

bool calclta_retracao()
{
int obj_total=ObjectsTotal();
for(int A=0; A<obj_total; A++) {
   string name=ObjectName(A);
   int objectType = ObjectType(name);
   if(objectType == OBJ_TREND) {
      string namelt = name;
      double LTA0 = ObjectGetDouble(0,namelt,OBJPROP_PRICE,0);
      double vLTA0 = ObjectGetValueByShift(namelt,0);
         if((LTA0!=0 && Open[0]>vLTA0 && Low[0]<=vLTA0)
         ){return(true);}
   }
}
return(false);
}

bool calcltb_retracao()
{
int obj_total=ObjectsTotal();
for(int A=0; A<obj_total; A++) {
   string name=ObjectName(A);
   int objectType = ObjectType(name);
   if(objectType == OBJ_TREND) {
      string namelt = name;
      double LTB0 = ObjectGetDouble(0,namelt,OBJPROP_PRICE,0);
      double vLTB0 = ObjectGetValueByShift(namelt,0);
         if((LTB0!=0 && Open[0]<vLTB0 && High[0]>=vLTB0) 
         ){return(true);}
   }
}
return(false);
}

bool calclta_reversao()
{
int obj_total=ObjectsTotal();
for(int A=0; A<obj_total; A++) {
   string name=ObjectName(A);
   int objectType = ObjectType(name);
   if(objectType == OBJ_TREND) {
      string namelt = name;
      double LTA0 = ObjectGetDouble(0,namelt,OBJPROP_PRICE,0);
      double vLTA0 = ObjectGetValueByShift(namelt,0);
      if((LTA0!=0 && (Open[1])>vLTA0 && Close[1]<vLTA0)
      ){return(true);}
   }
}
return(false);
}

bool calcltb_reversao()
{
int obj_total=ObjectsTotal();
for(int A=0; A<obj_total; A++) {
   string name=ObjectName(A);
   int objectType = ObjectType(name);
   if(objectType == OBJ_TREND) {
      string namelt = name;
      double LTB0 = ObjectGetDouble(0,namelt,OBJPROP_PRICE,0);
      double vLTB0 = ObjectGetValueByShift(namelt,0);
      if((LTB0!=0 && Open[1]<vLTB0 && Close[1]>vLTB0)
      ){return(true);}
   }
}
return(false);
}

void Trend(int limit)
  {
   ArrayResize(uptrend,limit);
   ArrayResize(dntrend,limit);
   ArrayResize(TrendBuffer,limit);
   ArrayResize(TriggBuffera,limit);
   ArrayResize(TriggBufferb,limit);
   ArrayResize(TriggBufferU,limit);
   ArrayResize(TriggBufferD,limit);
   ArrayResize(trend,limit);
  
   for (int i = limit; i >= 0; i--) TriggBufferU[i] = iMA(NULL, 0, trendPeriod, 0, MODE_EMA, PRICE_CLOSE, i);
   for (int i = limit; i >= 0; i--) 
     {   
      TriggBufferD[i] = iMAOnArray(TriggBufferU, 0, trendPeriod, 0, MODE_EMA, i);
      double impetmma = TriggBufferU[i] - (TriggBufferU[i + 1]);
      double impetsmma = TriggBufferD[i] - (TriggBufferD[i + 1]);
      double divma = MathAbs(TriggBufferU[i] - TriggBufferD[i]) / Point;
      double averimpet = (impetmma + impetsmma) / (2.0 * Point);
      trend[i] = divma * MathPow(averimpet, 3);
      double absValue = absHighest(trend, 3 * trendPeriod,i);
      
      if (absValue > 0.0){
         TrendBuffer[i] = trend[i] / absValue;
      }else TrendBuffer[i] = 0.0;
         TriggBuffera[i] =  0.05;
         TriggBufferb[i] = -0.05;
         
      if(/*TrendBuffer[i+1]< 0.2 &&*/ TrendBuffer[i]> 0.9 ){
         dntrend[i] = High[i];
      }else{ dntrend[i] = EMPTY_VALUE;}
         
      if(/*TrendBuffer[i+1]>-0.2 &&*/ TrendBuffer[i]<-0.9 ){
         uptrend[i] = Low[i];
      }else{ uptrend[i] = EMPTY_VALUE;}
     }         
  } 
         
double absHighest(double &array[], int length, int shift) 
  {
   double result = 0.0;
   for (int index = length - 1; index >= 0; index--)
   if (result < MathAbs(array[shift + index])) result = MathAbs(array[shift + index]);
   return (result);
  }

//+------------------------------------------------------------------+
void backteste(int limit)
  {
   if(Antiloss==0)
     {
      for(int fcr=limit; fcr>=0; fcr--)
        {
         if(AtivarLeitura && (RevRet==1||RevRet==3||RevRet==5||RevRet==7))
           {
            //Sem Gale
            if(ativar(dn[fcr]) && Close[fcr]<dn[fcr])
              {
               win[fcr] = High[fcr] + 10*Point;
               loss[fcr] = EMPTY_VALUE;
               continue;
              }
   
            if(ativar(dn[fcr]) && Close[fcr]>=dn[fcr])
              {
               loss[fcr] = High[fcr] + 10*Point;
               win[fcr] = EMPTY_VALUE;
               continue;
              }
   
            if(ativar(up[fcr]) && Close[fcr]>up[fcr])
              {
               win[fcr] = Low[fcr] - 10*Point;
               loss[fcr] = EMPTY_VALUE;
               continue;
              }
            if(ativar(up[fcr]) && Close[fcr]<=up[fcr])
              {
               loss[fcr] = Low[fcr] - 10*Point;
               win[fcr] = EMPTY_VALUE;
               continue;
              }
           }
   
         if(AtivarLeitura && (RevRet==0||RevRet==2||RevRet==4||RevRet==6))
           {
            //Sem Gale
            if(ativar(dn[fcr]) && Close[fcr]<Open[fcr])
              {
               win[fcr] = High[fcr] + 10*Point;
               loss[fcr] = EMPTY_VALUE;
               continue;
              }
   
            if(ativar(dn[fcr]) && Close[fcr]>=Open[fcr])
              {
               loss[fcr] = High[fcr] + 10*Point;
               win[fcr] = EMPTY_VALUE;
               continue;
              }
   
            if(ativar(up[fcr]) && Close[fcr]>Open[fcr])
              {
               win[fcr] = Low[fcr] - 10*Point;
               loss[fcr] = EMPTY_VALUE;
               continue;
              }
            if(ativar(up[fcr]) && Close[fcr]<=Open[fcr])
              {
               loss[fcr] = Low[fcr] - 10*Point;
               win[fcr] = EMPTY_VALUE;
               continue;
              }
           }
            
         if(!AtivarLeitura)
           {
            //Sem Gale
            if(ativar(dn[fcr]) && Close[fcr]<Open[fcr])
              {
               win[fcr] = High[fcr] + 10*Point;
               loss[fcr] = EMPTY_VALUE;
               continue;
              }
   
            if(ativar(dn[fcr]) && Close[fcr]>=Open[fcr])
              {
               loss[fcr] = High[fcr] + 10*Point;
               win[fcr] = EMPTY_VALUE;
               continue;
              }
   
            if(ativar(up[fcr]) && Close[fcr]>Open[fcr])
              {
               win[fcr] = Low[fcr] - 10*Point;
               loss[fcr] = EMPTY_VALUE;
               continue;
              }
            if(ativar(up[fcr]) && Close[fcr]<=Open[fcr])
              {
               loss[fcr] = Low[fcr] - 10*Point;
               win[fcr] = EMPTY_VALUE;
               continue;
              }
            }
           
         //G1
         if(ativar(dn[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]<Open[fcr])
           {
            wg[fcr] = High[fcr] + 10*Point;
            ht[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(dn[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]>=Open[fcr])
           {
            ht[fcr] = High[fcr] + 10*Point;
            wg[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(up[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]>Open[fcr])
           {
            wg[fcr] = Low[fcr] - 10*Point;
            ht[fcr] = EMPTY_VALUE;
            continue;
           }
         if(ativar(up[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]<=Open[fcr])
           {
            ht[fcr] = Low[fcr] - 10*Point;
            wg[fcr] = EMPTY_VALUE;
            continue;
           }

         //G2
         if(ativar(dn[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]<Open[fcr])
           {
            wg2[fcr] = High[fcr] + 10*Point;
            ht2[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(dn[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]>=Open[fcr])
           {
            ht2[fcr] = High[fcr] + 10*Point;
            wg2[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(up[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]>Open[fcr])
           {
            wg2[fcr] = Low[fcr] - 10*Point;
            ht2[fcr] = EMPTY_VALUE;
            continue;
           }
         if(ativar(up[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]<=Open[fcr])
           {
            ht2[fcr] = Low[fcr] - 10*Point;
            wg2[fcr] = EMPTY_VALUE;
            continue;
           }
        }
     }

   if(Antiloss!=0)
     {
      for(int fcr=limit; fcr>=0; fcr--)
        {
         //Sem Gale
         if(ativar(antilossdn[fcr]) && Close[fcr]<Open[fcr])
           {
            win[fcr] = High[fcr] + 10*Point;
            loss[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(antilossdn[fcr]) && Close[fcr]>=Open[fcr])
           {
            loss[fcr] = High[fcr] + 10*Point;
            win[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(antilossup[fcr]) && Close[fcr]>Open[fcr])
           {
            win[fcr] = Low[fcr] - 10*Point;
            loss[fcr] = EMPTY_VALUE;
            continue;
           }
         if(ativar(antilossup[fcr]) && Close[fcr]<=Open[fcr])
           {
            loss[fcr] = Low[fcr] - 10*Point;
            win[fcr] = EMPTY_VALUE;
            continue;
           }              
         //G1
         if(ativar(antilossdn[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]<Open[fcr])
           {
            wg[fcr] = High[fcr] + 10*Point;
            ht[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(antilossdn[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]>=Open[fcr])
           {
            ht[fcr] = High[fcr] + 10*Point;
            wg[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(antilossup[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]>Open[fcr])
           {
            wg[fcr] = Low[fcr] - 10*Point;
            ht[fcr] = EMPTY_VALUE;
            continue;
           }
         if(ativar(antilossup[fcr+1]) && ativar(loss[fcr+1]) && Close[fcr]<=Open[fcr])
           {
            ht[fcr] = Low[fcr] - 10*Point;
            wg[fcr] = EMPTY_VALUE;
            continue;
           }

         //G2
         if(ativar(antilossdn[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]<Open[fcr])
           {
            wg2[fcr] = High[fcr] + 10*Point;
            ht2[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(antilossdn[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]>=Open[fcr])
           {
            ht2[fcr] = High[fcr] + 10*Point;
            wg2[fcr] = EMPTY_VALUE;
            continue;
           }

         if(ativar(antilossup[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]>Open[fcr])
           {
            wg2[fcr] = Low[fcr] - 10*Point;
            ht2[fcr] = EMPTY_VALUE;
            continue;
           }
         if(ativar(antilossup[fcr+2]) && ativar(ht[fcr+1]) && Close[fcr]<=Open[fcr])
           {
            ht2[fcr] = Low[fcr] - 10*Point;
            wg2[fcr] = EMPTY_VALUE;
            continue;
           }
        }
     }
                
   if(Time[0]>tvb1)
     {

      g = 0;
      wbk = 0;
      lbk = 0;
      wg1 = 0;
      ht1 = 0;
      wg22 = 0;
      ht22 = 0;
     }

   if(AtivaPainel==true && g==0)
     {
      tvb1 = Time[0];
      g=g+1;

      for(int v=limit; v>0; v--)
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
         if(wg2[v]!=EMPTY_VALUE)
           {
            wg22=wg22+1;
           }
         if(ht2[v]!=EMPTY_VALUE)
           {
            ht22=ht22+1;
           }
        }

      wg1 = wg1 +wbk;
      wg22 = wg1 + wg22;


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
      if((wg22 + ht22)>0)
        {
         WinRateGale22 = ((ht22 / (wg22 + ht22)) - 1) * (-100);
        }
      else
        {
         WinRateGale22=100;
        }

      //RETANGULO
      ObjectCreate("zexa",OBJ_RECTANGLE_LABEL,0,0,0,0,0);
      ObjectSet("zexa",OBJPROP_BGCOLOR,"");
      ObjectSet("zexa",OBJPROP_CORNER,0);
      ObjectSet("zexa",OBJPROP_BACK,false);
      ObjectSet("zexa",OBJPROP_XDISTANCE,5); //DIREITO/ESQUERDO
      ObjectSet("zexa",OBJPROP_YDISTANCE,40); //CIMA/BAIXO
      ObjectSet("zexa",OBJPROP_XSIZE,200); //TAMANHO LARGURA DO RETANGULO
      ObjectSet("zexa",OBJPROP_YSIZE,90); //TAMANHO COMPRIMENTO DO RETANGULO
      ObjectSet("zexa",OBJPROP_ZORDER,5);
      ObjectSet("zexa",OBJPROP_BORDER_TYPE,BORDER_FLAT);
      ObjectSet("zexa",OBJPROP_COLOR,clrBlack);
      ObjectSet("zexa",OBJPROP_WIDTH,2);

      ObjectCreate("5twf",OBJ_LABEL,0,0,0,0,0);
      ObjectSetText("5twf","===BAÚ  [HARD CORE]===", 13, "Franklin Gothic Medium",clrGold);
      ObjectSet("5twf",OBJPROP_XDISTANCE,7); //DIREITO/ESQUERDO
      ObjectSet("5twf",OBJPROP_ZORDER,9);
      ObjectSet("5twf",OBJPROP_BACK,false);
      ObjectSet("5twf",OBJPROP_YDISTANCE,44); //CIMA/BAIXO
      ObjectSet("5twf",OBJPROP_CORNER,0);
      
      ObjectCreate("5twf12",OBJ_LABEL,0,0,0,0,0);
      ObjectSetText("5twf12","-------------------------------------------------", 13, "Franklin Gothic Medium",clrGold);
      ObjectSet("5twf12",OBJPROP_XDISTANCE,7); //DIREITO/ESQUERDO
      ObjectSet("5twf12",OBJPROP_ZORDER,9);
      ObjectSet("5twf12",OBJPROP_BACK,false);
      ObjectSet("5twf12",OBJPROP_YDISTANCE,60); //CIMA/BAIXO
      ObjectSet("5twf12",OBJPROP_CORNER,0);
      
      ObjectCreate("5twf1",OBJ_LABEL,0,0,0,0,0);
      ObjectSetText("5twf1","SEM GALE: WIN: "+DoubleToString(wbk,0)+" " + "LOSS: "+DoubleToString(lbk,0)+" - "+DoubleToString(WinRate1,2)+"%", 8, "Arial",Yellow);
      ObjectSet("5twf1",OBJPROP_XDISTANCE,10); //DIREITO/ESQUERDO
      ObjectSet("5twf1",OBJPROP_ZORDER,9);
      ObjectSet("5twf1",OBJPROP_BACK,false);
      ObjectSet("5twf1",OBJPROP_YDISTANCE,75); //CIMA/BAIXO
      ObjectSet("5twf1",OBJPROP_CORNER,0);

      ObjectCreate("5twf2",OBJ_LABEL,0,0,0,0,0);
      ObjectSetText("5twf2","GALE 1: WIN: "+DoubleToString(wg1,0)+" " + "LOSS: "+DoubleToString(ht1,0)+" - "+DoubleToString(WinRateGale1,2)+"%", 8, "Arial",White);
      ObjectSet("5twf2",OBJPROP_XDISTANCE,10); //DIREITO/ESQUERDO
      ObjectSet("5twf2",OBJPROP_ZORDER,9);
      ObjectSet("5twf2",OBJPROP_BACK,false);
      ObjectSet("5twf2",OBJPROP_YDISTANCE,95); //CIMA/BAIXO
      ObjectSet("5twf2",OBJPROP_CORNER,0);

      ObjectCreate("5twf3",OBJ_LABEL,0,0,0,0,0);
      ObjectSetText("5twf3","GALE 2: WIN: "+DoubleToString(wg22,0)+" " + "LOSS: "+DoubleToString(ht22,0)+" - "+DoubleToString(WinRateGale22,2)+"%", 8, "Arial",White);
      ObjectSet("5twf3",OBJPROP_XDISTANCE,10); //DIREITO/ESQUERDO
      ObjectSet("5twf3",OBJPROP_ZORDER,9);
      ObjectSet("5twf3",OBJPROP_BACK,false);
      ObjectSet("5twf3",OBJPROP_YDISTANCE,115); //CIMA/BAIXO
      ObjectSet("5twf3",OBJPROP_CORNER,0);
      ChartSetInteger(_Symbol,CHART_MODE,CHART_CANDLES);
      ChartSetInteger(_Symbol,CHART_SHIFT,true);
      ChartSetInteger(_Symbol,CHART_AUTOSCROLL,true);
      ChartSetInteger(_Symbol,CHART_COLOR_BACKGROUND,clrSlateGray);
      ChartSetInteger(_Symbol,CHART_COLOR_FOREGROUND,clrWhite);
      ChartSetInteger(_Symbol,CHART_COLOR_CHART_UP,Black);
      ChartSetInteger(_Symbol,CHART_COLOR_CANDLE_BULL,Green);
      ChartSetInteger(_Symbol,CHART_COLOR_CHART_DOWN,Black);
      ChartSetInteger(_Symbol,CHART_COLOR_CANDLE_BEAR,Tomato);
      ChartSetInteger(_Symbol,CHART_COLOR_ASK,clrWhite);
      ChartSetInteger(_Symbol,CHART_SCALE,3);
  
      //MEU NOME-CAIRO
      ObjectSetText("copyr1", "NINFOBOT ");
      ObjectSet("copyr100", OBJPROP_CORNER, 3);
      ObjectSet("copyr100", OBJPROP_FONTSIZE,10);
      ObjectSet("copyr100", OBJPROP_XDISTANCE, 5);
      ObjectSet("copyr100", OBJPROP_YDISTANCE, 1);
      ObjectSet("copyr100", OBJPROP_COLOR,WhiteSmoke);
      ObjectSetString(0,"copyr100",OBJPROP_FONT,"Arial Black");
      ObjectCreate(NULL,"nomeFundo",OBJ_LABEL,0,0,0);
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_XDISTANCE,5); //LADO DIREITO/LADO ESQUERDO
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_YDISTANCE,600);//BAIXO/CIMA
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_CORNER,0);
      ObjectSetString(NULL,"nomeFundo",OBJPROP_TEXT,"[ADM] Cairo Jr");
      ObjectSetString(NULL,"nomeFundo",OBJPROP_FONT,"Britannic Bold");
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_FONTSIZE,9);
      ObjectSetDouble(NULL,"nomeFundo",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_COLOR,clrGold);
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_BACK,false);
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_HIDDEN,true);
      ObjectSetInteger(NULL,"nomeFundo",OBJPROP_SELECTABLE,false);
   
      //NOME DO EMERSON
      ObjectSetText("copyr101", "");
      ObjectSet("copyr101", OBJPROP_CORNER, 3);
      ObjectSet("copyr101", OBJPROP_FONTSIZE,10);
      ObjectSet("copyr101", OBJPROP_XDISTANCE, 5);
      ObjectSet("copyr101", OBJPROP_YDISTANCE, 1);
      ObjectSet("copyr101", OBJPROP_COLOR,WhiteSmoke);
      ObjectSetString(0,"copyr101",OBJPROP_FONT,"Arial Black");
      ObjectCreate(NULL,"nomeFundo101",OBJ_LABEL,0,0,0);
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_XDISTANCE,5); //LADO DIREITO/LADO ESQUERDO
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_YDISTANCE,615);//BAIXO/CIMA
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_CORNER,0);
      ObjectSetString(NULL,"nomeFundo101",OBJPROP_TEXT,"[ADM] Emerson");
      ObjectSetString(NULL,"nomeFundo101",OBJPROP_FONT,"Britannic Bold");
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_FONTSIZE,9);
      ObjectSetDouble(NULL,"nomeFundo101",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_COLOR,clrGold);
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_BACK,false);
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_HIDDEN,true);
      ObjectSetInteger(NULL,"nomeFundo101",OBJPROP_SELECTABLE,false);
   
      //NOME DO PAULO
      ObjectSetText("copyr102", "");
      ObjectSet("copyr102", OBJPROP_CORNER, 3);
      ObjectSet("copyr102", OBJPROP_FONTSIZE,10);
      ObjectSet("copyr102", OBJPROP_XDISTANCE, 5);
      ObjectSet("copyr102", OBJPROP_YDISTANCE, 1);
      ObjectSet("copyr102", OBJPROP_COLOR,WhiteSmoke);
      ObjectSetString(0,"copyr102",OBJPROP_FONT,"Arial Black");
      ObjectCreate(NULL,"nomeFundo102",OBJ_LABEL,0,0,0);
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_XDISTANCE,5); //LADO DIREITO/LADO ESQUERDO
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_YDISTANCE,630);//BAIXO/CIMA
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_CORNER,0);
      ObjectSetString(NULL,"nomeFundo102",OBJPROP_TEXT,"[ADM] Paulo");
      ObjectSetString(NULL,"nomeFundo102",OBJPROP_FONT,"Britannic Bold");
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_FONTSIZE,9);
      ObjectSetDouble(NULL,"nomeFundo102",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_COLOR,clrGold);
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_BACK,false);
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_HIDDEN,true);
      ObjectSetInteger(NULL,"nomeFundo102",OBJPROP_SELECTABLE,false);
      
      //NOME DO JEFFERSON
      ObjectSetText("copyr103", "");
      ObjectSet("copyr103", OBJPROP_CORNER, 3);
      ObjectSet("copyr103", OBJPROP_FONTSIZE,10);
      ObjectSet("copyr103", OBJPROP_XDISTANCE, 5);
      ObjectSet("copyr103", OBJPROP_YDISTANCE, 1);
      ObjectSet("copyr103", OBJPROP_COLOR,WhiteSmoke);
      ObjectSetString(0,"copyr103",OBJPROP_FONT,"Arial Black");
      ObjectCreate(NULL,"nomeFundo103",OBJ_LABEL,0,0,0);
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_XDISTANCE,5); //LADO DIREITO/LADO ESQUERDO
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_YDISTANCE,645);//BAIXO/CIMA
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_CORNER,0);
      ObjectSetString(NULL,"nomeFundo103",OBJPROP_TEXT,"Col.Jefferson");
      ObjectSetString(NULL,"nomeFundo103",OBJPROP_FONT,"Britannic Bold");
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_FONTSIZE,9);
      ObjectSetDouble(NULL,"nomeFundo103",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_COLOR,clrGold);
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_BACK,false);
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_HIDDEN,true);
      ObjectSetInteger(NULL,"nomeFundo103",OBJPROP_SELECTABLE,false);
   
   
   
      ObjectCreate("copyr3", OBJ_LABEL, 0, Time[5], Close[5]);
      ObjectSetText("copyr3", "");
      ObjectSet("copyr3", OBJPROP_CORNER, 3);
      ObjectSet("copyr3", OBJPROP_FONTSIZE,12);
      ObjectSet("copyr3", OBJPROP_XDISTANCE, 20);
      ObjectSet("copyr3", OBJPROP_YDISTANCE, 160);
      ObjectSet("copyr3", OBJPROP_COLOR,clrWhiteSmoke);
      ObjectSetString(0,"copyr3",OBJPROP_FONT,"Andalus");
      ObjectCreate("copyr3",OBJ_RECTANGLE_LABEL,0,0,0,0,0,0);
  
      ObjectSetText("copyr1", "");
      ObjectSet("copyr1", OBJPROP_CORNER, 3);
      ObjectSet("copyr1", OBJPROP_FONTSIZE,10);
      ObjectSet("copyr1", OBJPROP_XDISTANCE, 5);
      ObjectSet("copyr1", OBJPROP_YDISTANCE, 1);
      ObjectSet("copyr1", OBJPROP_COLOR,WhiteSmoke);
      ObjectSetString(0,"copyr1",OBJPROP_FONT,"Arial Black");
      ObjectCreate(NULL,"nomeFundo1",OBJ_LABEL,0,0,0);
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_XDISTANCE,200);
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_YDISTANCE,300);
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_CORNER,4);
      ObjectSetString(NULL,"nomeFundo1",OBJPROP_TEXT,"");
      ObjectSetString(NULL,"nomeFundo1",OBJPROP_FONT,"Britannic Bold");
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_FONTSIZE,25);
      ObjectSetDouble(NULL,"nomeFundo1",OBJPROP_ANGLE,0);
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_COLOR,C'66,66,66');
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_BACK,true);
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_HIDDEN,true);
      ObjectSetInteger(NULL,"nomeFundo1",OBJPROP_SELECTABLE,false);
      ObjectCreate("copyr3", OBJ_LABEL, 0, Time[5], Close[5]);
      ObjectSetText("copyr3", "");  
      ObjectSet("copyr3", OBJPROP_CORNER, 3);
      ObjectSet("copyr3", OBJPROP_FONTSIZE,12);
      ObjectSet("copyr3", OBJPROP_XDISTANCE, 10);
      ObjectSet("copyr3", OBJPROP_YDISTANCE, 20);
      ObjectSet("copyr3", OBJPROP_COLOR,clrWhiteSmoke);
      ObjectSetString(0,"copyr3",OBJPROP_FONT,"Andalus");
      
      ObjectCreate("copyr3",OBJ_RECTANGLE_LABEL,0,0,0,0,0,0);
      ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
      ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
      ObjectCreate(0,"fundo",OBJ_BITMAP_LABEL,0,0,0);
      ObjectSetString(0,"fundo",OBJPROP_BMPFILE,200,"\\Images\\FSOCIETY.bmp");  //Fundo De Imagem
      ObjectSetInteger(0,"fundo",OBJPROP_XDISTANCE,5);//LADO DIREITO/LADO ESQUERDO
      ObjectSetInteger(0,"fundo",OBJPROP_YDISTANCE,130);//BAIXO/CIMA
      ObjectSetInteger(0,"fundo",OBJPROP_BACK,false);
      ObjectSetInteger(0,"fundo",OBJPROP_CORNER,0);
   
  }
 }

void robos()
  {
   datetime timeg;
   if( StringLen(Symbol()) > 6)
     {
      timeg = TimeGMT();
     }else{
      timeg = TimeCurrent();
     }
   fechamentominutos = Time[0] +_Period*60 - timeg;
   fechamentosegundos = fechamentominutos % 60;
   fechamentominutos = (fechamentominutos - fechamentominutos % 60) / 60;
   delay = 60 - antidelay;
   static datetime temposinal;
   
   if(autotrading==1 && temposinal < iTime(NULL,0,0))
     {
      if(((Antiloss == 0 && ativar(up[0]))||( Antiloss !=0 && ativar(antilossup[0])))
         && ((AntiDelay && fechamentominutos == 0 && fechamentosegundos >= delay) || !AntiDelay))
        {
         if(select_tool==MX2) mx2trading(Symbol(), "CALL", expiraca_mx2, nome_sinal, sinal_tipo_mx2, tipo_expiracao_mx2, timeframe, mID, "0");        
         else if(select_tool==FSOCIETY)
                 {
                  fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
                  FileSeek(fileHandle, 0, SEEK_END); 
                  string data = IntegerToString((long)TimeGMT())+";"+Symbol()+";call;"+IntegerToString(TempoDeOperacao_)+";"+nome_sinal;
                  FileWrite(fileHandle,data);
                  FileClose(fileHandle);
                 }                           
         else if(select_tool==FRANKENSTEIN)
                {
                 Print(Symbol(), ",", ExpiryMinutes, ",CALL,", Time[0]);
                 fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
                 FileSeek(fileHandle, 0, SEEK_END);
                 string data = IntegerToString((long)TimeGMT())+","+Symbol()+",call,"+IntegerToString(ExpiryMinutes);
                 FileWrite(fileHandle,data);
                 FileClose(fileHandle);
                }        
         else if(select_tool==BotPro) botpro("CALL", expiraca_botpro, ativar_mg_botpro, Symbol(), trade_amount_botpro, nome_sinal, tipo_ativo_botpro);
         else if(select_tool==PricePro) TradePricePro(Symbol(), "CALL", TempoDeOperacao, nome_sinal, 3, 1, TimeLocal(), Corretora);
         else if(select_tool==MT2) mt2trading(Symbol(), "CALL", TradeAmount, ExpiryMinutes, MartingaleType, MartingaleSteps, MartingaleCoef, Broker, nome_sinal, signalID);
         else if(select_tool==B2IQ) call(Symbol(), Period(), Modalidade, SinalEntrada, vps);
         else if(select_tool==Mamba) mambabot(_Symbol,"CALL",_Period, nome_sinal, Corretoram);
         else if(select_tool==TopWin)         
           {
            string texto = ReadFile(diretorio);
            datetime hora_entrada =  TimeLocal();
            string entrada = Symbol()+",call,"+string(Period())+","+string(0)+","+string(nome_sinal)+","+string(hora_entrada)+","+string(Period());
            texto = texto +"\n"+ entrada;
            WriteFile(diretorio,texto);
           }
         Print("CALL - Sinal enviado para o Automatizador!");
         temposinal = iTime(NULL,0,0);
        }
         
      else if(((Antiloss == 0 && ativar(dn[0]))||( Antiloss !=0 && ativar(antilossdn[0])))
         && ((AntiDelay && fechamentominutos == 0 && fechamentosegundos >= delay)|| !AntiDelay))
        {
         if(select_tool==MX2) mx2trading(Symbol(), "PUT", expiraca_mx2, nome_sinal, sinal_tipo_mx2, tipo_expiracao_mx2, timeframe, mID, "0");
         else if(select_tool==FSOCIETY)
                 {
                  fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
                  FileSeek(fileHandle, 0, SEEK_END); 
                  string data = IntegerToString((long)TimeGMT())+";"+Symbol()+";put;"+IntegerToString(TempoDeOperacao_)+";"+nome_sinal;
                  FileWrite(fileHandle,data);
                  FileClose(fileHandle);
                 }            
         else if(select_tool==FRANKENSTEIN)
                {
                 Print(Symbol(), ",", ExpiryMinutes,",PUT,", Time[0]);
                 fileHandle = FileOpen(nomearquivo,FILE_CSV|FILE_READ|FILE_WRITE);
                 FileSeek(fileHandle, 0, SEEK_END);
                 string data = IntegerToString((long)TimeGMT())+","+Symbol()+",put,"+IntegerToString(ExpiryMinutes);
                 FileWrite(fileHandle,data);
                 FileClose(fileHandle);
                }                 
         else if(select_tool==BotPro) botpro("PUT", expiraca_botpro, ativar_mg_botpro, Symbol(), trade_amount_botpro, nome_sinal, tipo_ativo_botpro);
         else if(select_tool==PricePro) TradePricePro(Symbol(), "PUT", TempoDeOperacao, nome_sinal, 3, 1, TimeLocal(), Corretora);
         else if(select_tool==MT2) mt2trading(Symbol(), "PUT", TradeAmount, ExpiryMinutes, MartingaleType, MartingaleSteps, MartingaleCoef, Broker, nome_sinal, signalID);
         else if(select_tool==B2IQ) put(Symbol(), Period(), Modalidade, SinalEntrada, vps);
         else if(select_tool==Mamba) mambabot(_Symbol,"PUT",_Period, nome_sinal, Corretoram);
         else if(select_tool==TopWin) 
           {
            string texto = ReadFile(diretorio);
            datetime hora_entrada =  TimeLocal();
            string entrada = Symbol()+",put,"+string(Period())+","+string(0)+","+string(nome_sinal)+","+string(hora_entrada)+","+string(Period());
            texto = texto +"\n"+ entrada;
            WriteFile(diretorio,texto);
           }
         Print("PUT - Sinal enviado para o Automatizador!");
         temposinal = iTime(NULL,0,0);
        }
     }else temposinal = iTime(NULL,0,0);
  }



//+--------[ envia requisição para boot ]---------------------------+  
string geturl(string url)
   {   
      int HttpOpen = InternetOpenW(" ", 0, " ", " ", 0); 
      int HttpConnect = InternetConnectW(HttpOpen, "", 80, "", "", 3, 0, 1); 
      int HttpRequest = InternetOpenUrlW(HttpOpen, url, NULL, 0, INTERNET_FLAG_NO_CACHE_WRITE, 0);
      if(HttpRequest==0) return "0";

      int read[1];
      uchar  Buffer[];
      ArrayResize(Buffer, READURL_BUFFER_SIZE + 1);
      string page = "";
      while (true)
         {
         InternetReadFile(HttpRequest, Buffer, READURL_BUFFER_SIZE, read);
         string strThisRead = CharArrayToString(Buffer, 0, read[0], CP_UTF8);
         if (read[0] > 0)
            {
               page = page + strThisRead;
            }else
               {
                  break;
               }
         }
      
      if (HttpRequest > 0) InternetCloseHandle(HttpRequest); 
      if (HttpConnect > 0) InternetCloseHandle(HttpConnect); 
      if (HttpOpen > 0) InternetCloseHandle(HttpOpen);  
      
      return page;
   }
   
string PeriodString() 
  {
   switch(_Period) 
     {
      case PERIOD_M1:   return("PT1M");
      case PERIOD_M5:   return("PT5M");
      case PERIOD_M15:  return("PT15M");
      case PERIOD_M30:  return("PT30M");
     }
   return(string(_Period));
}

string VolumeSerialNumber()
  {
//---
   string res="";
//---
   string RootPath=StringSubstr(TerminalInfoString(TERMINAL_COMMONDATA_PATH),0,1)+":\\";
   string VolumeName,SystemName;
   uint VolumeSerialNumber[1],Length=0,Flags=0;
//---
   if(!GetVolumeInformationW(RootPath,VolumeName,StringLen(VolumeName),VolumeSerialNumber,Length,Flags,SystemName,StringLen(SystemName)))
     {
      res="XXXX-XXXX";
      Print("Failed to receive VSN !");
     }
   else
     {
      //--
      uint VSN=VolumeSerialNumber[0];
      //--
      if(VSN==0)
        {
         res="0";
         Print("Error: Receiving VSN may fail on Mac / Linux.");
        }
      else
        {
         res=StringFormat("%X",VSN);
         res=StringSubstr(res,0,4)+"-"+StringSubstr(res,4,8);
         //Print("VSN successfully received.");
        }
      //--
     }
     
   return res;
 }
 
void alertar()
  {
   static datetime alertou;
    
   if(Time[0]>alertou && ativar(preup[0]) && !ativar(up[0]))
     {
      alertou = Time[0];
      Alert("Possivel CALL "+_Symbol+" M"+IntegerToString(_Period));
     }
    
   if(Time[0]>alertou && ativar(predn[0]) && !ativar(dn[0]))
     {
      alertou = Time[0];
      Alert("Possivel PUT "+_Symbol+" M"+IntegerToString(_Period));
     }
     
   if(Time[0]>alertou && ativar(up[0]))
     {
      alertou = Time[0];
      Alert("CALL "+_Symbol+" M"+IntegerToString(_Period));
     }
    
   if(Time[0]>alertou && ativar(dn[0]))
     {
      alertou = Time[0];
      Alert("PUT "+_Symbol+" M"+IntegerToString(_Period));
     }
  }
  
bool sequencia_gale(string direcao, int vela) 
  {
   if(TotalGalesMinimo == 0) 
     {
      return true;
     }
   int total=0;
   for(int i=0; i<TotalGalesMinimo; i++) 
     {
      if(Open[i+vela+1] > Close[i+vela+1] && direcao == "call") 
        {
         total++;
        }
      if(Open[i+vela+1] < Close[i+vela+1] && direcao == "put") 
        {
         total++;
        }
     }
   if(total >= TotalGalesMinimo) 
     {
      return true;
     }
   return false;
  }
  
//+------------------------------------------------------------------+
void WriteFile(string path, string escrita)
  {
   int filehandle = FileOpen(path,FILE_WRITE|FILE_TXT);
   FileWriteString(filehandle,escrita);
   FileClose(filehandle);
  }
//+------------------------------------------------------------------+
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
//+------------------------------------------------------------------+
