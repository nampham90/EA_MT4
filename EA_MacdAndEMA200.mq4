//+------------------------------------------------------------------+
//|                                             EA_MacdAndEMA200.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Library.mqh>

input int Magic=9999;
void OnTick()
  {
//---
     double EMA200=iMA(Symbol(),PERIOD_M30,200,0,MODE_EMA,PRICE_CLOSE,1);
    
     
     double MainMACD1=iMACD(Symbol(),PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
     double SigleMACD1=iMACD(Symbol(),PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
     
     double MainMACD2=iMACD(Symbol(),PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_MAIN,2);
     double SigleMACD2=iMACD(Symbol(),PERIOD_M30,12,26,9,PRICE_CLOSE,MODE_SIGNAL,2);
     
     if(iClose(Symbol(),PERIOD_M30,1)>EMA200 && MainMACD1<0){
         if(MainMACD1>SigleMACD1 && MainMACD2<SigleMACD2){
            int giatrithapnhat=iLowest(Symbol(),PERIOD_M30,MODE_HIGH,5,1);
            double giacaynenthapnhat=iLow(Symbol(),PERIOD_M30,giatrithapnhat);
            double sl=(giacaynenthapnhat-15*10*Point);
            double kcsl=Ask-sl;
            double tp=Bid+kcsl;
            if(Total_EA_OrderType(Magic,OP_BUY)<=0){
               OrderSend(Symbol(),OP_BUY,0.01,Ask,0,sl,tp,"EA MACD and EMA 200",Magic);
            }
         }
     }
     
     if(iClose(Symbol(),PERIOD_M30,1)<EMA200 && MainMACD1>0){
         if(MainMACD1<SigleMACD1 && MainMACD2>SigleMACD2){
            int giatricaonhat=iHighest(Symbol(),PERIOD_M30,MODE_HIGH,5,1);
            double giacaynencaonhat=iHigh(Symbol(),PERIOD_M30,giatricaonhat);
            double sl=(giacaynencaonhat+15*10*Point);
            double kcsl=sl-Bid;
            double tp=Ask-kcsl;
            if(Total_EA_OrderType(Magic,OP_SELL)<=0){
               OrderSend(Symbol(),OP_SELL,0.01,Bid,0,sl,tp,"EA MACD and EMA 200",Magic);
            }
         }
     }

  }
//+------------------------------------------------------------------+
