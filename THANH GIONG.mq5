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
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
input double      R                 = 0.5; 
input int         KC_Trading        = 5;
input int         AD_POINT          = 30;
input double         HS_SLMAX       = 3.6;
input int         AD_POINT_Max      = 300;
input int         Modify_PointStart        = 2000;
input int         Modify_Pointtrailing     = 100;
double            SL_Entry_M5;
datetime          Entry;
double Ask,Bid;
double SLBuy_TG1_M5;
double SLSell_TG1_M5;
double CD_SLOder_M5 = 1000;
datetime Day_Open;
datetime Day_Close;
datetime Time_Current;
bool RunAI = true;
//---M5---//



void OnTick()
  {
//---

      


   Ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);  
   Bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
   // ChuanBi
 //=========Lay gia tri NEN M15 ===========
 //---------Nen 1 ----------
   double GiaCao_Nen1_M5    = iHigh(_Symbol,PERIOD_M5,1);
   double GiaThap_Nen1_M5   = iLow(_Symbol,PERIOD_M5,1);
   double GiaMo_Nen1_M5     = iOpen(_Symbol,PERIOD_M5,1);
   double GiaDong_Nen1_M5   = iClose(_Symbol,PERIOD_M5,1);
   double ChieuDai_Nen1_M5  = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,1)-iLow(_Symbol,PERIOD_M5,1)),3);
   double Than_Nen1_M5      = NormalizeDouble(MathAbs(iOpen(_Symbol,PERIOD_M5,1)-iClose(_Symbol,PERIOD_M5,1)),3);
   double BongTren_Nen1_M5  = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,1)-MathMax(iOpen(_Symbol,PERIOD_M5,1), iClose(_Symbol,PERIOD_M5,1))),3);
   double BongDuoi_Nen1_M5  = NormalizeDouble((MathMin(iOpen(_Symbol,PERIOD_M5,1), iClose(_Symbol,PERIOD_M5,1))-iLow(_Symbol,PERIOD_M5,1)),3);
   double LucMua_Nen1_M5    = NormalizeDouble((iClose(_Symbol,PERIOD_M5,1)-iLow(_Symbol,PERIOD_M5,1)),3);
   double LucBan_Nen1_M5    = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,1)-iClose(_Symbol,PERIOD_M5,1)),3);
 //---------Nen 2 ----------
   double GiaCao_Nen2_M5    = iHigh(_Symbol,PERIOD_M5,2);
   double GiaThap_Nen2_M5   = iLow(_Symbol,PERIOD_M5,2);
   double GiaMo_Nen2_M5     = iOpen(_Symbol,PERIOD_M5,2);
   double GiaDong_Nen2_M5   = iClose(_Symbol,PERIOD_M5,2);
   double ChieuDai_Nen2_M5  = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,2)-iLow(_Symbol,PERIOD_M5,2)),3);
   double Than_Nen2_M5      = NormalizeDouble(MathAbs(iOpen(_Symbol,PERIOD_M5,2)-iClose(_Symbol,PERIOD_M5,2)),3);
   double BongTren_Nen2_M5  = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,2)-MathMax(iOpen(_Symbol,PERIOD_M5,2), iClose(_Symbol,PERIOD_M5,2))),3);
   double BongDuoi_Nen2_M5  = NormalizeDouble((MathMin(iOpen(_Symbol,PERIOD_M5,2), iClose(_Symbol,PERIOD_M5,2))-iLow(_Symbol,PERIOD_M5,2)),3);
   double LucMua_Nen2_M5    = NormalizeDouble((iClose(_Symbol,PERIOD_M5,2)-iLow(_Symbol,PERIOD_M5,2)),3);
   double LucBan_Nen2_M5    = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,2)-iClose(_Symbol,PERIOD_M5,2)),3);
 //---------Nen 3 ----------
   double GiaCao_Nen3_M5    = iHigh(_Symbol,PERIOD_M5,3);
   double GiaThap_Nen3_M5   = iLow(_Symbol,PERIOD_M5,3);
   double GiaMo_Nen3_M5     = iOpen(_Symbol,PERIOD_M5,3);
   double GiaDong_Nen3_M5   = iClose(_Symbol,PERIOD_M5,3);
   double ChieuDai_Nen3_M5  = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,3)-iLow(_Symbol,PERIOD_M5,3)),3);
   double Than_Nen3_M5      = NormalizeDouble(MathAbs(iOpen(_Symbol,PERIOD_M5,3)-iClose(_Symbol,PERIOD_M5,3)),3);
   double BongTren_Nen3_M5  = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,3)-MathMax(iOpen(_Symbol,PERIOD_M5,3), iClose(_Symbol,PERIOD_M5,3))),3);
   double BongDuoi_Nen3_M5  = NormalizeDouble((MathMin(iOpen(_Symbol,PERIOD_M5,3), iClose(_Symbol,PERIOD_M5,3))-iLow(_Symbol,PERIOD_M5,3)),3);
   double LucMua_Nen3_M5    = NormalizeDouble((iClose(_Symbol,PERIOD_M5,3)-iLow(_Symbol,PERIOD_M5,3)),3);
   double LucBan_Nen3_M5    = NormalizeDouble((iHigh(_Symbol,PERIOD_M5,3)-iClose(_Symbol,PERIOD_M5,3)),3);

   double Spead = NormalizeDouble((Ask - Bid),3);
 //=========Lay Stoploss THANH GIONG 1 ===========
      if(TimeCurrent() > 0)  
      {
      SLBuy_TG1_M5  = (iLow(_Symbol,PERIOD_M5,1) - Spead - AD_POINT*_Point);
      SLSell_TG1_M5 = (iHigh(_Symbol,PERIOD_M5,1)+ Spead + AD_POINT*_Point);
      }
  
TrailingSL(SL_Entry_M5, SLBuy_TG1_M5,  SLSell_TG1_M5, AD_POINT);
TrailingStopbyPoint( Modify_PointStart, Modify_Pointtrailing);

 //=========Trailling max ===========
   double Go_CDSL_Current_Buy  = NormalizeDouble((Ask - SL_Entry_M5),3);
   double Go_CDSL_Current_Sell = NormalizeDouble((SL_Entry_M5 - Bid),3);
//TrailingTP(CD_SLOder_M5,Go_CDSL_Current_Buy, Go_CDSL_Current_Sell, HS_SLMAX, AD_POINT_Max);
   double GTSL_TG1_Buy_M5  = NormalizeDouble(MathAbs(Ask - SLBuy_TG1_M5),3);
   double GTSL_TG1_Sell_M5 = NormalizeDouble(MathAbs(SLSell_TG1_M5 - Bid),3);
   double KL_Buy  = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY)*R*pow(100,-1)*pow(GTSL_TG1_Buy_M5/_Point*SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE),-1),2);
   double KL_Sell = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY)*R*pow(100,-1)*pow(GTSL_TG1_Sell_M5/_Point*SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE),-1),2);
   Comment("GTSL_TG1_Buy_M5 = " + string(GTSL_TG1_Buy_M5) + " : GTSL_TG1_Sell_M5 = " + string(GTSL_TG1_Sell_M5)
   + "\n : Ask = " + string(Ask) + " : Bid = " + string(Bid)
   + "\n : Spead = " + string(Spead) + " : KL_Buy = " + string(KL_Buy) + " : KL_Sell = " + string(KL_Sell)
   );
// Entry M5
   if(
         Count_Position("OP_BUY") == 0
         && Count_Position("OP_SELL") == 0
         && CheckColorCandle(_Symbol,PERIOD_M5,3) == "RED"
         && CheckColorCandle(_Symbol,PERIOD_M5,2) == "GREEN"
         && CheckColorCandle(_Symbol,PERIOD_M5,1) == "GREEN"
         && GiaDong_Nen1_M5 > GiaMo_Nen3_M5
         && TimeCurrent() >= Entry + 60*KC_Trading
      )
      {
         trade.Buy(KL_Buy,Symbol(),Ask,SLBuy_TG1_M5,0,"MRTGM5");
         SL_Entry_M5 = (iLow(_Symbol,PERIOD_M5,1)-Spead - AD_POINT*_Point);
         Entry  = TimeCurrent();
         CD_SLOder_M5  = NormalizeDouble(MathAbs(Ask - SL_Entry_M5),3);
      }

   if(
   
         Count_Position("OP_SELL") == 0
         && Count_Position("OP_BUY") == 0
         && CheckColorCandle(_Symbol,PERIOD_M5,3) == "GREEN"
         && CheckColorCandle(_Symbol,PERIOD_M5,2) == "RED"
         && CheckColorCandle(_Symbol,PERIOD_M5,1) == "RED"
         && GiaDong_Nen1_M5 < GiaMo_Nen3_M5
         && TimeCurrent() >= Entry + 60*KC_Trading
      )
      {
         trade.Sell(KL_Sell,Symbol(),Bid,SLSell_TG1_M5,0,"MRTGM5");
         SL_Entry_M5 = (iHigh(_Symbol,PERIOD_M15,1)+ Spead + AD_POINT*_Point);
         Entry  = TimeCurrent();
         CD_SLOder_M5  = NormalizeDouble(MathAbs(SL_Entry_M5 - Bid),3);

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

int Count_Orders(string type)
{
   int count = 0;
   for(int i= OrdersTotal() - 1; i >= 0 ; i--)
     {
      long OrderType = OrderGetInteger(ORDER_TYPE);
      if(OrderSelect(OrderGetTicket(i)))
        {
         string _symbol = OrderGetString(ORDER_SYMBOL);
         if(_symbol == _Symbol)
           {
            if(type=="ORDER_TYPE_BUY" && OrderType==ORDER_TYPE_BUY)
               count ++;
            if(type=="ORDER_TYPE_SELL" && OrderType==ORDER_TYPE_SELL)
               count ++;
            if(type=="AllLimitStop" && OrderType>1)
               count ++;
            if(type=="ORDER_TYPE_BUY_LIMIT" && OrderType==ORDER_TYPE_BUY_LIMIT)
               count ++;
            if(type=="ORDER_TYPE_SELL_LIMIT" && OrderType==ORDER_TYPE_SELL_LIMIT)
               count ++;
            if(type=="ORDER_TYPE_BUY_STOP" && OrderType==ORDER_TYPE_BUY_STOP)
               count ++;
            if(type=="ORDER_TYPE_SELL_STOP" && OrderType==ORDER_TYPE_SELL_STOP)
               count ++;
            if(type=="ORDER_TYPE_BUY_ORDER_TYPE_SELL" && (OrderType==ORDER_TYPE_BUY || OrderType==ORDER_TYPE_SELL))
               count ++;
            if(type=="ORDER_TYPE_BUY_STOP_LIMIT" && OrderType==ORDER_TYPE_BUY_STOP_LIMIT)
               count ++;
            if(type=="ORDER_TYPE_SELL_STOP_LIMIT" && OrderType==ORDER_TYPE_SELL_STOP_LIMIT)
               count ++;
           }
        }
     }
   return count;
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

// TrailingSL
void TrailingSL(double SLOrder,double SLCurrent_Buy, double SLCurrent_Sell, int KC_Point)
  {
   double Spead = NormalizeDouble((SymbolInfoDouble(Symbol(),SYMBOL_ASK) - SymbolInfoDouble(Symbol(),SYMBOL_BID)),3);
   uint total=PositionsTotal();
   for(uint i=0; i < total; i++)
     {
      string position_symbol = PositionGetSymbol(POSITION_SYMBOL);
      ulong Position_Ticket  = PositionGetTicket(i);
      ENUM_POSITION_TYPE PositionType = ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
        {
         if(position_symbol == _Symbol)
         {
            if(PositionType == POSITION_TYPE_BUY)
              {
            if(SLOrder < SLCurrent_Buy )
                 {trade.PositionModify(Position_Ticket,(iLow(_Symbol,PERIOD_M5,1)-Spead - KC_Point*_Point),0);
                 } 
              }
            if(PositionType == POSITION_TYPE_SELL)
              {
               if( SLOrder > SLCurrent_Sell )
                 {trade.PositionModify(Position_Ticket,(iHigh(_Symbol,PERIOD_M5,1)+ Spead + KC_Point*_Point),0);
                 } 
              }
           }

        }
     }
  }
// Trailing SL Max
void TrailingTP(double CDSL_Order,double CDSL_Current_Buy, double CDSL_Current_Sell, double HS_SL, int KC_Point)
  {
   double Spead = NormalizeDouble((SymbolInfoDouble(Symbol(),SYMBOL_ASK) - SymbolInfoDouble(Symbol(),SYMBOL_BID)),3);
   double SL_Modify_Buy = 0.0000005;
   double SL_Modify_Sell = 500000;
   //double SL_Modify_Buy;
   uint total=PositionsTotal();
   for(uint i=0; i < total; i++)
     {
      string position_symbol = PositionGetSymbol(POSITION_SYMBOL);
      ulong Position_Ticket  = PositionGetTicket(i);
      ENUM_POSITION_TYPE PositionType = ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
        {
         if(position_symbol == _Symbol)
         {
            if(PositionType == POSITION_TYPE_BUY)
              {
            if( CDSL_Current_Buy > CDSL_Order*HS_SL
              && (SymbolInfoDouble(Symbol(),SYMBOL_ASK) - KC_Point*_Point) > SL_Modify_Buy
              )
                 {trade.PositionModify(Position_Ticket,(SymbolInfoDouble(Symbol(),SYMBOL_ASK) - KC_Point*_Point),0);
                  SL_Modify_Buy = SymbolInfoDouble(Symbol(),SYMBOL_ASK) - KC_Point*_Point;

                 } 
              }
            if(PositionType == POSITION_TYPE_SELL)
              {
               if( CDSL_Current_Sell > CDSL_Order*HS_SL 
              && (SymbolInfoDouble(Symbol(),SYMBOL_BID)+ KC_Point*_Point) < SL_Modify_Sell
                  )
                 {trade.PositionModify(Position_Ticket,(SymbolInfoDouble(Symbol(),SYMBOL_BID)+ KC_Point*_Point),0);
                   SL_Modify_Sell = SymbolInfoDouble(Symbol(),SYMBOL_BID)+ KC_Point*_Point;

                 } 
              }
           }

        }
     }
  }
void TrailingStopbyPoint(int PointStart,int Pointtrailing)
  {
   uint total=PositionsTotal();
   for(uint i=0; i < total; i++)
     {
      string position_symbol=PositionGetSymbol(POSITION_SYMBOL);
      ulong Position_Ticket    = PositionGetTicket(i);
      ENUM_POSITION_TYPE PositionType = ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
        {
         if(position_symbol == _Symbol)// && PositionGetInteger(POSITION_MAGIC)==magic)
         {
            if(PositionType == POSITION_TYPE_SELL)
              {
               double Create_sl = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK)+100*PointStart *_Point,_Digits);
               if(PositionGetDouble (POSITION_SL)== 0)
                  {trade.PositionModify(Position_Ticket,Create_sl,PositionGetDouble (POSITION_TP));} 
               if(SymbolInfoDouble(_Symbol,SYMBOL_ASK)<PositionGetDouble (POSITION_PRICE_OPEN) - PointStart *_Point 
                     //- (MathAbs(PositionGetDouble(POSITION_SWAP) + PositionGetDouble(POSITION_COMMISSION))*pow(PositionGetDouble (POSITION_VOLUME),-1))*_Point
                  && SymbolInfoDouble(_Symbol,SYMBOL_ASK)<PositionGetDouble (POSITION_SL)- Pointtrailing*_Point)
                 {trade.PositionModify(Position_Ticket,NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK) + Pointtrailing *_Point,_Digits),PositionGetDouble (POSITION_TP));
                 Sleep(86);
                 } 
              }
            if(PositionType == POSITION_TYPE_BUY)
              {
               if(SymbolInfoDouble(_Symbol,SYMBOL_BID)>PositionGetDouble (POSITION_PRICE_OPEN) + PointStart *_Point 
                     //+ (MathAbs(PositionGetDouble(POSITION_SWAP) + PositionGetDouble(POSITION_COMMISSION))*pow(PositionGetDouble (POSITION_VOLUME),-1))*_Point
                  && SymbolInfoDouble(_Symbol,SYMBOL_BID)>PositionGetDouble (POSITION_SL)+ Pointtrailing*_Point)
                 {trade.PositionModify(Position_Ticket,NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID) - Pointtrailing *_Point,_Digits),PositionGetDouble (POSITION_TP));
                 Sleep(86);
                 } 
              }
           }

        }
     }
  }
  
  