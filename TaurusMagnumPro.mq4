//============================================================================================================================================================
//+------------------------------------------------------------------+
//|            CHAVE SEGURANÇA TRAVA MENSAL PRO CLIENTE              |
//+------------------------------------------------------------------+
//============================================================================================================================================================
//demo DATA DA EXPIRAÇÃO                           // demo DATA DA EXPIRAÇÃO
bool use_demo= FALSE; // FALSE  // TRUE            // TRUE ATIVA / FALSE DESATIVA EXPIRAÇÃO
string ExpiryDate= "30/03/2023";                   // DATA DA EXPIRAÇÃO
string expir_msg="TaurusMagnumPro Expirado ? Suporte Pelo Telegram @IndicadoresTaurus !!!"; // MENSAGEM DE AVISO QUANDO EXPIRAR
//============================================================================================================================================================
//NÚMERO DA CONTA MT4                              // NÚMERO DA CONTA MT4
bool use_acc_number= FALSE ; // TRUE  // TRUE      // TRUE ATIVA / FALSE DESATIVA NÚMERO DE CONTA
long acc_number= 500540333;                        // NÚMERO DA CONTA
string acc_numb_msg="TaurusMagnumPro não autorizado pra essa, conta !!!"; // MENSAGEM DE AVISO NÚMERO DE CONTA INVÁLIDO
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
#property copyright   "TaurusMagnumPro.O.B"
#property description "Atualizado no dia 16/03/2023"
#property link        "https://t.me/IndicadoresTaurus"
#property description "Programado por Ivonaldo Farias !!!"
#property description "===================================="
#property description "Contato WhatsApp => +55 84 8103‑3879"
#property description "===================================="
#property description "Suporte Pelo Telegram @IndicadoresTaurus"
#property description "===================================="
#property description "Receber Sinais Do Indicador No Telegram -> Somente No Grupo VIP"
#property strict
#property icon "\\Images\\taurus.ico"
//============================================================================================================================================================
#property indicator_chart_window
#property indicator_buffers 16
#property indicator_color1 clrLime
#property indicator_color2 clrRed
#property indicator_color3 clrLime
#property indicator_color4 clrRed
#property indicator_color5 clrLime
#property indicator_color6 clrRed
#property indicator_color12 clrRed
#property indicator_color13 clrRed
//============================================================================================================================================================
#define KEY_DELETE 46
#define READURL_BUFFER_SIZE   100
#define INTERNET_FLAG_NO_CACHE_WRITE 0x04000000
//============================================================================================================================================================
#include <WinUser32.mqh>
//============================================================================================================================================================
#define CALL 1
#define PUT -1
#define EXAMPLE_PHOTO "C:\\Users\\Usuario\\AppData\\Roaming\\MetaQuotes\\Terminal\\9D15457EC01AD10E06A932AAC616DC32\\MQL4\\Files\\exemplo.jpg"
//============================================================================================================================================================
struct backtest
  {
   double            win;
   double            loss;
   double            draw;
   int               consecutive_wins;
   int               consecutive_losses;
   int               count_win;
   int               count_loss;
   int               count_entries;
                     backtest()
     {
      Reset();
     }
   void              Reset()
     {
      win=0;
      loss=0;
      draw=0;
      consecutive_wins=0;
      consecutive_losses=0;
      count_win=0;
      count_loss=0;
      count_entries=0;
     }
  };
//============================================================================================================================================================
struct estatisticas
  {
   int               win_global;
   int               loss_global;
   int               win_restrito;
   int               loss_restrito;
   string            assertividade_global_valor;
   string            assertividade_restrita_valor;
                     estatisticas()
     {
      Reset();
     }
   //============================================================================================================================================================
   void              Reset()
     {
      win_global=0;
      loss_global=0;
      win_restrito=0;
      loss_restrito=0;
      assertividade_global_valor="0%";
      assertividade_restrita_valor="0%";
     }
  };
//============================================================================================================================================================
struct melhor_nivel
  {
   double            rate;
   double            value_chart_maxima;
   double            value_chart_minima;
  };
//============================================================================================================================================================
enum tipo
  {
   NA_MESMA_VELA,  //Na mesma vela
   NA_PROXIMA_VELA //Na próxima vela
  };
//============================================================================================================================================================
//---- Parâmetros de entrada - MX2
//DONO IVONALDO COPY
enum sinal
  {
   MESMA_VELA = 0,   //LIBERA COPY
   PROXIMA_VELA = 1  //LIBERA COPY
  };
//============================================================================================================================================================
//---- Parâmetros de entrada - MX2
//CLIENTES PROIBIDO COPY
//enum sinal
//  {
//   MESMA_VELA = 3,   //PROIBIDO COPY
//   PROXIMA_VELA = 4  //PROIBIDO COPY
// };
//============================================================================================================================================================
enum tipoexpericao
  {
   tempo_fixo = 0, //Tempo fixo
   retracao = 1    //Retração na mesma vela
  };
//--
//============================================================================================================================================================
enum IaTaurusChave
  {
   desativado=0, //desativado
   ativado=1     //ativado
  };
//============================================================================================================================================================
#import "Telegram4Mql.dll"
string            TelegramSendText(string ApiKey, string ChatId, string ChatText);
string            TelegramSendTextAsync(string apiKey, string chatId, string chatText);
string            TelegramSendPhotoAsync(string apiKey, string chatId, string filePath, string caption = "");
#import
//============================================================================================================================================================
#import "MX2Trading_library.ex4"
bool              mx2trading(string par, string direcao, int expiracao, string sinalNome, int Signaltipo, int TipoExpiracao, string TimeFrame, string mID, string Corretora);
#import
//============================================================================================================================================================
#import "PriceProLib.ex4"
void              TradePricePro(string ativo, string direcao, int expiracao, string nomedosinal, int martingales, int martingale_em, int data_atual, int corretora);
#import
//============================================================================================================================================================
#import "Kernel32.dll"
bool              GetVolumeInformationW(string,string,uint,uint&[],uint,uint,string,uint);
#import
//============================================================================================================================================================
#import "user32.dll"
int               PostMessageW(int hWnd,int Msg,int wParam,int lParam);
int               RegisterWindowMessageW(string lpString);
#import
//============================================================================================================================================================
#import  "Wininet.dll"
int               InternetOpenW(string, int, string, string, int);
int               InternetConnectW(int, string, int, string, string, int, int, int);
int               HttpOpenRequestW(int, string, string, int, string, int, string, int);
int               InternetOpenUrlW(int, string, string, int, int, int);
int               InternetReadFile(int, uchar & arr[], int, int& OneInt[]);
int               InternetCloseHandle(int);
#import
//============================================================================================================================================================
enum Posicao
  {
   LadoDireito  = 1,      // Lado Esquerdo Acima ?
   LadoEsquerdo  = 3,     // Lado Esquerdo Abaixo ?
   LadoDireitoAbaixo = 4, // Lado Direito Acima ?
   LadoEsquerdoAbaixo = 2 // Lado Direito Abaixo ?
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
datetime   timet;
//============================================================================================================================================================
enum signaltype
  {
   IntraBar = 0,          // Intrabar
   ClosedCandle = 1       // On new bar
  };
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                    INDICADOR_EXTERNO_1                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string ___________INDICADOR_EXTERNO_1_____________= "============ COMBINER!  ======================================================================"; //=================================================================================";
input bool COMBINER = false;         // Ativar este indicador?
input string IndicatorName = "";     // Nome do Indicador ?
input int IndiBufferCall = 0;        // Buffer Call ?
input int IndiBufferPut = 1;         // Buffer Put ?
signaltype SignalType = IntraBar;    // Tipo de Entrada ?
ENUM_TIMEFRAMES ICT1TimeFrame = PERIOD_CURRENT; //TimeFrame ?
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
input string  _________MODOATIVAR___________________ = "=====>> Iniciar Operações Taurus! <<===============================================================================";//=================================================================================";
input int  VelasBack  = 130;                         //Catalogação Por Velas Do backtest ?
input IaTaurusChave VerticalLines = false;           //Habilitar, Linhas Vertical Win x Loss ?
input IaTaurusChave atualizar_conf = false;          //Habilitar inteligência artificial ?
input IaTaurusChave FiltroDeTendência  = false;      //Habilitar Filtro De Tendência ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string  _________MODOOPERACIONAL___________________ = "======== Definição do usuário! =================================================================================";//=================================================================================";
Posicao painel =  LadoDireito;                      //Posição do painel ?
int   Intervalo = 2;                                //Intervalo Entre Ordens ?
input double assertividade_min = 10;                //Assertividade (Trade Automático) ?
int value_chart_maxima = 5;                         //Value Chart - Máxima ?
int value_chart_minima =-5;                         //Value Chart - Mínima ?
input IaTaurusChave ativar_mx2 = false;             //Automatizar com MX2 TRADING ?
input IaTaurusChave ativar_pricepro = false;        //Automatizar com PRICEPRO ?
int    MaxDelay = 5;                                //Delay Máximo Do Sinal - 0 = Desativar ?
input IaTaurusChave AlertsMessage = false;          //Alerta Sonoro Notificações ?
//============================================================================================================================================================
string SignalName ="TaurusMagnumPro"; //Nome do Sinal para os Robos (Opcional)
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                     DEFINIÇÃO DOS TRADES                         |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string  _________ANÁLISE___________________ = "======= FILTRO DE TENDENCIA! ================================================================================";//=================================================================================";
int               MAPeriod=60;                            // Periodo Da EMA No Grafico ?
FiltroEma   MAType = LWMA;                   // Desvio Da EMA Disponiveis ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string  _________OPERACIONAL5___________________ = "===== API resultados No Telegram! ================================================================================";//=================================================================================";
input IaTaurusChave  sinaltelegram = false;                                      //Enviar Sinal No Telegram ?
string               nome_sala = "TaurusMagnumPro";                              //Nome da Sala ?
string               apikey = "5570108277:AAFuiUL_hWupUgWyrgRMWwmEeG_M1C3FKiY";  //API Key
input string         chatid = "";                                                //Chat ID Telegram ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string  _________OPERACIONAL4___________________ = "====== Obrigatório Ativo ( EURUSD ) ================================================================================";//=================================================================================";
input IaTaurusChave  resultados_parciais_ao_vivo = false;                        //Exibir Resultados Parciais ?
string               msg_personalizada_ao_vivo = "🔮 RESULTADOS TAURUS MG 🔮";     //Msg Personalizada ?
input int            Parcial = 15;                                               //Enviar Parcial a Cada (Minutos): ?
input int            tempo_minutos_ao_vivo = 200;                                //Reiniciar Os Resultados Em (Minutos): ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
input string  _________OPERACIONAL1___________________ = "======== Estatísticas Telegram! ================================================================================";//=================================================================================";
input IaTaurusChave   assertividade_global = false;            //Exibir Assertividade Global ?
input IaTaurusChave   assertividade_restrita = false;          //Exibir Assertividade Restrita ?
bool                  block_registros_duplicados = false;      //Não Registrar Sinais Duplicados ?
string                arquivo_estatisticas = "results.txt";    //Filename
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string  _________OPERACIONAL___________________ = "=========== Telegram Conf! ================================================================================";//=================================================================================";
input IaTaurusChave   ativar_win_gale = false;                  //Ativar Win MartinGale G1 ?
input IaTaurusChave   ativar_win_gale2 = false;                 //Ativar Win MartinGale G2 ?
int                   tempo_expiracao = 0;                      //Expiracação em Minutos (0-TF) ?
tipo                  Entrada = NA_PROXIMA_VELA;                //Entrada Sinais Telegram ?         // ACESSO SOMEMTE AO DONO CHAVE ---> PROXIMA_VELA // NA_MESMA_VELA
IaTaurusChave         mostrar_taxa=false;                       //Mostrar Taxa? (MESMA VELA) ?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string  _________OPERACIONAL6___________________ = "============= Win/Loss! ================================================================================";//=================================================================================";
string         message_win = "Win De Primeira ";         //Mensagem de Win ?
string         message_win_gale = "Win No Martingale ";  //Mensagem de Win Gale ?
string         message_win_gale2 = "Win No Martingale "; //Mensagem de Win Gale2 ?
string         message_loss = "Loss ";                   //Mensagem de Loss ?
string         message_empate = "Empate ";               //Mensagem de Empate ?
string         file_win = EXAMPLE_PHOTO;                 //Imagem de Win ?
string         file_win_gale = EXAMPLE_PHOTO;            //Imagem de Win Gale ?
string         file_win_gale2 = EXAMPLE_PHOTO;           //Imagem de Win Gale 2 ?
string         file_loss = EXAMPLE_PHOTO;                //Imagem de Loss ?
//============================================================================================================================================================

extern string  _________TaurusMagnumPro___________________ = "=======>> TaurusMagnumPro! <<==============================================================================";//=================================================================================";

//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
string ___________CONFIGURAÇÕES_GERAIS_____________= "===== CONFIGURAÇÕES_GERAIS ======================================================================"; //=================================================================================";
IaTaurusChave    AlertsSound = false;                    //Alerta Sonoro?
string           SoundFileUp          = "alert2.wav";    //Som do alerta CALL
string           SoundFileDown        = "alert2.wav";    //Som do alerta PUT
string           AlertEmailSubject    = "";              //Assunto do E-mail (vazio = desabilita).
IaTaurusChave    SendPushNotification = false;           //Notificações por PUSH?
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                   DEFINIÇÃO DOS TRADES                           |
//+------------------------------------------------------------------+
//============================================================================================================================================================
int            expiraca_mx2    = 0;                                //Tempo de Expiração em Minuto (0-Auto)
sinal          sinal_tipo_mx2  = MESMA_VELA;                       //Entrar na
tipoexpericao  tipo_expiracao_mx2 = tempo_fixo;                    //Tipo Expiração
//============================================================================================================================================================
backtest          info, infog1, infog2;
melhor_nivel      sets[];
melhor_nivel      melhor_set;
string timeframe = "M"+IntegerToString(_Period);
string mID =      IntegerToString(ChartID());
int               SPC=5;
double            rate=0;
//============================================================================================================================================================
double            PossibleBufferUp[], PossibleBufferDw[], BufferUp[], BufferDw[];
double            ganhou[], perdeu[], empatou[];
//============================================================================================================================================================
//Alertas
datetime          TimeBarEntradaUp;
datetime          TimeBarEntradaDn;
datetime          TimeBarUp;
datetime          TimeBarDn;
int   Sig_Up0 =   0;
int   Sig_Dn0 =   0;
int   Sig_UpCall0 = 0;
int   Sig_DnPut0 = 0;
int   Sig_DnPut1 = 0;
datetime          LastSignal;
//============================================================================================================================================================
//----value
double            vcHigh[];
double            vcLow[];
double            vcOpen[];
double            vcClose[];
int               Taurus;
double            ExtMapBuffer1[];
double            ExtMapBuffer2[];
double            ExtMapBuffer3[];
//============================================================================================================================================================
double VC_Overbought = 6;
double VC_Oversold = -6;
double VC_SlightlyOverbought = 11;
double VC_SlightlyOversold = -11;
int BarrasAnalise = 288;
int VC_Period =   0;
int VC_NumBars =  5;
//============================================================================================================================================================
int               MAMode;
string            strMAType;
double            MA_Cur, MA_Prev;
//============================================================================================================================================================
bool              first=true, nivel1=true, nivel2=false;
datetime          data;
bool              acesso_liberado=true;
datetime          horario_expiracao[], horario_entrada[];
string            horario_entrada_local[];
double            entrada[];
int               tipo_entrada[];
string            expiracao="", up="CALL", down="PUT",msg2="";
string            orders_extreme="order_status.txt";
datetime          befTime_rate, befTime_delay;
string filename_sinais_ao_vivo = arquivo_estatisticas;                   //Arquivo de Resultados Parciais
int               ratestotal, prevcalculated;
datetime          desativar_sinais_horario;
bool              first_filter=true;
bool              LIBERAR_ACESSO=false;
string            chave;
bool MelhorNivel = true;
static int largura_tela = 0, altura_tela = 0;
//============================================================================================================================================================
//ATENÇÃO !!!
//CHAVE DE SEGURANÇA DO INDICADOR POR TRAVA CID NUNCA ESQUEÇA DE ATIVA QUANDO POR EM TESTE AOS CLIENTES!!!!
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
bool AtivaChaveDeSeguranca = FALSE; // Ativa Chave De Segurança !!!!
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
//CHAVE DE SEGURANÇA DO INDICADOR POR TRAVA CID NUNCA ESQUEÇA DE ATIVA QUANDO POR EM TESTE AOS CLIENTES!!!!
//ATENÇÃO !!!
//============================================================================================================================================================
int OnInit()
  {
//============================================================================================================================================================
   if(AtivaChaveDeSeguranca)
     {
      //--- indicator Seguranca Chave !!
      IndicatorSetString(INDICATOR_SHORTNAME,"TaurusMagnumPro");
      string teste2 = StringFormat("%.32s", chave = VolumeSerialNumber());
      //============================================================================================================================================================
      string UniqueID  = "DCFC-6F82";  // DONO IVONALDO FARIAS
      string UniqueID1 = "9C8C-83D2";  // DONO IVONALDO FARIAS VPS
      //============================================================================================================================================================
      string UniqueID2 = "";  // CLIENTE
      //============================================================================================================================================================
      if(UniqueID != teste2
         && UniqueID != teste2
         && UniqueID1 != teste2
         && UniqueID2 != teste2)
         //============================================================================================================================================================
        {
         Alert("Sua Chave  (   " +chave+ "   )  Mande Pro dono => Suporte Pelo Telegram @IndicadoresTaurus!!!");
         Alert("TaurusMagnumPro -> Não Liberado Pra Este Computador Suporte Pelo Telegram @IndicadoresTaurus!!!");
         ChartIndicatorDelete(0,0,"TaurusMagnumPro");
         if(LIBERAR_ACESSO==false)
            return(0);
        }
     }
// FIM DA LISTA
//============================================================================================================================================================
//SEGURANCA CHAVE---//
   if(!demo_f())
      return(INIT_FAILED);
   if(!acc_number_f())
      return(INIT_FAILED);
//============================================================================================================================================================
   if(expiraca_mx2==0)
      expiraca_mx2=Period();
   EventSetMillisecondTimer(1);
//============================================================================================================================================================
   melhor_set.rate=-1;
   befTime_rate=iTime(NULL,0,0);
//============================================================================================================================================================
   if(tempo_expiracao==0)
      tempo_expiracao=Period();
   if(tempo_expiracao==1)
      expiracao="M1";
   else
      if(tempo_expiracao>1 && tempo_expiracao<60)
         expiracao=IntegerToString(tempo_expiracao)+"M";
      else
         if(tempo_expiracao==60)
            expiracao="H1";
         else
            if(tempo_expiracao>60)
               expiracao="H"+(IntegerToString(tempo_expiracao/60));

   if(ativar_win_gale==true)
      msg2="COM 1G SE NECESSÁRIO";
   else
      msg2="SEM MARTINGALE";
//============================================================================================================================================================
//--- indicator buffers mapping
   IndicatorBuffers(16);
//============================================================================================================================================================
   SetIndexStyle(0,DRAW_ARROW,NULL,1);
   SetIndexArrow(0,233); //221 for up arrow
   SetIndexBuffer(0,BufferUp);
   SetIndexLabel(0,"CALL");
//============================================================================================================================================================
   SetIndexStyle(1,DRAW_ARROW,NULL,1);
   SetIndexArrow(1,234); //222 for down arrow
   SetIndexBuffer(1,BufferDw);
   SetIndexLabel(1,"PUT");
//============================================================================================================================================================
   SetIndexStyle(2,DRAW_ARROW,NULL,1);
   SetIndexArrow(2,118); //221 for up arrow
   SetIndexBuffer(2,PossibleBufferUp);
   SetIndexLabel(2,"PRE-ALERTA CALL");
//============================================================================================================================================================
   SetIndexStyle(3,DRAW_ARROW,NULL,1);
   SetIndexArrow(3,118); //222 for down arrow
   SetIndexBuffer(3,PossibleBufferDw);
   SetIndexLabel(3,"PRE-ALERTA PUT");
//============================================================================================================================================================
//--Statistics buffers
   SetIndexStyle(4,DRAW_ARROW,NULL,2);
   SetIndexArrow(4,254);
   SetIndexBuffer(4,ganhou);
   SetIndexLabel(4,"WIN");
//============================================================================================================================================================
   SetIndexStyle(5,DRAW_ARROW,NULL,2);
   SetIndexArrow(5,253);
   SetIndexBuffer(5,perdeu);
   SetIndexLabel(5,"LOSS");
//============================================================================================================================================================
   SetIndexBuffer(6,empatou);
   SetIndexLabel(6,"DRAW");
//============================================================================================================================================================
//---value chart
   SetIndexStyle(7, DRAW_NONE);
   SetIndexStyle(8, DRAW_NONE);
   SetIndexStyle(9, DRAW_NONE);
   SetIndexStyle(10, DRAW_NONE);
//============================================================================================================================================================
   SetIndexBuffer(7, vcHigh);
   SetIndexBuffer(8, vcLow);
   SetIndexBuffer(9, vcOpen);
   SetIndexBuffer(10, vcClose);
//============================================================================================================================================================
   SetIndexLabel(7,"vcHigh");
   SetIndexLabel(8,"vcLow");
   SetIndexLabel(9,"vcOpen");
   SetIndexLabel(10,"vcClose");
//============================================================================================================================================================
   SetIndexEmptyValue(7, 0.0);
   SetIndexEmptyValue(8, 0.0);
   SetIndexEmptyValue(9, 0.0);
   SetIndexEmptyValue(10, 0.0);
//============================================================================================================================================================
//---value chart
   SetIndexEmptyValue(0,EMPTY_VALUE);
   SetIndexEmptyValue(1,EMPTY_VALUE);
   SetIndexEmptyValue(2,EMPTY_VALUE);
   SetIndexEmptyValue(3,EMPTY_VALUE);
   SetIndexEmptyValue(4,EMPTY_VALUE);
   SetIndexEmptyValue(5,EMPTY_VALUE);
   SetIndexEmptyValue(6,EMPTY_VALUE);
//===========================================================================================================================================================
   SetIndexBuffer(11,ExtMapBuffer3);
   SetIndexStyle(11,DRAW_LINE,STYLE_SOLID,0,clrGreen);
   SetIndexLabel(11, "Linha Ema");
//============================================================================================================================================================
   SetIndexBuffer(12,ExtMapBuffer1);
   SetIndexStyle(12,DRAW_LINE,STYLE_SOLID,0,clrNONE);
   SetIndexLabel(12, "Linha Ema");
//============================================================================================================================================================
   SetIndexBuffer(13,ExtMapBuffer2);
   SetIndexStyle(13,DRAW_LINE,STYLE_SOLID,0,clrNONE);
   SetIndexLabel(13, "Linha Ema");
//============================================================================================================================================================
   IndicatorShortName("TaurusMagnumPro");
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
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrMaroon);
   ChartSetInteger(0,CHART_COLOR_GRID,clrMaroon);
   ChartSetInteger(0,CHART_COLOR_VOLUME,clrGray);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrLime);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrMaroon);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrGray);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrMaroon);
   ChartSetInteger(0,CHART_COLOR_BID,clrIndigo);
   ChartSetInteger(0,CHART_COLOR_ASK,clrIndigo);
   ChartSetInteger(0,CHART_COLOR_LAST,clrIndigo);
   ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,clrIndigo);
   ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,false);
   ChartSetInteger(0,CHART_DRAG_TRADE_LEVELS,false);
   ChartSetInteger(0,CHART_SHOW_DATE_SCALE,true);
   ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,true);
   ChartSetInteger(0,CHART_SHOW_ONE_CLICK,false);
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   return(INIT_SUCCEEDED);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void deinit()
  {
   ObjectsDeleteAll(0,OBJ_VLINE);
   ObjectsDeleteAll(0,OBJ_LABEL);
   if(acesso_liberado==false)
      ChartIndicatorDelete(0,0,"TaurusMagnumPro");
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
   if(TimeGMT()-10800 > StrToTime(ExpiryDate))
     {
      ChartIndicatorDelete(0,0,"TaurusMagnumPro");
      acesso_liberado=false;
     }
//============================================================================================================================================================
   if(WindowExpertName()!="TaurusMagnumPro")
     {
      Alert("Não mude o nome do indicador!");
      ChartIndicatorDelete(0,0,"TaurusMagnumPro");
     }
//============================================================================================================================================================
// RESULTADOS PARCIAL
   static datetime befTime_aovivo=TimeGMT()-1900+Parcial*60; // 30 minutos

   if(StringSubstr(Symbol(),0)=="EURUSD")  // EURUSD // BTCUSD

      if(resultados_parciais_ao_vivo)
        {
         if(befTime_aovivo < TimeGMT()-1900)
           {
            estatisticas estatistica;
            AtualizarEstatisticas(estatistica);

            string resultado = msg_personalizada_ao_vivo+"\n\n";
            resultado+=ExibirResultadoParcialAoVivo();
            resultado+="\n\nWin ✅ -> "+IntegerToString(estatistica.win_global)+" | Loss - > ☑️  "+IntegerToString(estatistica.loss_global)+" ("+estatistica.assertividade_global_valor+")\n";
            TelegramSendTextAsync(apikey,chatid,resultado);
            befTime_aovivo = TimeGMT()-1900+Parcial*60;
           }
        }
//============================================================================================================================================================
//SEGURANCA CHAVE---//
   if(!demo_f())
      return(INIT_FAILED);
   if(!acc_number_f())
      return(INIT_FAILED);
//============================================================================================================================================================
   ratestotal=rates_total;
   prevcalculated=prev_calculated;
//============================================================================================================================================================
   if(acesso_liberado)
     {
      static datetime befTime_signal, befTime_panel, befTime_check, befTime_telegram;
      int limit = rates_total-prev_calculated > 0  ? VelasBack : 0;

      if(!first && atualizar_conf && rate < assertividade_min && befTime_rate<iTime(NULL,0,0))
        {
         first=true;
         nivel1=true;
         nivel2=false;
         value_chart_maxima=6;
         value_chart_minima=-6;
         first_filter=true;
         ArrayInitialize(PossibleBufferUp,EMPTY_VALUE);
         ArrayInitialize(PossibleBufferDw,EMPTY_VALUE);
         ArrayInitialize(BufferUp,EMPTY_VALUE);
         ArrayInitialize(BufferDw,EMPTY_VALUE);
         ArrayInitialize(ganhou,EMPTY_VALUE);
         ArrayInitialize(perdeu,EMPTY_VALUE);
         ArrayInitialize(empatou,EMPTY_VALUE);
         ObjectsDeleteAll();
        }
      //============================================================================================================================================================
      if(!first)
        {
         if(ObjectFind(0,"carregando")!=-1)
           {
            limit=VelasBack;
            ArrayInitialize(PossibleBufferUp,EMPTY_VALUE);
            ArrayInitialize(PossibleBufferDw,EMPTY_VALUE);
            ArrayInitialize(BufferUp,EMPTY_VALUE);
            ArrayInitialize(BufferDw,EMPTY_VALUE);
            ArrayInitialize(ganhou,EMPTY_VALUE);
            ArrayInitialize(perdeu,EMPTY_VALUE);
            ArrayInitialize(empatou,EMPTY_VALUE);
            ObjectDelete("carregando");
           }
         //============================================================================================================================================================
         for(int i = limit; i >= 0; i--)
           {
            //============================================================================================================================================================
            double maxima = iCustom(NULL,0,"ValueChart",0,i);
            double minima = iCustom(NULL,0,"ValueChart",1,i);
            double up1 = 0, dn1 = 0;
            //============================================================================================================================================================
            // primeiro indicador
            if(COMBINER)
              {
               up1 = iCustom(NULL, ICT1TimeFrame, IndicatorName, IndiBufferCall, i+SignalType);
               dn1 = iCustom(NULL, ICT1TimeFrame, IndicatorName, IndiBufferPut, i+SignalType);
               up1 = sinal_buffer(up1);
               dn1 = sinal_buffer(dn1);
              }
            else
              {
               up1 = true;
               dn1 = true;
              }
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
            if((vcHigh[i] >= value_chart_minima && vcLow[i] <= value_chart_minima)&& close[i]<open[i]
               &&(vcClose[i+2] >= value_chart_minima && vcClose[i+1] <= value_chart_minima)
               &&(!FiltroDeTendência || MA_Prev < MA_Cur) && up1
               //============================================================================================================================================================
               &&PossibleBufferUp[i+1]==EMPTY_VALUE && PossibleBufferDw[i+1]==EMPTY_VALUE
               &&BufferUp[i+1]==EMPTY_VALUE && BufferDw[i+1]==EMPTY_VALUE)
              {
               //============================================================================================================================================================
               if(Time[i] > LastSignal + (Period()*Intervalo)*60)
                 {
                  PossibleBufferUp[i] = iLow(_Symbol,PERIOD_CURRENT,i)-SPC*Point();
                  Sig_Up0=1;
                 }
              }
            else
              {
               PossibleBufferUp[i] = EMPTY_VALUE;
               Sig_Up0=0;
              } // CALL
            //============================================================================================================================================================
            if((vcLow[i] <= value_chart_maxima && vcHigh[i] >= value_chart_maxima)&& close[i]>open[i]
               &&(vcClose[i+2] <= value_chart_maxima && vcClose[i+1] >= value_chart_maxima)
               &&(!FiltroDeTendência || MA_Prev > MA_Cur)  && dn1
               //============================================================================================================================================================
               &&PossibleBufferUp[i+1]==EMPTY_VALUE && PossibleBufferDw[i+1]==EMPTY_VALUE
               &&BufferUp[i+1]==EMPTY_VALUE && BufferDw[i+1]==EMPTY_VALUE)
              {
               //============================================================================================================================================================
               if(Time[i] > LastSignal + (Period()*Intervalo)*60)
                 {
                  PossibleBufferDw[i] = iHigh(_Symbol,PERIOD_CURRENT,i)+SPC*Point();
                  Sig_Dn0=1;
                 }
              }
            else
              {
               PossibleBufferDw[i] = EMPTY_VALUE;
               Sig_Dn0=0;
              }
            //PUT
            //============================================================================================================================================================
            if(sinal_buffer(PossibleBufferUp[i+1]) && !sinal_buffer(BufferUp[i+1]))
              {
               LastSignal = Time[i];
               BufferUp[i] = iLow(_Symbol,PERIOD_CURRENT,i)-SPC*Point();
               Sig_UpCall0=1;
              }
            else
              {
               Sig_UpCall0=0;
              }
            //============================================================================================================================================================
            if(sinal_buffer(PossibleBufferDw[i+1]) && !sinal_buffer(BufferDw[i+1]))
              {
               LastSignal = Time[i];
               BufferDw[i] = iHigh(_Symbol,PERIOD_CURRENT,i)+SPC*Point();
               Sig_DnPut0=1;
              }
            else
              {
               Sig_DnPut0=0;
              }
            //============================================================================================================================================================
            //---Check result
            if((PossibleBufferUp[i]!=EMPTY_VALUE && i>1))
              {
               int v=i-1;

               if(Close[v]>Open[v])
                  ganhou[v]=high[v]+SPC*_Point;
               else
                  if(Close[v]<Open[v])
                     perdeu[v]=high[v]+SPC*_Point;
                  else
                     empatou[v]=high[v];

               befTime_check=Time[0];
              }
            //============================================================================================================================================================
            else
               if((PossibleBufferDw[i]!=EMPTY_VALUE && i>1))
                 {
                  int v=i-1;

                  if(Close[v]<Open[v])
                     ganhou[v]=low[v]-SPC*_Point;
                  else
                     if(Close[v]>Open[v])
                        perdeu[v]=low[v]-SPC*_Point;
                     else
                        if(Close[v]==Open[v])
                           empatou[v]=low[v];

                  befTime_check=Time[0];
                 }
            //---Check result
            //============================================================================================================================================================
            //---Send signal to Telegram
            if(sinaltelegram==true && i==0 && !first && rate >= assertividade_min && TimeGMT()-1900 > LerArquivoDelay())
              {
               //============================================================================================================================================================
               if(PossibleBufferUp[i] != 0 && PossibleBufferUp[i] != EMPTY_VALUE && befTime_telegram != Time[0])        //Entra Na Proxima Vela  <==
                  //============================================================================================================================================================
                 {
                  ArrayResize(entrada,ArraySize(entrada)+1);
                  entrada[ArraySize(entrada)-1]=Close[0];

                  if(Entrada==NA_MESMA_VELA)
                    {
                     ArrayResize(horario_entrada,ArraySize(horario_entrada)+1);
                     horario_entrada[ArraySize(horario_entrada)-1]=iTime(Symbol(),_Period,0);

                     datetime time_final = iTime(Symbol(),_Period,0)+tempo_expiracao*60;
                     datetime horario_inicial = Offset(iTime(Symbol(),_Period,0),time_final);
                     int tempo_restante = TimeMinute(time_final)-TimeMinute(horario_inicial);

                     if(tempo_restante==1 && TimeSeconds(TimeGMT())>30)
                       {
                        ArrayResize(horario_expiracao,ArraySize(horario_expiracao)+1);
                        horario_expiracao[ArraySize(horario_expiracao)-1]=iTime(Symbol(),_Period,0)+(tempo_expiracao*2)*60;
                       }
                     else
                       {
                        ArrayResize(horario_expiracao,ArraySize(horario_expiracao)+1);
                        horario_expiracao[ArraySize(horario_expiracao)-1]=iTime(Symbol(),_Period,0)+tempo_expiracao*60;
                       }
                    }
                  else
                    {
                     datetime h_entrada=iTime(Symbol(),_Period,0)+_Period*60;

                     ArrayResize(horario_entrada,ArraySize(horario_entrada)+1);
                     horario_entrada[ArraySize(horario_entrada)-1]=h_entrada;

                     ArrayResize(horario_expiracao,ArraySize(horario_expiracao)+1);
                     horario_expiracao[ArraySize(horario_expiracao)-1] = h_entrada+tempo_expiracao*60;
                    }

                  ArrayResize(tipo_entrada,ArraySize(tipo_entrada)+1);
                  tipo_entrada[ArraySize(tipo_entrada)-1]=CALL;

                  ArrayResize(horario_entrada_local,ArraySize(horario_entrada_local)+1);
                  horario_entrada_local[ArraySize(horario_entrada_local)-1]=GetHoraMinutos(iTime(Symbol(),_Period,0));

                  datetime tempo = Entrada==NA_PROXIMA_VELA ? iTime(Symbol(),_Period,0) : iTime(Symbol(),PERIOD_M1,0);

                  estatisticas estatistica;
                  if(assertividade_global==true || assertividade_restrita==true)
                    {
                     estatistica.Reset();
                     AtualizarEstatisticas(estatistica);
                    }
                  //============================================================================================================================================================
                  string msg="";
                  if(Entrada==NA_PROXIMA_VELA)
                    {
                     msg =  "🏁🏁🏁🔰 ENTRADA 🔰🏁🏁🏁"
                            +"\n 》》 ⚡️"+nome_sala+"⚡️ 《《"
                            +"\n\n"
                            +"🟢 SINAL "+Symbol()+" "+up+"\n"
                            +"⬆️ ENTRADA "+GetHoraMinutos(tempo)+"\n"
                            +"♻️ "+msg2+"\n"
                            +"🕕 Expiração de "+expiracao;
                    }
                  else
                    {
                     msg = !mostrar_taxa ?  "🏁🏁🏁🔰 ENTRADA 🔰🏁🏁🏁"
                           +"\n 》》 ⚡️"+nome_sala+"⚡️ 《《"
                           +"\n\n"
                           +"🟢 SINAL "+Symbol()+" "+up+"\n"
                           +"⬆️ ENTRADA "+GetHoraMinutos(tempo)+" (AGORA)\n"
                           +"🕕 EXPIRAÇÃO "+GetHoraMinutos2(horario_expiracao[ArraySize(horario_expiracao)-1])+"\n"
                           +"♻️ "+msg2+"\n"
                           +"🕕 Expiração de "+expiracao : "🏁🏁🏁🔰 ENTRADA 🔰🏁🏁🏁"
                           +"\n 》》 ⚡️"+nome_sala+"⚡️ 《《"
                           +"\n\n"
                           +"🟢 SINAL "+Symbol()+" "+up+"\n"
                           +"⬆️ ENTRADA "+GetHoraMinutos(tempo)+" (AGORA)\n"
                           +"🎯 TAXA "+DoubleToString(entrada[ArraySize(entrada)-1])+"\n"
                           +"🕕 EXPIRAÇÃO "+GetHoraMinutos2(horario_expiracao[ArraySize(horario_expiracao)-1])+"\n"
                           +"♻️ "+msg2+"\n"
                           +"🕕 Expiração de "+expiracao;
                    }
                  //============================================================================================================================================================
                  if(assertividade_global==true && assertividade_restrita==true)
                    {
                     msg+="\n\nWin: "+IntegerToString(estatistica.win_global)+" | Loss: "+IntegerToString(estatistica.loss_global)+" ("+estatistica.assertividade_global_valor+")\n";
                     msg+="Esse par: "+IntegerToString(estatistica.win_restrito)+"x"+IntegerToString(estatistica.loss_restrito)+" ("+estatistica.assertividade_restrita_valor+")";
                    }

                  else
                     if(assertividade_global==true && assertividade_restrita==false)
                        msg+="\n\nWin: "+IntegerToString(estatistica.win_global)+" | Loss: "+IntegerToString(estatistica.loss_global)+" ("+estatistica.assertividade_global_valor+")\n";

                     else
                        if(assertividade_global==false && assertividade_restrita==true)
                           msg+="\n\nEsse par: "+IntegerToString(estatistica.win_restrito)+"x"+IntegerToString(estatistica.loss_restrito)+" ("+estatistica.assertividade_restrita_valor+")";

                  if(TelegramSendTextAsync(apikey, chatid, msg)==IntegerToString(0)
                    )
                    {
                     Print("=> Enviou sinal de CALL para o Telegram");
                    }

                  befTime_telegram = Time[0];
                 }
               //============================================================================================================================================================
               else
                  if(PossibleBufferDw[i] != 0 && PossibleBufferDw[i] != EMPTY_VALUE && befTime_telegram != Time[0])       //Entra Na Proxima Vela  <==
                     //============================================================================================================================================================
                    {
                     ArrayResize(entrada,ArraySize(entrada)+1);
                     entrada[ArraySize(entrada)-1]=Close[0];

                     if(Entrada==NA_MESMA_VELA)
                       {
                        ArrayResize(horario_entrada,ArraySize(horario_entrada)+1);
                        horario_entrada[ArraySize(horario_entrada)-1]=iTime(Symbol(),_Period,0);

                        datetime time_final = iTime(Symbol(),_Period,0)+tempo_expiracao*60;
                        datetime horario_inicial = Offset(iTime(Symbol(),_Period,0),time_final);
                        int tempo_restante = TimeMinute(time_final)-TimeMinute(horario_inicial);

                        if(tempo_restante==1 && TimeSeconds(TimeGMT())>30)
                          {
                           ArrayResize(horario_expiracao,ArraySize(horario_expiracao)+1);
                           horario_expiracao[ArraySize(horario_expiracao)-1]=iTime(Symbol(),_Period,0)+(tempo_expiracao*2)*60;
                          }
                        else
                          {
                           ArrayResize(horario_expiracao,ArraySize(horario_expiracao)+1);
                           horario_expiracao[ArraySize(horario_expiracao)-1]=iTime(Symbol(),_Period,0)+tempo_expiracao*60;
                          }
                       }
                     else
                       {
                        datetime h_entrada=iTime(Symbol(),_Period,0)+_Period*60;

                        ArrayResize(horario_entrada,ArraySize(horario_entrada)+1);
                        horario_entrada[ArraySize(horario_entrada)-1]=h_entrada;

                        ArrayResize(horario_expiracao,ArraySize(horario_expiracao)+1);
                        horario_expiracao[ArraySize(horario_expiracao)-1]= h_entrada+tempo_expiracao*60;
                       }

                     ArrayResize(tipo_entrada,ArraySize(tipo_entrada)+1);
                     tipo_entrada[ArraySize(tipo_entrada)-1]=PUT;

                     ArrayResize(horario_entrada_local,ArraySize(horario_entrada_local)+1);
                     horario_entrada_local[ArraySize(horario_entrada_local)-1]=GetHoraMinutos(iTime(Symbol(),_Period,0));

                     datetime tempo = Entrada==NA_PROXIMA_VELA ? iTime(Symbol(),_Period,0) : iTime(Symbol(),PERIOD_M1,0);

                     estatisticas estatistica;
                     if(assertividade_global==true || assertividade_restrita==true)
                       {
                        estatistica.Reset();
                        AtualizarEstatisticas(estatistica);
                       }
                     //============================================================================================================================================================
                     string msg="";
                     if(Entrada==NA_PROXIMA_VELA)
                       {
                        msg =  "🏁🏁🏁🔰 ENTRADA 🔰🏁🏁🏁"
                               +"\n 》》 ⚡️"+nome_sala+"⚡️ 《《"
                               +"\n\n"
                               +"🔴 SINAL "+Symbol()+" "+down+"\n"
                               +"⬇️ ENTRADA "+GetHoraMinutos(tempo)+"\n"
                               +"♻️ "+msg2+"\n"
                               +"🕕 Expiração de "+expiracao;
                       }
                     else
                       {
                        msg = !mostrar_taxa ?  "🏁🏁🏁🔰 ENTRADA 🔰🏁🏁🏁"
                              +"\n 》》 ⚡️"+nome_sala+"⚡️ 《《"
                              +"\n\n"
                              +"🔴 SINAL "+Symbol()+" "+down+"\n"
                              +"⬇️ ENTRADA "+GetHoraMinutos(tempo)+" (AGORA)\n"
                              +"🕕 EXPIRAÇÃO "+GetHoraMinutos2(horario_expiracao[ArraySize(horario_expiracao)-1])+"\n"
                              +"♻️ "+msg2+"\n"
                              +"🕕 Expiração de "+expiracao : "🏁🏁🏁🔰 ENTRADA 🔰🏁🏁🏁"
                              +"\n 》》 ⚡️"+nome_sala+"⚡️ 《《"
                              +"\n\n"
                              +"🔴 SINAL "+Symbol()+" "+down+"\n"
                              +"⬇️ ENTRADA "+GetHoraMinutos(tempo)+" (AGORA)\n"
                              +"🎯 TAXA "+DoubleToString(entrada[ArraySize(entrada)-1])+"\n"
                              +"🕕 EXPIRAÇÃO "+GetHoraMinutos2(horario_expiracao[ArraySize(horario_expiracao)-1])+"\n"
                              +"♻️ "+msg2+"\n"
                              +"🕕 Expiração de "+expiracao;
                       }
                     //============================================================================================================================================================
                     if(assertividade_global==true && assertividade_restrita==true)
                       {
                        msg+="\n\nWin: " +IntegerToString(estatistica.win_global)+" | Loss: "+IntegerToString(estatistica.loss_global)+" ("+estatistica.assertividade_global_valor+")\n";
                        msg+="Esse par: "+IntegerToString(estatistica.win_restrito)+"x"+IntegerToString(estatistica.loss_restrito)+" ("+estatistica.assertividade_restrita_valor+")";
                       }

                     else
                        if(assertividade_global==true && assertividade_restrita==false)
                           msg+="\n\nWin: "+IntegerToString(estatistica.win_global)+" | Loss: "+IntegerToString(estatistica.loss_global)+" ("+estatistica.assertividade_global_valor+")\n";

                        else
                           if(assertividade_global==false && assertividade_restrita==true)
                              msg+="\n\nEsse par: "+IntegerToString(estatistica.win_restrito)+"x"+IntegerToString(estatistica.loss_restrito)+" ("+estatistica.assertividade_restrita_valor+")";

                     if(TelegramSendTextAsync(apikey, chatid, msg)==IntegerToString(0)
                       )
                       {

                        Print("=> Enviou sinal de PUT para o Telegram");
                       }

                     befTime_telegram = Time[0];
                    }
              }
            //---Telegram
           }
         //============================================================================================================================================================
         //---Signal
         //  Comment(WinRate," % ",WinRate);
         if(iTime(NULL,PERIOD_M1,0) > desativar_sinais_horario)
           {
            if(rate >= assertividade_min && TimeGMT()-1900 > LerArquivoDelay())
              {
               // FILTRO DE DELAY
               if(StringLen(Symbol()) > 6)
                 {
                  timet = TimeGMT();
                 }
               else
                 {
                  timet = TimeCurrent();
                 }
               if(((Time[0]+MaxDelay)>=timet) || (MaxDelay == 0))
                 {
                  if(BufferUp[0]!=EMPTY_VALUE && BufferUp[0]!=0 && befTime_signal != iTime(NULL,0,0))
                    {
                     if(ativar_mx2)
                        mx2trading(Symbol(), "CALL", expiraca_mx2, SignalName, sinal_tipo_mx2, tipo_expiracao_mx2, timeframe, mID, "0");
                     if(ativar_pricepro)
                        TradePricePro(Symbol(), "CALL", Period(), SignalName, 3, 1, int(TimeLocal()), 1);
                     befTime_signal = iTime(NULL,0,0);
                    }
                  else
                     if(BufferDw[0]!=EMPTY_VALUE && BufferDw[0]!=0 && befTime_signal != iTime(NULL,0,0))
                       {
                        if(ativar_mx2)
                           mx2trading(Symbol(), "PUT", expiraca_mx2, SignalName, sinal_tipo_mx2, tipo_expiracao_mx2, timeframe, mID, "0");
                        if(ativar_pricepro)
                           TradePricePro(Symbol(), "PUT", Period(), SignalName, 3, 1, int(TimeLocal()), 1);
                        befTime_signal = iTime(NULL,0,0);
                       }
                 }
              }
           }
         //============================================================================================================================================================
         if(iTime(NULL,0,0) > befTime_panel)
           {
            Statistics();
            Painel();
            befTime_panel=iTime(NULL,0,0);
           }
         //---Painel
         //============================================================================================================================================================
         //se a qnt de entradas for 0 então tente aumentar diminuindo o tamanho do retangulo
         if(info.count_entries==0)
           {
            ObjectDelete(0,"wins");
            ObjectDelete(0,"consecutive_wins");
            ObjectDelete(0,"consecutive_losses");
            ObjectDelete(0,"count_entries");
            ObjectDelete(0,"wins_rate");
            ObjectDelete(0,"quant");
            ObjectDelete(0,"backtest");
            ObjectDelete(0,"ValueChart+");
            ObjectDelete(0,"ValueChart-");
            ObjectDelete(0,"linha_cima");
            ObjectDelete(0,"linha_baixo");
            ObjectDelete(0,"linhaEstrategia");
            ObjectDelete(0,"linhaEstrategia1");
            ObjectDelete(0,"divisaoValueChar");
            ArrayInitialize(PossibleBufferUp,EMPTY_VALUE);
            ArrayInitialize(PossibleBufferDw,EMPTY_VALUE);
            ArrayInitialize(BufferUp,EMPTY_VALUE);
            ArrayInitialize(BufferDw,EMPTY_VALUE);
            ArrayInitialize(ganhou,EMPTY_VALUE);
            ArrayInitialize(perdeu,EMPTY_VALUE);
            ArrayInitialize(empatou,EMPTY_VALUE);
            befTime_panel=Time[1];
            CreateTextLable("carregando", "Carregando...", 15, "Segoe UI", clrLime, 1, 20, 5);
           }
         //--end !first
        }
     }
   else
      deinit();
//---Signal
//============================================================================================================================================================
//SEGURANCA CHAVE---//
   if(!demo_f())
      return(INIT_FAILED);
   if(!acc_number_f())
      return(INIT_FAILED);
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                         ALERTAS                                  |
//+------------------------------------------------------------------+
   if(AlertsMessage || AlertsSound)
     {
      string message1 = (SignalName+" - "+Symbol()+" : Possível CALL "+PeriodString());
      string message2 = (SignalName+" - "+Symbol()+" : Possível PUT "+PeriodString());

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
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//============================================================================================================================================================
void              OnTimer()
  {
   static datetime befTime_aovivo=TimeGMT()-1900+tempo_minutos_ao_vivo*60;

   if(StringSubstr(Symbol(),0)=="EURUSD") // BTCUSD // EURUSD

      if(resultados_parciais_ao_vivo)
        {
         if(befTime_aovivo < TimeGMT()-1900)
           {
            estatisticas estatistica;
            estatistica.Reset();
            AtualizarEstatisticas(estatistica);

            string resultado = msg_personalizada_ao_vivo+"\n\n";
            resultado+=ExibirResultadoParcialAoVivo();
            resultado+="\n\nWin ✅ -> "+IntegerToString(estatistica.win_global)+" | Loss - > ☑️  "+IntegerToString(estatistica.loss_global)+" ("+estatistica.assertividade_global_valor+")\n";
            TelegramSendTextAsync(apikey,chatid,resultado);
            befTime_aovivo = TimeGMT()-1900+tempo_minutos_ao_vivo*60;
            FileDelete(arquivo_estatisticas);
           }
        }
//============================================================================================================================================================
   Robos();
   licenca();
   FundoImagem();
//============================================================================================================================================================
   if(ratestotal==prevcalculated)
     {
      if(first_filter || !first)
        {
         filtro_value();
         first_filter=false;
        }
      //---escolhe melhor nivel do value
      if(first)
        {
         ArrayInitialize(PossibleBufferUp,EMPTY_VALUE);
         ArrayInitialize(PossibleBufferDw,EMPTY_VALUE);
         ArrayInitialize(BufferUp,EMPTY_VALUE);
         ArrayInitialize(BufferDw,EMPTY_VALUE);
         ArrayInitialize(ganhou,EMPTY_VALUE);
         ArrayInitialize(perdeu,EMPTY_VALUE);
         ArrayInitialize(empatou,EMPTY_VALUE);

         static int num=0;

         for(int i = VelasBack; i >= 0; i--)
           {

            if(num==0)
              {
               CreateTextLable("carregando", "TaurusMagnumPro. Aguarde.", 15, "Andalus", clrPink, 1, 20, 5);
              }
            else
               if(num==1)
                 {
                  CreateTextLable("carregando", "TaurusMagnumPro. Aguarde..", 15, "Andalus", clrOrangeRed, 1, 20, 5);
                 }
               else
                  if(num==2)
                    {
                     CreateTextLable("carregando", "TaurusMagnumPro. Aguarde...", 15, "Andalus", clrRed, 1, 20, 5);
                    }
                  else
                    {
                     CreateTextLable("carregando", "TaurusMagnumPro. Aguarde....", 15, "Andalus", clrDarkRed, 1, 20, 5);
                    }
            if(num==3)
               num=0;
            else
               num++;
            //============================================================================================================================================================
            double maxima = iCustom(NULL,0,"ValueChart",0,i);
            double minima = iCustom(NULL,0,"ValueChart",1,i);
            double up1 = 0, dn1 = 0;
            //============================================================================================================================================================
            // primeiro indicador
            if(COMBINER)
              {
               up1 = iCustom(NULL, ICT1TimeFrame, IndicatorName, IndiBufferCall, i+SignalType);
               dn1 = iCustom(NULL, ICT1TimeFrame, IndicatorName, IndiBufferPut, i+SignalType);
               up1 = sinal_buffer(up1);
               dn1 = sinal_buffer(dn1);
              }
            else
              {
               up1 = true;
               dn1 = true;
              }
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
            //============================================================================================================================================================                   if(High[i+0]>= Suporte[i+1]&&(Low[i+0]<=Suporte[i+1])&& Open[i]>Close[i]
            if((vcHigh[i] >= value_chart_minima && vcLow[i] <= value_chart_minima)&& Close[i]<Open[i]
               &&(vcClose[i+2] >= value_chart_minima && vcClose[i+1] <= value_chart_minima)
               &&(!FiltroDeTendência || MA_Prev < MA_Cur) && up1
               //============================================================================================================================================================
               &&PossibleBufferUp[i+1]==EMPTY_VALUE && PossibleBufferDw[i+1]==EMPTY_VALUE
               &&BufferUp[i+1]==EMPTY_VALUE && BufferDw[i+1]==EMPTY_VALUE
               &&BufferUp[i]==EMPTY_VALUE && BufferDw[i]==EMPTY_VALUE)
              {
               //============================================================================================================================================================
               if(Time[i] > LastSignal + (Period()*Intervalo)*60)
                 {
                  PossibleBufferUp[i] = iLow(_Symbol,PERIOD_CURRENT,i)-SPC*Point();
                 }
              }
            else
              {
               PossibleBufferUp[i] = EMPTY_VALUE;
              }
            //============================================================================================================================================================
            if((vcLow[i] <= value_chart_maxima && vcHigh[i] >= value_chart_maxima)&& Close[i]>Open[i]
               &&(vcClose[i+2] <= value_chart_maxima && vcClose[i+1] >= value_chart_maxima)
               &&(!FiltroDeTendência || MA_Prev > MA_Cur) && dn1
               //============================================================================================================================================================
               &&PossibleBufferUp[i+1]==EMPTY_VALUE && PossibleBufferDw[i+1]==EMPTY_VALUE
               &&BufferUp[i+1]==EMPTY_VALUE && BufferDw[i+1]==EMPTY_VALUE
               &&BufferUp[i]==EMPTY_VALUE && BufferDw[i]==EMPTY_VALUE)
              {
               //============================================================================================================================================================
               if(Time[i] > LastSignal + (Period()*Intervalo)*60)
                 {
                  PossibleBufferDw[i] = iHigh(_Symbol,PERIOD_CURRENT,i)+SPC*Point();
                 }
              }
            else
              {
               PossibleBufferDw[i] = EMPTY_VALUE;
              }
            //============================================================================================================================================================
            if(PossibleBufferUp[i+1]!=EMPTY_VALUE && PossibleBufferUp[i+1]!=0)
               BufferUp[i] = Low[i]-SPC*Point;
            if(PossibleBufferDw[i+1]!=EMPTY_VALUE && PossibleBufferDw[i+1]!=0)
               BufferDw[i] = High[i]+SPC*Point;
            //============================================================================================================================================================
            //---Check result
            if((PossibleBufferUp[i]!=EMPTY_VALUE && i>1))
              {
               int v=i-1;

               if(Close[v]>Open[v])
                  ganhou[v]=High[v]+SPC*_Point;
               else
                  if(Close[v]<Open[v])
                     perdeu[v]=High[v]+SPC*_Point;
                  else
                     empatou[v]=High[v];
              }
            //============================================================================================================================================================
            else
               if((PossibleBufferDw[i]!=EMPTY_VALUE && i>1))
                 {
                  int v=i-1;

                  if(Close[v]<Open[v])
                     ganhou[v]=Low[v]-SPC*_Point;
                  else
                     if(Close[v]>Open[v])
                        perdeu[v]=Low[v]-SPC*_Point;
                     else
                        if(Close[v]==Open[v])
                           empatou[v]=Low[v];
                 }
           }
         //============================================================================================================================================================
         //---Statistics
         Statistics(true);
         if(info.win != 0)
            rate = (info.win/(info.win+info.loss))*100;
         else
            rate = 0;
         //---Statistics

         if(value_chart_maxima==10 && nivel1)
           {
            value_chart_maxima=5;
            value_chart_minima--;
           }
         else
            if(nivel1)
              {
               ArrayResize(sets,ArraySize(sets)+1);
               sets[ArraySize(sets)-1].rate=rate;
               sets[ArraySize(sets)-1].value_chart_maxima=value_chart_maxima;
               sets[ArraySize(sets)-1].value_chart_minima=value_chart_minima;
               value_chart_maxima++;
              }

         if(value_chart_minima==-10 && nivel1)
           {
            nivel1=false;
            nivel2=true;
            value_chart_maxima=5;
            value_chart_minima=-5;
           }

         if(value_chart_minima==-10 && nivel2)
           {
            value_chart_minima=-5;
            value_chart_maxima++;
           }
         else
            if(nivel2)
              {
               ArrayResize(sets,ArraySize(sets)+1);
               sets[ArraySize(sets)-1].rate=rate;
               sets[ArraySize(sets)-1].value_chart_maxima=value_chart_maxima;
               sets[ArraySize(sets)-1].value_chart_minima=value_chart_minima;
               value_chart_minima--;
              }

         if(value_chart_maxima==10 && nivel2)
           {
            nivel1=false;
            nivel2=false;
            first=false;

            for(int n=0; n<ArraySize(sets); n++)
              {
               if(sets[n].rate > melhor_set.rate)
                  melhor_set=sets[n];
              }

            value_chart_maxima=int(melhor_set.value_chart_maxima);
            value_chart_minima=int(melhor_set.value_chart_minima);
            CreateTextLable("carregando", "Melhor configuração TaurusMagnumPro escolhida. Carregando...", 15, "Andalus", clrLime, 1, 20, 5);

            befTime_rate=iTime(NULL,0,0)+PeriodSeconds()*12;
            Print(befTime_rate);
            Print("entrou "+DoubleToString(melhor_set.rate)+" "+DoubleToString(value_chart_maxima)+" "+DoubleToString(value_chart_minima));
            //--- escolher melhor nivel
           }
        }
     }
//============================================================================================================================================================
   for(int i=0; i<ArraySize(tipo_entrada); i++)
     {
      datetime horario_expiracao_gale = horario_expiracao[i]+tempo_expiracao*60; //horário acrescido para checkar o gale
      datetime horario_expiracao_gale2 = horario_expiracao_gale+tempo_expiracao*60; //horário acrescido para checkar o gale
      datetime horario_agora = iTime(Symbol(),_Period,0);
      bool remove_index=false;
      //============================================================================================================================================================
      if(horario_agora>=horario_expiracao[i] || horario_agora>=horario_expiracao_gale)
        {
         int shift_abertura=iBarShift(NULL,0,horario_entrada[i]);
         int shift_expiracao=tempo_expiracao==_Period ? shift_abertura : iBarShift(NULL,0,horario_expiracao[i]);

         int shift_abertura_gale=iBarShift(NULL,0,horario_expiracao[i]);
         int shift_expiracao_gale=tempo_expiracao==_Period ? shift_abertura_gale : iBarShift(NULL,0,horario_expiracao_gale);

         int shift_abertura_gale2=iBarShift(NULL,0,horario_expiracao_gale);
         int shift_expiracao_gale2=tempo_expiracao==_Period ? shift_abertura_gale2 : iBarShift(NULL,0,horario_expiracao_gale2);

         if(tipo_entrada[i]==CALL)  //entrada CALL
           {
            if(ativar_win_gale==false)
              {
               if(Entrada==NA_MESMA_VELA)
                 {
                  if(Close[shift_expiracao]>entrada[i])
                    {
                     if(message_win!="")
                        TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                     if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                        TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                     remove_index=true;
                     if(assertividade_global==true || assertividade_restrita==true)
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win");
                     else
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win#");
                    }

                  else
                     if(Close[shift_expiracao]<entrada[i])
                       {
                        if(message_loss!="")
                           TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                        if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                           TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                        remove_index=true;
                        if(assertividade_global==true || assertividade_restrita==true)
                          {
                           GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                           AumentarDelay(TimeGMT()-1800);
                          }
                        else
                          {
                           GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                           AumentarDelay(TimeGMT()-1800);
                          }
                       }
                     //============================================================================================================================================================

                     else
                        if(Close[shift_expiracao]==entrada[i])
                          {
                           if(message_empate!="")
                              TelegramSendTextAsync(apikey, chatid, message_empate+"🪙 ️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                           remove_index=true;
                          }
                 }
               else
                 {
                  if(Close[shift_expiracao]>Open[shift_abertura])
                    {
                     if(message_win!="")
                        TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                     if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                        TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                     remove_index=true;
                     if(assertividade_global==true || assertividade_restrita==true)
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win");
                     else
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win#");
                    }
                  //============================================================================================================================================================
                  else
                     if(Close[shift_expiracao]<Open[shift_abertura])
                       {
                        if(message_loss!="")
                           TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                        if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                           TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                        remove_index=true;
                        if(assertividade_global==true || assertividade_restrita==true)
                          {
                           GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                           AumentarDelay(TimeGMT()-1800);
                          }
                        else
                          {
                           GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                           AumentarDelay(TimeGMT()-1800);
                          }
                       }

                     else
                        if(Close[shift_expiracao]==Open[shift_abertura])
                          {
                           if(message_empate!="")
                              TelegramSendTextAsync(apikey, chatid, message_empate+"🪙 ️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                           remove_index=true;
                          }
                 }//ok
              }
            //============================================================================================================================================================
            else  //ativar gale ==true
              {
               if(Entrada==NA_MESMA_VELA)
                 {
                  if(Close[shift_expiracao]>entrada[i] && horario_agora>=horario_expiracao[i])
                    {
                     if(message_win!="")
                        TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                     if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                        TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                     remove_index=true;
                     if(assertividade_global==true || assertividade_restrita==true)
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win");
                     else
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win#");
                    }
                  //============================================================================================================================================================
                  else
                     if(Close[shift_expiracao]==entrada[i] && horario_agora>=horario_expiracao[i])
                       {
                        if(message_win!="")
                           TelegramSendTextAsync(apikey, chatid, message_empate+"🪙 → "+Symbol()+" "+horario_entrada_local[i]+" "+up);// arrumei
                        remove_index=true;
                       }

                     else
                        if(Close[shift_expiracao_gale]>Open[shift_abertura_gale])
                          {
                           if(horario_agora>=horario_expiracao_gale)
                             {
                              if(message_win_gale!="")
                                 TelegramSendTextAsync(apikey, chatid, message_win_gale+"✅🐔1G → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                              if(file_win_gale!=EXAMPLE_PHOTO&&file_win_gale!="")
                                 TelegramSendPhotoAsync(apikey, chatid, file_win_gale, "");
                              remove_index=true;
                              if(assertividade_global==true || assertividade_restrita==true)
                                {
                                 if(message_win_gale=="loss")
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg1");
                                 else
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","wing1");
                                }
                              else
                                {
                                 if(message_win_gale=="loss")
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg1#");
                                 else
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","wing1#");
                                }
                             }
                          }
                        //============================================================================================================================================================
                        else
                           if(Close[shift_expiracao_gale]<Open[shift_abertura_gale])
                             {
                              if(horario_agora>=horario_expiracao_gale)
                                {
                                 if(ativar_win_gale2==false)
                                   {
                                    if(message_loss!="")
                                       TelegramSendTextAsync(apikey, chatid, message_loss+"☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                    if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                       TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                    remove_index=true;
                                    if(assertividade_global==true || assertividade_restrita==true)
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                   }
                                 //============================================================================================================================================================

                                 else
                                   {
                                    if(Close[shift_expiracao_gale2]>Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                      {
                                       if(message_win_gale2!="")
                                          TelegramSendTextAsync(apikey, chatid, message_win_gale2+"✅🐔🐔G2 → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                       if(file_win_gale2!=EXAMPLE_PHOTO&&file_win_gale2!="")
                                          TelegramSendPhotoAsync(apikey, chatid, file_win_gale2, "");
                                       remove_index=true;
                                       if(assertividade_global==true || assertividade_restrita==true)
                                         {
                                          if(message_win_gale2=="loss")
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2");
                                          else
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2");
                                         }
                                       else
                                         {
                                          if(message_win_gale2=="loss")
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2#");
                                          else
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2#");
                                         }
                                      }
                                    //============================================================================================================================================================
                                    else
                                       if(Close[shift_expiracao_gale2]<Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                         {
                                          if(message_loss!="")
                                             TelegramSendTextAsync(apikey, chatid, message_loss+"☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                          if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                             TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                          remove_index=true;
                                          if(assertividade_global==true || assertividade_restrita==true)
                                            {
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                             AumentarDelay(TimeGMT()-1800);
                                            }
                                          else
                                            {
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                             AumentarDelay(TimeGMT()-1800);
                                            }
                                         }
                                       //============================================================================================================================================================

                                       else
                                          if(Close[shift_expiracao_gale2]==Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                            {
                                             if(message_loss!="")
                                                TelegramSendTextAsync(apikey, chatid, message_loss+"☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                             if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                                TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                             remove_index=true;
                                             if(assertividade_global==true || assertividade_restrita==true)
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                             else
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                            }
                                   }
                                }
                             }//ok
                           //============================================================================================================================================================
                           else
                              if(Close[shift_expiracao_gale]==Open[shift_abertura_gale])
                                {
                                 if(horario_agora>=horario_expiracao_gale)
                                   {
                                    if(message_loss!="")
                                       TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                    if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                       TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                    remove_index=true;
                                    if(assertividade_global==true || assertividade_restrita==true)
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                    else
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                   }
                                }
                 }
               //============================================================================================================================================================
               else   //na proxima vela
                 {
                  if(Close[shift_expiracao]>Open[shift_abertura] && horario_agora>=horario_expiracao[i])
                    {
                     if(message_win!="")
                        TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                     if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                        TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                     remove_index=true;
                     if(assertividade_global==true || assertividade_restrita==true)
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win");
                     else
                        GravarResultado(Symbol(),horario_entrada_local[i],"call","win#");
                    }

                  else
                     if(Close[shift_expiracao]==Open[shift_abertura])
                       {
                        if(message_empate!="")
                           TelegramSendTextAsync(apikey, chatid, message_empate+"🪙 ️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                        remove_index=true;
                       }
                     //============================================================================================================================================================

                     else
                        if(Close[shift_expiracao_gale]>Open[shift_abertura_gale])
                          {
                           if(horario_agora>=horario_expiracao_gale)
                             {
                              if(message_win_gale!="")
                                 TelegramSendTextAsync(apikey, chatid, message_win_gale+"✅🐔1G → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                              if(file_win_gale!=EXAMPLE_PHOTO&&file_win_gale!="")
                                 TelegramSendPhotoAsync(apikey, chatid, file_win_gale, "");
                              remove_index=true;
                              if(assertividade_global==true || assertividade_restrita==true)
                                {
                                 if(message_win_gale=="loss")
                                   {
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg1");
                                    AumentarDelay(TimeGMT()-1800);
                                   }
                                 else
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","wing1");
                                }
                              else
                                {
                                 if(message_win_gale=="loss")
                                   {
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg1#");
                                    AumentarDelay(TimeGMT()-1800);
                                   }
                                 else
                                    GravarResultado(Symbol(),horario_entrada_local[i],"call","wing1#");
                                }
                             }
                          }
                        //============================================================================================================================================================
                        else
                           if(Close[shift_expiracao_gale]<Open[shift_abertura_gale])
                             {
                              if(horario_agora>=horario_expiracao_gale)
                                {
                                 if(ativar_win_gale2==true)
                                   {
                                    if(Close[shift_expiracao_gale2]>Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                      {
                                       if(message_win_gale2!="")
                                          TelegramSendTextAsync(apikey, chatid, message_win_gale2+"✅🐔🐔2G → "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                       if(file_win_gale2!=EXAMPLE_PHOTO&&file_win_gale2!="")
                                          TelegramSendPhotoAsync(apikey, chatid, file_win_gale2, "");
                                       remove_index=true;
                                       if(assertividade_global==true || assertividade_restrita==true)
                                         {
                                          if(message_win_gale2=="loss")
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2");
                                          else
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2");
                                         }
                                       else
                                         {
                                          if(message_win_gale2=="loss")
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2#");
                                          else
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2#");
                                         }
                                      }
                                    //============================================================================================================================================================
                                    else
                                       if(Close[shift_expiracao_gale2]<Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                         {
                                          if(message_loss!="")
                                             TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                          if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                             TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                          remove_index=true;
                                          if(assertividade_global==true || assertividade_restrita==true)
                                            {
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                             AumentarDelay(TimeGMT()-1800);
                                            }
                                          else
                                            {
                                             GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                             AumentarDelay(TimeGMT()-1800);
                                            }
                                         }
                                       //============================================================================================================================================================
                                       else
                                          if(Close[shift_expiracao_gale2]==Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                            {
                                             if(message_loss!="")
                                                TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                             if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                                TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                             remove_index=true;
                                             if(assertividade_global==true || assertividade_restrita==true)
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                             else
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                            }
                                    //============================================================================================================================================================

                                   }
                                 else
                                   {
                                    if(message_loss!="")
                                       TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                    if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                       TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                    remove_index=true;
                                    if(assertividade_global==true || assertividade_restrita==true)
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                    else
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                   }
                                }
                             }
                           //============================================================================================================================================================
                           else
                              if(Close[shift_expiracao_gale]==Open[shift_abertura_gale])
                                {
                                 if(horario_agora>=horario_expiracao_gale)
                                   {
                                    if(message_loss!="")
                                       TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+up);
                                    if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                       TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                    remove_index=true;
                                    if(assertividade_global==true || assertividade_restrita==true)
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                    else
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                   }
                                }
                 }
              } //fim ativar gale true - ok
            //============================================================================================================================================================
            //ENTRADA PUT
           }
         else
            if(tipo_entrada[i]==PUT)
              {
               if(ativar_win_gale==false)
                 {
                  if(Entrada==NA_MESMA_VELA)
                    {
                     if(Close[shift_expiracao]<entrada[i])
                       {
                        if(message_win!="")
                           TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                        if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                           TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                        remove_index=true;
                        if(assertividade_global==true || assertividade_restrita==true)
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win");
                        else
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win#");
                       }
                     //============================================================================================================================================================

                     else
                        if(Close[shift_expiracao]>entrada[i])
                          {
                           if(message_loss!="")
                              TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                           if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                              TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                           remove_index=true;
                           if(assertividade_global==true || assertividade_restrita==true)
                             {
                              GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                              AumentarDelay(TimeGMT()-1800);
                             }
                           else
                             {
                              GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                              AumentarDelay(TimeGMT()-1800);
                             }
                          }
                        //============================================================================================================================================================
                        else
                           if(Close[shift_expiracao]==entrada[i])
                             {
                              if(message_empate!="")
                                 TelegramSendTextAsync(apikey, chatid, message_empate+"🪙 → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                              remove_index=true;
                             }
                    }
                  else
                    {
                     if(Close[shift_expiracao]<Open[shift_abertura])
                       {
                        if(message_win!="")
                           TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                        if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                           TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                        remove_index=true;
                        if(assertividade_global==true || assertividade_restrita==true)
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win");
                        else
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win#");
                       }
                     //============================================================================================================================================================

                     else
                        if(Close[shift_expiracao]>Open[shift_abertura])
                          {
                           if(message_loss!="")
                              TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️→ "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                           if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                              TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                           remove_index=true;
                           if(assertividade_global==true || assertividade_restrita==true)
                             {
                              GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                              AumentarDelay(TimeGMT()-1800);
                             }
                           else
                             {
                              GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                              AumentarDelay(TimeGMT()-1800);
                             }
                          }

                        else
                           if(Close[shift_expiracao]==Open[shift_abertura])
                             {
                              if(message_empate!="")
                                 TelegramSendTextAsync(apikey, chatid, message_empate+"🪙 → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                              remove_index=true;
                             }
                    }//ok
                  //============================================================================================================================================================
                 }
               else   //ativar gale ==true
                 {
                  if(Entrada==NA_MESMA_VELA)
                    {
                     if(Close[shift_expiracao]<entrada[i] && horario_agora>=horario_expiracao[i])
                       {
                        if(message_win!="")
                           TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                        if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                           TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                        remove_index=true;
                        if(assertividade_global==true || assertividade_restrita==true)
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win");
                        else
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win#");
                       }

                     else
                        if(Close[shift_expiracao]==entrada[i] && horario_agora>=horario_expiracao[i])
                          {
                           if(message_empate!="")
                              TelegramSendTextAsync(apikey, chatid, message_empate+" 🪙 → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                           remove_index=true;
                          }
                        //============================================================================================================================================================

                        else
                           if(Close[shift_expiracao_gale]<Open[shift_abertura_gale])
                             {
                              if(horario_agora>=horario_expiracao_gale)
                                {
                                 if(message_win_gale!="")
                                    TelegramSendTextAsync(apikey, chatid, message_win_gale+"✅🐔1G → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                 if(file_win_gale!=EXAMPLE_PHOTO&&file_win_gale!="")
                                    TelegramSendPhotoAsync(apikey, chatid, file_win_gale, "");
                                 remove_index=true;
                                 if(assertividade_global==true || assertividade_restrita==true)
                                   {
                                    if(message_win_gale=="loss")
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                    else
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","win");
                                   }
                                 else
                                   {
                                    if(message_win_gale=="loss")
                                      {
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","loss#");
                                       AumentarDelay(TimeGMT()-1800);
                                      }
                                    else
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","win#");
                                   }
                                }
                             }
                           //============================================================================================================================================================
                           else
                              if(Close[shift_expiracao_gale]>Open[shift_abertura_gale])
                                {
                                 if(horario_agora>=horario_expiracao_gale)
                                   {
                                    if(ativar_win_gale2==true)
                                      {
                                       if(Close[shift_expiracao_gale2]<Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                         {
                                          if(message_win_gale2!="")
                                             TelegramSendTextAsync(apikey, chatid, message_win_gale2+"✅🐔🐔2G → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                          if(file_win_gale2!=EXAMPLE_PHOTO&&file_win_gale2!="")
                                             TelegramSendPhotoAsync(apikey, chatid, file_win_gale2, "");
                                          remove_index=true;
                                          if(assertividade_global==true || assertividade_restrita==true)
                                            {
                                             if(message_win_gale2=="loss")
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2");
                                             else
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2");
                                            }
                                          else
                                            {
                                             if(message_win_gale2=="loss")
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2#");
                                             else
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2#");
                                            }
                                         }
                                       //============================================================================================================================================================

                                       else
                                          if(Close[shift_expiracao_gale2]>Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                            {
                                             if(message_loss!="")
                                                TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                             if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                                TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                             remove_index=true;
                                             if(assertividade_global==true || assertividade_restrita==true)
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                             else
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                            }
                                          //============================================================================================================================================================

                                          else
                                             if(Close[shift_expiracao_gale2]==Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                               {
                                                if(message_loss!="")
                                                   TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                                if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                                   TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                                remove_index=true;
                                                if(assertividade_global==true || assertividade_restrita==true)
                                                  {
                                                   GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                                   AumentarDelay(TimeGMT()-1800);
                                                  }
                                                else
                                                  {
                                                   GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                                   AumentarDelay(TimeGMT()-1800);
                                                  }
                                               }
                                       //============================================================================================================================================================
                                      }
                                    else
                                      {
                                       if(message_loss!="")
                                          TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                       if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                          TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                       remove_index=true;
                                       if(assertividade_global==true || assertividade_restrita==true)
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                       else
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                      }
                                   }
                                }//ok
                              //============================================================================================================================================================
                              else
                                 if(Close[shift_expiracao_gale]==Open[shift_abertura_gale])
                                   {
                                    if(horario_agora>=horario_expiracao_gale)
                                      {
                                       if(message_loss!="")
                                          TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                       if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                          TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                       remove_index=true;
                                       if(assertividade_global==true || assertividade_restrita==true)
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                       else
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                      }
                                   }
                     //============================================================================================================================================================

                    }
                  else   //na proxima vela
                    {
                     if(Close[shift_expiracao]<Open[shift_abertura] && horario_agora>=horario_expiracao[i])
                       {
                        if(message_win!="")
                           TelegramSendTextAsync(apikey, chatid, message_win+"✅ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                        if(file_win!=EXAMPLE_PHOTO&&file_win!="")
                           TelegramSendPhotoAsync(apikey, chatid, file_win, "");
                        remove_index=true;
                        if(assertividade_global==true || assertividade_restrita==true)
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win");
                        else
                           GravarResultado(Symbol(),horario_entrada_local[i],"put","win#");
                       }

                     else
                        if(Close[shift_expiracao]==Open[shift_abertura] && horario_agora>=horario_expiracao[i])
                          {
                           if(message_empate!="")
                              TelegramSendTextAsync(apikey, chatid, message_empate+"🪙 → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                           remove_index=true;
                          }
                        //============================================================================================================================================================

                        else
                           if(Close[shift_expiracao_gale]<Open[shift_abertura_gale])
                             {
                              if(horario_agora>=horario_expiracao_gale)
                                {
                                 if(message_win_gale!="")
                                    TelegramSendTextAsync(apikey, chatid, message_win_gale+"✅🐔1G → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                 if(file_win_gale!=EXAMPLE_PHOTO&&file_win_gale!="")
                                    TelegramSendPhotoAsync(apikey, chatid, file_win_gale, "");
                                 remove_index=true;
                                 if(assertividade_global==true || assertividade_restrita==true)
                                   {
                                    if(message_win_gale=="loss")
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg1");
                                    else
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","wing1");
                                   }
                                 else
                                   {
                                    if(message_win_gale=="loss")
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg1#");
                                    else
                                       GravarResultado(Symbol(),horario_entrada_local[i],"call","wing1#");
                                   }
                                }
                             }
                           //============================================================================================================================================================
                           else
                              if(Close[shift_expiracao_gale]>Open[shift_abertura_gale])
                                {
                                 if(horario_agora>=horario_expiracao_gale2)
                                   {
                                    if(ativar_win_gale2==true)
                                      {
                                       if(Close[shift_expiracao_gale2]<Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                         {
                                          if(message_win_gale2!="")
                                             TelegramSendTextAsync(apikey, chatid,  message_win_gale2+"✅🐔🐔2G → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                          if(file_win_gale2!=EXAMPLE_PHOTO&&file_win_gale2!="")
                                             TelegramSendPhotoAsync(apikey, chatid, file_win_gale2, "");
                                          remove_index=true;
                                          if(assertividade_global==true || assertividade_restrita==true)
                                            {
                                             if(message_win_gale2=="loss")
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2");
                                             else
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2");
                                            }
                                          else
                                            {
                                             if(message_win_gale2=="loss")
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","lossg2#");
                                             else
                                                GravarResultado(Symbol(),horario_entrada_local[i],"call","wing2#");
                                            }
                                         }
                                       //============================================================================================================================================================
                                       else
                                          if(Close[shift_expiracao_gale2]>Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                            {
                                             if(message_loss!="")
                                                TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                             if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                                TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                             remove_index=true;
                                             if(assertividade_global==true || assertividade_restrita==true)
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                             else
                                               {
                                                GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                                AumentarDelay(TimeGMT()-1800);
                                               }
                                            }
                                          //============================================================================================================================================================

                                          else
                                             if(Close[shift_expiracao_gale2]==Open[shift_abertura_gale2] && horario_agora>=horario_expiracao_gale2)
                                               {
                                                if(message_loss!="")
                                                   TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                                if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                                   TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                                remove_index=true;
                                                if(assertividade_global==true || assertividade_restrita==true)
                                                  {
                                                   GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                                   AumentarDelay(TimeGMT()-1800);
                                                  }
                                                else
                                                  {
                                                   GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                                   AumentarDelay(TimeGMT()-1800);
                                                  }
                                               }
                                       //============================================================================================================================================================

                                      }
                                    else
                                      {
                                       if(message_loss!="")
                                          TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                       if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                          TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                       remove_index=true;
                                       if(assertividade_global==true || assertividade_restrita==true)
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                       else
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                      }
                                   }
                                }
                              //============================================================================================================================================================

                              else
                                 if(Close[shift_expiracao_gale]==Open[shift_abertura_gale])
                                   {
                                    if(horario_agora>=horario_expiracao_gale)
                                      {
                                       if(message_loss!="")
                                          TelegramSendTextAsync(apikey, chatid, message_loss+" ☑️ → "+Symbol()+" "+horario_entrada_local[i]+" "+down);
                                       if(file_loss!=EXAMPLE_PHOTO&&file_loss!="")
                                          TelegramSendPhotoAsync(apikey, chatid, file_loss, "");
                                       remove_index=true;
                                       if(assertividade_global==true || assertividade_restrita==true)
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                       else
                                         {
                                          GravarResultado(Symbol(),horario_entrada_local[i],"put","loss#");
                                          AumentarDelay(TimeGMT()-1800);
                                         }
                                      }
                                   }
                    }
                 }//ok
              }
         //============================================================================================================================================================
         if(remove_index==true)
           {
            RemoveIndexFromArray(horario_entrada,i);
            RemoveIndexFromArray(horario_entrada_local,i);
            RemoveIndexFromArray(horario_expiracao,i);
            RemoveIndexFromArray(tipo_entrada,i);
            RemoveIndexFromArray(entrada,i);
           }
        }
     }
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string            GetHoraMinutos(datetime time_open, bool resul=false)
  {
   string entry,hora,minuto;

   MqlDateTime time_open_str, time_local_str, time_entrada_str; //structs
   TimeToStruct(time_open,time_open_str); //extraindo o time de abertura do candle atual e armazenando em um struct
   TimeLocal(time_local_str); //extraindo o time local e armazenando em um struct
   string time_local_abertura_str = IntegerToString(time_local_str.year)+"."+IntegerToString(time_local_str.mon)+"."+IntegerToString(time_local_str.day)+" "+IntegerToString(time_local_str.hour)+":"+IntegerToString(time_open_str.min)+":"+IntegerToString(time_open_str.sec);
   datetime time_local_abertura_dt = StrToTime(time_local_abertura_str); //convertendo de volta pra datetime já com o horário local e o time de abertura do candle

   if(Entrada == NA_PROXIMA_VELA && resul==false)
      time_local_abertura_dt=time_local_abertura_dt+_Period*60;

   TimeToStruct(time_local_abertura_dt,time_entrada_str); //convertendo datetime em struct para extrair hora e minuto

//--formatando horário
   if(time_entrada_str.hour >= 0 && time_entrada_str.hour <= 9)
      hora = "0"+IntegerToString(time_entrada_str.hour);
   else
      hora = IntegerToString(time_entrada_str.hour);

   if(time_entrada_str.min >= 0 && time_entrada_str.min <= 9)
      minuto = "0"+IntegerToString(time_entrada_str.min);
   else
      minuto = IntegerToString(time_entrada_str.min);

   entry = hora+":"+minuto;
//--

   return entry;
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string            GetHoraMinutos2(datetime time_open, bool resul=false)
  {
   string entry,hora,minuto;

   MqlDateTime time_open_str, time_local_str, time_entrada_str; //structs
   TimeToStruct(time_open,time_open_str); //extraindo o time de abertura do candle atual e armazenando em um struct
   TimeLocal(time_local_str); //extraindo o time local e armazenando em um struct
   string time_local_abertura_str;
   if(time_open_str.min!=0)
     {
      time_local_abertura_str = IntegerToString(time_local_str.year)+"."+IntegerToString(time_local_str.mon)+"."+IntegerToString(time_local_str.day)+" "+IntegerToString(time_local_str.hour)+":"+IntegerToString(time_open_str.min)+":"+IntegerToString(time_open_str.sec);
     }
   else
     {
      datetime timer_local = TimeLocal()+tempo_expiracao*60;
      TimeToStruct(timer_local,time_local_str);
      time_local_abertura_str = IntegerToString(time_local_str.year)+"."+IntegerToString(time_local_str.mon)+"."+IntegerToString(time_local_str.day)+" "+IntegerToString(time_local_str.hour)+":00:"+IntegerToString(time_open_str.sec);
     }

   datetime time_local_abertura_dt = StrToTime(time_local_abertura_str); //convertendo de volta pra datetime já com o horário local e o time de abertura do candle

   if(Entrada == NA_PROXIMA_VELA && resul==false)
      time_local_abertura_dt=time_local_abertura_dt+_Period*60;

   TimeToStruct(time_local_abertura_dt,time_entrada_str); //convertendo datetime em struct para extrair hora e minuto

//--formatando horário
   if(time_entrada_str.hour >= 0 && time_entrada_str.hour <= 9)
      hora = "0"+IntegerToString(time_entrada_str.hour);
   else
      hora = IntegerToString(time_entrada_str.hour);

   if(time_entrada_str.min >= 0 && time_entrada_str.min <= 9)
      minuto = "0"+IntegerToString(time_entrada_str.min);
   else
      minuto = IntegerToString(time_entrada_str.min);

   entry = hora+":"+minuto;
//--

   return entry;
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              SalvarSinal(datetime time, string status_sinal)
  {
   ResetLastError();

   int fp = FileOpen(orders_extreme, FILE_WRITE|FILE_READ|FILE_TXT);
   string line = TimeToStr(time)+";"+status_sinal+";"+IntegerToString(ChartID());
   Print(line+" "+IntegerToString(ChartID()));

   if(fp != INVALID_HANDLE)
     {
      FileWrite(fp, line);
      FileClose(fp);
     }
   else
     {
      Print(GetLastError());
     }
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string            fnReadFileValue()
  {
   int    str_size;
   string str="";
   string result[];
   ushort u_sep = StringGetCharacter(";",0);

   ResetLastError();
   int file_handle=FileOpen(orders_extreme,FILE_READ|FILE_TXT);

//--- read data from the file
//--- find out how many symbols are used for writing the time
   str_size=FileReadInteger(file_handle,INT_VALUE);
//--- read the string
   str=FileReadString(file_handle,str_size);

   FileClose(file_handle);

   if(StringLen(str)!=0)
     {
      StringSplit(str,u_sep,result);
      if(StringLen(ChartSymbol(int(result[2])))==0)
        {
         str=StringConcatenate(result[0],";loss;",result[2]);
        }

      else
         if(StringLen(ChartSymbol(int(result[2])))>0 && (result[0]=="nda"||result[0]=="ndas") &&
            ((PossibleBufferUp[1]==EMPTY_VALUE && BufferUp[0]==EMPTY_VALUE && PossibleBufferDw[1]==EMPTY_VALUE && BufferDw[0]==EMPTY_VALUE) ||
             (PossibleBufferUp[0]==EMPTY_VALUE && BufferUp[0]==EMPTY_VALUE && PossibleBufferDw[0]==EMPTY_VALUE && BufferDw[0]==EMPTY_VALUE)))
           {
            str=StringConcatenate(result[0],";loss;",result[2]);
           }
     }

   return str;
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string            ultimo_resultado_qtd()
  {
   string result[];
   ushort u_sep = StringGetCharacter(";",0);

   string ultimo_resultado_global = fnReadFileValue();

   if(StringLen(ultimo_resultado_global)>0)
     {
      int k = StringSplit(ultimo_resultado_global,u_sep,result);
      return result[3];
     }

   return "0";
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string            ultimo_resultado_global()
  {
   string result[];
   ushort u_sep = StringGetCharacter(";",0);

   string ultimo_resultado_global = fnReadFileValue();

   if(StringLen(ultimo_resultado_global)>0)
     {
      int k = StringSplit(ultimo_resultado_global,u_sep,result);
      if(result[1]=="loss")
         return "loss";
      else
         if(result[1]=="nda"||result[1]=="ndas")
            return "nda";
     }

   return "win";
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              GravarResultado(string par, string horario, string operacao, string resultado)
  {
   bool registrar=true;
   string registro = StringConcatenate(par,";",horario,";",operacao,";",resultado,"\n");
   int file_handle=FileOpen(arquivo_estatisticas,FILE_READ|FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_WRITE|FILE_TXT);

   if(block_registros_duplicados==true)
     {
      int    str_size;
      string str;
      ushort u_sep = StringGetCharacter(";",0);

      while(!FileIsEnding(file_handle))
        {
         string result[];
         str_size=FileReadInteger(file_handle,INT_VALUE);
         str=FileReadString(file_handle,str_size);
         StringSplit(str,u_sep,result);

         if(result[0]==par && result[1]==horario && result[2]==operacao && result[3]==resultado)
            registrar=false;
        }
     }
//============================================================================================================================================================
   if(registrar==true)
     {
      FileSeek(file_handle,0,SEEK_END);
      FileWriteString(file_handle,registro);
     }

   FileClose(file_handle);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              AtualizarEstatisticas(estatisticas &estatistica)
  {
   int file_handle=FileOpen(arquivo_estatisticas,FILE_READ|FILE_SHARE_READ|FILE_TXT);
   if(file_handle!=INVALID_HANDLE)
     {
      int    str_size;
      string str;
      ushort u_sep = StringGetCharacter(";",0);

      while(!FileIsEnding(file_handle))
        {
         string result[];
         str_size=FileReadInteger(file_handle,INT_VALUE);
         str=FileReadString(file_handle,str_size);
         StringSplit(str,u_sep,result);

         if(result[3]=="win"||result[3]=="wing1"||result[3]=="wing2")
            estatistica.win_global++;
         else
            if(result[3]=="loss"||result[3]=="lossg1"||result[3]=="lossg2")
               estatistica.loss_global++;
         if(result[0]==Symbol() && (result[3]=="win"||result[3]=="wing1"||result[3]=="wing2"))
            estatistica.win_restrito++;
         else
            if(result[0]==Symbol() && (result[3]=="loss"||result[3]=="lossg1"||result[3]=="lossg2"))
               estatistica.loss_restrito++;
        }

      estatistica.assertividade_global_valor = estatistica.win_global>0 ? DoubleToString(((double)estatistica.win_global/((double)estatistica.win_global+(double)estatistica.loss_global))*100,0)+"%" : "0%";
      estatistica.assertividade_restrita_valor = estatistica.win_restrito>0 ? DoubleToString(((double)estatistica.win_restrito/((double)estatistica.win_restrito+(double)estatistica.loss_restrito)*100),0)+"%" : "0%";

      FileClose(file_handle);
     }
   else
     {
      PrintFormat("Failed to open %s file, Error code = %d",arquivo_estatisticas,GetLastError());
     }
  }

template <typename T> void RemoveIndexFromArray(T& A[], int iPos)
  {
   int iLast;
   for(iLast = ArraySize(A) - 1; iPos < iLast; ++iPos)
      A[iPos] = A[iPos + 1];
   ArrayResize(A, iLast);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime          Offset(datetime expiracao_inicial, datetime expiracao_final)
  {
   MqlDateTime expiracao_convert, local_convert;
   TimeToStruct(expiracao_inicial,expiracao_convert);
   TimeLocal(local_convert);

   string expiracao_inicial_convert_str = string(expiracao_convert.year)+"."+string(expiracao_convert.mon)+"."+string(expiracao_convert.day)+" "+string(expiracao_convert.hour)+":"+string(local_convert.min)+":"+string(TimeSeconds(TimeGMT()));
   datetime expiracao_inicial_convert_dt = StringToTime(expiracao_inicial_convert_str);

   return expiracao_inicial_convert_dt;
  }
//============================================================================================================================================================
void              FundoImagem()
  {
   ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0);
   ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   ObjectCreate(0,"fundo",OBJ_BITMAP_LABEL,0,0,0);
   ObjectSetString(0,"fundo",OBJPROP_BMPFILE,0,"\\Images\\Taurus.bmp");  //Fundo De Imagem
   ObjectSetInteger(0,"fundo",OBJPROP_XDISTANCE,0,int(largura_tela/2.4));
   ObjectSetInteger(0,"fundo",OBJPROP_YDISTANCE,0,altura_tela/5);
   ObjectSetInteger(0,"fundo",OBJPROP_BACK,true);
   ObjectSetInteger(0,"fundo",OBJPROP_CORNER,0);
  }
//============================================================================================================================================================
void              licenca()
  {
   data = StringToTime(ExpiryDate);
   int expirc = int((data-Time[0])/86400);
   ObjectCreate("expiracao",OBJ_LABEL,0,0,0,0,0);
   ObjectSetText("expiracao"," Sua licença expira em: "+IntegerToString(expirc)+" dias!... ", 13,"Andalus",clrLavender);
   ObjectSet("expiracao",OBJPROP_XDISTANCE,0*2);
   ObjectSet("expiracao",OBJPROP_YDISTANCE,1*0);
   ObjectSet("expiracao",OBJPROP_CORNER,4);
  }
//============================================================================================================================================================
void              Robos()
  {
   if(sinaltelegram)
     {
      string carregando = "Conectado... Enviando Sinal Pro TELEGRAM...";
      CreateTextLable("carregando1",carregando,10,"Andalus",clrLavender,2,0,0);
     }
//============================================================================================================================================================
   if(ativar_mx2)
     {
      string carregando = "Conectado... Enviando Sinal Pro MX2 TRADING...!";
      CreateTextLable("carregando1",carregando,10,"Andalus",clrLavender,2,0,0);
     }
//============================================================================================================================================================
   if(ativar_pricepro)
     {
      string carregando = "Conectado... Enviando Sinal Pro PRICEPRO...";
      CreateTextLable("carregando1",carregando,10,"Andalus",clrLavender,2,0,0);
     }
//============================================================================================================================================================
     {
      //Contato Taurus
      string carregando = "|| Me chame no telegram para renovar: @IndicadoresTaurus ||";
      CreateTextLable("carregandoLabel",carregando,12,"Andalus",clrLavender,3,0,0);
     }
  }
//============================================================================================================================================================
bool              sinal_buffer(double value)
  {
   if(value != 0 && value != EMPTY_VALUE)
      return true;
   else
      return false;
  }
//============================================================================================================================================================
string            PeriodString()
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
double            LSMA(int Rperiod, int shift)
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
void              VerticalLine(int i, color clr)
  {
   string objName = "Backtest-Line "+string(iTime(NULL,0,i));

   ObjectCreate(objName, OBJ_VLINE,0,Time[i],0);
   ObjectSet(objName, OBJPROP_COLOR, clr);
   ObjectSet(objName, OBJPROP_BACK, true);
   ObjectSet(objName, OBJPROP_STYLE, 1);
   ObjectSet(objName, OBJPROP_WIDTH, 1);
   ObjectSet(objName, OBJPROP_SELECTABLE, false);
   ObjectSet(objName, OBJPROP_HIDDEN, true);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              Statistics(bool backtest_value=false)
  {
   info.Reset();

   for(int i=288; i>=1; i--)
     {
      //--- Statistics
      if(ganhou[i]!=EMPTY_VALUE)
        {
         info.win++;
         info.count_win++;
         info.count_entries++;
         info.count_loss=0;
         if(info.count_win>info.consecutive_wins)
            info.consecutive_wins++;
         if(VerticalLines)
           {
            if(!backtest_value)
               VerticalLine(i,clrLimeGreen);
           }
        }
      else
         if(perdeu[i]!=EMPTY_VALUE)
           {
            info.loss++;
            info.count_loss++;
            info.count_entries++;
            info.count_win=0;
            if(info.count_loss>info.consecutive_losses)
               info.consecutive_losses++;
            if(VerticalLines)
              {
               if(!backtest_value)
                  VerticalLine(i,clrRed);
              }
           }
         else
            if(empatou[i]!=EMPTY_VALUE)
              {
               info.draw++;
               info.count_entries++;
               if(VerticalLines)
                 {
                  if(!backtest_value)
                     VerticalLine(i,clrWhiteSmoke);
                 }
              }
     }
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              Painel()
  {
   color textColor = clrLavender;
   int Corner = painel;
   int font_size=8;
   int font_x=30;
   int font_x2=25; //martingales
   string font_type="Time New Roman";

   if(info.win != 0)
      rate = (info.win/(info.win+info.loss))*100;
   else
      rate = 0;

   string backtest_text = "Backtest Resultados";
   CreateTextLable("backtest",backtest_text,10,"Arial Black",clrLime,Corner,15,5);

   string divisao_cima = "______________________________";
   CreateTextLable("linha_cima",divisao_cima,font_size,font_type,textColor,Corner,0,10);

   string quant = "WIN: "+DoubleToString(info.win,0)+" | LOSS: "+DoubleToString(info.loss,0)+" | EMPATE: "+DoubleToString(info.draw,0);
   CreateTextLable("wins",quant,font_size,font_type,textColor,Corner,font_x,70);

   string consecutive_wins = "CONSECUTIVE WINS: "+IntegerToString(info.consecutive_wins);
   CreateTextLable("consecutive_wins",consecutive_wins,font_size,font_type,textColor,Corner,font_x,90);

   string consecutive_losses = "CONSECUTIVE LOSSES: "+IntegerToString(info.consecutive_losses);
   CreateTextLable("consecutive_losses",consecutive_losses,font_size,font_type,textColor,Corner,font_x,110);

   string count_entries = "QUANT ENTRADAS: "+IntegerToString(info.count_entries);
   CreateTextLable("count_entries",count_entries,font_size,font_type,textColor,Corner,font_x,50);

   string wins_rate = "WIN RATE: "+DoubleToString(rate,0)+"%";
   CreateTextLable("wins_rate",wins_rate,font_size,font_type,textColor,Corner,font_x,130);

   string bars_total = "QUANT VELAS "+IntegerToString(VelasBack);
   CreateTextLable("quant",bars_total,font_size,font_type,textColor,Corner,font_x,30);

   string divisao_baixo = "______________________________";
   CreateTextLable("linha_baixo",divisao_cima,font_size,font_type,textColor,Corner,0,140);

   string IaTaurus = "TAURUS MAGNUM PRO";
   CreateTextLable("linhaEstrategia1",IaTaurus,10,"Arial Black",clrLime,Corner,10,158);

   string divisaoEstrategia = "______________________________";
   CreateTextLable("linhaEstrategia",divisaoEstrategia,font_size,font_type,textColor,Corner,0,170);

   string ValueChartmMaxima = "ValueChartMaxima + "+IntegerToString(value_chart_maxima);
   CreateTextLable("ValueChart+",ValueChartmMaxima,font_size,font_type,textColor,Corner,font_x,190);

   string ValueChartMinima = "ValueChartMinima "+IntegerToString(value_chart_minima);
   CreateTextLable("ValueChart-",ValueChartMinima,font_size,font_type,textColor,Corner,font_x,210);

   string divisaoValueChar = "______________________________";
   CreateTextLable("divisaoValueChar",divisaoValueChar,font_size,font_type,textColor,Corner,0,220);

  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              AumentarDelay(datetime delay)
  {
   int file_handle=FileOpen("ultimo_resultado.txt",FILE_READ|FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_WRITE|FILE_TXT);
   FileWrite(file_handle,delay);
   FileClose(file_handle);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime          LerArquivoDelay()
  {
   int file_handle=FileOpen("ultimo_resultado.txt",FILE_READ|FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_WRITE|FILE_TXT);
   int str_size=FileReadInteger(file_handle,INT_VALUE);
   string str=FileReadString(file_handle,int(str_size));
   FileClose(file_handle);

   return StringToTime(str);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              OnChartEvent(const int id,
                               const long &lparam,
                               const double &dparam,
                               const string &sparam)
  {
   if(id==CHARTEVENT_KEYDOWN)
     {
      if((int)lparam==KEY_DELETE)
        {
         Alert(arquivo_estatisticas+" foi deletado");
        }
     }
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string            ExibirResultadoParcialAoVivo()
  {
   ushort u_sep = StringGetCharacter(";",0);
   int str_size;
   string str="",str_tratada="";

   int file_handle=FileOpen(filename_sinais_ao_vivo,FILE_READ|FILE_SHARE_READ|FILE_TXT);
   while(!FileIsEnding(file_handle))
     {
      str_size=FileReadInteger(file_handle,INT_VALUE);
      str=FileReadString(file_handle,str_size);

      if(str!="")
        {
         string result[];
         StringSplit(str,u_sep,result);
         //Symbol(1-hour,2-operation,3-result);

         if(result[2]=="put")
            result[2] = "⬇️";
         else
            result[2] = "⬆️";

         if(result[3]=="win" || result[3]=="win#")
            str_tratada+="✅ → "+result[0]+" "+result[1]+" "+result[2]+"\n";
         if(result[3]=="wing1" || result[3]=="wing1#")
            str_tratada+="✅🐔1G → "+result[0]+" "+result[1]+" "+result[2]+"\n";
         if(result[3]=="wing2" || result[3]=="wing2#")
            str_tratada+="✅🐔🐔2G → "+result[0]+" "+result[1]+" "+result[2]+"\n";
         if(result[3]=="loss" || result[3]=="loss#")
            str_tratada+="☑️ → "+result[0]+" "+result[1]+" "+result[2]+"\n";
         if(result[3]=="lossg1" || result[3]=="lossg1#")
            str_tratada+="loss✅🐔G1 → "+result[0]+" "+result[1]+" "+result[2]+"\n";
         if(result[3]=="lossg2" || result[3]=="lossg2#")
            str_tratada+="loss✅🐔🐔G2 → "+result[0]+" "+result[1]+" "+result[2]+"\n";
        }
     }

   FileClose(file_handle);

   return str_tratada;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              filtro_value()
  {
//---escolhe melhor nivel do value
   int bars;
   int counted_bars = IndicatorCounted();
   static int pa_profile[];

   double vc_support_high = VC_Oversold;
   double vc_resistance_high = VC_Overbought;
   double vc_support_med = VC_SlightlyOversold;
   double vc_resistance_med = VC_SlightlyOverbought;

// The last counted bar is counted again
   if(counted_bars > 0)
     {
      counted_bars--;
     }

   bars = counted_bars;

   if(bars > BarrasAnalise && BarrasAnalise > 0)
     {
      bars = BarrasAnalise;
     }

   computes_value_chart(bars, VC_Period);

   VC_Overbought = vc_resistance_high;
   VC_SlightlyOverbought = vc_resistance_med;
   VC_SlightlyOversold = vc_support_med;
   VC_Oversold = vc_support_high;
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void              computes_value_chart(int bars, int period)
  {
   double sum;
   double floatingAxis;
   double volatilityUnit;

   for(int i = bars-1; i >= 0; i--)
     {
      datetime t = Time[i];
      int y = iBarShift(NULL, _Period, t);
      int z = iBarShift(NULL, 0, iTime(NULL, _Period, y));

      sum = 0;
      for(int k = y; k < y+VC_NumBars; k++)
        {
         sum += (iHigh(NULL, _Period, k) + iLow(NULL, _Period, k)) / 2.0;
        }
      floatingAxis = sum / VC_NumBars;
      sum = 0;
      for(int kp = y; kp < VC_NumBars + y; kp++)
        {
         sum += iHigh(NULL, _Period, kp) - iLow(NULL, _Period, kp);
        }
      volatilityUnit = 0;
      if(_Period == 1)
        {
         volatilityUnit = 0.2 * (sum / VC_NumBars);
        }
      if(_Period == 5)
        {
         volatilityUnit = 0.1 * (sum / VC_NumBars);
        }
      if(_Period == 15)
        {
         volatilityUnit = 0.1 * (sum / VC_NumBars);
        }

      if(volatilityUnit !=0)
        {
         vcHigh[i] = (iHigh(NULL, _Period, y) - floatingAxis) / volatilityUnit;
         vcLow[i] = (iLow(NULL, _Period, y) - floatingAxis) / volatilityUnit;
         vcOpen[i] = (iOpen(NULL, _Period, y) - floatingAxis) / volatilityUnit;
         vcClose[i] = (iClose(NULL, _Period, y) - floatingAxis) / volatilityUnit;
        }
      else
        {
         vcHigh[i] = 0;
         vcLow[i] = 0;
         vcOpen[i] = 0;
         vcClose[i] = 0;
        }
     }
  }
//============================================================================================================================================================
string            VolumeSerialNumber()
  {
   string res="";
   string RootPath=StringSubstr(TerminalInfoString(TERMINAL_COMMONDATA_PATH),0,1)+":\\";
   string VolumeName,SystemName;
   uint VolumeSerialNumber[1],Length=0,Flags=0;
   if(!GetVolumeInformationW(RootPath,VolumeName,StringLen(VolumeName),VolumeSerialNumber,Length,Flags,SystemName,StringLen(SystemName)))
     {
      res="XXXX-XXXX";
      ChartIndicatorDelete(0,0,"TaurusMagnumPro");
      Print("Failed to receive VSN !");
     }
   else
     {
      uint VSN=VolumeSerialNumber[0];
      if(VSN==0)
        {
         res="0";
         ChartIndicatorDelete(0,0,"TaurusMagnumPro");
         Print("Error: Receiving VSN may fail on Mac / Linux.");
        }
      else
        {
         res=StringFormat("%X",VSN);
         res=StringSubstr(res,0,4)+"-"+StringSubstr(res,4,8);
         Print("VSN successfully received.");
        }
     }
   return res;
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
bool              demo_f()
  {
//demo
   if(use_demo)
     {
      if(Time[0]>=StringToTime(ExpiryDate))
        {
         Alert(expir_msg);
         ChartIndicatorDelete(0,0,"TaurusMagnumPro");
         return(false);
        }
     }
   return(true);
  }
//============================================================================================================================================================
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool              acc_number_f()
  {
//acc_number
   if(use_acc_number)
     {
      if(AccountNumber()!=acc_number && AccountNumber()!=0)
        {
         Alert(acc_numb_msg);
         ChartIndicatorDelete(0,0,"TaurusMagnumPro");
         return(false);
        }
     }
   return(true);
  }
//============================================================================================================================================================

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
