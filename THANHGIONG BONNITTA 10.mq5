//+------------------------------------------------------------------+
//|                                      MRD ALL DAY.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "+84962533268 MrDoai"
#property link        "Telegramchanel: 84962533268,  Telegram, Zalo Group: 84962533268;"
#property version   "1.00"
#property strict
#property description "Strategists: MrDoai"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade trade;
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
//if(IsTesting()) GlobalVariablesDeleteAll();  

   }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
input double  D                  = 0.4;
input int     HS_LOT             = 5000;
input double  HS_D               = 1.3;
input int     TT_PS1             = 10;
input int     TT_PS2             = 20;
input int     TT_PS3             = 30;
input int     TT_PS4             = 40;
input int     TT_PS5             = 50;
input int     TT_PS6             = 60;
input int     TT_PS7             = 70;
input int     TT_PS8             = 80;
input int     TT_PS9             = 90;
input int     TT_PS10            = 100;
int           MA_M15_period_8    = 8;
int           MA_M15_period_13   = 13;
int           MA_M15_period_21   = 21;
int           MA_H1_period_8     = 8;
int           MA_H1_period_13    = 13;
int           MA_H1_period_21    = 21;
double        EquityEntry;
double        Ask,Bid;
datetime      Time_Current;
//---M5---//
int      getMA_M15_8, getMA_M15_13, getMA_M15_21;
double   arrayMA_M15_8[], arrayMA_M15_13[], arrayMA_M15_21[];
double   MA_M15_8_0,MA_M15_8_1, MA_M15_8_2,MA_M15_13_0,MA_M15_13_1, MA_M15_13_2,MA_M15_21_0,MA_M15_21_1, MA_M15_21_2; 
int      getMA_H1_8, getMA_H1_13, getMA_H1_21;
double   arrayMA_H1_8[], arrayMA_H1_13[], arrayMA_H1_21[];
double   MA_H1_8_0,MA_H1_8_1, MA_H1_8_2,MA_H1_13_0,MA_H1_13_1, MA_H1_13_2,MA_H1_21_0,MA_H1_21_1, MA_H1_21_2; 
datetime Entry;
double   KL_BUY_1       = 0.01;
double   KL_SELL_1      = 0.01;
double   KL_BUY_2       = 0.01;
double   KL_SELL_2      = 0.01;
double   KL_BUY_3       = 0.01;
double   KL_SELL_3      = 0.01;
double   KL_BUY_4       = 0.01;
double   KL_SELL_4      = 0.01;
double   KL_BUY_5       = 0.01;
double   KL_SELL_5      = 0.01;
double   KL_BUY_6       = 0.01;
double   KL_SELL_6      = 0.01;
double   KL_BUY_7       = 0.01;
double   KL_SELL_7      = 0.01;
double   KL_BUY_8       = 0.01;
double   KL_SELL_8      = 0.01;
double   KL_BUY_9       = 0.01;
double   KL_SELL_9      = 0.01;
double   KL_BUY_10      = 0.01;
double   KL_SELL_10     = 0.01;
bool     DongLenhBuy    = false;
bool     DongLenhSell   = false;
string EMAH1;
void OnTick()
  {
//---

   datetime TGHienTai = TimeCurrent(); 
   if(SumProfit("POSITION_TYPE_BUY")> EquityEntry*D*pow(100,-1))
      {  
         DongLenhBuy = true;
      }
   if(SumProfit("POSITION_TYPE_SELL")> EquityEntry*D*pow(100,-1))
      {  
         DongLenhSell = true;
      }
      
   
   if(DongLenhBuy == true)
      {CloseAllBuy();
      }
   if(DongLenhSell == true)
      {CloseAllSell();
      }
      
   if( Count_Position("OP_BUY") == 0
      && DongLenhBuy == true
      )
      {
         DongLenhBuy  = false;
      }
      
   if( Count_Position("OP_SELL") == 0
      && DongLenhSell == true
      )
      {
         DongLenhSell  = false;
      }

   Ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);  
   Bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
   double Spead = NormalizeDouble((Ask - Bid),3);
   // ChuanBi
   
   // --- EMA_M5 ---//
   string Signal_SMA_M5 = "";
   getMA_M15_8  = iMA(_Symbol,PERIOD_M15,MA_M15_period_8,0,MODE_EMA,PRICE_CLOSE);
   getMA_M15_13 = iMA(_Symbol,PERIOD_M15,MA_M15_period_13,0,MODE_EMA,PRICE_CLOSE);
   getMA_M15_21 = iMA(_Symbol,PERIOD_M15,MA_M15_period_21,0,MODE_EMA,PRICE_CLOSE);
   ArraySetAsSeries(arrayMA_M15_8,true);
   ArraySetAsSeries(arrayMA_M15_13,true);
   ArraySetAsSeries(arrayMA_M15_21,true);
   CopyBuffer(getMA_M15_8,0,0,5,arrayMA_M15_8);
   CopyBuffer(getMA_M15_13,0,0,5,arrayMA_M15_13);
   CopyBuffer(getMA_M15_21,0,0,5,arrayMA_M15_21);
   // LayGiaTri
   MA_M15_8_0 = NormalizeDouble(arrayMA_M15_8[0],_Digits);
   MA_M15_8_1 = NormalizeDouble(arrayMA_M15_8[1],_Digits);
   MA_M15_8_2 = NormalizeDouble(arrayMA_M15_8[2],_Digits);
   MA_M15_13_0 = NormalizeDouble(arrayMA_M15_13[0],_Digits);
   MA_M15_13_1 = NormalizeDouble(arrayMA_M15_13[1],_Digits);
   MA_M15_13_2 = NormalizeDouble(arrayMA_M15_13[2],_Digits);
   MA_M15_21_0 = NormalizeDouble(arrayMA_M15_21[0],_Digits);
   MA_M15_21_1 = NormalizeDouble(arrayMA_M15_21[1],_Digits); 
   MA_M15_21_2 = NormalizeDouble(arrayMA_M15_21[2],_Digits);
   
   if(MA_M15_8_1 > MA_M15_13_1 && MA_M15_13_1 > MA_M15_21_1)  Signal_SMA_M5 = "OP_BUY";
   if(MA_M15_8_1 < MA_M15_13_1 && MA_M15_13_1 < MA_M15_21_1)  Signal_SMA_M5 = "OP_SELL"; 
    
   // --- EMA_H1 ---//
   getMA_H1_8  = iMA(_Symbol,PERIOD_H1,MA_H1_period_8,0,MODE_EMA,PRICE_CLOSE);
   getMA_H1_13 = iMA(_Symbol,PERIOD_H1,MA_H1_period_13,0,MODE_EMA,PRICE_CLOSE);
   getMA_H1_21 = iMA(_Symbol,PERIOD_H1,MA_H1_period_21,0,MODE_EMA,PRICE_CLOSE);
   ArraySetAsSeries(arrayMA_H1_8,true);
   ArraySetAsSeries(arrayMA_H1_13,true);
   ArraySetAsSeries(arrayMA_H1_21,true);
   CopyBuffer(getMA_H1_8,0,0,5,arrayMA_H1_8);
   CopyBuffer(getMA_H1_13,0,0,5,arrayMA_H1_13);
   CopyBuffer(getMA_H1_21,0,0,5,arrayMA_H1_21);
   // LayGiaTri
   MA_H1_8_0 = NormalizeDouble(arrayMA_H1_8[0],_Digits);
   MA_H1_8_1 = NormalizeDouble(arrayMA_H1_8[1],_Digits);
   MA_H1_8_2 = NormalizeDouble(arrayMA_H1_8[2],_Digits);
   MA_H1_13_0 = NormalizeDouble(arrayMA_H1_13[0],_Digits);
   MA_H1_13_1 = NormalizeDouble(arrayMA_H1_13[1],_Digits);
   MA_H1_13_2 = NormalizeDouble(arrayMA_H1_13[2],_Digits);
   MA_H1_21_0 = NormalizeDouble(arrayMA_H1_21[0],_Digits);
   MA_H1_21_1 = NormalizeDouble(arrayMA_H1_21[1],_Digits); 
   MA_H1_21_2 = NormalizeDouble(arrayMA_H1_21[2],_Digits);

 //=========Lay gia tri NEN M15 ===========
 //---------Nen 1 ----------
   double GiaCao_Nen1_M15    = iHigh(_Symbol,PERIOD_M15,1);
   double GiaThap_Nen1_M15   = iLow(_Symbol,PERIOD_M15,1);
   double GiaMo_Nen1_M15     = iOpen(_Symbol,PERIOD_M15,1);
   double GiaDong_Nen1_M15   = iClose(_Symbol,PERIOD_M15,1);
   double ChieuDai_Nen1_M15  = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,1)-iLow(_Symbol,PERIOD_M15,1)),3);
   double Than_Nen1_M15      = NormalizeDouble(MathAbs(iOpen(_Symbol,PERIOD_M15,1)-iClose(_Symbol,PERIOD_M15,1)),3);
   double BongTren_Nen1_M15  = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,1)-MathMax(iOpen(_Symbol,PERIOD_M15,1), iClose(_Symbol,PERIOD_M15,1))),3);
   double BongDuoi_Nen1_M15  = NormalizeDouble((MathMin(iOpen(_Symbol,PERIOD_M15,1), iClose(_Symbol,PERIOD_M15,1))-iLow(_Symbol,PERIOD_M15,1)),3);
   double LucMua_Nen1_M15    = NormalizeDouble((iClose(_Symbol,PERIOD_M15,1)-iLow(_Symbol,PERIOD_M15,1)),3);
   double LucBan_Nen1_M15    = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,1)-iClose(_Symbol,PERIOD_M15,1)),3);
 //---------Nen 2 ----------
   double GiaCao_Nen2_M15    = iHigh(_Symbol,PERIOD_M15,2);
   double GiaThap_Nen2_M15   = iLow(_Symbol,PERIOD_M15,2);
   double GiaMo_Nen2_M15     = iOpen(_Symbol,PERIOD_M15,2);
   double GiaDong_Nen2_M15   = iClose(_Symbol,PERIOD_M15,2);
   double ChieuDai_Nen2_M15  = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,2)-iLow(_Symbol,PERIOD_M15,2)),3);
   double Than_Nen2_M15      = NormalizeDouble(MathAbs(iOpen(_Symbol,PERIOD_M15,2)-iClose(_Symbol,PERIOD_M15,2)),3);
   double BongTren_Nen2_M15  = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,2)-MathMax(iOpen(_Symbol,PERIOD_M15,2), iClose(_Symbol,PERIOD_M15,2))),3);
   double BongDuoi_Nen2_M15  = NormalizeDouble((MathMin(iOpen(_Symbol,PERIOD_M15,2), iClose(_Symbol,PERIOD_M15,2))-iLow(_Symbol,PERIOD_M15,2)),3);
   double LucMua_Nen2_M15    = NormalizeDouble((iClose(_Symbol,PERIOD_M15,2)-iLow(_Symbol,PERIOD_M15,2)),3);
   double LucBan_Nen2_M15    = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,2)-iClose(_Symbol,PERIOD_M15,2)),3);
 //---------Nen 3 ----------
   double GiaCao_Nen3_M15    = iHigh(_Symbol,PERIOD_M15,3);
   double GiaThap_Nen3_M15   = iLow(_Symbol,PERIOD_M15,3);
   double GiaMo_Nen3_M15     = iOpen(_Symbol,PERIOD_M15,3);
   double GiaDong_Nen3_M15   = iClose(_Symbol,PERIOD_M15,3);
   double ChieuDai_Nen3_M15  = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,3)-iLow(_Symbol,PERIOD_M15,3)),3);
   double Than_Nen3_M15      = NormalizeDouble(MathAbs(iOpen(_Symbol,PERIOD_M15,3)-iClose(_Symbol,PERIOD_M15,3)),3);
   double BongTren_Nen3_M15  = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,3)-MathMax(iOpen(_Symbol,PERIOD_M15,3), iClose(_Symbol,PERIOD_M15,3))),3);
   double BongDuoi_Nen3_M15  = NormalizeDouble((MathMin(iOpen(_Symbol,PERIOD_M15,3), iClose(_Symbol,PERIOD_M15,3))-iLow(_Symbol,PERIOD_M15,3)),3);
   double LucMua_Nen3_M15    = NormalizeDouble((iClose(_Symbol,PERIOD_M15,3)-iLow(_Symbol,PERIOD_M15,3)),3);
   double LucBan_Nen3_M15    = NormalizeDouble((iHigh(_Symbol,PERIOD_M15,3)-iClose(_Symbol,PERIOD_M15,3)),3);
   if(MA_H1_8_1 > MA_H1_21_1)  EMAH1 = "BUY";
   if(MA_H1_8_1 < MA_H1_21_1)  EMAH1 = "SELL";
   double EQ_Current = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
   double KL = NormalizeDouble(EQ_Current*0.01/HS_LOT,2);
   if( KL < 0.01) KL = 0.01;
   int Total_Buy = Count_Position("OP_BUY");
   int Total_Sell = Count_Position("OP_SELL");
   
double Profit_Buy  = SumProfit("POSITION_TYPE_BUY");
double Profit_Sell = SumProfit("POSITION_TYPE_SELL");
   Comment("Total_Buy = " + string(Total_Buy) + " : Total_Sell = " + string(Total_Sell)
   + "\n : Ask = " + string(Ask) + " : Bid = " + string(Bid)
   + "\n : Spead = " + string(Spead) + " : KL = " + string(KL)
   + "\n : TGHienTai = " + string(TGHienTai)  + " : EMAH1 = " + string(EMAH1)
   + "\n : DongLenhBuy = " + string(DongLenhBuy)+ " : DongLenhSell = " + string(DongLenhSell)
   + "\n : Profit_Buy = " + string(Profit_Buy)+ " : Profit_Sell = " + string(Profit_Sell) + " : EQ_Current = " + string(EQ_Current)
   );
// Entry F
    
      
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      && Count_Position("OP_BUY") == 0
      )
      {
         trade.Buy(KL,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_1 = KL;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      && Count_Position("OP_SELL") == 0
      
      )
      {
         trade.Sell(KL,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_1 = KL;
      }

// Entry 1
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= 1
      && Count_Position("OP_BUY") < TT_PS1
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_1,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_2 = NormalizeDouble((KL_BUY_1*HS_D),2);
         if( KL_BUY_2 < 0.01) KL_BUY_2 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= 1
      && Count_Position("OP_SELL") < TT_PS1
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_1,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_2 = NormalizeDouble((KL_SELL_1*HS_D),2);
         if( KL_SELL_2 < 0.01) KL_SELL_2 = 0.01;
      }
// Entry 2
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS1
      && Count_Position("OP_BUY") < TT_PS2
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_2,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_3 = NormalizeDouble((KL_BUY_2*HS_D),2);
         if( KL_BUY_3 < 0.01) KL_BUY_3 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS1
      && Count_Position("OP_SELL") < TT_PS2
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_2,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_3 = NormalizeDouble((KL_SELL_2*HS_D),2);
         if( KL_SELL_3 < 0.01) KL_SELL_3 = 0.01;
      }
// Entry 3
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS2
      && Count_Position("OP_BUY") < TT_PS3
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_3,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_4= NormalizeDouble((KL_BUY_3*HS_D),2);
         if( KL_BUY_4 < 0.01) KL_BUY_4 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS2
      && Count_Position("OP_SELL") < TT_PS3
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_3,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_4 = NormalizeDouble((KL_SELL_3*HS_D),2);
         if( KL_SELL_4 < 0.01) KL_SELL_4 = 0.01;
      }
// Entry 4
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS3
      && Count_Position("OP_BUY") < TT_PS4
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_4,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_5= NormalizeDouble((KL_BUY_4*HS_D),2);
         if( KL_BUY_5 < 0.01) KL_BUY_5 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS3
      && Count_Position("OP_SELL") < TT_PS4
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_4,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_5 = NormalizeDouble((KL_SELL_4*HS_D),2);
         if( KL_SELL_5 < 0.01) KL_SELL_5 = 0.01;
      }
// Entry 5
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS4
      && Count_Position("OP_BUY") < TT_PS5
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_5,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_6= NormalizeDouble((KL_BUY_5*HS_D),2);
         if( KL_BUY_6 < 0.01) KL_BUY_6 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS4
      && Count_Position("OP_SELL") < TT_PS5
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_5,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_6 = NormalizeDouble((KL_SELL_5*HS_D),2);
         if( KL_SELL_6 < 0.01) KL_SELL_6 = 0.01;
      }
// Entry 6
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS5
      && Count_Position("OP_BUY") < TT_PS6
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_6,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_7= NormalizeDouble((KL_BUY_6*HS_D),2);
         if( KL_BUY_7 < 0.01) KL_BUY_7 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS5
      && Count_Position("OP_SELL") < TT_PS6
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_6,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_7 = NormalizeDouble((KL_SELL_6*HS_D),2);
         if( KL_SELL_7 < 0.01) KL_SELL_7 = 0.01;
      }
// Entry 7
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS6
      && Count_Position("OP_BUY") < TT_PS7
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_7,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_8= NormalizeDouble((KL_BUY_7*HS_D),2);
         if( KL_BUY_8 < 0.01) KL_BUY_8 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS6
      && Count_Position("OP_SELL") < TT_PS7
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_7,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_8 = NormalizeDouble((KL_SELL_7*HS_D),2);
         if( KL_SELL_8 < 0.01) KL_SELL_8 = 0.01;
      }
// Entry 8
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS7
      && Count_Position("OP_BUY") < TT_PS8
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_8,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_9= NormalizeDouble((KL_BUY_8*HS_D),2);
         if( KL_BUY_9 < 0.01) KL_BUY_9 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS7
      && Count_Position("OP_SELL") < TT_PS8
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_8,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_9 = NormalizeDouble((KL_SELL_8*HS_D),2);
         if( KL_SELL_9 < 0.01) KL_SELL_9 = 0.01;
      }
// Entry 9
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS8
      && Count_Position("OP_BUY") <  TT_PS9
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_9,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_BUY_10 = NormalizeDouble((KL_BUY_9*HS_D),2);
         if( KL_BUY_10 < 0.01) KL_BUY_10 = 0.01;
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS8
      && Count_Position("OP_SELL") <  TT_PS9
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_9,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
         KL_SELL_10 = NormalizeDouble((KL_SELL_9*HS_D),2);
         if( KL_SELL_10 < 0.01) KL_SELL_10 = 0.01;
      }
// Entry 10
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && MA_H1_8_1 > MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      && Count_Position("OP_BUY") >= TT_PS9
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      )
      {
         trade.Buy(KL_BUY_10,Symbol(),Ask,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && MA_H1_8_1 < MA_H1_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      && Count_Position("OP_SELL") >= TT_PS9
      && TimeCurrent() >= Entry + 60*PERIOD_M15
      
      )
      {
         trade.Sell(KL_SELL_10,Symbol(),Bid,0,0,"MRTGM5");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Entry  = TimeCurrent();
      }
}
//+------------------------------------------------------------------+
string CheckColorCandle(string symbol, ENUM_TIMEFRAMES tf_candle, int shift )
{
   string ColorCandle = "";
   if(iOpen(symbol,tf_candle,shift) <= iClose(symbol,tf_candle,shift) )ColorCandle = "GREEN";
   else ColorCandle = "RED";
   return ColorCandle;
}
int Count_Position(string type)
{
    int count = 0;
    uint total=PositionsTotal();
    for(uint i=0; i < total; i++)
	 { 	
	   string position_symbol=PositionGetSymbol(i);
	   ENUM_POSITION_TYPE PositionType = ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
	   {
	      if(position_symbol == _Symbol)
	      {
	         if(type=="OP_BUY" && PositionType ==0)
	            count ++;
	         if(type=="OP_SELL" && PositionType==1)
	            count ++;
	         if(type=="OP_SELL_OP_BUY" && PositionType>-1 &&PositionType<2)
	            count ++;
	      }
	   }	
	}
   return count;
}

  
double SumProfit(string type)
{
    double sum = 0;
    uint total=PositionsTotal();// Tổng số lệnh của Mt5 đang có
    for(uint i=0; i < total; i++)// Đếm từ cái lệnh cũ nhất đến cái lệnh mới mở nhất
	 { 	
	   string position_symbol=PositionGetSymbol(i);
	   long PositionType = (PositionGetInteger(POSITION_TYPE));
	   {
	      if(position_symbol == _Symbol)// _Symbol thể hiện cái sản phẩm ngay chart robot đang tại vị
	      {
	         if(type=="POSITION_TYPE_BUY"  && PositionType   == POSITION_TYPE_BUY)
	            sum += PositionGetDouble(POSITION_PROFIT);
	         if(type=="POSITION_TYPE_SELL" && PositionType   == POSITION_TYPE_SELL)
	            sum += PositionGetDouble(POSITION_PROFIT);
	         if(type=="POSITION_TYPE_BUY_POSITION_TYPE_SELL" && PositionType>-1 &&PositionType<2)
	            sum += PositionGetDouble(POSITION_PROFIT);
	      }
	   }	
	}
   return sum;
}

void CloseAllBuy()
   {
   for(int i=PositionsTotal()-1; i >= 0; i--)
      {
          ulong ticket = PositionGetTicket(i);
          long PositionDirection = PositionGetInteger(POSITION_TYPE);
          if(PositionDirection == POSITION_TYPE_BUY)
          trade.PositionClose(ticket);
      } 
   }
void CloseAllSell()
   {
   for(int i=PositionsTotal()-1; i >= 0; i--)
      {
          ulong ticket = PositionGetTicket(i);
          long PositionDirection = PositionGetInteger(POSITION_TYPE);
          if(PositionDirection == POSITION_TYPE_SELL)
          trade.PositionClose(ticket);
      } 
   }