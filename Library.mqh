//+------------------------------------------------------------------+
//|                                                      Library.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict



bool IsNew(){

    bool nenMoi = false;
    datetime static thoimocuanen=0;
    if(thoimocuanen==0){
         thoimocuanen=Time[0];
    }else if(thoimocuanen != Time[0]){
        nenMoi=true;
        thoimocuanen=Time[0];
    }
    return nenMoi;
    
}
bool IsNenTang(int iIndex){
   return ((Close[iIndex] >= Open[iIndex]) == true);

}
int Total_EA(int magic)
{
   int total=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol())
          {
              total=total+1;
          }
      }
   }
   return total;
}
// tong lenh cua EA theo kieu Lenh
int Total_EA_OrderType(int magic,int ordertype)
{
   int total=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS))
      {
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==ordertype)
          {
              total=total+1;
          }
      }
   }
   return total;
}

double TotalProfitTrade(int magic){
    double tongprofit=0;
    for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS)){
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol()){
              double profit=OrderProfit()+OrderSwap()+OrderCommission();
              tongprofit=tongprofit+profit;
          }
      
      }
    }
    return tongprofit;

}
// Price Close All 
double GetPriceAtCloseBuy(int kieulenh,int magic,double giavaolenhl0,double giatheokieulenh)
   
{
    double PriceClodeOrder=0;
    double priceMax=giavaolenhl0;
    double priceMin=giatheokieulenh;
    double priceAverage=(priceMax+priceMin)/2;
    double priceAveraga2=(priceAverage+priceMax)/2;
    PriceClodeOrder=(priceAverage+priceAveraga2)/2;

    return NormalizeDouble(PriceClodeOrder,Digits);
}
// kiem tra EA co lenh hay khong.
bool CheckEA(int magic,int kieulenh)
{
    bool kq=false;
    int colenh=0;
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
        if(OrderSelect(i,SELECT_BY_POS))
        {
            if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==kieulenh)
            {
               colenh=colenh+1;   
            }
        }
    }
    if(colenh>0) kq=true;
    else kq=false;
    return kq;
}
// dong lenh theo kieu lenh
void CloseAll(int magic,int ordertype)
{

    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==ordertype)
           {
               bool tam= OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red);
           }

       }
    }

}
void CloseAllLimit(int magic, int kieulenh)
{
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
           if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic && OrderType()==kieulenh)
           {
              
               //bool tam= OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red);
               bool tamcho=OrderDelete(OrderTicket(),Red);
           }
       }
    }
}
// tong so lot dang trade

double TongLotDangTrade(int magic,int kieulenh)
{
    double tonglot=0;
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==kieulenh)
          {
              tonglot=tonglot+OrderLots();
          }
       }
    }
    return tonglot;
}

void DiChuyenStoploss(int pipLoi,int pipKhoangCach, int pipNhay,int iMagic)
{
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        if(OrderSelect(i, SELECT_BY_POS))
        {
            if(OrderMagicNumber()== iMagic && OrderSymbol() == Symbol())
            {
                 if(OrderType()==OP_BUY)
                 {
                    double dbGiaKeoSL = OrderOpenPrice() + (pipLoi)* 10 * Point;
                    double dbGiaSLMoi = Bid - pipKhoangCach * 10 * Point;
                    double dbGiaTPMoi = OrderTakeProfit() + pipNhay*10*Point;
                    if(Bid>dbGiaKeoSL && (OrderStopLoss() == 0 || (OrderStopLoss()>0 && Bid> OrderStopLoss() + (pipKhoangCach + pipNhay)*10*Point)))
                    {
                        int tam=OrderModify(OrderTicket(),OrderOpenPrice(),dbGiaSLMoi,0,NULL,Green);
                    }
                 }
                 if(OrderType()==OP_SELL)
                 {
                    double dbGiaKeoSL = OrderOpenPrice() - (pipLoi)*10*Point;
                    double dbGiaSLMoi = Ask + pipKhoangCach*10*Point;
                    double dbGiaTPMoi = OrderTakeProfit() - pipNhay*10*Point;
                    if(Ask < dbGiaKeoSL && (OrderStopLoss() == 0 || (OrderStopLoss() > 0 && Ask < OrderStopLoss() - (pipKhoangCach + pipNhay)*10*Point)))
                    {
                         bool bTam = OrderModify(OrderTicket(), OrderOpenPrice(), dbGiaSLMoi, 0, 0);
                    }
                 }

              }    
            
          }
       
    }

}


void BaoVeLenh(int pipbaove,int khoangcach,int magic){
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(OrderSelect(i,SELECT_BY_POS)){
          double openprice=OrderOpenPrice();
          double sopiploi=0;
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==OP_BUY){
             sopiploi=Bid-openprice;
          }else if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==OP_SELL){
             sopiploi=openprice-Ask;
          }
          
          if(((sopiploi/(10*Point)))>=khoangcach){
              double newstoploss=0;
              if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==OP_BUY)
                 newstoploss=OrderOpenPrice()+(pipbaove*10*Point);
                 
              else if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==OP_SELL)
                 newstoploss=OrderOpenPrice()-(pipbaove*10*Point);
                 
                 
              int tam=OrderModify(OrderTicket(),OrderOpenPrice(),newstoploss,OrderTakeProfit(),NULL,Blue);
           }
      
      }
   
   }
}

// tien lot lon nhat theo kieu lenh

double LotLonNhattheokieulenh(int magic,int kieulenh)
{
    double lln=0.01;
   
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderType()==kieulenh && OrderLots()>lln)lln=OrderLots();
       }
    }
    return lln;
}


double LotLonNhat(int magic)
{
    double lln=0.01;
   
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol() && OrderLots()>lln)lln=OrderLots();
       }
    }
    return lln;
}

double TangLot(int sotien){
   double solot=0.01;
   switch(sotien){
     case 5000 : solot=0.01;break;
     case 10000 : solot=0.02;break;
     case 15000 : solot=0.03;break;
     case 20000 : solot=0.04;break;
     case 25000 : solot=0.05;break;
     case 30000 : solot=0.06;break;
     case 50000 : solot=0.07;break;
     case 100000 : solot=0.08;break;
     case 500000 : solot=0.1;break;
     case 700000 : solot=0.2;break;
     case 1000000 : solot=0.3;break;
     case 1500000 : solot=0.4;break;
     case 2000000 : solot=0.5;break;
     case 250000 : solot=0.7;break;
     case 5000000 : solot=1.0;break;
     case 0000000 : solot=2.0;break;
     case 15000000 : solot=3.0;break;
   }
   
   return solot;
}