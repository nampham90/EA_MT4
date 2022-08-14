//+------------------------------------------------------------------+
//|                                                EA_RaiLenhSell.mq4 |
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
input int      Magic=9998;
input int      sopiploi=30;
input int      BoLenh=3;
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
             int tam=OrderSend(NULL,OP_SELL,LotVaoLenh,Bid,0,0,Bid-(sopiploi*10*Point),"EA_RaiLenhSell",Magic,NULL,Green);
             Luulenh(tam);
             LuulenhL0(tam);
     }

     else 
     {
        lotvaolenhtheobolenh=GetLotVaoLenh();
       // Comment()
        if((Ask-KhoangCach*10*Point)>=giavaolenh  )
        {
           
           int tam=OrderSend(NULL,OP_SELL,lotvaolenhtheobolenh,Bid,0,0,0,"EA_RaiLenhSell",Magic,NULL,Green);
           Luulenh(tam);
        }
     }
     double giathapnhat=GiaDongLenh();
     double giacaonhat=GetGiaCaoNhat(OP_SELL,Magic);
     
     double pricedelete=giaxoalenh(giacaonhat,giathapnhat);
     Comment("Gia Dong Lenh;"+ (string)GiaDongLenh()+ "Tong Lenh: "+(string)GetTongLenh(Magic)+" Gai dong lnh:"+(string)giacaonhat+"Gia Cao Nhat:"+(string)GetGiaCaoNhat(OP_SELL,Magic)+"Gia Xoa Lenh: "+ (string)pricedelete);
     
     if(GetTongLenh(Magic)>=2 && Ask<=pricedelete)
     {
        DongLenh(Magic);
        Luulenh(-1);
        LuulenhL0(-1);
     }
  }
//+------------------------------------------------------------------+
double giaxoalenh(double priceMax,double priceMin){
     double giaxoa=0;
     double giatrungbinh=(priceMax+priceMin)/2;
     giaxoa=(priceMin+giatrungbinh)/2;
     return NormalizeDouble(giaxoa,Digits);
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

double GiaDongLenh()
{
    
    double giadl=0;
    int tonglenh=GetTongLenh(Magic);
    if(giavaolenhl0!=0){
         giadl=giavaolenhl0-((tonglenh-1)*KhoangCach*(2/3)*10*Point);
    }
   
    
    return NormalizeDouble(giadl,Digits);
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
            if(OrderMagicNumber()==magic && OrderSymbol()==Symbol())
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

double GetGiaCaoNhat(int kieulenh,int magic){
    double  giacaonhat=0;
    for(int i=OrdersTotal()-1;i>=0;i--){
        if(OrderSelect(i,SELECT_BY_POS)){
          if(OrderMagicNumber()==magic && OrderSymbol()==Symbol()){
              if(OrderType()==kieulenh){
                  double price=OrderOpenPrice();
                  if(giacaonhat==0) giacaonhat=price;
                  else if(price>giacaonhat) giacaonhat=price;
              }
          }
        }
    
    }

    return giacaonhat;
}