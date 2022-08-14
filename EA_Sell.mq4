//+------------------------------------------------------------------+
//|                                                      EA_Sell.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Library.mqh>

input int Magic=9999;
input int TP=30;
input double Lotvaolenh=0.01;
input int Khoangcach=20;
input double BoiSo=1.72;

double giavaolenhSell=0;
double lotvaolenhSell=0;

double lotSelllonnhat=0.01;

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
void OnTick()
  {

       // dieu kien dong lenh sell
       if(CheckEA(Magic,OP_SELL)==true){   
          double lotSelllonnhathientai=LotLonNhatTheoKieuLenh(Magic,OP_SELL);
          if(lotSelllonnhat>lotSelllonnhathientai){
             CloseAll(Magic,OP_SELL);
             CloseAllLimit(Magic,OP_SELLLIMIT);
             lotSelllonnhat=0.01;
          }
       }
       
        // kiem tra vao lenh sell
        if(CheckEA(Magic,OP_SELL)==false && Total_EA_OrderType(Magic,OP_SELL)<2){
            CloseAllLimit(Magic,OP_SELLLIMIT);
            int tam=OrderSend(NULL,OP_SELL,Lotvaolenh,Bid,0,0,Bid-(TP*10*Point),"EA_SuperProfit",Magic,NULL,Green);
            LuulenhSell(tam);
            double lotmoi=NormalizeDouble(Lotvaolenh*BoiSo,2);
            int tamlimt=OrderSend(NULL,OP_SELLLIMIT,lotmoi,Bid+(20*10*Point),0,0,Bid+(20*10*Point)-(TP*10*Point),"EA_SuperProfit",Magic,NULL,Green);
        }
        // dieu kien vao lenh selllimit
        if(Total_EA_OrderType(Magic,OP_SELLLIMIT)==0 && CheckEA(Magic,OP_SELL)==true){
           
           double lotselllonnhat=LotLonNhatTheoKieuLenh(Magic,OP_SELL);
           int tamlimt=OrderSend(NULL,OP_SELLLIMIT,NormalizeDouble(lotselllonnhat*BoiSo,2),Bid+(20*10*Point),0,0,Bid+(20*10*Point)-(TP*10*Point),"EA_SuperProfit",Magic,NULL,Green);
          
        }
        
        if(CheckEA(Magic,OP_SELL)==true){
              lotSelllonnhat=LotLonNhatTheoKieuLenh(Magic,OP_SELL);
        }
   
  }
//+------------------------------------------------------------------+
           // Tim lot lon nhat theo kieu lenh
   double LotLonNhatTheoKieuLenh(int magic,int kieulenh)
   {
       double lotlonnhat=0.01;
     //  int tichket=0;
       for(int i=OrdersTotal()-1;i>=0;i--)
       {
          if(OrderSelect(i,SELECT_BY_POS))
          {
             if(OrderMagicNumber()==Magic && OrderSymbol()==Symbol() && OrderType()==kieulenh && OrderLots()>lotlonnhat)
             {
                lotlonnhat=OrderLots();
              //  tichket=OrderTicket();
             }
          }
       }
       return lotlonnhat;
   }


// luu lenh sell
void LuulenhSell(int ticket){
     if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
         giavaolenhSell=OrderOpenPrice();
         lotvaolenhSell=OrderLots();
     }
}