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
input double                 R      = 0.95; 
input double                 D      = 6.5; 
input int                    SL     = 200;
input int                    KC     = 15;
int            DiemStep             = 50;
int            MA_M5_period_5       = 5;
int            MA_M5_period_14      = 14;
input int      MA_M5_period_Gold    = 40;
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
int getMA_M5_Xanh, getMA_M5_Do, getMA_M5_Gold;
double arrayMA_M5_Xanh[], arrayMA_M5_Do[], arrayMA_M5_Gold[];
double MA_M5_Xanh_0,MA_M5_Xanh_1, MA_M5_Xanh_2,MA_M5_Do_0,MA_M5_Do_1, MA_M5_Do_2,MA_M5_Gold_0,MA_M5_Gold_1, MA_M5_Gold_2; 



void OnTick()
  {
//---

      
   if(SumProfit("POSITION_TYPE_SELL") + SumProfit("POSITION_TYPE_BUY")>= EquityEntry*D*pow(100,-1)
      //|| SumProfit("POSITION_TYPE_SELL") + SumProfit("POSITION_TYPE_BUY")<= - EquityEntry*A*pow(100,-1)
      )
      {CloseAllAll("POSITION_TYPE_BUY_POSITION_TYPE_SELL");
         Price_Sell_N = 0;      
         Price_Buy_N = 0;      
      }

  // TrailingStopbyPoint(Trailing,Trailing,DiemStep);

   Ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);  
   Bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);

   // ChuanBi
   
   
   // --- EMA_M5 ---//
   string Signal_SMA_M5 = "";
   getMA_M5_Xanh = iMA(_Symbol,PERIOD_M5,MA_M5_period_5,0,MODE_EMA,PRICE_CLOSE);
   getMA_M5_Do = iMA(_Symbol,PERIOD_M5,MA_M5_period_14,0,MODE_EMA,PRICE_CLOSE);
   getMA_M5_Gold = iMA(_Symbol,PERIOD_M5,MA_M5_period_Gold,0,MODE_EMA,PRICE_CLOSE);
   ArraySetAsSeries(arrayMA_M5_Xanh,true);
   ArraySetAsSeries(arrayMA_M5_Do,true);
   ArraySetAsSeries(arrayMA_M5_Gold,true);
   CopyBuffer(getMA_M5_Xanh,0,0,5,arrayMA_M5_Xanh);
   CopyBuffer(getMA_M5_Do,0,0,5,arrayMA_M5_Do);
   CopyBuffer(getMA_M5_Gold,0,0,5,arrayMA_M5_Gold);
   // LayGiaTri
   MA_M5_Xanh_0 = NormalizeDouble(arrayMA_M5_Xanh[0],_Digits);
   MA_M5_Xanh_1 = NormalizeDouble(arrayMA_M5_Xanh[1],_Digits);
   MA_M5_Xanh_2 = NormalizeDouble(arrayMA_M5_Xanh[2],_Digits);
   MA_M5_Do_0 = NormalizeDouble(arrayMA_M5_Do[0],_Digits);
   MA_M5_Do_1 = NormalizeDouble(arrayMA_M5_Do[1],_Digits);
   MA_M5_Do_2 = NormalizeDouble(arrayMA_M5_Do[2],_Digits);
   MA_M5_Gold_0 = NormalizeDouble(arrayMA_M5_Gold[0],_Digits);
   MA_M5_Gold_1 = NormalizeDouble(arrayMA_M5_Gold[1],_Digits); 
   MA_M5_Gold_2 = NormalizeDouble(arrayMA_M5_Gold[2],_Digits);
   
   if(MA_M5_Xanh_2 > MA_M5_Do_2 && MA_M5_Xanh_1 < MA_M5_Do_1)  Signal_SMA_M5 = "OP_SELL";
   if(MA_M5_Xanh_2 < MA_M5_Do_2 && MA_M5_Xanh_1 > MA_M5_Do_1)  Signal_SMA_M5 = "OP_BUY";  
   
   Comment("MA_M5_Xanh_1 = " + string(MA_M5_Xanh_1) + " : MA_M5_Do_1 = " + string(MA_M5_Do_1) + " : MA_M5_Gold_1 = " + string(MA_M5_Gold_1));
   
   
   
   
   
   
   
   
     if(Count_Position("OP_SELL") == 1)  Price_Sell_N = 1000000;
         double KL = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY)*R*pow(100,-1)*pow(SL*SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE),-1),2);
// Entry Firt
   if(//RunAI == true
   
      Signal_SMA_M5 == "OP_SELL"
      && Count_Position("OP_SELL") == 0
      && MA_M5_Xanh_1 < MA_M5_Gold_1
      && MA_M5_Do_1 < MA_M5_Gold_1
      
      )
      {
         trade.Sell(KL,Symbol(),Bid,0,0,"MrDoai_Sell_Firt");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Price_Sell_F = Bid;
      }
    
      
   if( //RunAI == true
      Signal_SMA_M5 == "OP_BUY"
      && Count_Position("OP_BUY") == 0
      && MA_M5_Xanh_1 > MA_M5_Gold_1
      && MA_M5_Do_1 > MA_M5_Gold_1
      )
      {
         trade.Buy(KL,Symbol(),Ask,0,0,"MrDoai_Buy_Firt");
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Price_Buy_F = Ask;
      }
// Entry n
   if(//RunAI == true
      Count_Position("OP_SELL") >= 1
      && Bid <= Price_Sell_F - KC*_Point
      && Bid <= Price_Sell_N - KC*_Point
      )
      {
         trade.Sell(KL,Symbol(),Bid,0,0,"MrDoai_Sell_N");
         //TimeEntry = TimeCurrent();
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Price_Sell_N = Bid;
      }
    
      
   if( //RunAI == true
      Count_Position("OP_BUY") >= 1
      && Ask >= Price_Buy_F + KC*_Point
      && Ask >= Price_Buy_N + KC*_Point
      )
      {
         trade.Buy(KL,Symbol(),Ask,0,0,"MrDoai_Buy_N");
         //TimeEntry = TimeCurrent();
         EquityEntry = NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY),_Digits);
         Price_Buy_N= Ask;
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
  
  
  