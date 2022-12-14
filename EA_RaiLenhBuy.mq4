//+------------------------------------------------------------------+
//|                                                EA_RaiLenhBuy.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input int      KhoangCach=30;
input double   LotVaoLenh=0.01;
input int      SoLenhRai=5;
input int      Magic=9999;
input int      sopiploi=30;
input int      BoLenh=3;
input int      PhanTramHoiVe=60;// Phan Tram Hoi 60 vao 75
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//int Loailenh=-1;
double giavaolenh=0;
double giavaolenhl0=0;
double lotvaolenh=0;
double lotvaolenhtheobolenh=0.01;
void OnTick()
  {
     if(CheckEA(Magic)==false)
     {
             int tam=OrderSend(NULL,OP_BUY,LotVaoLenh,Ask,0,0,Ask+(sopiploi*10*Point),"EA_RaiLenhBuy",Magic,NULL,Green);
             Luulenh(tam);
             LuulenhL0(tam);
     }

     else 
     {
        lotvaolenhtheobolenh=GetLotVaoLenh();
       // Comment()
        if((Bid+KhoangCach*10*Point)<=giavaolenh)
        {
           
           int tam=OrderSend(NULL,OP_BUY,lotvaolenhtheobolenh,Ask,0,0,0,"EA_RaiLenhBuy",Magic,NULL,Green);
           Luulenh(tam);
        }
     }
    // double giaxl=giaxoalenh(giavaolenhl0);
     //Comment("Gia Lenh L0: "+(string)giavaolenhl0 + "/Gia Xoa Lenh: "+(string)giaxl );
     
    // double giacaonhat=GiaDongLenh();
   //  double giathapnhat=GetGiaThapNhat(OP_BUY,Magic);
    
     
     double pricedelete=GetPriceAtCloseBuy(OP_BUY,Magic);
     double pricedelete2=GetPriceAtCloseBuy2(OP_BUY,Magic);
     double pricedelete75=GetPriceAtCloseBuy75(OP_BUY,Magic);
     double priced=0;
     if(PhanTramHoiVe==60)priced=pricedelete;
     else priced=pricedelete75;
     
     Comment("Tong Lenh: "+(string)GetTongLenh(Magic)+"Gia Thap Nhat:"+(string)GetGiaThapNhat(OP_BUY,Magic)+ "Gia Vao Lenh L0="+(string)giavaolenhl0);
     if(GetTongLenh(Magic)==2 && Ask>=pricedelete2)
     {
        DongLenh(Magic);
        Luulenh(-1);
        LuulenhL0(-1);
     }
     if(GetTongLenh(Magic)>2 && Ask>=priced)
     {
        DongLenh(Magic);
        Luulenh(-1);
        LuulenhL0(-1);
     }
     
  }
//+------------------------------------------------------------------+
// Gia dong lenh
/*double giaxoalenh(double pricelo){//pricelo. gia cua lenh đau tien
     double giaxoa=0;
     int tonglenh=GetTongLenh(Magic);//tong lenh
     if(tonglenh>2)giaxoa=pricelo - (tonglenh-1)*KhoangCach*0.01*10*Point;
     else giaxoa=pricelo+(20*Point);
     return NormalizeDouble(giaxoa,Digits);
}*/

double GetPriceAtCloseBuy(int kieulenh,int magic)
   
{
    double PriceClodeOrder=0;
    double priceMax=giavaolenhl0;
    double priceMin=GetGiaThapNhat(kieulenh,magic);
    double priceAverage=(priceMax+priceMin)/2;
    double priceAveraga2=(priceAverage+priceMax)/2;
    PriceClodeOrder=(priceAverage+priceAveraga2)/2;

    return NormalizeDouble(PriceClodeOrder,Digits);
}
// dong lenh khi tong lenh =2
double GetPriceAtCloseBuy2(int kieulenh,int magic)
   
{
    double PriceClodeOrder=0;
    double priceMax=giavaolenhl0;
   // double priceMin=GetGiaThapNhat(kieulenh,magic);
   // double priceAverage=(priceMax+priceMin)/2;
   // double priceAveraga2=(priceAverage+priceMax)/2;
    PriceClodeOrder=giavaolenhl0+3*10*Point;

    return NormalizeDouble(PriceClodeOrder,Digits);
}

// hoi ve 75 phan tram
double GetPriceAtCloseBuy75(int kieulenh,int magic)
   
{
    double PriceClodeOrder=0;
    double priceMax=giavaolenhl0;
    double priceMin=GetGiaThapNhat(kieulenh,magic);
    double priceAverage=(priceMax+priceMin)/2;
    PriceClodeOrder=(priceAverage+priceMax)/2;
   // PriceClodeOrder=giavaolenhl0+3*10*Point;

    return NormalizeDouble(PriceClodeOrder,Digits);
}
int GetTongLenh(int magic)
{
 
    int tonglenh=0;
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
        if(OrderSelect(i,SELECT_BY_POS))
        {
            if(OrderMagicNumber()==magic && OrderSymbol()==Symbol())
            {
               tonglenh=tonglenh+1;   
            }
        }
    }

    return tonglenh;
}
void Luulenh(int ticket){
     if(OrderSelect(ticket,SELECT_BY_TICKET))
     {
         giavaolenh=OrderOpenPrice();
         lotvaolenh=OrderLots();
     }


}
void LuulenhL0(int ticket){
     if(OrderSelect(ticket,SELECT_BY_TICKET))
         giavaolenhl0=OrderOpenPrice();

}



void DongLenh(int magic)
{
    
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol())
          {
            bool tam= OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,Red);
          }
       }
    
    }


}

bool CheckEA(int magic)
{
    bool kq=false;
    int colenh=0;
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
        if(OrderSelect(i,SELECT_BY_POS))
        {
            if(OrderMagicNumber()==magic)
            {
               colenh=colenh+1;   
            }
        }
    }
    if(colenh>0) kq=true;
    else kq=false;
    return kq;
}

double LotLonNhat(int magic)
{
    double lotlonnhat=0.01;
   
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
          if(OrderMagicNumber()==Magic && OrderSymbol()==Symbol() && OrderLots()>lotlonnhat)lotlonnhat=OrderLots();
       }
    }
    return lotlonnhat;
}

int SoLenhCoLotLonNhat(double lotlonnhat)
{
   int solenhlonnhat=0;
   for(int i=OrdersTotal()-1;i>=0;i--) 
   {
       if(OrderSelect(i,SELECT_BY_POS))
       {
          if(OrderMagicNumber()==Magic && OrderSymbol()==Symbol() && lotlonnhat==OrderLots()) solenhlonnhat++;
       }
   }
   return solenhlonnhat;
}

double GetLotVaoLenh()

{
   double solot=LotLonNhat(Magic);
   if(SoLenhCoLotLonNhat(solot)==SoLenhRai) 
      solot=LotLonNhat(Magic)+LotVaoLenh;
   
   return solot;
}

double Totalprofit(int magic)
{
    double total=0;
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
       if(OrderSelect(i,SELECT_BY_POS))
       {
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol())
          {
             double profit=OrderProfit()+OrderSwap()+OrderCommission();
             
             total=total+profit;
          }
       }
    
    }
    return total;

}

// tim lenh cos gia cao nhat caur lenh

double GetGiaThapNhat(int kieulenh,int magic){
    double  giathapnhat=0;
    for(int i=OrdersTotal()-1;i>=0;i--){
        if(OrderSelect(i,SELECT_BY_POS)){
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol()){
              if(OrderType()==kieulenh){
                  double price=OrderOpenPrice();
                  if(giathapnhat==0) giathapnhat=price;
                  else if(price<giathapnhat) giathapnhat=price;
              }
          }
        }
    
    }

    return giathapnhat;
}