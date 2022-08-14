//+------------------------------------------------------------------+
//|                                                 Bot_telegram.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern string serverUrl = "http://localhost";


int OnInit(){
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason){}

void OnTick()
  {
    string ordersString = ListOrders();
    Print(ordersString);
    SendPOSTToServer(serverUrl + "/orders", ListOrders());
  }


void SendPOSTToServer(string url, string ordersString){
   string cookie = NULL, headers;
   char post[], result[];
   int res;
   
   StringToCharArray(ordersString, post, 0, -1, CP_UTF8);
   ArrayResize(post, ArraySize(post));
   
   ResetLastError();
   
   res = WebRequest("POST", url , cookie, NULL, 5000, post, 0, result, headers);
   
   if(res == -1){
      Print("Error:", GetLastError());
      
   }else {
     Print("Send orders to server successfully");
   } 
}

string ListOrders() {
   string accBalance = AccountBalance() + "";
   string accEquity = AccountEquity() + "";
   string accNumber = AccountNumber() + "";
   string donbay = AccountLeverage() + "";
   string accServer = AccountServer() + "";
   string sLO = "{\"server\":\"NamPham\",\"total\":\"0\",\"accBalance\":\"{acc}\",\"accEquity\":\"{accE}\",\"accNumber\":\"{accN}\",\"donbay\":\"{donbay}\",\"accServer\":\"{accS}\"";
   
   int sum = RunningOrders(); // tong so lenh dang chay
   Print("Num:", sum);
  
   if (sum == 0){
      StringReplace(sLO, "{0}", sum);
      StringReplace(sLO, "{acc}", accBalance);
      StringReplace(sLO, "{accE}", accEquity);
      StringReplace(sLO, "{accN}", accNumber);
      StringReplace(sLO, "{donbay}", donbay);
      StringReplace(sLO, "{accS}", accServer);
      sLO += JsonHistory();
      sum = sum + "}";
   } else {
      sLO = "{\"server\":\"NamPham\",\"total\":\"{0}\",\"accBalance\":\"{acc}\",\"accEquity\":\"{accE}\",\"accNumber\":\"{accN}\",\"donbay\":\"{donbay}\",\"accServer\":\"{accS}\"";
      // do cac lenh dang chay
      sLO += ", \"orders\":[";
      
      int orderNumber = 0;
      
      for(int pos = 0 ;pos < OrdersTotal(); pos ++) {
         if(OrderSelect(pos, SELECT_BY_POS)==false) continue;
         if(OrderType() == OP_BUY || OrderType() == OP_SELL) {
           orderNumber ++;
           if(orderNumber > 1) {
             sLO += ",";
           }
            sLO += "{\"ticket\":\"[0]\", \"pair\":\"[1]\", \"direction\":\"[2]\", \"lot\":\"[3]\", \"price\":\"[4]\", \"sl\":\"[5]\", \"tp\":\"[6]\", \"opentime\":\"[7]\", \"comment\":\"[8]\", \"orderProfit\":\"[9]\"}";
         }
         
         StringReplace(sLO, "{0}", sum);
         StringReplace(sLO, "{acc}", accBalance);
         StringReplace(sLO, "{accE}", accEquity);
         StringReplace(sLO, "{accN}", accNumber);
         StringReplace(sLO, "{donbay}", donbay);
         StringReplace(sLO, "{accS}", accServer);
         StringReplace(sLO, "[0]", OrderTicket());
         StringReplace(sLO, "[1]", OrderSymbol());
         StringReplace(sLO, "[2]", OrderType());
         StringReplace(sLO, "[3]", OrderLots());
         StringReplace(sLO, "[4]", OrderOpenPrice());
         StringReplace(sLO, "[5]", OrderStopLoss());
         StringReplace(sLO, "[6]", OrderTakeProfit());
         StringReplace(sLO, "[7]", OrderOpenTime());
         StringReplace(sLO, "[8]", OrderComment());
         StringReplace(sLO, "[9]", OrderProfit());                 
      }
      
      sLO += "]";
      sLO += JsonHistory();
      sLO += "}";
   }
   
   return sLO;
}

int RunningOrders() {
   int total=0;
   for(int i = OrdersTotal() - 1;i >= 0;i--){
      if(OrderSelect(i,SELECT_BY_POS)){
          if(OrderSymbol()==Symbol()){
              total=total+1;
          }
      }
   }
   return total;
}

string JsonHistory(){
   string sLO = ", \"ordershistory\":[";
    int orderHistoryNum = 0;
   
   for(int pos = 0 ;pos < OrdersHistoryTotal(); pos ++) {
         if(OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)==false) continue;
         if(OrderType() == OP_BUY || OrderType() == OP_SELL) {
           orderHistoryNum ++;
           if(orderHistoryNum > 1) {
             sLO += ",";
           }
           sLO += "{\"ticket\":\"[0]\", \"pair\":\"[1]\", \"direction\":\"[2]\", \"lot\":\"[3]\", \"price\":\"[4]\", \"sl\":\"[5]\", \"tp\":\"[6]\", \"opentime\":\"[7]\", \"comment\":\"[8]\", \"orderProfit\":\"[9]\"}";
         }
         StringReplace(sLO, "[0]", OrderTicket());
         StringReplace(sLO, "[1]", OrderSymbol());
         StringReplace(sLO, "[2]", OrderType());
         StringReplace(sLO, "[3]", OrderLots());
         StringReplace(sLO, "[4]", OrderOpenPrice());
         StringReplace(sLO, "[5]", OrderStopLoss());
         StringReplace(sLO, "[6]", OrderTakeProfit());
         StringReplace(sLO, "[7]", OrderOpenTime());
         StringReplace(sLO, "[8]", OrderComment());
         StringReplace(sLO, "[9]", OrderProfit());                 
      }
      
      sLO += "]";
      return sLO;
}