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
input double                 R      = 0.5; 
input double                 D      = 6.5; 
input int                    SL     = 200;
input int                    KC     = 15;
input int      KC_Trading           = 15;
input int      AD_POINT             = 3;
int            DiemStep             = 50;
int            MA_M15_period_8      = 8;
int            MA_M15_period_13     = 13;
int            MA_M15_period_21     = 21;
double EquityEntry;
double Ask,Bid;
datetime Day_Open;
datetime Day_Close;
datetime Time_Current;
bool RunAI = true;
double Price_Sell_F = 0;
double Price_Buy_F  = 0;
double Price_Sell_N = 0;
double Price_Buy_N  = 0;
//---M5---//
int getMA_M15_8, getMA_M15_13, getMA_M15_21;
double arrayMA_M15_8[], arrayMA_M15_13[], arrayMA_M15_21[];
double MA_M15_8_0,MA_M15_8_1, MA_M15_8_2,MA_M15_13_0,MA_M15_13_1, MA_M15_13_2,MA_M15_21_0,MA_M15_21_1, MA_M15_21_2; 
datetime Entry;
bool           Run_Trading       = false;
input int      Start_Time        = 1;
input int      End_Time          = 17;
double SLBuy_M15;
double SLSell_M15;
double SL_Entry_M15;
void OnTick()
  {
//---
   datetime TGHienTai = TimeCurrent(); 
   datetime ThoiGianMoNen_D1 = iTime(_Symbol,PERIOD_D1,0);
   datetime ThoiGianBatDau   = ThoiGianMoNen_D1 + Start_Time*60*PERIOD_H1;
   datetime ThoiGianKetThuc  = ThoiGianMoNen_D1 + End_Time*60*PERIOD_H1;
     if(   TGHienTai >= ThoiGianBatDau
        && TGHienTai <= ThoiGianKetThuc
         ) Run_Trading = true;
         else  Run_Trading = false;
  /*    
   if(SumProfit("POSITION_TYPE_SELL") + SumProfit("POSITION_TYPE_BUY")>= EquityEntry*D*pow(100,-1)
      //|| SumProfit("POSITION_TYPE_SELL") + SumProfit("POSITION_TYPE_BUY")<= - EquityEntry*A*pow(100,-1)
      )
      {CloseAllAll("POSITION_TYPE_BUY_POSITION_TYPE_SELL");
         Price_Sell_N = 0;      
         Price_Buy_N = 0;      
      }
*/
  // TrailingStopbyPoint(Trailing,Trailing,DiemStep);

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
 //=========Lay Stoploss THANH GIONG 1 ===========
      if(TimeCurrent() > 0)  
      {
      SLBuy_M15  = (iLow(_Symbol,PERIOD_M15,1) - Spead - AD_POINT*_Point);
      SLSell_M15 = (iHigh(_Symbol,PERIOD_M15,1)+ Spead + AD_POINT*_Point);
      }
  
TrailingSL(SL_Entry_M15, SLBuy_M15,  SLSell_M15, AD_POINT);
 //=========Trailling max ===========
   double Go_CDSL_Current_Buy  = NormalizeDouble((Ask - SL_Entry_M15),3);
   double Go_CDSL_Current_Sell = NormalizeDouble((SL_Entry_M15 - Bid),3);
   double GTSL_TG1_Buy_M5  = NormalizeDouble(MathAbs(Ask - SLBuy_M15),3);
   double GTSL_TG1_Sell_M5 = NormalizeDouble(MathAbs(SLSell_M15 - Bid),3);
   double KL_Buy  = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY)*R*pow(100,-1)*pow(GTSL_TG1_Buy_M5/_Point*SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE),-1),2);
   double KL_Sell = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY)*R*pow(100,-1)*pow(GTSL_TG1_Sell_M5/_Point*SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE),-1),2);
   Comment("GTSL_TG1_Buy_M5 = " + string(GTSL_TG1_Buy_M5) + " : GTSL_TG1_Sell_M5 = " + string(GTSL_TG1_Sell_M5)
   + "\n : Ask = " + string(Ask) + " : Bid = " + string(Bid)
   + "\n : Spead = " + string(Spead) + " : KL_Buy = " + string(KL_Buy) + " : KL_Sell = " + string(KL_Sell)
   + "\n : TGHienTai = " + string(TGHienTai) + " : Run_Trading = " + string(Run_Trading)
   );
   
   
   

// Entry
    
      
   if( 
         MA_M15_8_1 > MA_M15_13_1
      && MA_M15_13_1 > MA_M15_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "GREEN"
      && GiaMo_Nen1_M15 > MA_M15_8_1
      && Count_Position("OP_BUY") == 0
      && LucMua_Nen1_M15 > LucBan_Nen1_M15
      //&& Run_Trading == true
      && TimeCurrent() >= Entry + 60*KC_Trading
      )
      {
         trade.Buy(KL_Buy,Symbol(),Ask,SLBuy_M15,0,"MRTGM5");
         SL_Entry_M15 = (iLow(_Symbol,PERIOD_M15,1)-Spead - AD_POINT*_Point);
         Entry  = TimeCurrent();
      }
   if(
         MA_M15_8_1 < MA_M15_13_1
      && MA_M15_13_1 < MA_M15_21_1
      && CheckColorCandle(_Symbol,PERIOD_M15,1) == "RED"
      && GiaMo_Nen1_M15 < MA_M15_8_1
      && Count_Position("OP_SELL") == 0
      && LucMua_Nen1_M15 < LucBan_Nen1_M15
      //&& Run_Trading == true
      && TimeCurrent() >= Entry + 60*KC_Trading
      
      )
      {
         trade.Sell(KL_Sell,Symbol(),Bid,SLSell_M15,0,"MRTGM5");
         SL_Entry_M15 = (iHigh(_Symbol,PERIOD_M15,1)+ Spead + AD_POINT*_Point);
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

// TrailingStop
void TrailingStopbyPoint(int PointStart,int Pointtrailing, int Point_Step)// int magic)
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
                  && SymbolInfoDouble(_Symbol,SYMBOL_ASK)<PositionGetDouble (POSITION_SL)- (Pointtrailing + Point_Step) *_Point)
                 {trade.PositionModify(Position_Ticket,NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK) + Pointtrailing *_Point,_Digits),PositionGetDouble (POSITION_TP));
                 Sleep(86);
                 } 
              }
            if(PositionType == POSITION_TYPE_BUY)
              {
               if(SymbolInfoDouble(_Symbol,SYMBOL_BID)>PositionGetDouble (POSITION_PRICE_OPEN) + PointStart *_Point 
                     //+ (MathAbs(PositionGetDouble(POSITION_SWAP) + PositionGetDouble(POSITION_COMMISSION))*pow(PositionGetDouble (POSITION_VOLUME),-1))*_Point
                  && SymbolInfoDouble(_Symbol,SYMBOL_BID)>PositionGetDouble (POSITION_SL)+ (Pointtrailing + Point_Step) *_Point)
                 {trade.PositionModify(Position_Ticket,NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID) - Pointtrailing *_Point,_Digits),PositionGetDouble (POSITION_TP));
                 Sleep(86);
                 } 
              }
           }

        }
     }
  }
// CloseAllAll
void CloseAllAll(string type)
  {
   int Result = -1;
   uint total=PositionsTotal();
   for(uint i=0; i <= total; i++)
     {
      string PositionSymbol=PositionGetString(POSITION_SYMBOL);
      ENUM_POSITION_TYPE PositionType = ENUM_POSITION_TYPE(PositionGetInteger(POSITION_TYPE));
        {
         if(PositionSymbol ==_Symbol)
           {
            if(type == "POSITION_TYPE_BUY" && PositionType==0) 
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
            if(type == "POSITION_TYPE_SELL" && PositionType==1) 
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
            if(type == "POSITION_TYPE_BUY_POSITION_TYPE_SELL" && (PositionType<2 && PositionType>-1)) 
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
           }
           //if(PositionSymbol ==_Symbol)
           {
            if(type == "POSITION_TYPE_BUYAllSymbol" && PositionType==0) 
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
            if(type == "POSITION_TYPE_SELLAllSymbol" && PositionType==1) 
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
            if(type == "POSITION_TYPE_BUY_POSITION_TYPE_SELLAllSymbol" && (PositionType<2 && PositionType>-1)) 
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
           }
        }
     }
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
                 {trade.PositionModify(Position_Ticket,(iLow(_Symbol,PERIOD_M15,1)-Spead - KC_Point*_Point),0);
                 } 
              }
            if(PositionType == POSITION_TYPE_SELL)
              {
               if( SLOrder > SLCurrent_Sell )
                 {trade.PositionModify(Position_Ticket,(iHigh(_Symbol,PERIOD_M15,1)+ Spead + KC_Point*_Point),0);
                 } 
              }
           }

        }
     }
  }
  
  