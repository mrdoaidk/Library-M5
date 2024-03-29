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
input double  Lots               = 0.01;
input double  R                  = 2.0;
input int     OrderDistPoints    = 200;

input int     TpPoints           = 200;
input int     SlPoints           = 200;
input int     TslPoints          = 5;
input int     TslTriggerPoints   = 10;
input ENUM_TIMEFRAMES  Timeframe = PERIOD_H1;
input int     BarsN = 5;
input int     ExpirationHours = 50;
input int     Magic = 286;
ulong buyPos, sellPos;
int totalBars;

int OnInit()
  {
//---
   trade.SetExpertMagicNumber(Magic);   
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


void OnTick()
  {
//---
   processPos(buyPos);
   processPos(sellPos);

   int bars = iBars(_Symbol,Timeframe);
   if(totalBars != bars)
   {
      totalBars = bars;
      if(buyPos > 0 && !PositionSelectByTicket(buyPos) && !OrderSelect(buyPos))
         {
            buyPos = 0;
         }
      if(sellPos > 0 && !PositionSelectByTicket(sellPos) && !OrderSelect(sellPos))
         {
            sellPos = 0;
         }

      if(buyPos <= 0)
         {
            double high = findHigh();
            if(high > 0)
               {
                  executeBuy(high);
               }
         }
      
      if(sellPos <= 0)
         {
            double low = findLow();
            if(low > 0)
               {
                  executeSell(low);
               }
         }
      
   }
   
 
   Comment(findHigh(), " ",findLow()
   );
}
//End OnTick
double calclots(double slPoints)
{
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*R/100;
   double ticksize = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double tickvalue = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double lotstep = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double moneyPerLotstep = slPoints/ticksize*tickvalue*lotstep;
   
   double lots = MathFloor(risk/moneyPerLotstep)*lotstep;
   lots = MathMin(lots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX));
   lots = MathMax(lots,SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));
   
   return lots;
}
void  OnTradeTransaction( 
   const MqlTradeTransaction&    trans,     // trade transaction structure 
   const MqlTradeRequest&        request,   // request structure 
   const MqlTradeResult&         result     // response structure 
   )
   {
    if( trans.type == TRADE_TRANSACTION_ORDER_ADD ) 
    {
      COrderInfo order;
      if(order.Select(trans.order))
        {
         if(order.Magic() == Magic)
            {
               if(order.OrderType() == ORDER_TYPE_BUY_STOP)
                  {
                   buyPos = order.Ticket();
                  }
                  else if(order.OrderType() == ORDER_TYPE_SELL_STOP)
                        {
                         sellPos = order.Ticket();
                        }

            }
         
        }
    }
   }
void processPos(ulong &posTicket)
{
   if( posTicket <= 0 ) return;
   if( OrderSelect(posTicket)) return;
   CPositionInfo pos;
   if(!pos.SelectByTicket(posTicket))
      { 
         posTicket = 0;
         return;
      }
      else
      {
         if(pos.PositionType() == POSITION_TYPE_BUY)
            {
             double bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
             if(bid > pos.PriceOpen() + TslTriggerPoints*_Point)
                {
                 double sl = bid -TslPoints*_Point;
                        sl = NormalizeDouble(sl,_Digits);
                if( sl > pos.StopLoss())
                  {
                     trade.PositionModify(pos.Ticket(),sl,pos.TakeProfit());
                  }
                }
            }
          else if(pos.PositionType() == POSITION_TYPE_SELL)   
                  {
                   double ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
                   if(ask < pos.PriceOpen() - TslTriggerPoints*_Point)
                      {
                       double sl = ask +TslPoints*_Point;
                              sl = NormalizeDouble(sl,_Digits);
                      if( sl < pos.StopLoss() || pos.StopLoss() == 0)
                        {
                           trade.PositionModify(pos.Ticket(),sl,pos.TakeProfit());
                        }
                      }
                  }
      
      }


}



void executeBuy(double entry)
   {
         entry  = NormalizeDouble(entry,_Digits);
         double ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
         if(ask > entry - OrderDistPoints*_Point) return;
         
         double tp = entry + TpPoints*_Point;
         tp     = NormalizeDouble(tp,_Digits);
         double sl = entry - SlPoints*_Point;
         sl     = NormalizeDouble(sl,_Digits);
         
         double lots = Lots;
         if(R > 0) lots = calclots(entry-sl);
         
         datetime expiration = iTime(_Symbol,Timeframe,0) + ExpirationHours*PeriodSeconds(PERIOD_H1);
         trade.BuyStop(lots,entry,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,expiration);
         buyPos =  trade.ResultOrder();    
   }
void executeSell(double entry)
   {
         entry  = NormalizeDouble(entry,_Digits);
         
         double bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
         if(bid < entry + OrderDistPoints*_Point) return;
         
         double tp = entry - TpPoints*_Point;
         tp     = NormalizeDouble(tp,_Digits);
         double sl = entry + SlPoints*_Point;
         sl     = NormalizeDouble(sl,_Digits);
         
         double lots = Lots;
         if(R > 0) lots = calclots(sl-entry);
         
         datetime expiration = iTime(_Symbol,Timeframe,0) + ExpirationHours*PeriodSeconds(PERIOD_H1);
         trade.SellStop(lots,entry,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,expiration);
         sellPos =  trade.ResultOrder();    
   }
double findHigh()
{
   double highestHigh = 0;
    for(int i=0; i < 200; i++)
   {
         double high = iHigh(_Symbol,Timeframe,i);
         if(i > BarsN && iHighest(_Symbol,Timeframe,MODE_HIGH,BarsN*2+1,i-5) == i)
         {
            if(high > highestHigh)
            {
            return high;
            }
         }
         highestHigh = MathMax(high,highestHigh);
   }
    return -1;
   
}

double findLow()
{
   double lowestLow = DBL_MAX;
    for(int i=0; i < 200; i++)
   {
         double low = iLow(_Symbol,Timeframe,i);
         if(i > BarsN && iLowest(_Symbol,Timeframe,MODE_LOW,BarsN*2+1,i-5) == i)
         {
            if(low < lowestLow)
            {
            return low;
            }
         }
         lowestLow = MathMin(low,lowestLow);
   }
    return -1;
   
}

