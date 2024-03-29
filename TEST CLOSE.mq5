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
input double     D = 3.0;
bool DongLenhBuy   = false;
bool DongLenhSell  = false;
double EquityEntry;
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
      {CloseBuy("POSITION_TYPE_BUY");
      }
   if(DongLenhSell == true)
      {CloseSell("POSITION_TYPE_SELL");
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
	      }
	   }	
	}
   return sum;
}
// CloseBuy
void CloseBuy(string type)
  {
   int Result = -1;
   uint total=PositionsTotal();
   for(uint i=0; i <= total; i++)
     {
      string PositionSymbol=PositionGetString(POSITION_SYMBOL);
	   long PositionType = PositionGetInteger(POSITION_TYPE);
        {
         if(PositionSymbol ==_Symbol)
           {
            if(type == "POSITION_TYPE_BUY" && PositionType == POSITION_TYPE_BUY) 
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
           }
        }
     }
}
// CloseSell
void CloseSell(string type)
  {
   int Result = -1;
   uint total=PositionsTotal();
   for(uint i=0; i <= total; i++)
     {
      string PositionSymbol = PositionGetString(POSITION_SYMBOL);
	   long PositionType = PositionGetInteger(POSITION_TYPE);
        {
         if(PositionSymbol ==_Symbol)
           {
              if(type == "POSITION_TYPE_SELL" && PositionType == POSITION_TYPE_SELL)
              {
               if(!trade.PositionClose(PositionGetTicket(i),-1))
               Print("OrderClose has been ended with an error #",GetLastError());
              }
           }
         
        }
     }
}

void Closeall_BUYSELL(int type , int magci)
{
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
        ulong tkbuf=PositionGetTicket(i);
        if(tkbuf>0)
        {
           long pmg = PositionGetInteger(POSITION_MAGIC);
           long typ = PositionGetInteger(POSITION_TYPE);
           string position_symbol=PositionGetSymbol(i);
           if(pmg == magci  && typ==type  && position_symbol==_Symbol )
           {
              m_trade.PositionClose(tkbuf);
           }
        }
     }
     
}