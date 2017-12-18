@RestResource(urlMapping='/v1/getSimilarAccounts/*')
   global with sharing class GetSimilarAccounts {
     @HttpGet
      global static List<Account> similarAccounts(){
          RestRequest req = RestContext.request;
          String receivedAccountName=req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
          System.debug('receivedAccountName----'+receivedAccountName);
          receivedAccountName = receivedAccountName.replace('+',' ');
          String accountName= '%'+receivedAccountName+'%'; 
          System.debug('ReplacedAccountName----'+receivedAccountName);
          List<String >receivedAccountNames = receivedAccountName.split(' ');
          List<Account> lstAccount;
          if(receivedAccountNames.size()>1){
              for(Integer i=0;i<receivedAccountNames.size();i++){
                  receivedAccountNames[i]='%'+receivedAccountNames[i]+'%'; 
              }
              lstAccount =[SELECT Id,Name, Website, Phone, Fax, NumberOfEmployees, Description  
                                   FROM Account WHERE Name LIKE :receivedAccountNames];
              return lstAccount;                 
          }else {
              System.debug('receivedAccountName==='+receivedAccountName);  
               lstAccount =[SELECT Id,Name, Website, Phone, Fax, NumberOfEmployees, Description  
                                   FROM Account WHERE Name LIKE :accountName]; 
              return lstAccount;
          }
      }
   }