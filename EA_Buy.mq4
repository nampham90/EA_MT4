//+------------------------------------------------------------------+
//|                                                       EA_Buy.mq4 |
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

double giavaolenhBuy=0;
double lotvaolenhBuy=0;

double lotBuylonnhat=0.01;



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
      // dieu kien dong lenh buy
          if(CheckEA(Magic,OP_BUY)==true){
             double lotBuylonnhathientai=LotLonNhatTheoKieuLenh(Magic,OP_BUY);
             if(lotBuylonnhat>lotBuylonnhathientai){
                CloseAll(Magic,OP_BUY);
                CloseAllLimit(Magic,OP_BUYLIMIT);
                lotBuylonnhat=0.01;
             }
          }
          
           // kiem tra vao lenh buy
        if(CheckEA(Magic,OP_BUY)==false && Total_EA_OrderType(Magic,OP_BUY)<2){
            CloseAllLimit(Magic,OP_BUYLIMIT);
            int tam=OrderSend(NULL,OP_BUY,Lotvaolenh,Ask,0,0,Ask+(TP*10*Point),"EA_SuperProfit",Magic,NULL,Green);
            LuulenhBuy(tam);
            double lotmoi=NormalizeDouble(Lotvaolenh*BoiSo,2);
            int tamlimt=OrderSend(NULL,OP_BUYLIMIT,lotmoi,Ask-(20*10*Point),0,0,Ask-(20*10*Point)+(TP*10*Point),"EA_SuperProfit",Magic,NULL,Green);
       
        }
        
          // dieu kiem vao lenh buylimit
        if(Total_EA_OrderType(Magic,OP_BUYLIMIT)==0){
           double lotbuylonnhat=LotLonNhatTheoKieuLenh(Magic,OP_BUY);
           int tamlimt=OrderSend(NULL,OP_BUYLIMIT,NormalizeDouble(lotbuylonnhat*BoiSo,2),Ask-(20*10*Point),0,0,Ask-(20*10*Point)+(TP*10*Point),"EA_SuperProfit",Magic,NULL,Green);
        }
        
        if(CheckEA(Magic,OP_BUY)==true){
           lotBuylonnhat=LotLonNhatTheoKieuLenh(Magic,OP_BUY);
        }
   
  }
  
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
//+------------------------------------------------------------------+
// luu lenh buy
void LuulenhBuy(int ticket){
     if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
         giavaolenhBuy=OrderOpenPrice();
         lotvaolenhBuy=OrderLots();
     }
}